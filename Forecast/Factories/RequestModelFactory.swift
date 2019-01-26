//
//  RequestModelFactory.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/24/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Alamofire

final class RequestModelFactory {
    private let builder = Request.EndpointsBuilder()

    func getForecast(latitude: Double, longitude: Double) -> Request.Model {
        let model = Request.Model(endpoint: builder.forecast5day3hours(latitude: latitude, longitude: longitude),
                                  methodType: .get, parameters: nil, encoding: URLEncoding.default)
        return model
    }

    func getTodayWeather(latitude: Double, longitude: Double) -> Request.Model {
        let model = Request.Model(endpoint: builder.todayWeather(latitude: latitude, longitude: longitude),
                                  methodType: .get, parameters: nil, encoding: URLEncoding.default)
        return model
    }
}
