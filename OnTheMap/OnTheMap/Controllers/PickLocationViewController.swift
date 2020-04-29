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
                self.showUIAlert(title: "Address not found", message: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    

    @IBAction func onSubmitButtonCLicked(_ sender: Any) {
        self.showActivityLoadingIndicatorView("Uploading location...")

        let studentPostLocation = StudentPostLocation();
       
        studentPostLocation.firstName = "Tiago"
        studentPostLocation.lastName = "Oliveira"
        studentPostLocation.latitude = latlng.latitude
        studentPostLocation.longitude = latlng.longitude
        studentPostLocation.mapString = address
        studentPostLocation.mediaURL = urlField.text
        studentPostLocation.uniqueKey = AuthProvider.loginData.account.key
        
        StudentProvider.postStudyLocation(studentPostLocation: studentPostLocation) {
            result in
          
            print("location saved: \(result)")
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SeguesConstants.UnwindBackToMapSegue, sender: self)
            }
        }
    }
}
    


