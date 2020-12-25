//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 12/24/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func pickAlbumImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

