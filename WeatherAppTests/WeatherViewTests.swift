//
//  WeatherViewTests.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//


import XCTest
@testable import WeatherApp
import CoreLocation

final class WeatherViewTests: XCTestCase {
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
    func testWeatherViewModelIntegration() async throws {
        let mockLocationService = MockLocationService()
        let mockWeatherService = MockWeatherService()
        let viewModel = WeatherViewModel(
            weatherService: mockWeatherService,
            locationService: mockLocationService
        )

        await viewModel.fetchWeather(city: "Los Angeles")

        // Test Parameters
        XCTAssertNotNil(viewModel.weather)
        XCTAssertEqual(viewModel.weather?.name, "Los Angeles")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
}
