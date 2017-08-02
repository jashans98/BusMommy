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
import AVFoundation

class MapViewController: UIViewController, CLLocationManagerDelegate, LocationTextFieldViewDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var locationTextField: LocationTextFieldView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationTextField.layoutIfNeeded()
        
        // set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        // locationManager.startUpdatingLocation()
        
        locationTextField.delegate = self
        
        if locationManager.location != nil {
            updateLocation()
        } else {
            print("waiting to receive location")
        }
        
    }
    
    
    func updateLocation() {
        currentLocation = locationManager.location
        
        // give the text field context on current location to optimize querying
        locationTextField.userLocation = currentLocation
        print("current location: \(currentLocation!)")
        
        mapView.setCenter(currentLocation!.coordinate, zoomLevel: 10, animated: false)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (manager.location != nil) {
            currentLocation = manager.location
            locationTextField.userLocation = manager.location
            
            if mapView.annotations != nil && mapView.annotations!.count > 0{
                // compute the distance between two points
                let destinationCoordinate = mapView.annotations!.first!.coordinate
                let destination = CLLocation.init(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
                
                let distanceFromDestination: Double = currentLocation!.distance(from: destination)
                print("distance from destination: \(distanceFromDestination)")
                
                // if the user is less than 1km away from the destination, wake him up
                
                if distanceFromDestination <= 1000 {
                    
                    let soundURL = Bundle.main.url(forResource: "alarm", withExtension: "mp3")
                    do {
                        self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.play()
                    } catch {
                        print("error playing audio: \(error.localizedDescription)")
                    }
                    
                }
                
            }
        }
        
        

    }
    
    
    // MARK: CLLocationManagerDelegate
    func userEnteredLocation(_ location: CLLocation) {
        
        print("delegate called")
        
        // remove existing annotations
        if mapView.annotations != nil {
            mapView.removeAnnotations(mapView.annotations!)
        }
        
        // add a coordinate to the mapview and zoom in
        let destinationAnnotation = MGLPointAnnotation()
        destinationAnnotation.coordinate = location.coordinate
        
        mapView.setCenter(destinationAnnotation.coordinate, zoomLevel: 10, animated: true)
        mapView.addAnnotation(destinationAnnotation)
        
        // Start listening for location updates in the background
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        
    }

}

