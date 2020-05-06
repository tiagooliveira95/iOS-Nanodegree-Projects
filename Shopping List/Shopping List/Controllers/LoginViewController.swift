//
//  LoginViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 05/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var authHandle: AuthStateDidChangeListenerHandle!
    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    
    override func viewWillAppear(_ animated: Bool) {
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("user is logged in")
                self.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        //TODO CHECK DATA FIRST!
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showMessagePrompt(error: error.localizedDescription)
              return
            }
            strongSelf.performSegue(withIdentifier: SeguesConstants.LoginToShoppingListSegue, sender: nil)
        }
    }
    
    func showMessagePrompt(error: String){
        //TODO
        print("error: \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO
    }
}
