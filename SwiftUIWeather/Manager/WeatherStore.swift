//
//  WeatherStore.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation
import RealmSwift

class WeatherStore: ObservableObject {
    
    let realm = try! Realm()
    @Published var weather: WeatherViewModel?
    @Published var locationsWeather: [CurrentWeatherViewModel]?
    @Published var currentWeatherViewModel: [CurrentWeatherViewModel] = []
    
    var weatherManager = WeatherManager()
    
    private lazy var locations: Results<Location> = {
        return realm.objects(Location.self)
    }()
    
    private var observingToken: NotificationToken?
    
    init() {
        self.observingToken = locations.observe { _ in
            for item in self.locations {
                let weatherViewModel = CurrentWeatherViewModel(id: UUID().uuidString ,dt: Int(NSDate().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: item.timeZone), temp: item.temperature!, cityId: item.cityId, name: item.cityName)
                self.currentWeatherViewModel.append(weatherViewModel)
            }
        }
    }
    
    deinit {
        self.observingToken?.invalidate()
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
    
    func getLocationsWeather() {
        let arrIds = Array(self.locations.map(\.cityId))
        weatherManager.fetchCurrentWeather(ids: arrIds) { (res) in
            DispatchQueue.global(qos: .userInteractive).async {
                let realm = try! Realm()
                let items = realm.objects(Location.self)
                try! realm.write {
                    for item in res {
                        let realmItem = items.filter("cityId ==[cd] %@", item.cityId).first!
                        realmItem.currentDate = Int(NSDate().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: realmItem.timeZone)
                        realmItem.temperature = String(format: "%.0f", item.temp) + "°"
                    }
                }
            }
        } exception: { (error) in
            print("Error in getting cities list, \(error)")
        }

    }
    
    func saveLocation(location: Location?, weather: WeatherViewModel) {
        if let safeLocation = location {
            safeLocation.currentDate = Int(Date().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: weather.timeZone)
            safeLocation.temperature = String(format: "%.0f", weather.temp) + "°"
            safeLocation.timeZone = weather.timeZone
            DispatchQueue.main.async {
                do {
                    let realm = try! Realm()
                    try realm.write {
                        realm.add(safeLocation)
                    }
                } catch {
                    print("Error saving location: \(error)")
                }
            }

        }
    }
    
    
}
