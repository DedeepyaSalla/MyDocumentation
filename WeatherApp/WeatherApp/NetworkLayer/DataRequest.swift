//
//  DataRequest.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation

/**
 Whenever a new URL request is created, create ur own concrete type and confirm to this protocol. So that nothing will be missed and you can take help of default implementations
 */

protocol DataRequest {
    associatedtype DataModel
    
    var url: String {get}
    var method: HTTPMethod { get }
    var queryItems: [String: Any] {get}
    
    func decode(_ data: Data) throws -> DataModel
}

extension DataRequest where DataModel: Decodable {
    func decode(_ data: Data) throws -> DataModel {
        let decoder = JSONDecoder()
        return try decoder.decode(DataModel.self, from: data)
    }
}

extension DataRequest {
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [String: Any] {
        [:]
    }
}
