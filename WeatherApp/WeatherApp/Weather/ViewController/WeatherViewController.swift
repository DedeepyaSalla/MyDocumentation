//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import UIKit
import Combine

/**
    Displays weather information.
        - Intially checks if weather information from previous session exists and if exists then displays weather information from that session
        - Then tries to replace that previous session weather info with latest weather info by using user's current location
        - If user searches for any specific location, then fetches weather info for that location
 */

class WeatherViewController: UIViewController, StoryboardLoadable {
    
    private var weatherViewModel: WeatherViewModel?
    private var weatherLoadCancellable: AnyCancellable?
    private var imageLoadCancellable: AnyCancellable?
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
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
    
    func setUpInitialData() {
        // initialize viewModel
        setUpViewModel()
        
        // reload previous weather data if exists
        reloadPreviousData()
        
        // replace the previous data with curren location weather
        getWeatherOfUserLocation()
    }
    
    func setUpViewModel() {
        let service = DefaultRestNetworkService()
        weatherViewModel = WeatherViewModel(networkService: service)
        
        weatherLoadCancellable = weatherViewModel?.$weather.sink {[weak self] weatherData in
            if let val = weatherData {
                self?.reloadViewData(weather: val)
            }
        }
        
        imageLoadCancellable = weatherViewModel?.$cloudImage.sink {[weak self] image in
            if let image = image {
                self?.skyImageView.image = image
            }
        }
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

    func reloadViewData(weather: CurrentWeatherInfo) {
        print("came to reload view")
        print(weather)
        currentTemperature.text = getStrFormat(val: weather.temperature.farenheit)
        feelsLikeLabel.text = "Feels like " + getStrFormat(val: weather.feelsLike.farenheit)
        visibilityLabel.text = getStrFormat(val: weather.visibility)
        pressureLabel.text = getStrFormat(val: weather.pressure)
        humidityLabel.text = getStrFormat(val: weather.humidity)
        minTemperatureLabel.text = getStrFormat(val: weather.minTemp)
        maxTemperatureLabel.text = getStrFormat(val: weather.maxTemp)
        skyInfoLabel.text = weather.description
        cityNameLabel.text = weather.cityName
        //skyImageView.image = UIImage()
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
