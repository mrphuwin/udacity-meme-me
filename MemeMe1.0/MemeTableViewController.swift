//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 2/6/21.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Reload view whenever memes are added
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_reload),
            name: NSNotification.Name(rawValue: "memesUpdated"),
            object: nil
        )
    }
    
    @objc func _reload() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)

        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText

        return cell
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        let memeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        present(memeViewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailViewController.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
