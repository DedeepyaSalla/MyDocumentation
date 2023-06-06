//
//  Double+Ext.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation

extension Double {
    /**
        Converts current Kelvin value to Farenheit value. Uses below formula. Assuming  value is in Kelvin units.
        formula: Fahrenheit = (temperature in Kelvin - 273.15) * 9/5 + 32
     */
    var farenheit: String {
        let farenheitValue = (self - 273.15) * 9/5 + 32
        return "\(Int(farenheitValue))" + "°F"
    }
}
