//
//  File.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastInteractorInput: class {
    func getForecast(completion: ApiService.ForecastCompletion?)
}

final class ForecastInteractor {

    private let apiService: ApiService
    private let locationManager: LocationManager

    private var location: CLLocationCoordinate2D? {
        didSet {
            isLocationUpdated = true
        }
    }

    private var isLocationUpdated = false
    private var inputCompletion: ApiService.ForecastCompletion?

    init(apiService: ApiService, locationManager: LocationManager = .shared) {
        self.apiService = apiService
        self.locationManager = locationManager
    }
}

// MARK: - ForecastInteractorInput
extension ForecastInteractor: ForecastInteractorInput {

    func getForecast(completion: ApiService.ForecastCompletion?) {
        inputCompletion = completion
        locationManager.delegate = self
        if isLocationUpdated {
            isLocationUpdated = false
            guard let currentLocation = location else {
                completion?(Result.failure(ForecastError.failedToFetchLocation))
                return
            }
            apiService.getForecast(latitude: currentLocation.latitude,
                                       longitude: currentLocation.longitude,
                                       completion: completion)
        } else {
            locationManager.requestLocation()
        }
    }
}

// MARK: - LocationManagerDelegate
extension ForecastInteractor: LocationManagerDelegate {
    
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocationCoordinate2D) {
        self.location = location
        getForecast(completion: inputCompletion)
    }

    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {
        
    }
}
