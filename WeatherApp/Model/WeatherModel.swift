//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

#if DEBUG
extension WeatherData {
    static let mock = WeatherData(
        name: "Los Angeles",
        main: .init(temp: 18.0),
        weather: [
            .init(description: "light rain")
        ]
    )
}
#endif
