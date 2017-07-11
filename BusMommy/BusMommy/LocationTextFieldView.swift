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
        
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
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
        handleGeocode(forQuery: updatedText)
        
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        // TODO: populate the cell with geocoded results
        
        return cell
    }
    
    // MARK: Geocoding
    func handleGeocode(forQuery queryString: String) {
        // TODO: implement geocode, populate tableview accordingly
    }

}


protocol LocationTextFieldViewDelegate {
    func userEnteredLocation()
}









