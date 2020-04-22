//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 20/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    //TODO set image view dinamicly to fit all screens
    
    func setMeme(_ meme: Meme){
        //TODO
        cellImageView.image = meme.memedImage
    }
}
