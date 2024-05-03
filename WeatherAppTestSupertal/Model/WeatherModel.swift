//
//  WeatherModel.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 02/05/2024.
//

import Foundation

struct WeatherModel: Decodable {
    let latitude: Double?
    let longitude: Double?
    let generationTimeMs: Double?
    let utcOffsetSeconds: Int?
    let timezone: String?
    let timezoneAbbreviation: String?
    let elevation: Double?
    let currentUnits: CurrentUnitsWeatherModel?
    let current: CurrentWeatherModel?
    var cityName: String?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude, elevation, current
        case generationTimeMs = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone, timezoneAbbreviation = "timezone_abbreviation"
        case cityName = "city_name"
        case currentUnits = "current_units"
    }
}
