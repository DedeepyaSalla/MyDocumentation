//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import Foundation

struct WeatherModel: Codable {
    let id: Int
    let cod: Int
    let coord: Coordinates
    let weather: [SkyInfo]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let name: String?
}

struct Coordinates: Codable, encodeConvertable {
    let lon: Double
    let lat: Double
}

struct SkyInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}

struct CurrentWeatherInfo: Codable {
    var temperature: Double = 0.0
    var feelsLike: Double = 0.0
    var visibility: Double = 0.0
    var pressure: Double = 0.0
    var humidity: Double = 0.0
    var minTemp: Double = 0.0
    var maxTemp: Double = 0.0
    var skyImageUrl: String = ""
    var description: String = ""
    var cityName: String = ""
}

protocol encodeConvertable {
    func setEncodedData<Q> (toObject object: inout Q)
    func getDecodeData<Q> (toObject object: inout Q)
}

extension encodeConvertable where Self: Codable {
    func setEncodedData<Q> (toObject object: inout Q) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            object = encoded as! Q
           }
    }
    
    func getDecodeData<Q> (toObject object: inout Q) {
        let type = String(describing: Self.self)
        let type1 = String(describing: self)
        let decoder = JSONDecoder()
        let decodedObject = try? decoder.decode(Self.self, from: object as! Data)
        print(decodedObject)
    }
}
