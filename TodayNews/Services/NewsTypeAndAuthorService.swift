//
//  NewsTypeAndAuthorService.swift
//  TodayNews
//
//  Created by Ron Rith on 2/18/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class NewsTypeAndAuthorService{
    private init() {}
    
    static let shared: NewsTypeAndAuthorService = NewsTypeAndAuthorService()
    
    func getAllNewsTypeAndAuthor(completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
        Alamofire.request(DataManager.URL.NEWSTYPE_AUTHOR,
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
