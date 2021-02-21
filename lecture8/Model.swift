//
//  Model.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import Foundation


struct Weather: Codable {
    let description: String?
}

struct Temp: Codable {
    let day: Double?
    let night: Double?
}

struct FeelsLike: Codable {
    let day: Double?
    let night: Double?
}

public struct Model: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Hourly: Codable {
    let dt: UInt64
    let temp: Double?
    let feels_like: Double?
    let weather: [Weather]?
}

struct Current: Codable {
    let temp: Double?
    let feels_like: Double?
    let weather: [Weather]?
}

struct Daily: Codable {
    let dt: UInt64
    let temp: Temp?
    let feels_like: FeelsLike?
    let weather: [Weather]?
}
