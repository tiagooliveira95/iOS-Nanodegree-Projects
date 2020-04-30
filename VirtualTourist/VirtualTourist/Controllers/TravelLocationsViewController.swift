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
        loadMapPostion()
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapPosition()
    }
    
    func saveMapPosition() {
         //Saves the last map position
        let region = mapView.region
        let userDefaults = UserDefaults.standard
        userDefaults.set(region.center.latitude, forKey: UserDefaultsKeys.mapLastLatitude)
        userDefaults.set(region.center.longitude, forKey: UserDefaultsKeys.mapLastLongitude)
        userDefaults.set(region.span.latitudeDelta, forKey: UserDefaultsKeys.mapLastSpanLatitude)
        userDefaults.set(region.span.longitudeDelta, forKey: UserDefaultsKeys.mapLastSpanLongitude)
    }
    
    func loadMapPostion() {
         //Check for last map position
        let userDefaults = UserDefaults.standard
        guard let lat = userDefaults.value(forKey: UserDefaultsKeys.mapLastLatitude) else { return }
        guard let lng = userDefaults.value(forKey: UserDefaultsKeys.mapLastLongitude) else { return }
        guard let latSpan = userDefaults.value(forKey: UserDefaultsKeys.mapLastSpanLatitude) else { return }
        guard let lngSpan = userDefaults.value(forKey: UserDefaultsKeys.mapLastSpanLongitude) else { return }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: CLLocationDegrees(exactly: lat as! Double)!,
                longitude: CLLocationDegrees(exactly: lng  as! Double)!
            ),
            span: MKCoordinateSpan(
                latitudeDelta: CLLocationDegrees(exactly: latSpan  as! Double)!,
                longitudeDelta: CLLocationDegrees(exactly: lngSpan  as! Double)!
            )
        )
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
       
    }
}
