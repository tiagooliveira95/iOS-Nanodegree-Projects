//
//  MemeListViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 21/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeListViewController : UITableViewController{
    
    @IBOutlet var memeTableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           tableView?.reloadData()
       }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("memes count \(memes.count)")
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.memeTableViewCellIdentifier, for: indexPath) as! MemeTableViewCell
        cell.setMeme(memes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeOriginalImage = memes[indexPath.row].memedImage
        performSegue(withIdentifier: Segues.memeDisplayFromList, sender: memeOriginalImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.memeDisplayFromList {
            let viewController = segue.destination as! MemeDisplayViewController
            viewController.image = sender as? UIImage
        }
    }
}
