//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 01/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController{
    
    var mPin: Pin!

    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        let coord = CLLocationCoordinate2D(latitude: mPin.lat, longitude: mPin.lng)
        addMapAnnotation(coordinates: coord)
        
        print(FlickrProvider().getGeoUrl(coordinates: coord))
    }
    
    func addMapAnnotation(coordinates: CLLocationCoordinate2D) {
        setMapPosition(coordinates: coordinates)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    func setMapPosition(coordinates: CLLocationCoordinate2D){
        let locationDistance = CLLocationDistance(500)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        mapView.setRegion(region, animated: true)
    }
    
}
