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

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)
    var ref: DatabaseReference!
    var dbFamilyRef: DatabaseReference!
    var shippingItems: [ShoppingItem] = []
    var currentUser: User!
    
    // use to avoid executing the firebase observer when making changes to it
    var buzy = false

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newListButton: UIBarButtonItem!
    @IBOutlet weak var addFamilyButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        currentUser = try! coreData.persistentContainer.viewContext.fetch(User.fetchRequest()).first
    
        shoppingListTable.dataSource = self
        shoppingListTable.delegate = self
        
        let db = Database.database()
              ref = db.reference()
     
        NotificationCenter.default.addObserver(self, selector: #selector(setFirebaseObserver), name:NSNotification.Name(rawValue: "reload"), object: nil)
        
        print("family: \(currentUser?.family ?? "nil")")
        //disable buttons if family is not found
        if currentUser.family == nil || currentUser.family!.count <= 0 {
            self.newListButton.isEnabled = false
            self.settingsButton.isEnabled = false
            self.shoppingListTable.isHidden = true
            return
        }
        
        print("family: " + currentUser.family!)
        
        self.addFamilyButton.isHidden = true
        
        setFirebaseObserver()
    }
    
    @objc func setFirebaseObserver(){
        currentUser = try! coreData.persistentContainer.viewContext.fetch(User.fetchRequest()).first
        
        dbFamilyRef = ref.child("\(FirebaseConstants.FAMILY_PATH)/\(currentUser.family!)/\(FirebaseConstants.ITEMS_PATH)")
        dbFamilyRef.keepSynced(true)
        
        dbFamilyRef.observe(DataEventType.value, with: { (snapshot) in
            guard !self.buzy else{ return }
            let postDict = snapshot.value as? [String : [String : Any]] ?? [:]
            print(postDict.count)
            self.populateList(postDict: postDict)
        })
    }
    
    func populateList(postDict:[String : [String : Any]]){
        shippingItems = []
        for (key, value) in postDict {
            let shopItem: ShoppingItem = ShoppingItem()
            shopItem.uid = key
            shopItem.name = value["name"]! as? String
            shopItem.quantity = value["amount"]! as? String
            self.shippingItems.append(shopItem)
        }
       
        self.addFamilyButton.isHidden = true
        self.newListButton.isEnabled = true
        self.settingsButton.isEnabled = true
        self.shoppingListTable.isHidden = false


        self.shoppingListTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dbFamilyRef?.removeAllObservers()
    }

    @IBAction func addFamilyButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: SeguesConstants.ShoppingListToAddFamilySegue, sender: nil)
    }
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shippingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shoppingListTable.dequeueReusableCell(withIdentifier: Identifiers.ShoppingTableCellIdentifier, for: indexPath) as! ShoppingItemViewCell
        cell.setData(item: self.shippingItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            buzy = true
            dbFamilyRef.child(shippingItems[indexPath.row].uid).removeValue {
                (error,ref) in
                if error == nil {
                    self.shippingItems.remove(at: indexPath.row)
                    self.shoppingListTable.deleteRows(at: [indexPath], with: .automatic)
                }else {
                    //show error to user
                    self.showUIAlert(title: "Error", message: "Error deliting item, please try again later", style: .alert, actions: [], viewController: nil)
                }
                self.buzy = false
            }
        }
    }
    
    @IBAction func onSignOutButtonPressed(_ sender: Any) {
        do{
            self.coreData.persistentContainer.viewContext.delete(self.currentUser)
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: SeguesConstants.UnwindBackToLoginSegue, sender: self)
        }catch{
            self.showUIAlert(title: "Error", message: "Signout failed", style: .alert, actions: [], viewController: nil)
        }
    }
}
