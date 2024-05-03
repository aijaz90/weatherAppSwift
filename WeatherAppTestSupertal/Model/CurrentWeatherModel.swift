//
//  CurrentWeatherModel.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 03/05/2024.
//

import Foundation

struct CurrentWeatherModel: Decodable {
    let time: String?
    let interval: Int?
    let temperature2m: Double?
    let windSpeed10m: Double?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2m = "temperature_2m"
        case windSpeed10m = "wind_speed_10m"
    }
}
