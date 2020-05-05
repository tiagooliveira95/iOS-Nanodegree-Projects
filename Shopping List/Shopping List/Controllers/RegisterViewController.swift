//
//  RegisterViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 05/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var createAccountButoon: UIButton!
    
    
    @IBAction func onCreateAccountButtonClicked(_ sender: Any) {
        //TODO CHECK DATA FIRST!
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
            //TODO check for errors!
            
            var ref: DatabaseReference! = Database.database().reference()
            //TODO save first/last name to db

            
        }
    }
    
}
