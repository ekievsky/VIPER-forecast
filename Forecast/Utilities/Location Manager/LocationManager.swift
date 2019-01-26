//
//  LocationManager.swift
//  Forecast
//
//  Created by Evgenii Kyivskyi on 1/25/19.
//  Copyright © 2019 Evgenii Kyivskyi. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocationCoordinate2D)
    func locationManager(_ manager: LocationManager, didFailWithError error: Error)
}

typealias CityDetermineCompletion = CLGeocodeCompletionHandler

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    private var location: CLLocationCoordinate2D?

    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
    }

    func requestLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    func getCity(completion: @escaping CityDetermineCompletion) {
        guard let location2d = self.location else {
            return
        }
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location2d.latitude, longitude: location2d.longitude)
        geocoder.reverseGeocodeLocation(location, completionHandler: completion)
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let locValue = manager.location?.coordinate else {
            delegate?.locationManager(self, didFailWithError: ForecastError.couldNotGetCurrentLocation)
            return
        }
        delegate?.locationManager(self, didUpdateLocation: locValue)
        self.location = locValue
        delegate = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        delegate?.locationManager(self, didFailWithError: error)
        delegate = nil
    }
}

