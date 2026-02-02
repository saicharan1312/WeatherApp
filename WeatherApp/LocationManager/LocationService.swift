//
//  LocationService.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation() async throws -> CLLocation?
}

final class LocationService: NSObject, ObservableObject, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() async throws -> CLLocation? {

        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            continuation?.resume(throwing: CLError(.locationUnknown))
            continuation = nil
            return
        }

        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
