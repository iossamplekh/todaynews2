//
//  UserService.swift
//  TodayNews
//
//  Created by Ron Rith on 2/9/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class UserService{
    private init() {}
    
    static let shared: UserService = UserService()
    
    func singup(paramaters: [String: String],files: [String:Data], completion: @escaping (DataResponse<Any>?, Error?)->()) {
        // Request to server
        Alamofire.request(DataManager.URL.USER_SIGNUP,
                          method: .post,
                          parameters:  paramaters,
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
                .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print("Value of json: \(json)")
                    print("Code: \(json["code"])")
                    guard let code = json["code"].int, code == 2222 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                        // Error
                        SCLAlertView().showInfo("No data", subTitle: "No value")
                        return
                    }
                    // Success
                    completion(response, nil)
                    SCLAlertView().showInfo("Have", subTitle: "OK")
                case .failure(let error):
                     completion(nil, error)
                }
        }
        
    }
    func signin(with secEmail: String,with secPassword: String,completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
        // Request to server
        Alamofire.request("\(DataManager.URL.USER_LOGIN)/\(secEmail)/\(secPassword)",
                          method: .get,
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in // response from server
                // check success or failure
                switch response.result {
                case .success:
                    completion(response, nil)
                    print("response: \(response)")
                case .failure(let error):
                    completion(nil, error)
                    print("Error: \(error)")
                }
        }
        
    }
}
