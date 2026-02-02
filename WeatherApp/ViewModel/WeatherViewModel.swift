//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import Foundation
import SwiftUI
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?

    let weatherService: WeatherServiceProtocol
    let locationService: LocationServiceProtocol

    init(weatherService: WeatherServiceProtocol,
         locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
    }

    func fetchWeather(city: String? = nil) async {
        isLoading = true
        errorMessage = nil

        do {
            if let city {
                weather = try await weatherService.fetchWeatherByCity(city)
            } else {
                if let location = try await locationService.requestLocation() {
                    weather = try await weatherService.fetchWeatherByLocation(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                }
            }
        } catch {
            errorMessage = ErrorValue.locationAccessDenied.errorDescription
        }
        
        isLoading = false
    }
}
