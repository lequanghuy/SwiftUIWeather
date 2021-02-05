//
//  CitiesStore.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 21/01/2021.
//

import Foundation

class CitiesStore: ObservableObject {
    @Published var cities: [City] = []
    
    let citiesManager = CityManager.shared
    var searchString: String?
    
    init() {
    }
    
    func getCities(cityName: String?) {
        self.searchString = cityName
        citiesManager.fetchCities(cityName: cityName) { (result) in
            guard self.searchString == cityName else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let cities):
                    self.cities = cities
                case .failure(let error):
                    print(error)
                }
            }
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
