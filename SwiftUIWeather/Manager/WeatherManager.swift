//
//  WeatherManager.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import SwiftUI

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=0b8564ff8bdb9f0b78a854f11229727c&exclude=minutely,daily"
    
    let currentWeatherUrl = "https://api.openweathermap.org/data/2.5/group?appid=0b8564ff8bdb9f0b78a854f11229727c"
    
    var location: Location?
    
    //MARK: - Get detail weather
    mutating func fetchWeather(location: Location?,  completion: @escaping (WeatherViewModel) -> Void,  exception: @escaping (Error) -> Void) {
        if let safeLocation = location {
            self.location = safeLocation
            let unit = UserDefaults.standard.string(forKey: "unit")
            let urlString = "\(weatherUrl)&lat=\(safeLocation.lat!)&lon=\(safeLocation.lon!)&units=\(unit!)"
            print(urlString)
            performRequest(with: urlString, completion: completion, exception: exception)
        }
    }
    
    func performRequest(with urlString: String, completion: @escaping (WeatherViewModel) -> Void,  exception: @escaping (Error) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    exception(err)
                    return
                }
                if let safeData = data {
                    if let weather = parseJsonDetail(safeData) {
                        DispatchQueue.main.async {
                            completion(weather)
                        }
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func parseJsonDetail(_ weatherData: Data) -> WeatherViewModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let timeZone = decodedData.timezone
            let cityName = self.location?.cityName ?? decodedData.timezone
            let description = decodedData.current.weather[0].description
            let temp = decodedData.current.temp
            let sunrise = decodedData.current.sunrise
            let sunset = decodedData.current.sunset
            let humidity = decodedData.current.humidity
            let windSpeed = decodedData.current.wind_speed
            let feelsLike = decodedData.current.feels_like
            let pressure = decodedData.current.pressure
            let visibility = decodedData.current.visibility
            let uvi = decodedData.current.uvi
            var hourly: [HourlyIdentify] = []
            for item in decodedData.hourly {
                let hourIden = HourlyIdentify(id: UUID().uuidString, dt: item.dt, temp: item.temp, weather: item.weather)
                hourly.append(hourIden)
            }
            let weather = WeatherViewModel(timeZone: timeZone,cityName: cityName, description: description, temp: temp, hourly: hourly, sunrise: sunrise, sunset: sunset, humidity: humidity, wind_speed: windSpeed, feels_like: feelsLike, pressure: pressure, visibility: visibility, uvi: uvi, dt: 0)
            return weather
        } catch {
            print("Error parseJson, \(error)")
            return nil
        }
    }
    
    //MARK: - Weather of a group of cities
    
    func fetchCurrentWeather(ids: [String], completion: @escaping ([CurrentWeatherViewModel]) -> Void, exception: @escaping (Error) -> Void ) {
        let stringIds = ids.joined(separator: ",")
        let unit = UserDefaults.standard.string(forKey: "unit")
        let urlString = "\(currentWeatherUrl)&id=\(stringIds)&units=\(unit!)"
        print(urlString)
        performRequestCurrentWeather(with: urlString, completion: completion, exception: exception)
    }
    
    func performRequestCurrentWeather(with urlString: String, completion: @escaping ([CurrentWeatherViewModel]) -> Void, exception: @escaping (Error) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let err = error {
                    exception(err)
                    return
                }
                if let safeData = data {
                    if let currentWeather = parseJsonLocation(safeData) {
                        completion(currentWeather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJsonLocation(_ data: Data) -> [CurrentWeatherViewModel]? {
        let decoder = JSONDecoder()
        var result = [CurrentWeatherViewModel]()
        do {
            let decodedData = try decoder.decode(LocationData.self, from: data)
            for item in decodedData.list {
                let weatherModel = CurrentWeatherViewModel(id: UUID().uuidString, dt: String(item.dt), temp: String(format: "%.0f", item.main.temp), cityId: String(item.id))
                result.append(weatherModel)
            }
            return result
        } catch {
            print("\(error)")
            return nil
        }
    }
    
    
    
}
