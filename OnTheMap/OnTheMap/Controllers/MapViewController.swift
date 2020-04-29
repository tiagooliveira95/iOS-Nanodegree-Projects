//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 27/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
        loadPins()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList(notification:)), name:NSNotification.Name(rawValue: NotificationConstants.NotificationReload), object: nil)
    }
    
    @objc func reloadList(notification: NSNotification){
           loadPins()
    }
    
    func loadPins() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        self.showActivityLoadingIndicatorView("Loading...")
            
        StudentProvider.getStudents { (students, error) in
            if error != nil {
                self.showUIAlert(title: "Network error occurred", message: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return
            }
            
            DispatchQueue.main.async {
                for student in students {
                    let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: student.latitude)!, longitude: CLLocationDegrees(student.longitude))
                    let pin = MKPointAnnotation()
                    pin.coordinate = coord
                    pin.title = "\(student.firstName) \(student.lastName)"
                    pin.subtitle = student.mediaURL
                    self.mapView.addAnnotation(pin)
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            let pinButton = PinUIButton(type: .infoLight)
            pinButton.pinUrl = annotation.subtitle!
            pinButton.tag = annotation.hash
            pinButton.addTarget(self, action: #selector(onUrlButtonPress), for: .touchUpInside)
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.rightCalloutAccessoryView = pinButton
            return pinView
        }
        else {
            return nil
        }
    }
    
    @objc func onUrlButtonPress(sender: PinUIButton){
        let url = URL(string: sender.pinUrl!.starts(with: "www") ? "https://" + sender.pinUrl! : sender.pinUrl!)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            //TODO show message
        }
    }
}
