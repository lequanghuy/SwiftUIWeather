//
//  WeatherStore.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

class WeatherStore: ObservableObject {
    
    @Published var weather: WeatherViewModel?
    var weatherManager = WeatherManager()
    
    init() {
        
    }
    
    func getWeatherDetail(location: Location?) {
        weatherManager.fetchWeather(location: location) { (weatherViewModel) in
            DispatchQueue.main.async {
                self.weather = weatherViewModel
            }
        } exception: { (error) in
            print(error)
        }
    }
}
