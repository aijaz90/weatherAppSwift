//
//  CurrentUnits.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 03/05/2024.
//

import Foundation

struct CurrentUnitsWeatherModel: Decodable {
    let time: String?
    let interval: String?
    let temperature2m: String?
    let windSpeed10m: String?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2m = "temperature_2m"
        case windSpeed10m = "wind_speed_10m"
    }
}
