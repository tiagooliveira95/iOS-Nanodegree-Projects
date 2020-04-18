//
//  ViewController.swift
//  ImagePicker
//
//  Created by Tiago Oliveira on 18/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func expiriment(_ sender: Any) {
        print("touched")
        //let nextController = UIImagePickerController()
        let nextControllerAlert = UIAlertController()
        
        nextControllerAlert.title = "Test Title"
        nextControllerAlert.message = "Test Message"
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        nextControllerAlert.addAction(okAction)

        present(nextControllerAlert, animated: true, completion: nil)
        //present(nextController, animated: true, completion: nil)

    }
    
}

