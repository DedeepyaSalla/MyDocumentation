//
//  UserDefaults+Ext.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation


/**
    Holds all properties which are stored in UserDefaults
 */

extension UserDefaults {
    @UserDefault(key: DataStorageConstants.UserDefaultKeys.currentLocation, defaultValue: Data())
    static var currentLocation: Data

    @UserDefault(key:DataStorageConstants.UserDefaultKeys.currentWeatherInfo, defaultValue: Data())
    static var currentWeatherInfo: Data
}

/**
    Used Property Wrapper to set and get values for UserDefaults. As it accpets generic value, all kinds of data types can be set here itself using this single property wrapper.
 */
@propertyWrapper
struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
