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
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var createAccountButoon: UIButton!
        
    
    @IBAction func onCreateAccountButtonClicked(_ sender: Any) {
        guard let email = self.emailField?.text, let password = self.passwordField?.text,
            !email.isEmpty && !password.isEmpty && email.contains("@") else {
                self.showUIAlert(title: "Input Error", message: "E-mail or password are invalid.", style: .alert, actions: [], viewController: nil)
                return
        }
        
        guard password.count >= AuthConstants.MIN_PASSWORD_LENGTH else {
            self.showUIAlert(title: "Input Error", message: "Password must have at least 8 characters.", style: .alert, actions: [], viewController: nil)
            return
        }
        
        self.showActivityLoadingIndicatorView("Creating account...")
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
            let userData = UserData()
            userData.firstName = self.firstNameField.text!
            userData.lastName = self.lastNameField.text!

            do{
                try Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                    .setData(from: userData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            self.showUIAlert(title: "Error", message: err.localizedDescription, style: .alert, actions: [], viewController: nil)
                        } else {
                            print("Document successfully written!")
                            let user = User(context: self.coreData.persistentContainer.viewContext)
                            user.email = self.emailField.text!
                            user.firstName = userData.firstName
                            user.lastName = userData.lastName
                            self.coreData.saveContext()
                            self.dismiss(animated: false)
                            self.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
                        }
                }
            } catch {
                self.dismiss(animated: true)
                self.showUIAlert(title: "Error", message: error.localizedDescription, style: .alert, actions: [], viewController: nil)
            }
        }
    }
}
