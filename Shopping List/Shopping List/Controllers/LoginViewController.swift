//
//  LoginViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 05/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestoreSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}

    
    var authHandle: AuthStateDidChangeListenerHandle!
    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.isEnabled = true

        let user = Auth.auth().currentUser
        if user != nil && !user!.isAnonymous {
            let userFetch:NSFetchRequest = User.fetchRequest()
            let userCD = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
            
            if userCD == nil {
                print("User not found on CoreData getting data from Firebase")
                self.retriveAndSaveUserData()
                return
            }
            print("user is logged in")
            self.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
        }
    }
    
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        loginButton.isEnabled = false
        
        //Validate user input
        guard let email = emailField?.text, let password = passwordField?.text,
            //check if user input is empty
            !email.isEmpty && !password.isEmpty &&
            password.count >= AuthConstants.MIN_PASSWORD_LENGTH && email.contains("@") else {
                
            loginButton.isEnabled = true
                
            self.showUIAlert(title: "Invalid credentials", message: "Please review your credentials details", style: .alert, actions: [], viewController: nil)
                
            return
        }
        self.showActivityLoadingIndicatorView("Logging in...",animated: false)

        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.dismiss(animated: false)
                strongSelf.showMessagePrompt(error: error.localizedDescription)
                strongSelf.loginButton.isEnabled = true
              return
            }
            strongSelf.retriveAndSaveUserData()
        }
    }
    
    func showMessagePrompt(error: String){
        self.showUIAlert(title: "Invalid credentials", message: error, style: .alert, actions: [], viewController: nil)
    }
        
    func retriveAndSaveUserData(){
        Firestore.firestore().collection(FirebaseConstants.USER_PATH).document(Auth.auth().currentUser!.uid).getDocument{ (document,error) in
            if let document = document {
                let dataDescription = document.data() as! [String: String]
                
                let user = User(context: self.coreData.persistentContainer.viewContext)
                user.email = self.emailField.text!
                user.firstName = dataDescription["firstName"]
                user.lastName = dataDescription["lastName"]
                user.family = dataDescription["family"]
                self.coreData.saveContext()
                self.dismiss(animated: false)
                self.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
            } else {
                print("Document does not exist in cache")
            }
        }
    }
}
