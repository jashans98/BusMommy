//
//  LocationTextFieldView.swift
//  BusMommy
//
//  Created by Jashan Shewakramani on 2017-07-11.
//  Copyright © 2017 Jashan Shewakramani. All rights reserved.
//

import UIKit
import MapboxGeocoder

class LocationTextFieldView: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let reuseIdentifier = "cell"
    var userLocation: CLLocation?
    var currentPlaceMarks: [Placemark] = []
    
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // TODO: implement
        let view = viewFromNibForClass()
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        view.autoresizesSubviews = true
        
        tableView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        // TODO: geocode and do stuff with the updated text
        if updatedText.characters.count > 5 {
            handleGeocode(forQuery: updatedText)
        } else {
            tableView.isHidden = true
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if reason == .committed {
            handleGeocode(forQuery: textField.text!)
        }
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // we never display more than the top 4 results
        return currentPlaceMarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        // TODO: populate the cell with geocoded results
        cell.textLabel?.text = currentPlaceMarks[indexPath.row].qualifiedName
        return cell
    }
    
    // MARK: Geocoding
    func handleGeocode(forQuery queryString: String) {

        // TODO: implement geocode, populate tableview accordingly
        let geocoder = Geocoder.shared
        
        let options = ForwardGeocodeOptions(query: queryString)
        options.focalLocation = CLLocation(latitude: 43.472285, longitude: -80.544858)
        options.autocompletesQuery = true
        options.allowedScopes = [.all]
        
        let _ = geocoder.geocode(options) { (placemarks, attributrion, error) in
            
            if (error != nil) {
                print("error geocoding: \(error!.localizedDescription)")
                return
            }
            
            if (placemarks == nil) {
                print("no placemarks")
                return
            }
            
            self.currentPlaceMarks = placemarks!
           
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    


}


protocol LocationTextFieldViewDelegate {
    func userSelectedLocation(_: CLLocationCoordinate2D)
}









