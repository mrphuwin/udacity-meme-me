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

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setFlowLayout(self.view.bounds.size.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // NOTE: The view size is not updated until after the transition. i.e. Height and width will switch values afterward.
        setFlowLayout(self.view.bounds.size.height)
    }

    @objc func _reload() {
        self.collectionView.reloadData()
    }

    func setFlowLayout(_ frameWidth: CGFloat) {
        let cellWidth:CGFloat = 120
        let nCells:CGFloat = floor(frameWidth / cellWidth)
        let space:CGFloat = floor(frameWidth.truncatingRemainder(dividingBy: cellWidth) / (nCells-1))
        
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
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
