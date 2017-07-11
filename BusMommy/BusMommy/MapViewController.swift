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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var locationTextField: LocationTextFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationTextField.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        locationTextField.userLocation = mapView.userLocation?.location
    }

}

