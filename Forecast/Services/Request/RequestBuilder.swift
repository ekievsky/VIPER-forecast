//
//  RequestBuilder.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/24/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation

enum Request {}

extension Request {
    final class EndpointsBuilder {

        func forecast5day3hours(latitude: Double, longitude: Double) -> String {
            return ApiConstants.baseURL + "forecast?lat=\(latitude)&lon=\(longitude)" + ApiConstants.appId
        }

        func todayWeather(latitude: Double, longitude: Double) -> String {
            return ApiConstants.baseURL + "weather?lat=\(latitude)&lon=\(longitude)" + ApiConstants.appId
        }
    }
}

private enum ApiConstants {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let appId = "&APPID=b2b2cc9aa7ea1fb9d821a4a6b1a9ac12"
}
