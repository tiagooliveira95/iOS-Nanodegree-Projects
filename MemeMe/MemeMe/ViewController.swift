//
//  ViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 18/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Variable to check if the user has rewritten the default text
    // when set to true, the text wont get cleared when user touches the text field
    var wasTopDefaultTextOverwritten = false
    var wasBottomDefaultTextOverwritten = false

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]
    
    
    //Delegate is called when image is picked by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("image recived")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }else {
            print("failed to set image")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //Delegate is called when user canceled the image pick
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    override func viewDidLoad() {
        setTextStyles(topTextField, "Top")
        setTextStyles(bottomTextField, "Bottom")
    }
    
    func setTextStyles(_ textField: UITextField, _ defaultText: String){
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
    }

    @IBAction func pickImage(_ sender: Any) {
        //Shows image picker
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    

    @objc func keyboardWillShow(_ notification: Notification){
        // Makes sure bottom TextField is editing otherwise there is no need to elevate the view
        // because doing so will probably hide the textField that the user is typing on
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow(_:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func getKeyboardHight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if bottomTextField.isEditing && !wasBottomDefaultTextOverwritten {
            textField.text = nil
            wasBottomDefaultTextOverwritten = true
        } else if topTextField.isEditing && !wasTopDefaultTextOverwritten {
            textField.text = nil
            wasTopDefaultTextOverwritten = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // set y back to 0 when keyboard is closed
        view.frame.origin.y = 0
        print(textField.text!)
        return true
    }
    
    
}

