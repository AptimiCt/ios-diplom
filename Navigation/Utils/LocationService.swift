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
    
    var location: CLLocation?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        configure()
    }
    
    private func configure() {
        locationManager.delegate = self
    }
    private func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getLocation() {
        locationManager.requestLocation()
    }
}
extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                requestPermission()
            case .restricted:
                print("Запрещено через родительский контроль")
            case .denied:
                print("Вы запретили доступ к геолокации")
            case .authorizedAlways,.authorizedWhenInUse:
                manager.requestLocation()
            @unknown default:
                print("Не известный этап проверки")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
}
