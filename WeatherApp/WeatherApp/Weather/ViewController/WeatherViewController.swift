//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import UIKit
import Combine

/**
    Converts current Kelvin value to Farenheit value. Uses below formula. Assuming  value is in Kelvin units.
    formula: Fahrenheit = (temperature in Kelvin - 273.15) * 9/5 + 32
 */

class WeatherViewController: UIViewController, StoryboardLoadable {
    
    private var weatherViewModel: WeatherViewModel?
    private var cancellable: AnyCancellable?
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var skyImageView: UIImageView!
    @IBOutlet weak var skyInfoLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    
    let appUtil = AppUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialData()
        setUpUI()
    }
    
    /*
     conditions:
     1.If your previous data exists, then reload view with that data
     2.If you have access to current location, use that location coordinates to get weather updates for that location. Map request and api request with that coordinates
     3.If you don't have access to current location, then request user to give access?? later
     4.make api call for cities or zipcodes only when user wants to search
     5.By dfault, when there is no location access and no search is performed -- display -- for all of them and default placeholder for image
     */
    func setUpInitialData() {
        // initialize viewModel
        let service = DefaultRestNetworkService()
        weatherViewModel = WeatherViewModel(networkService: service)
        
        cancellable = weatherViewModel?.$weather.sink {[weak self] weatherData in
            if let val = weatherData {
               // self?.reloadViewData(weather: val)
            }
        }
        // reload previous weather data if exists
        reloadPreviousData()
        
        // replace the previous data with curren location weather
        getWeatherOfUserLocation()
    }
    
    func reloadPreviousData() {
        let decoder = JSONDecoder()
        if let launch = try? decoder.decode(CurrentWeatherInfo.self, from: UserDefaults.currentWeatherInfo) {
            //kddp same model for reloading view -- so modify that
        }
    }
    
    func requestUserLocation() {
        appUtil.delegate = self
        appUtil.requestUserLocation()
    }
    
    func setUpUI() {
//        if let img = UIImage(named: DataStorageConstants.ImageNames.weatherBackground) {
//            self.view.backgroundColor = UIColor(patternImage: img)
//        }
       
        guard let locationsVC = getVC(storyboardId: DataStorageConstants.FileName.searchViewController) as? SearchViewController else {
            return
        }
        let searchController = UISearchController(searchResultsController: locationsVC)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    func reloadViewData(weather: WeatherModel) {
        currentTemperature.text = "\(weather.main.temp.farenheit)"
        feelsLikeLabel.text = getStrFormat(val: weather.main.feels_like)
        skyInfoLabel.text = getStrFormat(val: weather.weather.description)
        visibilityLabel.text = getStrFormat(val: weather.visibility)
        pressureLabel.text = getStrFormat(val: weather.main.pressure)
        humidityLabel.text = getStrFormat(val: weather.main.humidity)
        minTemperatureLabel.text = getStrFormat(val: weather.main.temp_min)
        maxTemperatureLabel.text = getStrFormat(val: weather.main.temp_max)
        skyImageView.image = UIImage()
    }
    
    func getStrFormat<T>(val: T) -> String {
        return "\(String(describing: val))"
    }
}

extension WeatherViewController: AppUtilityProtocol {
    func locationUpdated() {
        getWeatherOfUserLocation()
    }
    
    func getWeatherOfUserLocation() {
        let decoder = JSONDecoder()
        if let coordinates = try? decoder.decode(Coordinates.self, from: UserDefaults.currentLocation) {
            weatherViewModel?.fetchWeather(city: nil, coordinates: coordinates)
        } else {
            requestUserLocation()
        }
    }
}

extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? SearchViewController
        vc?.searchText = searchText
        weatherViewModel?.fetchWeather(city: searchText, coordinates: nil)
    }
}
