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

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newListButton: UIBarButtonItem!
    @IBOutlet weak var addFamilyButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    @IBOutlet weak var shoppingListTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let userFetch:NSFetchRequest = User.fetchRequest()
        let user = try! coreData.persistentContainer.viewContext.fetch(userFetch).first
    
        shoppingListTable.dataSource = self
        shoppingListTable.delegate = self
        
        let itemsFetch:NSFetchRequest = ShoppingItem.fetchRequest()
        shippingItems = try! coreData.persistentContainer.viewContext.fetch(itemsFetch)
        self.shoppingListTable.reloadData()
        
        //disable buttons if family is not found
        if user?.family == nil {
            self.newListButton.isEnabled = false
            self.settingsButton.isEnabled = false
            self.shoppingListTable.isHidden = true
            return
        }
        
        self.addFamilyButton.isHidden = true
        ref = Database.database().reference()
        dbFamilyRef = ref.child("family/\(user!.family!)/items")
        
        dbFamilyRef.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.populateList(postDict: postDict)
        })
        
        
    }
    
    func populateList(postDict:[String : AnyObject]){
        
        for (key, value) in postDict {
            let item = value as! [String : String]
            print("key: \(key) value name: \(item["name"]!), \(item["amount"]!)")
            
            //⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️\\
            //⚠️ WARNING: CRINGEY CODE AHEAD ⚠️\\
            //🤮 WARNING: CRINGEY CODE AHEAD 🤮\\
            //⚠️ WARNING: CRINGEY CODE AHEAD ⚠️\\
            
           
            var exists = false
            for coreDataItem in self.shippingItems {
                if coreDataItem.uid == key {
                    exists = true
                    break
                }
            }
        
            //⚠️                            ⚠️\\
            //⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️ \\
            
            if !exists {
                let shopItem: ShoppingItem = ShoppingItem(context: self.coreData.persistentContainer.viewContext)
                shopItem.uid = key
                shopItem.name = item["name"]!
                shopItem.quantity = item["amount"]!
            
                self.shippingItems.append(shopItem)
                self.coreData.saveContext()
            }
        }
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
}
