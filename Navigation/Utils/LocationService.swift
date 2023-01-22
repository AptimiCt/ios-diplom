//
//
// LocationService.swift
// Navigation
//
// Created by Александр Востриков
//


import Foundation
import CoreLocation

final class LocationService: NSObject {
    
    private var locationManager: CLLocationManager
    
    private var completion: ((CLLocation) -> Void)?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
    }
    
    private func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: @escaping ((_ location: CLLocation?) -> Void)) {
        self.completion = completion
        requestPermission()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    
    func getNameFor(location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard error == nil, let place = placemarks?.first else {
                completion(nil)
                return
            }
            let name = place.name
            completion(name)
        }
    }
}
extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                requestPermission()
            case .restricted:
                print("Доступ к геолокации запрещен через родительский контроль!")
            case .denied:
                print("Вы запретили доступ к геолокации!")
            case .authorizedAlways,.authorizedWhenInUse:
                manager.requestLocation()
            @unknown default:
                print("Не известный этап проверки.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            completion?(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
