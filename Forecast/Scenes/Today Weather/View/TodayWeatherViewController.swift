//
//  TodayWeatherViewController.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import UIKit
import SDWebImage

protocol TodayWeatherViewInput: BaseViewInput {
    func showWeather(_ viewModel: TodayWeatherViewModel)
}

final class TodayWeatherViewController: BaseViewController {

    override class var nibFile: String? {
        return "TodayWeatherViewController"
    }

    // MARK: VIPER
    var output: TodayWeatherViewOutput!

    // MARK: Outlets
    @IBOutlet private weak var weatherConditionImageView: UIImageView!
    @IBOutlet private weak var placeTitle: UILabel!
    @IBOutlet private weak var weatherTitle: UILabel!
    
    @IBOutlet private weak var humidityTitle: UILabel!
    @IBOutlet private weak var rainVolumeTitle: UILabel!
    @IBOutlet private weak var pressureTitle: UILabel!
    @IBOutlet private weak var windSpeedTitle: UILabel!
    @IBOutlet private weak var windDirectionTitle: UILabel!

    private var refreshButton: UIBarButtonItem!

    // MARK: Variables
    private var viewModel: TodayWeatherViewModel?
    private var cityName: String?

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
private extension TodayWeatherViewController {
    func configure() {
        configureTitle()
        configureNavigation()
        output.getWeather()
    }

    func configureTitle() {
        title = "Today"
    }

    func configureNavigation() {
        let barButton = UIBarButtonItem(image: Assets.Images.Common.refresh, style: .plain,
                                        target: self, action: #selector(refreshButtonAction(_:)))
        navigationItem.rightBarButtonItem = barButton
        refreshButton = barButton
    }

    func showActivityController() {
        guard
            let viewModel = self.viewModel,
            let cityName = self.cityName
        else { return }

        let content = ["Look at the weather in \(viewModel.locationDescription) – \(cityName).",
            "It is \(viewModel.degrees) and \(viewModel.weatherType) here!"]
        let activityController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        present(activityController, animated: true)
    }
}

// MARK: - Actions
extension TodayWeatherViewController {
    @objc
    private func restoredConnection() {
        output.getWeather()
    }

    @objc
    private func refreshButtonAction(_ barButton: UIBarButtonItem) {
        output.getWeather()
    }

    @IBAction
    private func shareButtonAction(_ sender: UIButton) {
        showActivityController()
    }
}

// MARK: - TodayWeatherViewInput
extension TodayWeatherViewController: TodayWeatherViewInput {
    
    func showWeather(_ viewModel: TodayWeatherViewModel) {
        self.viewModel = viewModel

        if let url = URL(string: viewModel.image) {
            weatherConditionImageView.sd_setImage(with: url, completed: nil)
        }
        LocationManager.shared.getCity { (placemarks, _) in
            self.cityName = placemarks?.first?.locality
            self.placeTitle.text = "\(self.cityName ?? "") \(viewModel.locationDescription)"
        }

        weatherTitle.text = "\(viewModel.degrees) | \(viewModel.weatherType)"
        humidityTitle.text = viewModel.humidity
        rainVolumeTitle.text = viewModel.rainVolume
        pressureTitle.text = viewModel.pressure
        windSpeedTitle.text = viewModel.windSpeed
        windDirectionTitle.text = viewModel.windDirection
    }
}
