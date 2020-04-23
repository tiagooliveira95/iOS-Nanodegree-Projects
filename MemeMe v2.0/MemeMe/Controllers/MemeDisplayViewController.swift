//
//  MemeDisplayViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 21/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeDisplayViewController : UIViewController {
    
    var image: UIImage!

    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memedImage.image = image
    }
    
    @IBAction func onCloseNavigationButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
