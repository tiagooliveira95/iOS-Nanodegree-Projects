//
//  RegisterViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 05/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import CodableFirebase

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
            
            //TODO save first/last name to db
            let userData = UserData()
            userData.firstName = self.firstNameField.text!
            userData.lastName = self.lastNameField.text!
            
            do{
                try Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                    .setData(from: userData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            self.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
                        }
                }
            } catch {
                print("Error info: \(error)")
            }
        }
    }
}
