//
//  ViewController.swift
//  MemeMe
//
//  Created by Daffolapmac-155 on 29/06/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties
    var label: UILabel!
    var count = 0
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var camera: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.foregroundColor: UIColor.black /* TODO: fill in appropriate UIColor */,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 10  /* TODO: fill in appropriate Float */
    ]
    
    //MARK: ViewLifeCycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label = UILabel()
        self.label = label
        self.view.endEditing(true)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topField.defaultTextAttributes = memeTextAttributes
        bottomField.defaultTextAttributes = memeTextAttributes
        bottomField.delegate = self
        topField.delegate = self
        subscribeToKeyBoardNotifications()
        subscribeToHideKeyBoardNotifications()


    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        unsubscribeFromKeyBoardNotifications()
//        subscribeToHideKeyBoardNotifications()

    }

    
    //Mark: Keyboard Function to move view up as keyboard shows up
    func subscribeToKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    func subscribeToHideKeyBoardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyBoardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    func unsubscribeFromHideKeyBoardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if view.frame.origin.y == 0{
            if !topField.isEditing{
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    @objc func keyboardWillHide(){
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification: Notification)-> CGFloat{
        let userinfo  = notification.userInfo
        let frame  = userinfo![UIResponder.keyboardFrameBeginUserInfoKey] as!NSValue
        return frame.cgRectValue.height
    }
    
    //MARK: Actions
    @IBAction func pickButton(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func captureImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker,animated: true, completion: nil)
    }
}

 // MARK: Extensions
extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker.sourceType == .photoLibrary{
            if let pickedImage =  info[UIImagePickerController.InfoKey.originalImage]as? UIImage{
                Image.image = pickedImage
            }
        }else{
            print(info)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
}
