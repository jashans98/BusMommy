//
//  ViewController.swift
//  BusMommy
//
//  Created by Jashan Shewakramani on 2017-07-11.
//  Copyright © 2017 Jashan Shewakramani. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder

class MapViewController: UIViewController, CLLocationManagerDelegate, LocationTextFieldViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var locationTextField: LocationTextFieldView!
    var currentLocation: CLLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationTextField.layoutIfNeeded()
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        currentLocation = locationManager.location
        locationTextField.userLocation = currentLocation
        locationTextField.delegate = self
        print("current location: \(currentLocation!)")
        
        mapView.setCenter(currentLocation!.coordinate, zoomLevel: 10, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (manager.location != nil) {
            currentLocation = manager.location
            locationTextField.userLocation = manager.location
        }

    }
    
    func userEnteredLocation(_ location: CLLocation) {
        
        // remove existing annotations
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
        
        // add a coordinate to the mapview and zoom in
        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = location.coordinate
        
        mapView.setCenter(destinationAnnotation.coordinate, zoomLevel: 10, animated: true)
        mapView.addAnnotation(destinationAnnotation)
        
        
    }

}

