//
//  ViewController.swift
//  Click Counter
//
//  Created by Tiago Oliveira on 18/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 0
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
    }
    
   
    @IBAction func incrementCount(){
        self.count += 1
        self.label.text = "\(self.count)"
    }


}

