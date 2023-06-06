//
//  GetCitiesService.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation


struct GetCitiesService: DataRequest {
    
    typealias DataModel = CitiesModel
    
    var method: HTTPMethod {
        .post
    }

    var queryItems: [String : String] {
        ["country": "United States"]
    }
    
    var url: String {
        let baseURL: String = APIConstants.HttpString.getCitiesURL
        return baseURL
    }
    
//    func getCitiesList(networkService: RestNetworkService, completion: @escaping (Result<CitiesModel, ServiceError<String>>) -> Void) {
//
//        networkService.request(self) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let citiesInfo):
//                    let cities = citiesInfo.data
//                    print(cities.count)
//                    //completion(.success(cities))
//                case .failure(_):
//                    print("failed, so inform to user")
//                    completion(.failure(.badURL))
//                }
//            }
//        }
//    }
}

