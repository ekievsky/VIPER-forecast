//
//  TodayWeatherInteractor.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation
import CoreLocation

protocol TodayWeatherInteractorInput: class {
    
    func getWeather(completion: ApiService.TodayWeatherCompletion?)
}

final class TodayWeatherInteractor {

    private let apiService: ApiService
    private let locationManager: LocationManager

    private var location: CLLocationCoordinate2D? {
        didSet {
            isLocationUpdated = true
        }
    }

    private var isLocationUpdated = false
    private var inputCompletion: ApiService.TodayWeatherCompletion?

    init(apiService: ApiService, locationManager: LocationManager = .shared) {
        self.apiService = apiService
        self.locationManager = locationManager
    }
}

extension TodayWeatherInteractor: TodayWeatherInteractorInput {

    func getWeather(completion: ApiService.TodayWeatherCompletion?) {
        inputCompletion = completion
        locationManager.delegate = self
        if isLocationUpdated {
            isLocationUpdated = false
            guard let currentLocation = location else {
                completion?(Result.failure(ForecastError.failedToFetchLocation))
                return
            }
            apiService.getTodayWeather(latitude: currentLocation.latitude,
                                       longitude: currentLocation.longitude,
                                       completion: completion)
        } else {
            locationManager.requestLocation()
        }
    }
}

// MARK: - LocationManagerDelegate
extension TodayWeatherInteractor: LocationManagerDelegate {
    
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocationCoordinate2D) {
        self.location = location
        self.getWeather(completion: inputCompletion)
    }

    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {

    }
}
