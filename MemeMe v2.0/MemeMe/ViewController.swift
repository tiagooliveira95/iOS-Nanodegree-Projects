//
//  ViewController.swift
//  MemeMe
//
//  Created by Tiago Oliveira on 18/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    let DEFAULT_TOP_TEXT = "TOP"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM"
    
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
    
    // MARK: Outlets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    

    //MARK: Lifecycles

    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewDidLoad() {
        setTextStyles(topTextField, DEFAULT_TOP_TEXT)
        setTextStyles(bottomTextField, DEFAULT_BOTTOM_TEXT)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    func setTextStyles(_ textField: UITextField, _ defaultText: String){
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
    }
    
    //MARK:ImagePicker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //Enable share button
            shareButton.isEnabled = true
            imagePickerView.image = image
        } else {
            //Disable share button
            shareButton.isEnabled = false
            print("failed to set image")
        }
        dismiss(animated: true, completion: nil)
    }
      
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: IB Actions
    @IBAction func pickImage(_ sender: Any) {
        initPicker(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        initPicker(.camera)
    }
    
    func initPicker(_ src: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = src
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])

        activityViewController.completionWithItemsHandler = { activity, success, items, error in
        if success {
            let meme = Meme(
                topText: self.topTextField.text!,
                bottomText: self.bottomTextField.text!,
                originalImage: self.imagePickerView.image!,
                memedImage: memedImage
            )
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            }
        }
        present(activityViewController,animated: true,completion: nil)
    }
    
    
    //MARK: Methods
    
    func generateMemedImage() -> UIImage {

        // Hide toolbar and navbar
        toggleNavigationAndToolbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        toggleNavigationAndToolbar(false)

        return memedImage
    }
    
    
    //Hides or shows toolbar and navigation bar
    func toggleNavigationAndToolbar(_ toggle: Bool){
        self.toolbar.isHidden = toggle
        self.navigationBar.isHidden = toggle
    }
    

    //MARK: Keyboard Listeners
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow(_:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide(_:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Keyboard Handlers
    @objc func keyboardWillShow(_ notification: Notification){
        // Makes sure bottom TextField is editing otherwise there is no need to elevate the view
        // because doing so will probably hide the textField that the user is typing on
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHight(notification)
        }
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        //Resets origin Y after keyboard is closed
        view.frame.origin.y = 0
    }
    
    func getKeyboardHight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: TextField Delegates

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
        print(textField.text!)
        return true
    }
}

