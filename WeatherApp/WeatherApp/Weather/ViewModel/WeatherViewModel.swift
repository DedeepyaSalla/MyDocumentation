//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import Foundation
import UIKit

/**
    Converts current Kelvin value to Farenheit value. Uses below formula. Assuming  value is in Kelvin units.
    formula: Fahrenheit = (temperature in Kelvin - 273.15) * 9/5 + 32
 */

protocol WeatherViewModelProtocol {
    var weather: CurrentWeatherInfo { get  set }
    func fetchWeather(city: String?, coordinates: Coordinates?)
    func saveWeatherInfo()
}

class WeatherViewModel: ObservableObject {
    @Published var weather: CurrentWeatherInfo?
    private let networkService: RestNetworkService
    
    init(networkService: RestNetworkService) {
        self.networkService = networkService
        featchAllCities()
    }
    
    private func featchAllCities() {
        let citiesService = GetCitiesService()
//        networkService.request(citiesService) { result in
//            print("cities list")
//            print(result)
//        }
    }
    
    func fetchWeather(city: String?, coordinates: Coordinates?) {
        var weatherService = WeatherDataRequest(networkService: networkService)
        if let city = city {
            weatherService.addQueryItem(withCityName: "London, UK")
        } else if let coordinates = coordinates {
            weatherService.addQueryItem(withCoordinates: coordinates)
        }
        
        weatherService.getWeatherInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.saveWeatherInfo(weatherInfo: weather)
                    if weather.weather.count > 0 {
                        let weatherIcon = weather.weather[0].icon
                        self?.getWeatherIcon(iconName: weatherIcon)
                    }
                case .failure(_):
                    print("failed, so inform to user")
                }
            }
        }
    }
    
    func getWeatherIcon(iconName: String) {
        let imageService = ImageService(req: WeatherIconDataRequest(imageIcon: iconName))
        imageService.getWeatherIcon {  image in
            print(image)
        }
    }
    
    func featureSkyIcon() {
 
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
        model.description = weatherInfo?.weather.description ?? ""
        model.skyImageUrl = ""
        
        weather = model
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(CurrentWeatherInfo()) {
            UserDefaults.currentWeatherInfo = encoded
           }
    }
    
}

