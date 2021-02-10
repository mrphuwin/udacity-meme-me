//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 2/6/21.
//

import UIKit

private let reuseIdentifier = "MemeTableCell"

class MemeTableViewController: UITableViewController {

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 100
        // add a white separator between rows
        self.tableView.separatorColor = .white
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left:0, bottom:0, right: 0)

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText

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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // handle swipe to delete action
        if editingStyle == .delete {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)

            // Notify the app a meme has been removed
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "memeRemoved"), object: nil)
        }
    }
}
