//
//  ShoppingListViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 06/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ShoppingListViewController: UIViewController{
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)
    var ref: DatabaseReference!
    var dbFamilyRef: DatabaseReference!

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newListButton: UIBarButtonItem!
    @IBOutlet weak var addFamilyButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let userFetch:NSFetchRequest = User.fetchRequest()
        let user = try! coreData.persistentContainer.viewContext.fetch(userFetch).first
        
        //disable buttons if family is not found
        if user?.family == nil {
            self.newListButton.isEnabled = false
            self.settingsButton.isEnabled = false
            self.shoppingListTable.isHidden = true
        }else{
            self.addFamilyButton.isHidden = true
        }
        
        ref = Database.database().reference()
        dbFamilyRef = ref.child("family/\(user!.family!)/items")
        
        dbFamilyRef.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.populateList(postDict: postDict)
        })
    }
    
    func populateList(postDict:[String : AnyObject]){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dbFamilyRef.removeAllObservers()
    }

    @IBAction func addFamilyButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: SeguesConstants.ShoppingListToAddFamilySegue, sender: nil)
    }
}
