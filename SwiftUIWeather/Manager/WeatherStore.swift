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
    @Published var currentWeatherViewModel: [CurrentWeatherViewModel] = []
    @Published var isHiddenAdd: Bool = false
    @Published var isHiddenCancel: Bool = false
    
    var newWeather: CurrentWeatherViewModel?
    
    var weatherManager = WeatherManager()
    
    private lazy var locations: Results<Location> = {
        return realm.objects(Location.self)
    }()
    
    private var observingToken: NotificationToken?
    
    init() {
        reloadData()
        self.observingToken = locations.observe { _ in
            if let newWeather = self.newWeather {
                self.currentWeatherViewModel.append(newWeather)
                self.newWeather = nil
            }
        }
        
        
    }
    
    func checkHiddenButton(location: Location?, fromMainView: Bool) {
        let loc = locations.filter("cityId==[cd] %@", location!.cityId)
        if loc.count > 0 {
            isHiddenAdd = true
        }
        if fromMainView {
            isHiddenAdd = true
            isHiddenCancel = true
        }
        
    }
    
    func reloadData() {
        for item in self.locations {
            let weatherViewModel = CurrentWeatherViewModel(id: UUID().uuidString ,dt: Int(NSDate().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: item.timeZone), temp: item.temperature!, cityId: item.cityId, name: item.cityName, lat: item.lat!, lon: item.lon!)
            self.currentWeatherViewModel.append(weatherViewModel)
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
        
        var locationRef: ThreadSafeReference<Location>? {
            guard let location = location, location.realm != nil else { return nil }
            return ThreadSafeReference(to: location)
        }
        
        var safeLocation: Location?
        do {
            let realm = try! Realm()
            autoreleasepool {
                // check neu object da dc manage hay chua (da dc save vao db chua)
                if let ref = locationRef, let location = realm.resolve(ref) { // Neu da dc manage thi phai dung ThreadSafeReference (https://realm.io/docs/swift/latest/#threading)
                    safeLocation = location
                } else {
                    safeLocation = location
                }
                safeLocation!.currentDate = Int(Date().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: weather.timeZone)
                safeLocation!.temperature = String(format: "%.0f", weather.temp) + "°"
                safeLocation!.timeZone = weather.timeZone
            }
            try realm.write {
                realm.add(safeLocation!)
            }
            newWeather = CurrentWeatherViewModel(id: UUID().uuidString ,dt: Int(NSDate().timeIntervalSince1970).timeStampToString(format: "HH:mm", timezone: safeLocation!.timeZone), temp: safeLocation!.temperature!, cityId: safeLocation!.cityId, name: safeLocation!.cityName, lat: safeLocation!.lat!, lon: safeLocation!.lon!)
        } catch {
            print("Error saving location: \(error)")
        }
        
    }
    
    func deleteLocation(index: IndexSet) {
        let safeLocation = locations[index.first!]
        try! realm.write {
            realm.delete(safeLocation)
        }
        currentWeatherViewModel.remove(at: index.first!)
        
    }
    
    func convertViewModelToLocation(viewModel: CurrentWeatherViewModel) -> Location {
        let location = Location()
        location.cityId = viewModel.cityId
        location.cityName = viewModel.name
        location.lat = viewModel.lat
        location.lon = viewModel.lon
        return location
    }
    
    
}
