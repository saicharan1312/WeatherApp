//
//  APIConstants.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//


import Foundation

enum APIConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    static let units = "metric"
    static let weatherApiKey = "d01b2c5449aaa2687f90bc71e092aaea"
}

enum NetworkConstants {
    static let successStatusCodes = 200...299
}

enum ErrorValue: LocalizedError {
    case invalidURL
    case fetchError
    case locationAccessDenied

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .fetchError:
            return "Error while fetching data"
        case .locationAccessDenied:
            return "Please allow location access to fetch weather data"
        }
    }
}
