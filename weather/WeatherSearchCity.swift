//
//  Weather.swift
//  weather
//
//  Created by pavel on 9/5/20.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation

struct WeatherSearchCity: Decodable {
    var list: [List]
    var city: City
    var cod: String
}

struct City: Decodable {
    var name: String
    var country: String
}

struct List: Decodable {
    var dt: TimeInterval
    var main: Main
    var weather: [WeatherDetail]
    var wind: Wind
    var dt_txt: String
}

struct MainLocation: Decodable {
    var temp: Double
    var humidity: Int
}

struct WeatherDetail: Decodable {
    var main: String
    var description: String
}

struct WindLocation: Decodable {
    var speed: Double
}
