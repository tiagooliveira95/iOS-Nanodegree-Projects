//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 28/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController{
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    @IBAction func onFindOnTheMapClickButtonClicked(_ sender: Any) {
        //Check if location is valid
        guard let location = locationField.text, !location.isEmpty else {
            self.showUIAlert(title: "Location is not valid", message: "Please type a valid location.", style: .alert, actions: [], viewController: nil)
            return
        }
        performSegue(withIdentifier: SeguesConstants.SegueFindOnMapSegue, sender: nil)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesConstants.SegueFindOnMapSegue {
            let viewController = segue.destination as! PickLocationViewController
            viewController.address = locationField.text
        }
    }
    
    
    func subscribeToKeyboardNotifications() {
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          }
          
          func unsubscribeFromKeyboardNotification() {
              NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
          }
          
          private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
              let userInfo = notification.userInfo
              let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
              return keyboardSize.cgRectValue.height
          }
          
          @objc func keyboardWillShow (_ notification: Notification) {
            let keyboardHeight = getKeyboardHeight(notification)
            self.view.frame.origin.y = -keyboardHeight
          }
          
          @objc func keyboardWillHide (_ notification: Notification) {
              view.frame.origin.y = 0
          }
}
