//
//  SettingsViewController.swift
//  Shopping List
//
//  Created by Tiago Oliveira on 06/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController{
    let coreData = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak var familyLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let userFetch:NSFetchRequest = User.fetchRequest()
        let user = try! coreData.persistentContainer.viewContext.fetch(userFetch).first
        familyLabel.text = user!.family ?? ""
    }
}
