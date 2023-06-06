//
//  ImageService.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import UIKit



class ImageService {
    
    var imageRequest: WeatherIconRequest
    var networkService: RestNetworkService
    
    private let lock = NSLock()
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        return cache
    }()
    
    init(req: WeatherIconRequest, networkService: RestNetworkService = DefaultRestNetworkService()) {
        imageRequest = req
        self.networkService = networkService
    }
    
    func insertInCache(_ image: UIImage?, for url: String) {
        guard let image = image else { return }
        
        lock.lock()
        defer {
            lock.unlock()
        }
        imageCache.setObject(image, forKey: url as AnyObject)
    }
    
    func downloadImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        networkService.request(imageRequest) { result in
            switch result {
            case .success(let response):
                //placeholderImage: UIImage?
                guard let image: UIImage = response as? UIImage else {
                    return
                }
                completion(image, nil)
                print(image)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func getWeatherIcon(completion: @escaping (UIImage?) -> Void) {
        
        if let cacheImage = imageCache.object(forKey: imageRequest.url as AnyObject) as? UIImage {
            completion(cacheImage)
        } else {
            downloadImage { [weak self] image, error in
                guard let self = self else {
                    return
                }

                guard let image = image else {
                    print(error?.localizedDescription)
                    return
                }
                self.insertInCache(image, for: imageRequest.url)
                completion(image)
            }
        }
    }
}
