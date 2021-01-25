//
//  LocationData.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 23/01/2021.
//

import Foundation

struct LocationData: Decodable {
    let list: [ItemLocationData]
}

struct ItemLocationData: Decodable {
    let dt: Int
    let id: Int
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
