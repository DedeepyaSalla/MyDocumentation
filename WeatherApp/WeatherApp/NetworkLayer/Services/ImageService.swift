//
//  ImageService.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 05/06/23.
//

import UIKit



class ImageService {
    
    var imageRequest: WeatherIconDataRequest
    var networkService: RestNetworkService
    private var imageCache: NSCache<AnyObject, AnyObject>?
    
    private let lock = NSLock()
    
    init(req: WeatherIconDataRequest, networkService: RestNetworkService = DefaultRestNetworkService(), imageCach: NSCache<AnyObject, AnyObject>) {
        imageRequest = req
        self.networkService = networkService
        imageCache = imageCach
    }
    
    func insertInCache(_ image: UIImage?, for url: String) {
        guard let image = image else { return }
        print("Imageservice -- insertInCache -- start", Thread.current)
        lock.lock()
        defer {
            print("Imageservice -- insertInCache -- ended and unloack thread", Thread.current)
            lock.unlock()
        }
        imageCache?.setObject(image, forKey: url as AnyObject)
        print("Imageservice -- insertInCache -- inserted", Thread.current)
    }
    
    func downloadImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        networkService.request(imageRequest) { result in
            switch result {
            case .success(let response):
                print("Imageservice -- downloadImage - completion - url session request", Thread.current)
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
        
        if let cacheImage = imageCache?.object(forKey: imageRequest.url as AnyObject) as? UIImage {
            completion(cacheImage)
        } else {
            downloadImage { [self] image, error in
                guard let image = image else {
                    print(error?.localizedDescription)
                    return
                }
                
                print("Imageservice -- inserting cache", Thread.current)
                self.insertInCache(image, for: imageRequest.url)
                print("Imageservice -- calling completion", Thread.current)
                completion(image)
            }
        }
    }
}
