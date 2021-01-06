//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 12/24/20.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupTextField(_ button: UITextField, _ text: String) {
            let memeTextAttributes: [NSAttributedString.Key: Any] = [
//                NSAttributedString.Key.strokeColor: UIColor.black,
//                NSAttributedString.Key.backgroundColor: UIColor.red,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedString.Key.strokeWidth: 5
            ]
            
            button.defaultTextAttributes = memeTextAttributes
            button.textAlignment = .center
            button.text = text
            button.delegate = self
        }
        
        setupTextField(topTextField, DEFAULT_TOP_TEXT)
        setupTextField(bottomTextField, DEFAULT_BOTTOM_TEXT)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // disable the camera button, if needed
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear the text field when the user begins editing
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss the keyboard when the user presses return
        textField.resignFirstResponder()
        return true
    }
}