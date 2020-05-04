//
//  PhotoAlbumViewCell.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 03/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class PhotoAlbumViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!


    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageView.isHidden = false;
        }
    }
    
    func setPhoto(photo: Photo) {
        let photoURL = FlickrProvider().getPhotoDownloadURL(photo: photo)
        FlickrProvider().downloadPhoto(url: photoURL) { (imageData) in
            if imageData == nil { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData!){
                    self.imageView.image = image
                    //print("downloaded")
                }else{
                    self.imageView.isHidden = false;
                }
                //print("hidden")
            }
        }
    }
}
