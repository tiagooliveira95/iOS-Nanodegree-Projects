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
    
    //used to set the height of the submit button to it's original height when keyboard is closed
    var normalSubmitButtonConstraintBottom: CGFloat! = 0.0


    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showActivityLoadingIndicatorView("Fetching address...")

           _ = getCoordinatesLatLng(forAddress: address) { (coord) in
               let pin = MKPointAnnotation()
               pin.coordinate = coord!
               self.latlng = coord!
               self.mapView.addAnnotation(pin)
               self.mapView.setCenter(coord!, animated: true)
           }
        
        for constraint in self.view.constraints {
            if constraint.identifier == Identifiers.SubmitButtonBottomConstraitIdentifier {
               normalSubmitButtonConstraintBottom = constraint.constant
                break
            }
        }
        
        subscribeToKeyboardNotifications()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    func getCoordinatesLatLng(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {

        CLGeocoder().geocodeAddressString(address) {
            (placemarks, error) in
            self.dismiss(animated: false)
            
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showUIAlert(title: "Address not found", message: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                }
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
            
            if !result{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.dismiss(animated: false)
                      self.showUIAlert(title: "Error", message: "An error occured while trying to save your location, please try again later", style: .alert, actions: [], viewController: nil)
                }
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: SeguesConstants.UnwindBackToMapSegue, sender: self)
                self.dismiss(animated: true)
            }
        }
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow (_ notification: Notification) {
        for constraint in self.view.constraints {
            if constraint.identifier == Identifiers.SubmitButtonBottomConstraitIdentifier {
               constraint.constant = getKeyboardHeight(notification) + normalSubmitButtonConstraintBottom
                break
            }
        }
        submitButton.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        //set submit button to it's original height
       for constraint in self.view.constraints {
            if constraint.identifier == Identifiers.SubmitButtonBottomConstraitIdentifier {
               constraint.constant = normalSubmitButtonConstraintBottom
                break
            }
        }
        submitButton.layoutIfNeeded()
    }
}
    


