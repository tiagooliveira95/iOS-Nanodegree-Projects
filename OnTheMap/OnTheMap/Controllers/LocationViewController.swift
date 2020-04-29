//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 28/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController{
    
    @IBOutlet weak var locationField: UITextField!
        
    @IBAction func onFindOnTheMapClickButtonClicked(_ sender: Any) {
        //Check if location is valid
        guard let location = locationField.text, !location.isEmpty else {
            //not valid show an error to the user
            return
        }
        performSegue(withIdentifier: SeguesConstants.SegueFindOnMapSegue, sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesConstants.SegueFindOnMapSegue {
            let viewController = segue.destination as! PickLocationViewController
            viewController.address = locationField.text
        }
    }
}
