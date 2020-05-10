//
//  SetFamilyViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 06/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestoreSwift

class SetFamilyViewController: UIViewController{
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)
    var ref: DatabaseReference!
    @IBOutlet weak var familyTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    @IBAction func joinFamilyButtonClicked(_ sender: Any) {
        ref.child("family").child(familyTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get value
            if snapshot.exists() {
                //save family to Firestore
                Firestore.firestore().collection(FirebaseConstants.USER_PATH).document(Auth.auth().currentUser!.uid)
                    .updateData([FirebaseConstants.FAMILY_PATH : self.familyTextField.text!]) { err in
                        if let err = err {
                            self.showUIAlert(title: "Error", message: err.localizedDescription, style: .alert, actions:[], viewController: nil)
                        } else {
                            //save into core data
                            let userFetch:NSFetchRequest = User.fetchRequest()
                            let user = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
                            
                            self.ref.child("\(FirebaseConstants.FAMILY_PATH)/\(self.familyTextField.text!)/\(MEMBERS_PATH)/").child(Auth.auth().currentUser!.uid)
                                .setValue(["name": "\(user!.firstName!) \(user!.lastName!)"])
                    
                            user?.family = self.familyTextField.text!
                            self.coreData.saveContext()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                            self.dismiss(animated: true)
                    }
                }
            } else {
                self.showUIAlert(title: "Error", message: "Family not found", style: .alert, actions: [], viewController: nil)
            }
          }) { (error) in
            self.showUIAlert(title: "Error", message: error.localizedDescription, style: .alert, actions: [], viewController: nil)
        }
    }
    
    @IBAction func createFamilyButtonClicked(_ sender: Any) {
        ref.child("family").child(familyTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            //tell user that family already exists!
            if snapshot.exists() {
                self.showUIAlert(title: "Error", message: "Family already exists", style: .alert, actions: [], viewController: nil)
            } else {
                let userFetch:NSFetchRequest = User.fetchRequest()
                let user = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
                
                self.ref.child("\(FirebaseConstants.FAMILY_PATH)/\(self.familyTextField.text!)/\(FirebaseConstants.MEMBERS_PATH)/").child(Auth.auth().currentUser!.uid)
                    .setValue(["name": "\(user!.firstName!) \(user!.lastName!)"])
                
                user!.family = self.familyTextField.text!
                self.coreData.saveContext()
            }
          }) { (error) in
            print("error: \(error.localizedDescription)")
        }
    }
}
