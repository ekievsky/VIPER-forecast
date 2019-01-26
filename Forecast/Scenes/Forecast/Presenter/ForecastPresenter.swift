//
//  ForecastPresenter.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

protocol ForecastViewOutput: class {
    func getForecast()
}

final class ForecastPresenter {

    var interactor: ForecastInteractorInput!
    
    weak var view: ForecastViewInput?
}

// MARK: - ForecastViewOutput
extension ForecastPresenter: ForecastViewOutput {
    func getForecast() {
        view?.showLoader()
        interactor.getForecast { [weak self] (result) in
            switch result {
            case .success(let models):
                let sections = self?.groupData(models) ?? []
                self?.view?.showForecast(sections)
            case .failure(let error):
                self?.view?.show(error: error)
            }
            self?.view?.hideLoader()
        }
    }
}

// MARK: - Private methods
private extension ForecastPresenter {

    func groupData(_ data: [Forecast]) -> [(String, [ForecastViewModel])] {

        var models: [(String, [ForecastViewModel])] = []
        let dates = Set(data.map({ $0.fullDayString }))

        dates.forEach { (date) in
            let oneDayModels = data
                .filter({ $0.fullDayString == date })
                .map({ model -> ForecastViewModel in
                    let temperature = Int(model.temperature) - 273
                    return ForecastViewModel(image: model.weather.icon,
                                             time: model.time,
                                             weatherType: model.weather.main,
                                             weatherDescription: model.weather.description,
                                             degree: String(temperature))
                })
            models.append((date, oneDayModels))
        }
        
        return models.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.0 < rhs.0
        })
    }
}
