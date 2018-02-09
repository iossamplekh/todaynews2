//
//  UserService.swift
//  TodayNews
//
//  Created by Ron Rith on 2/9/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire

class UserService{
    private init() {}
    
    static let shared: UserService = UserService()
    
    func singup(paramaters: [String: String], files: [String:Data], completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
    }
    func signin(completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
        // Request to server
        Alamofire.request("\(DataManager.URL.USER_LOGIN)/rithronlkh%40gmail.com/123456",
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
