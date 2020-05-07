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

class SetFamilyViewController: UIViewController{
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)
    var ref: DatabaseReference!
    @IBOutlet weak var familyTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    @IBAction func joinFamilyButtonClicked(_ sender: Any) {
        //TODO check for errors!
        //TODO move to constants!
        
        ref.child("family").child(familyTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get value
            if snapshot.exists() {
                let userFetch:NSFetchRequest = User.fetchRequest()
                let user = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
                user?.family = self.familyTextField.text!
                
                self.ref.child("family/\(self.familyTextField.text!)/members/")
                    .setValue([Auth.auth().currentUser!.uid: "\(user!.firstName!) \(user!.lastName!)"])
               
                self.coreData.saveContext()
            } else {
                print("family not found")
            }
            
          }) { (error) in
            print("error: \(error.localizedDescription)")
            //tell user that family was not found!
        }
    }
    
    @IBAction func createFamilyButtonClicked(_ sender: Any) {
        ref.child("family").child(familyTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            //tell user that family already exists!
            if snapshot.exists() {
                //join family
                print("tell user that family ID already exixts.")
            } else {
                let userFetch:NSFetchRequest = User.fetchRequest()
                let user = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
                
                print("creating family")
                
                self.ref.child("family/\(self.familyTextField.text!)/members/").setValue(
                    [Auth.auth().currentUser!.uid: "\(user!.firstName!) \(user!.lastName!)"]
                )
                
                user!.family = self.familyTextField.text!
                self.coreData.saveContext()
            }
          }) { (error) in
            print("error: \(error.localizedDescription)")
        }
    }
}
