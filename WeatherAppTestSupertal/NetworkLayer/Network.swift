//
//  Network.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 02/05/2024.
//

import Foundation



class Network {
    
    // MARK: - Get method API call
       func getData<T: Decodable>(apiRoute: String) async throws -> T {
           
           let urlString = API.baseURL + apiRoute
           
           guard let url = URL(string: urlString) else {
               throw URLError(.badURL)
           }

           let (data, response) = try await URLSession.shared.data(from: url)
           guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
               throw URLError(.badServerResponse)
           }

           let decoder = JSONDecoder()
           let result = try decoder.decode(T.self, from: data)
           return result
       }
}

enum LocationError: Error {
    case locationUnavailable
    case unauthorized
    case unknown
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .locationUnavailable:
                return "Current location is unavailable."
            case .unauthorized:
                return "Location access has been denied."
            case .unknown:
                return "An unknown error occurred."
        }
    }
}
