//
//  APIManager.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import Foundation

// MARK: - Protocol
protocol WeatherServiceProtocol {
    func fetchWeatherByCity(_ city: String) async throws -> WeatherData
    func fetchWeatherByLocation(latitude: Double, longitude: Double) async throws -> WeatherData
}

// MARK: - Service
final class WeatherService: WeatherServiceProtocol {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchWeatherByCity(_ city: String) async throws -> WeatherData {
        try await fetchWeather(endpoint: .city(city))
    }

    func fetchWeatherByLocation(latitude: Double, longitude: Double) async throws -> WeatherData {
        try await fetchWeather(endpoint: .location(latitude: latitude, longitude: longitude))
    }
}

// MARK: - Private Helpers
private extension WeatherService {

    // API Endpoint types for scalability
    enum Endpoint {
        case city(String)
        case location(latitude: Double, longitude: Double)

        var queryItems: [URLQueryItem] {
            switch self {
            case .city(let name):
                return [
                    URLQueryItem(name: "q", value: name)
                ]
            case .location(let latitude, let longitude):
                return [
                    URLQueryItem(name: "lat", value: "\(latitude)"),
                    URLQueryItem(name: "lon", value: "\(longitude)")
                ]
            }
        }
    }

    // Generic Fetch Operation
    func fetchWeather(endpoint: Endpoint) async throws -> WeatherData {
        guard var components = URLComponents(string: APIConstants.baseURL) else {
            throw ErrorValue.invalidURL
        }

        // Adding query items
        components.queryItems = endpoint.queryItems + [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: APIConstants.units)
        ]

        // Valid URL
        guard let url = components.url else {
            throw ErrorValue.invalidURL
        }

        // Network request
        let (data, response) = try await URLSession.shared.data(from: url)

        // Validating the HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              NetworkConstants.successStatusCodes.contains(httpResponse.statusCode) else {
            throw ErrorValue.fetchError
        }

        // Decoding the Json response
        return try JSONDecoder().decode(WeatherData.self, from: data)
    }
}
