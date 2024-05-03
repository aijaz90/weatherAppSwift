//
//  WeatherViewModel.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 02/05/2024.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherModel?
    @Published var errorMessage: String?

    private var network: Network?
    
    public init() {
        LocationManager.shared.delegate = self
        self.network = Network()
    }

    func loadCurrentWeatherData(cityName: String? = nil, customLatitude: Double? = nil, customLongitude: Double? = nil) {
        var latitude: Double = 0.0
        var longitude: Double = 0.0
        if let customLatitude = customLatitude, let customLongitude = customLongitude {
            latitude = customLatitude
            longitude = customLongitude
        }
        
        let apiRoute = API.weatherForecast + "latitude=\(latitude)&longitude=\(longitude)" + API.currentWeather
        
        Task {
            do {
                let weatherData: WeatherModel = try await self.network!.getData(apiRoute: apiRoute)
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                    self.weatherData?.cityName = cityName
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: Search city by entering its name
    public func searchCityLocationByName(cityName: String) {
        LocationManager.shared.geocodeCityName(cityName: cityName) { result in
                   switch result {
                   case .success(let coordinates):
                       self.loadCurrentWeatherData(cityName: cityName, customLatitude: coordinates.latitude, customLongitude: coordinates.longitude)
                   case .failure(let error):
                       self.errorMessage = "Error fetching coordinates: \(error.localizedDescription)"
                   }
               }
    }
}

extension WeatherViewModel: LocationManagerDelegate {
    func didUpdateCurrentLocation(cityName: String?, lat: Double, long: Double) {
        self.loadCurrentWeatherData(cityName: cityName, customLatitude: lat, customLongitude: long)
    }
}
