//
//  MemeDisplayViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 21/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeDisplayViewController : UIViewController {
    
    
    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("setting the image")
        self.memedImage.image = meme?.memedImage
    }
}
