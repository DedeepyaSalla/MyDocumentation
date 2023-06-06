//
//  CitiesModel.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation

struct CitiesModel: Codable {
    let error: Bool
    let msg: String
    let data: [String]
}
