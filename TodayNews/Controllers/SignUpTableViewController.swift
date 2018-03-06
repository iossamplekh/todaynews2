//
//  SignUpTableViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 2/11/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftyJSON
import NVActivityIndicatorView

class SignUpTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var saveUserButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var userImageView: UIImageView!
    
    var newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        saveUserButton.layer.cornerRadius = 25
    }
    @IBAction func signUp(_ sender: Any) {
        if let imageData = UIImageJPEGRepresentation(self.userImageView.image!, 1){
            print("imageData: \(imageData)")
            newsService.uploadFile(file: imageData) { (imageUrl, error) in
                // Check error
                if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
                print("imageUrl: \(imageUrl!)")
            
                let parameters =
                    [
                        "password": self.passwordTextField.text ?? "",
                        "email": self.emailTextField.text ?? "",
                        "name": self.nameTextField.text ?? "",
                        "lastName": self.lastNameTextField.text ?? "",
                        "realImageUrl": imageUrl ?? "",
                        "gender": self.genderSegmentedControl.selectedSegmentIndex == 0 ? "Male" : "Female"
                ]
                
                UserService.shared.singup(paramaters: parameters) { (response, error) in
                    
                }
            }
        }
        
    }
    
    @IBAction func browserPhotoTapGesture(_ sender: Any) {
        print(#function)
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.userImageView.contentMode = .scaleAspectFit
            self.userImageView.image = pickedImage
            print("pickedImage: \(pickedImage)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
