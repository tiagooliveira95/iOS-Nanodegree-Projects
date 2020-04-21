//
//  MYOAViewController.swift
//  TheTiger
//
//  Created by Tiago Oliveira on 20/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit


class MYOAViewControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start Over", style: .plain, target: self, action: #selector(startOver))
    }
    
    @objc func startOver(){
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    deinit {
        print("View Controller Deollocated")
    }


}
