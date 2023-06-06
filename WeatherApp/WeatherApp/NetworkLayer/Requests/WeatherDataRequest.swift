//
//  WeatherDataRequest.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 06/06/23.
//

import Foundation

struct WeatherDataRequest: DataRequest {
    
    typealias DataModel = WeatherModel
    
    private enum QueryKey: String {
        case appId = "appid"
        case query = "q"
        case latitude = "lat"
        case longtitude = "lon"
    }
    
    private let apiKey = APIConstants.APIKeys.weatherApiKey
    var networkService: RestNetworkService?
    var queryItems: [String : Any] = [QueryKey.appId.rawValue: APIConstants.APIKeys.weatherApiKey]
    
    var url: String {
        let baseURL: String = APIConstants.HttpString.openWeatherBaseUrl
        return baseURL
    }
    
    init(networkService: RestNetworkService? = nil) {
        self.networkService = networkService
    }
    
    mutating func addQueryItem(withCityName city: String) {
        queryItems[QueryKey.query.rawValue] = city
    }
    
    mutating func addQueryItem(withCoordinates coordinates: Coordinates) {
        queryItems[QueryKey.latitude.rawValue] = coordinates.lat
        queryItems[QueryKey.longtitude.rawValue] = coordinates.lon
    }
    
    func getWeatherInfo(completion: @escaping (Result<WeatherModel, ServiceError<String>>) -> Void) {
        
        networkService?.request(self) { result in
            switch result {
            case .success(let weather):
                let weatherInfo = weather
                completion(.success(weather))
                //--check ur queue n create async call if necessary
            case .failure(_):
                print("failed, so inform to user")
                completion(.failure(.badURL))
            }
        }
    }
    

}

