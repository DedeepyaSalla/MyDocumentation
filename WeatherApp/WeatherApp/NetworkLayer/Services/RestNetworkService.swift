//
//  RestNetworkService.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Result<response, error: Error> {
    case success (response)
    case failure (error)
}

enum ServiceError<errorInfo>: Error {
    case badURL
    case apiFailure (errorInfo)
    case httpStatusError
    case emptyData
    case parseError (errorInfo)
}

protocol RestNetworkService {
    func request<Request: DataRequest>(_ serviceInfo: Request, completion: @escaping (Result<Request.DataModel, ServiceError<String>>) -> Void)
}

final class DefaultRestNetworkService: RestNetworkService {
    
    func request<Request: DataRequest> (_ serviceInfo: Request, completion: @escaping ( Result<Request.DataModel, ServiceError<String>> ) -> Void) {
        
        var postData:Data?
        
        guard var urlComponent = URLComponents(string: serviceInfo.url) else {
            return completion(.failure(.badURL))
        }
        
        switch serviceInfo.method {
            case HTTPMethod.get:
                let urlQueryItems = getQueryItems(queryItems: serviceInfo.queryItems)
                urlComponent.queryItems = urlQueryItems
            case HTTPMethod.post:
                let parameters: [String: Any] = ["country": "United States"]
                postData = getHttpBodyData(params: parameters)
        }
        
        guard let url = urlComponent.url else {
            return completion(.failure(.badURL))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = serviceInfo.method.rawValue
        if let postData = postData {
            urlRequest.httpBody = postData
        }
        
        makeApiCall(dataRequest: serviceInfo, urlRequest: urlRequest) { result in
            completion(result)
        }
    }
    
    private func makeApiCall<Request: DataRequest>(dataRequest: Request, urlRequest: URLRequest, completion: @escaping (Result<Request.DataModel, ServiceError<String>>) -> Void) {
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.apiFailure(error.localizedDescription)))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(.httpStatusError))
            }
            
            guard let data = data else {
                return completion(.failure(.emptyData))
            }
            
            do {
                try completion(.success(dataRequest.decode(data)))
            } catch let parseError {
                completion(.failure(.parseError(parseError.localizedDescription)))
            }
        }
        .resume()
    }
    
    private func getQueryItems(queryItems: [String: Any]) -> [URLQueryItem] {
        var urlQueryItems: [URLQueryItem] = []
        
        queryItems.forEach {
            let item = URLQueryItem(name: $0.key, value: "\($0.value)")
            urlQueryItems.append(item)
        }
        
        return urlQueryItems
    }
    
    private func getHttpBodyData(params: [String: Any]) -> Data? {
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            let parameters: [String: Any] = ["country": "United States"]
            return "country=United States".data(using: .utf8)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
