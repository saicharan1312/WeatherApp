//
//  WeatherViewModelTests.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//


import CoreLocation
import Foundation
@testable import WeatherApp
import XCTest

final class WeatherViewModelTests: XCTestCase {
    var mockLocationService: LocationServiceProtocol!
    var mockWeatherService: WeatherServiceProtocol!
    var viewModel: WeatherViewModel!
    
    override func setUpWithError() throws {
        mockLocationService = MockLocationService()
        mockWeatherService = MockWeatherService()
    }
    
    override func tearDown() async throws {
        mockLocationService = nil
        mockWeatherService = nil
    }
    
    @MainActor
    func testfetchWeatherWithCity() async {
        viewModel = WeatherViewModel(weatherService: mockWeatherService,
                                 locationService: mockLocationService)
        await viewModel.fetchWeather(city: "Los Angeles")
        XCTAssertNotNil(viewModel.weather)
    }
    
    @MainActor
    func testfetchWeatherWithCoordinates() async {
        viewModel = WeatherViewModel(weatherService: mockWeatherService,
                                 locationService: mockLocationService)
        await viewModel.fetchWeather()
        XCTAssertNotNil(viewModel.weather)
    }
}

struct MockLocationService: LocationServiceProtocol {

    // Default mock location (Los Angeles)
    var location: CLLocation? = CLLocation(latitude: 34.09094, longitude: -118.38420)

    func requestLocation() async throws -> CLLocation? {
        return location
    }
}
 
struct MockWeatherService: WeatherServiceProtocol {
    func fetchWeatherByCity(
        _ city: String
    ) async throws -> WeatherData {
        WeatherData.mock
    }

    func fetchWeatherByLocation(
        latitude: Double,
        longitude: Double) async throws -> WeatherData {
        WeatherData.mock
    }
}