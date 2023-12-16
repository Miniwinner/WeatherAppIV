//
//  Model1.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 13.12.23.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation

// MARK: - Weather
struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main?
    let visibility: Int
    let wind: Wind?
    let snow: Snow?
    let clouds: Clouds
    let dt: Int
    let sys: Sys?
    let timezone, id: Int
    let name: String?
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let sealevel, grndlevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case sealevel = "sea_level"
        case grndlevel = "grnd_level"
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main:String
    let description:String?
    let icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int   
    let gust: Double?
}
