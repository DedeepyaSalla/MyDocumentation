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
        [APIConstants.QueryConstants.country.rawValue: APIConstants.QueryConstants.unitedStates.rawValue]
    }
    
    var url: String {
        let baseURL: String = APIConstants.HttpString.getCitiesURL
        return baseURL
    }
    
}

