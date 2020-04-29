//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 28/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showUIAlert(title: String, message: String?, style: UIAlertController.Style, actions: [UIAlertAction], viewController: UIViewController?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            
            if actions.count == 0 {
                let closeAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alert.addAction(closeAction)
            } else {
                for action in actions {
                    alert.addAction(action)
                }
            }
            self.present(alert, animated: true)
        }
    }
    
    func showActivityLoadingIndicatorView(_ message: String? = "Please wait a moment...") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        
        present(alert, animated: true, completion: nil)
    }
}
