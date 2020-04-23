//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 22/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelBottom: UILabel!
    
    public func setMeme(_ model: Meme) {
        labelTop.text = model.topText
        labelBottom.text = model.bottomText
        cellImageView.image = model.memedImage
    }
}
