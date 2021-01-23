//
//  Location.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var cityName: String?
    @objc dynamic var currentDate: String?
    @objc dynamic var temperature: String?
    @objc dynamic var unit: String = "metric"
    @objc dynamic var lat: String?
    @objc dynamic var lon: String?
    @objc dynamic var cityId: String = ""
    @objc dynamic var timeZone: String = ""
}
