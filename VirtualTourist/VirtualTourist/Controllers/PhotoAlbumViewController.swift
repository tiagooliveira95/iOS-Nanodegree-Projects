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

    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    var mPin: Pin!
    var photos: [Photo]! = []
    var selectedPage = 1

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
        
        if mPin.hasPhotos {
            loadImagesFromCD()
        }else{
            loadImagesFromCloud(coord: coord)
        }
    }
    
    func loadImagesFromCloud(coord: CLLocationCoordinate2D, page: Int = 1) {
        print("loading from cloud")
        
        self.showActivityLoadingIndicatorView("Downloading images...")
        newCollectionButton.isEnabled = false
        
        FlickrProvider().getGeolocationData(coordinates: coord, page: String(page)){ bool, photos, error in
            print("Success: \(bool) error: \(error?.localizedDescription ?? "nil")")

            guard bool else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {self.dismiss(animated: true)}
                //TODO show error to the user!
                return
            }
            //Debug
            print("photo: \(photos!.photo.count)")
            print("pages: \(photos!.pages)")
            print("perpage: \(photos!.perpage)")
            
            //reset page index, if page count == page, the selected page will be set to 0, so when the next collection button is pressed the next page will be 1
            
            //TODO maybe this is no longer needed since i have already implemented CD, check later!.
            if photos!.pages == page {
                self.selectedPage = 0
            } else {
                self.mPin.lastPageSaved = Int16(page)
            }
            
            print(FlickrProvider().getPhotoDownloadURL(photo: photos!.photo[0]))
            self.photos = photos!.photo
            
            for (i, photo) in self.photos.enumerated() {
                let photoURL = FlickrProvider().getPhotoDownloadURL(photo: photo)
               
                FlickrProvider().downloadPhoto(url: photoURL){ image in
                    let photoCD = PhotoCD(context: self.coreData.persistentContainer.viewContext)
                    photoCD.id = photo.id
                    photoCD.farm = Int16(photo.farm)
                    photoCD.imageData = image
                    photoCD.owner = photo.owner
                    photoCD.secret = photo.secret
                    photoCD.server = photo.server
                    photoCD.title = photo.title
                    self.mPin.addToPhotos(photoCD)
                    
                    DispatchQueue.main.async {
                        self.photos[i].imageData = image
                        self.collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if photos!.photo.count > 0  {
                    self.noImagesLabel.isHidden = true
                }
                self.newCollectionButton.isEnabled = true
                self.dismiss(animated: true)
            }
            
            self.mPin.hasPhotos = true
            self.coreData.saveContext()
           
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //    if photos!.photo.count > 0  {
            //        self.noImagesLabel.isHidden = true
            //    }
            //    self.newCollectionButton.isEnabled = true
            //    self.dismiss(animated: true)
            //    self.collectionView.reloadData()
            //}
        }
    }
    
    func loadImagesFromCD(){
        print("loading from core data :)")
        self.newCollectionButton.isEnabled = false
        let photosCD: [PhotoCD] = mPin.photos!.allObjects as! [PhotoCD]
        
        print("photos core data count: \(photosCD.count)")
        
        for (i, photoCD) in photosCD.enumerated() {
            let photo = Photo(id: photoCD.id!,
                owner: photoCD.owner!,
                secret: photoCD.secret!,
                server: photoCD.server!,
                farm: Int(photoCD.farm),
                title: photoCD.title!,
                imageData: photoCD.imageData!
            )
           
            photos.append(photo)
            
            DispatchQueue.main.async {
                if self.photos!.count > 0  {
                    self.noImagesLabel.isHidden = true
                }
                self.newCollectionButton.isEnabled = true
                self.dismiss(animated: true)
                
                self.collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
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
            self.photos.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }
    }
    
    @IBAction func onNewLocationClicked(_ sender: Any) {
        photos = []
        collectionView.reloadData()
        selectedPage += 1
        print("lastPage: \(String(mPin.lastPageSaved))")
        if selectedPage < mPin.lastPageSaved {
            loadImagesFromCD()
        }else{
            loadImagesFromCloud(coord:CLLocationCoordinate2D(latitude: mPin.lat, longitude: mPin.lng), page: selectedPage)
        }
    }
}
