//
//  CityListManager.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 21/01/2021.
//

import SwiftUI

struct CityManager {
    //Lấy dữ liệu thành phố theo tên thành phố
    func fetchCities(cityName name: String?, completion: @escaping ([City]) -> Void, exception: @escaping (Error) -> Void) {
        var cities: [City] = []
        let decoder = JSONDecoder()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
                    let fileUrl = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                    cities = try decoder.decode([City].self, from: data)
                    if let cityName = name {
                        cities = cities.filter({ (city) -> Bool in
                            return city.name.contains(cityName)
                        })
                    }
                    else {
                        cities = []
                    }
                    completion(cities)
                }
            }
            catch {
                exception(error)
            }
        }
    }
}
