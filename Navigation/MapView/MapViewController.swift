//
//
// MapViewController.swift
// Navigation
//
// Created by Александр Востриков
//
    

import UIKit
import MapKit


final class MapViewController: UIViewController {
    
    private let latitudinalMeters: CLLocationDistance = 1000
    private let longitudinalMeters: CLLocationDistance = 1000
    private let locationService = LocationService()
    
    //MARK: - let mapView
    private lazy var  mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.toAutoLayout()
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
                
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .flat)
        }
        mapView.delegate = self
        return mapView
    }()
    
    private let tabBar: UITabBarItem = {
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: "map.fill")
        tabBarItem.title = Constants.tabBarItemMapTitle
        return tabBarItem
    }()
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        let image = UIImage(systemName: "paperplane.fill")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .green
        button.addTarget(self, action: #selector(locationAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeAnnotationsButton: UIButton = {
        let button = UIButton()
        button.toAutoLayout()
        let image =  UIImage(systemName: "trash.fill")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .red
        button.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - init
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = tabBar
        view.backgroundColor = .systemGray3
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        longPressForAddAnnotation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocation()
    }
}
//MARK: - private extension
private extension MapViewController {
    func longPressForAddAnnotation() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        mapView.addGestureRecognizer(longPress)
    }
    func getLocation() {
        locationService.getLocation { location in
            DispatchQueue.main.async { [weak self] in
                guard let self, let coordinate = location?.coordinate else { return }
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: self.latitudinalMeters, longitudinalMeters: self.longitudinalMeters)
                self.mapView.setCenter(coordinate, animated: true)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    func setPin(_ location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        locationService.getNameFor(location: location) { title in
            annotation.title = title
        }
        mapView.addAnnotation(annotation)
    }
    func removeAllAnnotations(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    func setupView() {
        view.addSubviews(mapView, removeAnnotationsButton, currentLocationButton)
        self.tabBarItem = tabBar
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            currentLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            currentLocationButton.widthAnchor.constraint(equalToConstant: Constants.screenWeight / 10),
            currentLocationButton.heightAnchor.constraint(equalTo: currentLocationButton.widthAnchor),
            
            removeAnnotationsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            removeAnnotationsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            removeAnnotationsButton.widthAnchor.constraint(equalToConstant: Constants.screenWeight / 10),
            removeAnnotationsButton.heightAnchor.constraint(equalTo: currentLocationButton.widthAnchor),
        ])
    }
}
//MARK: - @objc private extension
@objc private extension MapViewController {
    func locationAction() {
        getLocation()
    }
    func removeAction() {
        removeAllAnnotations()
    }
    func longPressAction(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let mapCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            let mapLocation = CLLocation(latitude: mapCoordinate.latitude, longitude: mapCoordinate.longitude)
            setPin(mapLocation)
        }
    }
}
//MARK: - extension MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    //Настройка линии маршрута
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 6
        return render
    }
    
    //Добавление маркеров аннотаций
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var viewMarker: MKMarkerAnnotationView
        let idView = Constants.idView
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        }
        return viewMarker
    }
    
    //Построение маршрута
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let userCoordinate = mapView.userLocation.coordinate
        guard let annotationCoordinate = view.annotation?.coordinate else { return }
        mapView.removeOverlays(mapView.overlays)
        let startPoint = MKPlacemark(coordinate: userCoordinate)
        let endPoint = MKPlacemark(coordinate: annotationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            guard let response else { return }
            for route in response.routes {
                mapView.addOverlay(route.polyline)
            }
        }
    }
}
