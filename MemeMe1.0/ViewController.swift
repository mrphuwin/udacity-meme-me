//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Phu Huynh on 12/24/20.
//

import UIKit

class ViewController: UIViewController {
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    weak var currentTextField: UITextField!
    weak var memedImage: UIImage!
    
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
        setImage(nil)
    }
    
    func setImage(_ image: UIImage?) {
        if let image = image {
            imageView.image = image
            shareButton.isEnabled = true
        } else {
            imageView.image = nil
            shareButton.isEnabled = false
        }
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
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        resetMeme()
    }
        
    @IBAction func albumButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }

    // MARK: Keyboard show/hide notification handling
    
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
    
    // MARK: Share meme
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        let image = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        nextController.completionWithItemsHandler = { (
                activityType: UIActivity.ActivityType?,
                completed: Bool,
                arrayReturnedItems: [Any]?,
                error: Error?
            ) in
                if completed {
                    self.memedImage = image
                    self.save()
                }
        }
        present(nextController, animated: true, completion: nil)
    }
    
    // Just saves the meme in memory for now.
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false

        return memedImage
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            setImage(image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
