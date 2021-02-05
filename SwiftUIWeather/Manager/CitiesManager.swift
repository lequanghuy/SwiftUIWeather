//
//  CityListManager.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 21/01/2021.
//

import SwiftUI

class CityManager {
    static let shared = CityManager()
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    private var isLoaded: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isLoaded")

        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoaded")
        }
    }

    //Lấy dữ liệu thành phố theo tên thành phố
    func fetchCities(cityName name: String?, completion: @escaping (Result<[City], Error>) -> Void) {
        guard let name = name, !name.isEmpty else {
            completion(.success([]))
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if (!self.isLoaded) {
                    try self.loadDataFirstTime()
                    self.isLoaded = true
                }

                let cities = try self.loadCities(with: name)
                completion(.success(cities))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    private func loadCities(with name: String) throws -> [City] {
        let fileName = String(name.prefix(1)).lowercased()
        let fileURL = try self.fileURL(with: fileName)
        let data = try Data(contentsOf: fileURL)
        let allCities = try self.decoder.decode([City].self, from: data)
        return allCities.filter {
            $0.name.hasPrefix(name)
        }
    }
    
    private func loadDataFirstTime() throws {
        guard
            let url = Bundle.main.url(forResource: "cities", withExtension: "json")
        else {
            throw CityManagerError.dataFileNotFound
        }

        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        let cities = try self.decoder.decode([City].self, from: data)
        
        let citiesGroupedByName = Dictionary(grouping: cities) { (city) in
            return String(city.name.prefix(1)).lowercased()
        }
        
        //[{name: "A"}, {name: "A1"}, {name: "A2"}, {name: "B"}] -> {"a":  [{name: "A"}, {name: "A1"}, {name: "A2"}], "b": [{name: "B"}]}

        for groupedCity in citiesGroupedByName {
            let fileName = groupedCity.key
            let citiesThatStartWithCharacter = groupedCity.value
            try saveCities(citiesThatStartWithCharacter, with: fileName)
        }
    }
    
    private func saveCities(_ cities: [City], with fileName: String) throws {
        let savingURL = try self.fileURL(with: fileName)
        let data = try encoder.encode(cities)
        try data.write(to: savingURL)
    }

    private func fileURL(with name: String) throws -> URL {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw CityManagerError.documentFolderNotAccessible
        }

        return documentURL.appendingPathComponent("\(name).json")
    }
}

enum CityManagerError: Error {
    case dataFileNotFound
    case documentFolderNotAccessible
}
