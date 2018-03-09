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
    @IBOutlet var signinButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.string(forKey: "userIDS") != nil) {
            self.showMainScreen(animation: false)
        }

        signinButton.layer.cornerRadius = 25
        signUpButton.layer.cornerRadius = 25

    }
    
    @IBAction func toLogin(_ sender: Any) {
        if((userEmailTextField.text != "" && userPasswordTextField.text != nil) &&
            ((userPasswordTextField.text != "" && userPasswordTextField.text != nil))
            ){
            UserService.shared.signin(with: userEmailTextField.text!, with: userPasswordTextField.text!) { (response, error) in
                if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
                if let value = response?.result.value {
                    let json = JSON(value)
                  
                    if let code = json["code"].int, code == 2222 ,let id = json["object"]["id"].int {
                        let secEmail = json["object"]["email"].string ?? ""
                        let secRealImageUrl = json["object"]["realImageUrl"].string ?? ""
                        print("-----------Login Success-----------")
                        UserDefaults.standard.set("\(id)", forKey: "userIDS")
                        UserDefaults.standard.set("\(secEmail)", forKey: "userEmail")
                        UserDefaults.standard.set("\(secRealImageUrl)", forKey: "userRealImageUrl")
                        
                        print("USER ID: \(UserDefaults.standard.string(forKey: "userIDS")!)")
                        print("USER userEmail \(UserDefaults.standard.string(forKey: "userEmail")!)")
                        print("USER image url \(UserDefaults.standard.string(forKey: "userRealImageUrl")!)")
                        print("-----------Login Success-----------")
                        SCLAlertView().showInfo("Welcome", subTitle: "Login Success!")

                        self.showMainScreen(animation: true)

                    }else { // error
                        SCLAlertView().showError("Error \(String(describing: json["code"].int!))", subTitle: json["message"].stringValue); return
                    }
                }else {
                    SCLAlertView().showError("Error", subTitle: "Server error"); return
                }

                self.showMainScreen(animation: true)

            }
        }
        
    }
    func showMainScreen(animation: Bool) {
        let storybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybaord.instantiateInitialViewController()
        self.present(vc!, animated: animation, completion: nil)
    }

}
