//
//  ShoppingListViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 06/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController{
    
    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var newListButton: UIBarButtonItem!
    @IBOutlet weak var addFamilyButton: UIButton!
    @IBOutlet weak var signoutButton: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        let userFetch:NSFetchRequest = User.fetchRequest()
        let user = try! coreData.persistentContainer.viewContext.fetch(userFetch).first
        
        //disable buttons if family is not found
        if user?.family == nil {
            self.newListButton.isEnabled = false
            self.settingsButton.isEnabled = false
        }
        
    }

    @IBAction func addFamilyButtonClicked(_ sender: Any) {
        print("clicked")
        self.performSegue(withIdentifier: SeguesConstants.ShoppingListToAddFamilySegue, sender: nil)
    }
}
