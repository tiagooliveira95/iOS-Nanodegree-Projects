//
//  AddNewItemViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 06/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AddNewItemViewController: UIViewController{
        
    let coreData = (UIApplication.shared.delegate as! AppDelegate)
    var ref: DatabaseReference!

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let userFetch:NSFetchRequest = User.fetchRequest()
        let user = try! self.coreData.persistentContainer.viewContext.fetch(userFetch).first
        
        self.ref.child("\(FirebaseConstants.FAMILY_PATH)/\(user!.family!)/\(FirebaseConstants.ITEMS_PATH)/").child(generateItemUID()).setValue(
                [
                    "name" : itemTextField.text!,
                    "amount": amountTextField.text!
                ]
        ) { (error, ref) -> Void in
            guard error == nil else{
                //todo show error0
                self.dismiss(animated: true)
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    func generateItemUID() -> String {
        var uid = ""
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let maxRandom = chars.count
        
        for _ in 0...20 {
            uid += String(chars[chars.index(chars.startIndex, offsetBy: Int.random(in: 0...maxRandom-1))])
        }
        return uid
    }
}
