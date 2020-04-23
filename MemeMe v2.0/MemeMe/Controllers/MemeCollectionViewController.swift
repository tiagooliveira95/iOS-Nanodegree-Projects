//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 20/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController  {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
        
    
    override func viewDidAppear(_ animated: Bool) {
        //sets width of image to handle multiple display widths
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name:NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    @objc func loadList(notification: NSNotification){
        self.collectionView.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    //gets items count
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.memeCollectionViewCell, for: indexPath) as! MemeCollectionViewCell
        cell.setMeme(memes[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.memeDisplayFromCollection, sender: memes[indexPath.row].memedImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.memeDisplayFromCollection {
            let viewController = segue.destination as! MemeDisplayViewController
            viewController.image = sender as? UIImage
        }
    }
}
