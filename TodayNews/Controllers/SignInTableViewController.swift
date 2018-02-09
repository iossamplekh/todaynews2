//
//  SignInTableViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 2/7/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

class SignInTableViewController: UITableViewController{
    @IBOutlet var userEmailTextField: UITextField!
    @IBOutlet var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toLogin(_ sender: Any) {
        UserService.shared.signin { (response, error) in
            if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
            if let value = response?.result.value {
                let json = JSON(value) // Convert to SwiftyJSON
                // Check server code
                if let code = json["code"].int, code == 2222 {
                    print("Login Success")
                     SCLAlertView().showInfo("Welcome", subTitle: "Login Success!");
                }else { // error
                    SCLAlertView().showError("Error \(String(describing: json["code"].int!))", subTitle: json["message"].stringValue); return
                }
            }else { // error
                SCLAlertView().showError("Error", subTitle: "Server error"); return
            }
        }
    }
}
