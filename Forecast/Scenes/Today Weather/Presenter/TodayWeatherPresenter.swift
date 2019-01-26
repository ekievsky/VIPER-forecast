//
//  TodayWeatherPresenter.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

protocol TodayWeatherViewOutput: class {
    func getWeather()
}

final class TodayWeatherPresenter {

    // MARK: VIPER
    var interactor: TodayWeatherInteractorInput!

    weak var view: TodayWeatherViewInput?

    // MARK: Utilities
    private let windDirectionUtility: WindDirectionUtility

    init(windDirectionUtility: WindDirectionUtility = WindDirectionUtilityImpl.shared) {
        self.windDirectionUtility = windDirectionUtility
    }
}

// MARK: - TodayWeatherViewOutput
extension TodayWeatherPresenter: TodayWeatherViewOutput {

    func getWeather() {
        view?.showLoader()
        interactor.getWeather { [weak self] (result) in
            self?.view?.hideLoader()
            guard let strongSelf = self else { return }
            switch result {
            case .success(let weather):
                guard let weather = weather else {
                    strongSelf.view?.show(error: ForecastError.couldNotGetTodayWeather)
                    strongSelf.view?.showWeather(.empty)
                    return
                }
                strongSelf.view?.showWeather(strongSelf.getViewModel(weather: weather))
            case .failure(let error):
                strongSelf.view?.show(error: error)
            }
            strongSelf.view?.hideLoader()
        }
    }
}

// MARK: - Private methods
private extension TodayWeatherPresenter {

    func getViewModel(weather: Forecast) -> TodayWeatherViewModel {
        let temperature = "\(Int(weather.temperature) - 273)°C"
        let pressure = "\(Int(weather.pressure)) hPa"
        let humidity = "\(weather.humidity)%"
        let windSpeed = "\(weather.windSpeed) km/h"
        let windDirection = windDirectionUtility.getWindDirection(from: weather.windDegree)
        return TodayWeatherViewModel(image: weather.weather.icon, locationDescription: weather.countryCode, degrees: temperature,
                                     weatherType: weather.weather.main, humidity: humidity,
                                     rainVolume: "N/A", pressure: pressure,
                                     windSpeed: windSpeed, windDirection: windDirection)
    }
}
