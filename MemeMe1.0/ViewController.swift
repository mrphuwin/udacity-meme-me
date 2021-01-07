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
    weak var currentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupTextField(_ button: UITextField) {
            let memeTextAttributes: [NSAttributedString.Key: Any] = [
//                NSAttributedString.Key.strokeColor: UIColor.black,
//                NSAttributedString.Key.backgroundColor: UIColor.red,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedString.Key.strokeWidth: 5
            ]
            
            button.defaultTextAttributes = memeTextAttributes
            button.textAlignment = .center
            button.delegate = self
        }
        
        setupTextField(topTextField)
        setupTextField(bottomTextField)
        resetMeme()
    }
    
    func resetMeme() {
        topTextField.text = DEFAULT_TOP_TEXT
        bottomTextField.text = DEFAULT_BOTTOM_TEXT
        imagePickerView.image = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sign up to be notified when the keyboard appears
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

        // disable the camera button, if needed
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancel(_ sender: Any) {
        resetMeme()
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
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keyboardWillShow(_ notification:Notification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // When the keyboardWillHide notification is received, shift the view's frame down to its original position
    @objc func keyboardWillHide(_ notification:Notification) {
        if currentTextField == bottomTextField {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // clear the text field when the user begins editing
        textField.text = ""
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss the keyboard when the user presses return
        textField.resignFirstResponder()
        return true
    }
}
