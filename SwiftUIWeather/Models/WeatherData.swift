//
//  WeatherData.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

struct WeatherData: Decodable {
    let timezone: String
    let current: Current
    let hourly: [Hourly]
}

struct Current: Decodable {
    let temp: Double
    let weather: [Weather]
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let wind_speed: Double
    let feels_like: Double
    let pressure: Int
    let visibility: Int
    let uvi: Double
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]

}

struct Weather: Decodable {
    let id: Int
    let description: String
    let icon: String
}
