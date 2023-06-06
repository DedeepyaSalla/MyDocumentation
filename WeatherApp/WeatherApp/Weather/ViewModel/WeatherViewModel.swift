//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import Foundation
import UIKit

protocol WeatherViewModelProtocol {
    var weather: CurrentWeatherInfo { get  set }
    var citiesList: [String] { get  set }
    func fetchWeather(city: String?, coordinates: Coordinates?)
    func saveWeatherInfo()
}

class WeatherViewModel: ObservableObject {
    @Published var weather: CurrentWeatherInfo?
    @Published var cloudImage: UIImage?
    private let networkService: RestNetworkService
    var citiesList: [String] = []
    
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        return cache
    }()
    
    init(networkService: RestNetworkService) {
        self.networkService = networkService
        featchAllCities()
    }
    
    private func featchAllCities() {
        let citiesService = GetCitiesService()
        networkService.request(citiesService) { [weak self] result in
            print("Obtained final cities response")
            DispatchQueue.main.async {
                switch result {
                case .success(let citiesModel):
                    self?.citiesList = citiesModel.data
                case .failure(_):
                    print("failed, to get cities")
                }
            }
        }
    }
    
    func fetchWeather(city: String?, coordinates: Coordinates?) {
        var weatherService = WeatherDataRequest(networkService: networkService)
        if let city = city {
            weatherService.addQueryItem(withCityName: "Oreland")
        } else if let coordinates = coordinates {
            weatherService.addQueryItem(withCoordinates: coordinates)
        }
        
        weatherService.getWeatherInfo { [weak self] result in
            print("Obtained final weatherService response")
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    print("updating weather ui", Thread.current)
                    self?.saveWeatherInfo(weatherInfo: weather)
                    if weather.weather.count > 0 {
                        let weatherIcon = weather.weather[0].icon
                        self?.getWeatherIcon(iconName: weatherIcon)
                    }
                case .failure(_):
                    print("failed, to get weather")
                }
            }
        }
    }
    
    func getWeatherIcon(iconName: String) {
        let imageRequest = WeatherIconDataRequest(imageIcon: iconName)
        let imageService = ImageService(req: imageRequest, imageCach: imageCache)
        
        imageService.getWeatherIcon {  image in
            DispatchQueue.main.async {
                print("received image and came to main to udpate it", Thread.main)
                self.cloudImage = image
            }
        }
    }

    func saveWeatherInfo(weatherInfo: WeatherModel?) {
        var model = CurrentWeatherInfo()
        model.temperature = weatherInfo?.main.temp ?? 0.0
        model.feelsLike = weatherInfo?.main.temp ?? 0.0
        model.visibility = weatherInfo?.main.temp ?? 0.0
        model.pressure = weatherInfo?.main.temp ?? 0.0
        model.humidity = weatherInfo?.main.temp ?? 0.0
        model.temperature = weatherInfo?.main.temp ?? 0.0
        model.minTemp = weatherInfo?.main.temp ?? 0.0
        model.maxTemp = weatherInfo?.main.temp ?? 0.0
        model.skyImageUrl = ""
        model.cityName = weatherInfo?.name ?? ""
        if (weatherInfo?.weather.count ?? 0) > 0 {
            model.description = weatherInfo?.weather[0].description ?? ""
        }
        
        weather = model
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(CurrentWeatherInfo()) {
            UserDefaults.currentWeatherInfo = encoded
           }
    }
    
}

