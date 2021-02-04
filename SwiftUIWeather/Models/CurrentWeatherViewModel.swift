//
//  CurrentWeatherViewModel.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

class CurrentWeatherViewModel: Identifiable, ObservableObject {
    let id: String
    let dt: String
    let temp: String
    let cityId: String
    var name: String?
    var lat: String
    var lon: String
    var show: Bool = false
    
    init(id: String, dt: String, temp: String, cityId: String, name: String?, lat: String, lon: String) {
        self.id = id
        self.dt = dt
        self.temp = temp
        self.cityId = cityId
        self.name = name
        self.lat = lat
        self.lon = lon
    }
}
