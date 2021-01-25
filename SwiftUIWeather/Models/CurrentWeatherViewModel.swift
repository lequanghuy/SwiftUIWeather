//
//  CurrentWeatherViewModel.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

struct CurrentWeatherViewModel: Identifiable {
    let id: String
    let dt: String
    let temp: String
    let cityId: String
    var name: String?
}
