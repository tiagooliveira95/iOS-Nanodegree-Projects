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
        //Validate user input
        guard let email = emailField?.text, let password = passwordField?.text,
            //check if user input is empty
            !email.isEmpty || !password.isEmpty ||
            //Validate email and check if password ranges are valid, Udacity has a minimum password length of 8 charecters.
            //Therefore there's no need to make a login request to the server if the password doesn't meet the minimum requirements
            password.count <= ServerConstants.UDACITY_MIN_PASSWORD_LENGTH || !email.contains("@")
            else {
            //TODO show error to the user
            return
        }
        //TODO proceed with login
        AuthProvider.login(email: email, password: password) { (isLoggedIn, error) in
            if error != nil {
                print("error logging in \(String(describing: error?.localizedDescription))")
                return
            }
            if isLoggedIn == false {
                print("loggedIn")
                return
            }
        }
    }
   
    
    @IBAction func onSignInButtonClicked(_ sender: Any) {
        //TODO redirect user to Udacity sign in webpage
    }
    
}
