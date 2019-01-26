//
//  TodayWeatherViewModel.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

struct TodayWeatherViewModel {

    let image: String
    let locationDescription: String
    let degrees: String
    let weatherType: String
    let humidity: String
    let rainVolume: String
    let pressure: String
    let windSpeed: String
    let windDirection: String
}

extension TodayWeatherViewModel {
    static var empty: TodayWeatherViewModel {
        return TodayWeatherViewModel(image: "-", locationDescription: "-", degrees: "-",
                                     weatherType: "-", humidity: "-",
                                     rainVolume: "-", pressure: "-",
                                     windSpeed: "-", windDirection: "-")
    }
}
