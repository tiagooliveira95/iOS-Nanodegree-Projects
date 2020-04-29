//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 26/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        //Disable login button to avoid multiple clicks
        loginButton.isEnabled = false
        
        //Validate user input
        guard let email = emailField?.text, let password = passwordField?.text,
            //check if user input is empty
            !email.isEmpty && !password.isEmpty &&
            //Validate email and check if password ranges are valid, Udacity has a minimum password length of 8 charecters.
            //Therefore there's no need to make a login request to the server if the password doesn't meet the minimum requirements
            password.count >= ServerConstants.UDACITY_MIN_PASSWORD_LENGTH && email.contains("@") else {
                
            loginButton.isEnabled = true
            
            self.showUIAlert(title: "Invalid credentials", message: "Please review your credentials details", style: .alert, actions: [], viewController: nil)
                
            return
        }
        
        self.showActivityLoadingIndicatorView("Logging in...")
        
        AuthProvider.login(email: email, password: password) { (isLoggedIn, error) in
            //check for errors such as network not available
            if error != nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                    self.loginButton.isEnabled = true
                }
                
                print("error logging in \(String(describing: error?.localizedDescription))")
                self.showUIAlert(title: "An error occured while logging in", message: error?.localizedDescription, style: .alert, actions: [], viewController: nil)
                
                
                return
            }
            
            //check for invalid credentials
            if isLoggedIn == false {
                print("log in failed")
                
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                    self.loginButton.isEnabled = true
                }
                
                self.showUIAlert(title: "Invalid credentials", message: "Please review your credentials details", style: .alert, actions: [], viewController: nil)
                return
            }
            
            //performs segue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loginButton.isEnabled = true
                self.dismiss(animated: false)
                self.performSegue(withIdentifier: SeguesConstants.SegueTabBarFromLogin, sender: nil)
            }
        }
    }
   
    
    @IBAction func onSignInButtonClicked(_ sender: Any) {
        let url = URL(string: ServerConstants.SIGN_IN_URL)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            self.showUIAlert(title: "Invalid url", message: "\(ServerConstants.SIGN_IN_URL) is not a valid URL!", style: .alert, actions: [], viewController: nil)
        }
    }
}
