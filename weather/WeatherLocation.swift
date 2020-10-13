//
//  WeatherLocation.swift
//  weather
//
//  Created by pavel on 9/12/20.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation

struct WeatherLocation: Decodable  {
    var coord: Coord
    var weather: [WeatherLoc]
    var main: Main
    var wind: Wind
    var dt: TimeInterval
    var sys: Sys
    var name: String
}


struct Coord: Decodable {
    var lon: Double
    var lat: Double
}

struct WeatherLoc: Decodable {
    var main: String
    var description: String
}

struct Main: Decodable {
    var temp: Double
    var humidity: Int
    
    //test view
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
}

struct Wind: Decodable {
    var speed: Double
}

struct Sys: Decodable {
    var country: String
}
