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
                self.showUIAlert(title: "Error", message: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                return;
            }
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func onAddNewLocationClicked(_ sender: Any) {
        performSegue(withIdentifier: SeguesConstants.SegueAddPin, sender: nil)
    }
    
    @IBAction func onRefreshButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConstants.NotificationReload), object: nil)
    }
}
