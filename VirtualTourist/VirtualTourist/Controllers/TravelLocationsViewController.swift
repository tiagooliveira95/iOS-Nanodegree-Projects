//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 30/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.delegate = self
    }
}
