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
    @IBOutlet weak var activityLoadingIndicator: UIActivityIndicatorView!
    
    func setPhoto(photo: Photo) {
        let photoURL = FlickrProvider().getPhotoDownloadURL(photo: photo)
        FlickrProvider().downloadPhoto(url: photoURL) { (imageData) in
            if imageData == nil { return }
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData!){
                    self.imageView.image = image
                    self.activityLoadingIndicator.isHidden = true
                }else{
                    self.imageView.isHidden = false;
                }
            }
        }
    }
}
