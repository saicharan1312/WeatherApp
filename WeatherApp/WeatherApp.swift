//
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var locationService = LocationService()

    var body: some Scene {
        WindowGroup {
            WeatherView(
                viewModel: WeatherViewModel(
                    weatherService: WeatherService(apiKey: APIConstants.weatherApiKey),
                    locationService: locationService
                )
            )
            .onAppear {
                Task {
                    try await locationService.requestLocation()
                }
            }
        }
    }
}
