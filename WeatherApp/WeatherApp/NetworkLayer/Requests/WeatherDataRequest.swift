//
//  WeatherDataRequest.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 06/06/23.
//

import Foundation

struct WeatherDataRequest: DataRequest {
    
    typealias DataModel = WeatherModel
    private let apiKey = APIConstants.APIKeys.weatherApiKey
    
    var networkService: RestNetworkService?
    var queryItems: [String : Any] = [APIConstants.QueryConstants.appId.rawValue: APIConstants.APIKeys.weatherApiKey]
    
    var url: String {
        let baseURL: String = APIConstants.HttpString.openWeatherBaseUrl
        return baseURL
    }
    
    init(networkService: RestNetworkService? = nil) {
        self.networkService = networkService
    }
    
    mutating func addQueryItem(withCityName city: String) {
        queryItems[APIConstants.QueryConstants.query.rawValue] = city
    }
    
    mutating func addQueryItem(withCoordinates coordinates: Coordinates) {
        queryItems[APIConstants.QueryConstants.latitude.rawValue] = coordinates.lat
        queryItems[APIConstants.QueryConstants.longtitude.rawValue] = coordinates.lon
    }
    
    func getWeatherInfo(completion: @escaping (Result<WeatherModel, ServiceError<String>>) -> Void) {
        
        print("started - weather service - api - getWeatherInfo")
        networkService?.request(self) { result in
            switch result {
            case .success(let weather):
                let weatherInfo = weather
                print("sending completion getWeatherInfo", Thread.current)
                completion(.success(weather))
            case .failure(_):
                print("failed, so inform to user")
                completion(.failure(.badURL))
            }
        }
    }
}

