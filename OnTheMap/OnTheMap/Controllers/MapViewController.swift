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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.delegate = self
        loadPins()
    }
    
    func loadPins() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        

        //TODO tell user that pins are loading
        
    
        StudentProvider.getStudents { (students, error) in
            if error != nil {
                print("error happen")
                //Show user network error
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
