//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 20/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController  {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //gets items count
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TODO", for: indexPath) as! MemeCollectionViewCell
        cell.setMeme(memes[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TODO", sender: memes[indexPath.row].memedImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TODO" {
            let viewController = segue.destination as! MemeDisplayViewController
            viewController.memedImage.image = sender as? UIImage
        }
    }
    
}
