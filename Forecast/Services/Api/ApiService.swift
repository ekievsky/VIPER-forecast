//
//  ApiService.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/24/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

protocol ApiService {
    typealias ForecastCompletion = (Result<[Forecast]>) -> ()
    typealias TodayWeatherCompletion = (Result<Forecast?>) -> ()

    func getForecast(latitude: Double, longitude: Double, completion: ForecastCompletion?)
    func getTodayWeather(latitude: Double, longitude: Double, completion: TodayWeatherCompletion?)
}
