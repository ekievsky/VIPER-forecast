//
//  ApiService.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/24/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

final class ApiServiceImpl: ApiService {

    private let executor = Request.Executor.shared
    private let requestModelsFactory = RequestModelFactory()

    func getForecast(latitude: Double, longitude: Double, completion: ForecastCompletion?) {

        executor.request(model: requestModelsFactory.getForecast(latitude: latitude,
                                                                 longitude: longitude))
        { (result) in
            switch result {
            case .success(let json):
                let models = json["list"].arrayValue
                    .compactMap { json in
                        return Forecast(json: json)
                    }
                completion?(Result.success(models))
            case .failure(let error):
                completion?(Result.failure(error))
            }
        }
    }

    func getTodayWeather(latitude: Double, longitude: Double, completion: TodayWeatherCompletion?) {

        executor.request(model: requestModelsFactory.getTodayWeather(latitude: latitude, longitude: longitude))
        { (result) in
            switch result {
            case .success(let json):
                let model = Forecast(json: json)
                completion?(Result.success(model))
            case .failure(let error):
                completion?(Result.failure(error))
            }
        }
    }
}
