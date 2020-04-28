//
//  PickLocationViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 28/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import MapKit

class PickLocationViewController: UIViewController{
    
    var address: String!
    var latlng: CLLocationCoordinate2D!

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           _ = getCoordinatesLatLng(forAddress: address) { (coord) in
               let pin = MKPointAnnotation()
               pin.coordinate = coord!
               self.latlng = coord!
               self.mapView.addAnnotation(pin)
               self.mapView.setCenter(coord!, animated: true)
           }
    }
    
    func getCoordinatesLatLng(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                //TODO shoe error to user
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    
    @IBAction func onSubmitButtonCLicked(_ sender: Any) {
    }
    
}
