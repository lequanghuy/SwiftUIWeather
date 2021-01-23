//
//  City.swift
//  SwiftUIWeather
//
//  Created by Lê Huy on 21/01/2021.
//

import Foundation

struct City: Codable, Identifiable {
    let id: Int
    let country: String
    let name: String
    let state: String?
    let coord: Coord

}

struct Coord: Codable {
    let lat: Double
    let lon: Double
}
