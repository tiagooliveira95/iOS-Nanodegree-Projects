//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 01/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate {

    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    var mPin: Pin!
    var photos: [Photo]! = []
    var selectedPage = 1
    var correntLocationPagesCount: Int! = 1

    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        let coord = CLLocationCoordinate2D(latitude: mPin.lat, longitude: mPin.lng)
        addMapAnnotation(coordinates: coord)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if mPin.hasPhotos {
            correntLocationPagesCount = Int(mPin.maxPages)
            loadImagesFromCD()
        }else{
            loadImagesFromCloud(coord: coord)
        }
    }
    
    func loadImagesFromCloud(coord: CLLocationCoordinate2D, page: Int = 1) {
        self.dismiss(animated: true) // dismiss ui alert

        print("loading from cloud")
        self.photos = []
        self.collectionView.reloadData()
        
        self.showActivityLoadingIndicatorView("Downloading images...")
        newCollectionButton.isEnabled = false
        
        FlickrProvider().getGeolocationData(coordinates: coord, page: String(page)){ bool, photos, error in
            print("Success: \(bool) error: \(error?.localizedDescription ?? "nil")")

            guard bool else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    self.dismiss(animated: true)
                    self.showUIAlert(title: "Error", message: "Please, double check your internet connection", style: .alert, actions: [], viewController: nil)
                    self.newCollectionButton.isEnabled = true
                }
                return
            }
            
            //used to check for page overflow
            self.correntLocationPagesCount = photos!.pages
            self.mPin.maxPages = Int16(photos!.pages)
            
            self.mPin.lastPageSaved = Int16(page)
            
            
            print("photos cloud, Page count: \(photos!.pages), Selected Page: \(String(page)), Image count \(photos!.photo.count) ")

            
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
                    photoCD.page = Int16(page)
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
               
                self.mPin.hasPhotos = true
                self.coreData.saveContext()
            }
            
            
           
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
    
    func loadImagesFromCD(page: Int = 1){
        print("loading from core data :)")
        self.showActivityLoadingIndicatorView("Loading images...", animated: false)

        self.newCollectionButton.isEnabled = false
        
        //Query CD for photos at page = x
        let fetch: NSFetchRequest<PhotoCD> = PhotoCD.fetchRequest()
        fetch.predicate = NSPredicate(format: "pin == %@ && page == %@", mPin, String(Int16(page)))
        let photosCD: [PhotoCD] = try! self.coreData.persistentContainer.viewContext.fetch(fetch)
                
        print("photos CoreData count: \(photosCD.count), Page: \(String(Int16(page)))")
        
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
            
            if self.photos!.count > 0  {
                self.noImagesLabel.isHidden = true
            }
            self.newCollectionButton.isEnabled = true
            self.dismiss(animated: true)
            self.collectionView.insertItems(at: [IndexPath(row: i, section: 0)])
           
        }
        self.dismiss(animated: true)
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
        let photo = photos[indexPath.row]
        cell.setPhoto(photo: photo)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let fetch:NSFetchRequest<PhotoCD> = PhotoCD.fetchRequest()
            fetch.predicate = NSPredicate(format: "id == %@", self.photos[indexPath.row].id)
            let delPhoto = try! self.coreData.persistentContainer.viewContext.fetch(fetch).first
            self.coreData.persistentContainer.viewContext.delete(delPhoto!)

            self.photos.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }
    }
    
    @IBAction func onNewLocationClicked(_ sender: Any) {
        photos = []
        collectionView.reloadData()
        
        print("lastPage: \(String(mPin.lastPageSaved))")
        selectedPage += 1
        
        //check if we exceeded the max page count, if so reset it back to 1
        if self.correntLocationPagesCount < selectedPage{
            selectedPage = 1
        }
        
        if selectedPage <= mPin.lastPageSaved {
            loadImagesFromCD(page: selectedPage)
        }else{
            loadImagesFromCloud(coord:CLLocationCoordinate2D(latitude: mPin.lat, longitude: mPin.lng), page: selectedPage)
        }
    }
}
