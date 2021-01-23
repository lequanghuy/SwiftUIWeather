//
//  CitiesStore.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 21/01/2021.
//

import Foundation

class CitiesStore: ObservableObject {
    @Published var cities: [City] = []
    
    let citiesManager = CityManager()
    
    init() {
    }
    
    func getCities(cityName: String?) {
        citiesManager.fetchCities(cityName: cityName) { (cities) in
            DispatchQueue.main.async {
                self.cities = cities
            }
        } exception: { (error) in
            print("Fetching cities unsucessful, \(error)")
        }
    }
    
    func convertCityToLocation(city: City) -> Location {
        let location = Location()
        location.cityId = String(city.id)
        location.cityName = city.name
        location.lat = String(city.coord.lat)
        location.lon = String(city.coord.lon)
        return location
    }
}
