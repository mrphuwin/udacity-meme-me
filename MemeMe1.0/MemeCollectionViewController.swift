//
//  MemeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 2/6/21.
//

import UIKit

private let reuseIdentifier = "MemeCollectionCell"

class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        // I commented this out to fix the following error when calling collectionView.dequeueReusableCell().
        // Error: "Could not cast value of type 'UICollectionViewCell' to 'MemeMe1_0.MemeCollectionCell'"
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Reload view whenever memes are added
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_reload),
            name: NSNotification.Name(rawValue: "memesUpdated"),
            object: nil
        )
        
        func addMeme(_ imageName:String) {
            if let image = UIImage(named: imageName) {
                let meme = Meme(
                    topText: imageName,
                    bottomText: "FOOBAR",
                    originalImage: image,
                    memedImage: image
                )
                // Add it to the memes array in the Application Delegate
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
            }
        }
        
        addMeme("mushroom")
        addMeme("toad")

        // Notify the app that memes has been updated
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memesUpdated"), object: nil)
    }

    @objc func _reload() {
        self.collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionCell
    
        let meme = self.memes[indexPath.row]
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailView.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
