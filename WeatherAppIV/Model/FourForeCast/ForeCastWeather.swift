//
//  ForeCastWeather.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 14.12.23.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct ForeCastWeather: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: CityForeCast
}

// MARK: - City
struct CityForeCast: Codable {
    let id: Int?
    let name: String?
    let coord: CoordForeCast
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct CoordForeCast: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass
    let weather: [WeatherElementForeCast]
    let clouds: CloudsForeCast
    let wind: WindForeCast
    let visibility: Int?
    let pop: Double?
    let snow: Rain?
    let sys: SysForeCast
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, snow, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct CloudsForeCast: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct SysForeCast: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - WeatherElement
struct WeatherElementForeCast: Codable {
    let id: Int?
    let main: MainEnum?
    let description: Description?
    let icon: String?//Icon?
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case lightRain = "light rain"
    case lightSnow = "light snow"
    case overcastClouds = "overcast clouds"
    case snow = "snow"
    case clearSky = "clear sky"
    case scatteredClouds = "scattered clouds"
    case fewClouds = "few clouds"
    case freezingRain = "freezing rain"
    case moderateRain = "moderate rain"
}

//enum Icon: String, Codable {
//    case the04D = "04d"
//    case the04N = "04n"
//    case the10D = "10d"
//    case the10N = "10n"
//    case the13D = "13d"
//    case the13N = "13n"
//}

enum MainEnum: String, Codable {
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    case clear = "Clear"
}

// MARK: - Wind
struct WindForeCast: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
