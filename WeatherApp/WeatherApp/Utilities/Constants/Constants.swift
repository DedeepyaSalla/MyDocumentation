//
//  Constants.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import Foundation

/**
    Contains constants which are used for DataStorage and Resources names are also declared here.
 */
enum DataStorageConstants {
    enum FileName {
        static let main = "Main"
        static let searchViewController = "SearchViewController"
    }

    enum UserDefaultKeys {
        static let currentLocation = "currentLocation"
        static let currentWeatherInfo = "currentWeatherInfo"
    }
    
    enum ImageNames {
        static let skyStatusPlaceholder = "skyStatus_placeholder"
        static let weatherBackground = "weather_Background"
    }
}

/**
    Contains constants which are used during Network call
 */
enum APIConstants {
    enum HttpString {
        static let openWeatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
        static let iconRequestUrl = "https://openweathermap.org/img/wn/"
        static let getCitiesURL = "https://countriesnow.space/api/v0.1/countries/cities"
    }

    enum APIKeys {
        static let weatherApiKey: String = "fa5cb89e48e32f17f631ae8c5b5469f6"
    }
    
    enum QueryConstants: String {
        case country = "country"
        case unitedStates = "United States"
        case appId = "appid"
        case query = "q"
        case latitude = "lat"
        case longtitude = "lon"
    }
}



