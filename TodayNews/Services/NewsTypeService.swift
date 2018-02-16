//
//  NewsTypeService.swift
//  TodayNews
//
//  Created by Ron Rith on 2/15/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class NewsTypeService{
    private init() {}
    
    static let shared: NewsTypeService = NewsTypeService()
    
    func getAllNewsType(completion: @escaping (DataResponse<Any>?, Error?)->()) {
        
        Alamofire.request(DataManager.URL.NEWSTYPE,
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
