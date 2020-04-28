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
    
    @IBAction func onSignOutButtonClicked(_ sender: Any) {
        //show loading message
        AuthProvider.logout { (result, error) in
            if error != nil {
                //TODO show error
                return;
            }
    
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func onAddNewLocationClicked(_ sender: Any) {
        performSegue(withIdentifier: SeguesConstants.SegueAddPin, sender: nil)
    }
}
