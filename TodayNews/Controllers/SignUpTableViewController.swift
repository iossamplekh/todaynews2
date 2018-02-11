//
//  SignUpTableViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 2/11/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import SCLAlertView

class SignUpTableViewController: UITableViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func signUp(_ sender: Any) {
        let parameters =
        [
            "password": passwordTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "name": nameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? ""
        ]
        UserService.shared.singup(paramaters: parameters) { (response, error) in
            
        }
    }
    
    
}
