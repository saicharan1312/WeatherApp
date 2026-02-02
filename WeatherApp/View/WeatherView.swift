//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Sai Charan Thummalapudi on 2/2/26.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {

    // MARK: - Constants
    private enum Constants {
        static let navigationTitle = "Weather"
        static let spacing: CGFloat = 16
        static let padding: CGFloat = 16
        static let errorColor: Color = .red
    }

    @StateObject var viewModel: WeatherViewModel
    @State private var city: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: Constants.spacing) {

                // MARK: - Search Bar
                SearchBar(city: $city, isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.fetchWeather(city: city)
                    }
                }

                // MARK: - Loading
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top)
                }

                // MARK: - Weather Card
                if let weather = viewModel.weather {
                    WeatherCard(weather: weather)
                }

                // MARK: - Error
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(Constants.errorColor)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding(Constants.padding)
            .navigationTitle(Constants.navigationTitle)
            .onAppear {
                Task {
                    await viewModel.fetchWeather()
                }
            }
        }
    }
}

// MARK: - SearchBar Component
struct SearchBar: View {
    private enum Constants {
        static let cityPlaceholder = "Enter city"
        static let magnifyImage = "magnifyingglass"
    }
    @Binding var city: String
    var isLoading: Bool
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField(Constants.cityPlaceholder, text: $city)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .autocapitalization(.words)

            Button(action: onSearch) {
                Image(systemName: Constants.magnifyImage)
                    .padding(10)
            }
            .disabled(isLoading || city.isEmpty)
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - WeatherCard Component
struct WeatherCard: View {
    private enum Constants {
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let backgroundColor: Color = .secondary.opacity(0.1)
        static let temperatureFormat: String = "%.1f°C"
    }
    let weather: WeatherData

    var body: some View {
        VStack(spacing: Constants.spacing) {
            Text(weather.name)
                .font(.title2)
                .bold()

            Text(String(format: Constants.temperatureFormat, weather.main.temp))
                .font(.system(size: 44, weight: .semibold))

            Text(weather.weather.first?.description.capitalized ?? "")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Constants.backgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .shadow(radius: 2)
    }
}

#if DEBUG
struct MockLocationService: LocationServiceProtocol {
    var location: CLLocation? = CLLocation(
        latitude: 34.09094,
        longitude: -118.38420
    )

    func requestLocation() async throws -> CLLocation? { location }
}

struct MockWeatherService: WeatherServiceProtocol {
    func fetchWeatherByCity(_ city: String) async throws -> WeatherData { WeatherData.mock }
    func fetchWeatherByLocation(latitude: Double,
                                longitude: Double
    ) async throws -> WeatherData {
        WeatherData.mock
    }
}

#Preview {
    WeatherView(
        viewModel: WeatherViewModel(
            weatherService: MockWeatherService(),
            locationService: MockLocationService()
        )
    )
}
#endif

