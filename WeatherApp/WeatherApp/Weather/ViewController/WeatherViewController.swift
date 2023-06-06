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
    
    // MARK: - Private Properties
    private var searchResultsVC: SearchViewController?
    private var weatherViewModel: WeatherViewModel?
    private var allCancellables = Set<AnyCancellable>()
  
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
    
    // MARK: - Others
    let appUtility = AppUtility()
    
    // MARK: - Initial Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpInitialData()
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
        
        weatherViewModel?.$citiesList.sink {[weak self] cities in
            if let cities = cities {
                self?.searchResultsVC?.originalList = cities
            }
        }.store(in: &allCancellables)
        
      weatherViewModel?.$weather.sink {[weak self] weatherData in
            if let val = weatherData {
                self?.reloadViewData(weather: val)
            }
        }.store(in: &allCancellables)
        
        weatherViewModel?.$cloudImage.sink {[weak self] image in
            if let image = image {
                self?.skyImageView.image = image
            }
        }.store(in: &allCancellables)
    }
    
    func reloadPreviousData() {
        let decoder = JSONDecoder()
        if let launch = try? decoder.decode(CurrentWeatherInfo.self, from: UserDefaults.currentWeatherInfo) {
            //kddp same model for reloading view -- so modify that
        }
    }
    
    func requestUserLocation() {
        appUtility.delegate = self
        appUtility.requestUserLocation()
    }

    func setUpUI() {
//        if let img = UIImage(named: DataStorageConstants.ImageNames.weatherBackground) {
//            self.view.backgroundColor = UIColor(patternImage: img)
//        }
       
        guard let searchVC = getVC(storyboardId: DataStorageConstants.FileName.searchViewController) as? SearchViewController else {
            return
        }
        let searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        searchResultsVC = searchController.searchResultsController as? SearchViewController
        searchResultsVC?.delegate = self
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
    }
    
    func getStrFormat<T>(val: T) -> String {
        return "\(String(describing: val))"
    }
}

// MARK: - AppUtilityProtocol 
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

// MARK: - UISearchResultsUpdating Delegate
extension WeatherViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchResultsVC?.searchText = searchText
    }
}

// MARK: - UISearchResultsUpdating Delegate
extension WeatherViewController: SearchVCProtocol {
    
    func selectedItem(item: String) {
        searchResultsVC?.dismiss(animated: true)
        weatherViewModel?.fetchWeather(city: item, coordinates: nil)
    }
}
