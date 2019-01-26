//
//  ForecastViewController.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import UIKit

protocol ForecastViewInput: BaseViewInput {
    func showForecast(_ sections: [(String, [ForecastViewModel])])
}

final class ForecastViewController: BaseViewController {

    override class var nibFile: String? {
        return "ForecastViewController"
    }

    // MARK: VIPER
    var output: ForecastViewOutput!

    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!

    private var refreshButton: UIBarButtonItem!

    // MARK: Local variables
    private var sections: [Section] = []

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(restoredConnection),
                                               name: .internetRestored, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .internetRestored, object: nil)
    }
}

//MARK: - Private configure
private extension ForecastViewController {

    func configure() {
        output.getForecast()
        configureTableView()
        configureTitle()
        configureNavigation()
    }

    func configureTitle() {
        LocationManager.shared.getCity { (placemarks, _) in
            self.title = "\(placemarks!.first?.locality ?? "")"
        }
    }

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(ForecastTableViewCell.self)
    }

    func configureNavigation() {
        let barButton = UIBarButtonItem(image: UIImage(named: "icRefresh"), style: .plain,
                                        target: self, action: #selector(refreshButtonAction(_:)))
        navigationItem.rightBarButtonItem = barButton
        refreshButton = barButton
    }
}

// MARK: - Notification actions
extension ForecastViewController {
    @objc
    private func restoredConnection() {
        output.getForecast()
    }

    @objc
    private func refreshButtonAction(_ barButton: UIBarButtonItem) {
        output.getForecast()
    }
}

// MARK: - ForecastViewInput
extension ForecastViewController: ForecastViewInput {

    func showForecast(_ sections: [(String, [ForecastViewModel])]) {
        self.sections = sections
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].forecastViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ForecastTableViewCell.self, selectionStyle: .none)
        let viewModel = sections[indexPath.section].forecastViewModels[indexPath.row]
        cell.configure(viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

// MARK: - Entities declaration
private extension ForecastViewController {

    typealias Section = (title: String, forecastViewModels: [ForecastViewModel])

    enum Constants {
        static let headerHeight: CGFloat = 32
        static let cellHeight: CGFloat = 80
    }
}
