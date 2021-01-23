//
//  WeatherViewModel.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

struct WeatherViewModel {
    let timeZone: String
    let cityName: String
    let description: String
    let temp: Double
    let hourly: [Hourly]
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let wind_speed: Double
    let feels_like: Double
    let pressure: Int
    let visibility: Int
    let uvi: Double
    let dt: Int
}
