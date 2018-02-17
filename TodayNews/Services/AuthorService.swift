//
//  AuthorService.swift
//  TodayNews
//
//  Created by Ron Rith on 2/17/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class AuthorService{
    private init() {}
    
    static let shared: AuthorService = AuthorService()
    
    func getAllAuthors(completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
        Alamofire.request(DataManager.URL.AUTHOR,
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
