//
//  NetworkManager.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/24/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension Request {

    class Executor {

        typealias BaseJSONResponse = (Result<JSON>) -> Void

        static let shared = Executor()

        private let manager : SessionManager

        private let configuration: URLSessionConfiguration = {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

            return config
        }()

        private init() {
            self.manager = SessionManager(configuration: configuration)
        }

        func request(model: Model, completion: @escaping BaseJSONResponse) {
            manager.request(model.endpoint,
                                 method: model.methodType,
                                 parameters: model.parameters,
                                 encoding: model.encoding,
                                 headers: nil).responseJSON { (dataResponse) in
                if let error = dataResponse.result.error {
                    completion(Result.failure(error))
                } else {
                    guard let json = JSON(arrayLiteral: dataResponse.result.value ?? [:]).arrayValue.first else {
                        completion(Result.failure(ForecastError.executorParserError))
                        return
                    }
                    completion(Result.success(json))
                }
            }
        }
    }
}
