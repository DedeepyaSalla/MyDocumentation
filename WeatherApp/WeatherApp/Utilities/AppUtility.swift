//
//  AppUtility.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 03/06/23.
//

import CoreLocation

protocol AppUtilityProtocol: AnyObject {
    func locationUpdated()
}

class AppUtility: NSObject {
    
    // MARK: - Request Permissions
    private var locationManager: CLLocationManager?
    weak var delegate: AppUtilityProtocol?
    
    override init() {
        super.init()
    }
    
    func requestUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate methods
extension AppUtility: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let coordinates = Coordinates(lon: userLocation.coordinate.longitude, lat: userLocation.coordinate.latitude)
        coordinates.setEncodedData(toObject: &UserDefaults.currentLocation)
        coordinates.getDecodeData(toObject: &UserDefaults.currentLocation)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        delegate?.locationUpdated()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        requestBasedOnStatus(status: status)
    }
    
    func requestBasedOnStatus(status: CLAuthorizationStatus) {
        switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                // Permission granted, you can start using location services
                print("Location permission granted")
                // Start updating location or perform any other location-related tasks
            locationManager?.startUpdatingLocation()
            //get current location and store it in ur appUtility or anyehwere
            case .denied, .restricted:
                // Permission denied or restricted, you cannot use location services
                //direct user to settings screen or give alert like that
                print("Location permission denied")
            case .notDetermined:
                // Permission not determined yet, user hasn't made a choice
            // request permission
            locationManager?.requestWhenInUseAuthorization()
                print("Location permission not determined")
            @unknown default:
                // Handle any future authorization status changes
                print("Unhandled location authorization status")
        }
    }
}


//        let decoder = JSONDecoder()
//        let launch = try? decoder.decode(Coordinates.self, from: UserDefaults.currentLocation)
        ///
//        print(UserDefaults.currentLocation)
//        print(launch)


//let encoder = JSONEncoder()
//if let encoded = try? encoder.encode(CurrentWeatherInfo()) {
//    UserDefaults.currentWeatherInfo = encoded
//   }
