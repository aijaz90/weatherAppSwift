//
//  LocationManager.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 02/05/2024.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateCurrentLocation(cityName: String?, lat: Double, long: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()  // Singleton instance
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
    var currentLocation: CLLocation?
    var currentCity: String = ""
    
    weak var delegate: LocationManagerDelegate?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location permissions are restricted or denied")
            onAuthorizationChange?(.denied)
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("A new case was added to CLAuthorizationStatus")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
        onAuthorizationChange?(status) // Notify about authorization status change
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if let location = locations.last {
            self.getCurrentCityName(location: location)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    
    private func getCurrentCityName(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.delegate?.didUpdateCurrentLocation(cityName: city, lat: location.coordinate.latitude, long: location.coordinate.longitude)
                } else {
                    self.delegate?.didUpdateCurrentLocation(cityName: nil, lat: location.coordinate.latitude, long: location.coordinate.longitude)
                    print("City name not found")
                }
            } else {
                self.delegate?.didUpdateCurrentLocation(cityName: nil, lat: location.coordinate.latitude, long: location.coordinate.longitude)
                print("No placemarks found")
            }
        }
    }
    
    // MARK: - Get City coordinates using by providing city name
    public func geocodeCityName(cityName: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                completion(.success(coordinate))
            } else {
                completion(.failure(NSError(domain: "LocationManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "No coordinates found for \(cityName)"])))
            }
        }
    }
}
