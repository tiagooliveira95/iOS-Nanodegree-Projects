//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 01/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate {
    
    var mPin: Pin!
    var photos: [Photo]! = []

    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewDidLoad()
        let coord = CLLocationCoordinate2D(latitude: mPin.lat, longitude: mPin.lng)
        addMapAnnotation(coordinates: coord)
        collectionView.delegate = self
        collectionView.dataSource = self
        loadImages(coord: coord)
    }
    
    
    func loadImages(coord: CLLocationCoordinate2D) {
        self.showActivityLoadingIndicatorView("Downloading images...")
        newCollectionButton.isEnabled = false
        
        FlickrProvider().getGeolocationData(coordinates: coord){ bool, photos, error in
            print("Success: \(bool) error: \(error?.localizedDescription ?? "nil")")
            //TODO show error to the user!
            guard bool else { return }
            //Debug
            print("photo: \(photos!.photo.count)")
            print("pages: \(photos!.pages)")
            print("perpage: \(photos!.perpage)")
            
            print(FlickrProvider().getPhotoDownloadURL(photo: photos!.photo[0]))
            self.photos = photos!.photo
           
            DispatchQueue.main.async {
                if photos!.photo.count > 0  {
                    self.noImagesLabel.isHidden = true
                }
                self.newCollectionButton.isEnabled = true
                self.dismiss(animated: true)
                self.collectionView.reloadData()
            }
        }
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.PhotoAlbumViewCellIdentifier, for: indexPath) as! PhotoAlbumViewCell
    
        let photo = photos[indexPath.row];
        
        cell.setPhoto(photo: photo)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            //TODO
        }
    }
}
