//
//  TabBarNavigationController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 26/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class TabBarNavigationController : UITabBarController {
    
    
    
    
    @IBAction func onAddNewLocationClicked(_ sender: Any) {
        performSegue(withIdentifier: SeguesConstants.SegueAddPin, sender: nil)
    }
}
