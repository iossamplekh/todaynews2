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

protocol NewsTypeServiceDelegate{
    func didResivedNewsType(with newsType: [NewsType]?,error: Error?)
}
extension NewsTypeServiceDelegate{
    func didResivedNewsType(with newsType: [NewsType]?,error: Error?){}
}
class NewsTypeService{
    var delegate: NewsTypeServiceDelegate?

    func getNewsTypeData(){
        Alamofire.request(DataManager.URL.NEWSTYPE,
                          method: .get,
                          encoding: URLEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    
                    let json = JSON(value)
                    guard let code = json["code"].int, code == 2222 else {
                        let dictionary = [NSLocalizedDescriptionKey: json["message"].string ?? "unknown"]
                        let host = response.request?.url?.host ?? "unknown"
                        let error = NSError(domain: host, code: 9999, userInfo: dictionary)
                        self.delegate?.didResivedNewsType(with: nil, error: error)
                        SCLAlertView().showError("Data Error", subTitle: error.localizedDescription)
                        return
                    }
                    let newstype =  json["objects"].arrayValue.map{ NewsType($0) }
                    self.delegate?.didResivedNewsType(with: newstype, error: nil)
                    SCLAlertView().showInfo("Done", subTitle: "newstype request success")
                    
                case .failure(let error):
                    self.delegate?.didResivedNewsType(with: nil, error: error)
                    SCLAlertView().showError("Server Error", subTitle: error.localizedDescription)
                }
        }
    }
    
//    func getData(with newsType: [NewsType]?,completion: @escaping (DataResponse<Any>?, Error?)->()) {
//
//        // Request to server
//        Alamofire.request(DataManager.URL.NEWSTYPE,
//            method: .get,
//            encoding: JSONEncoding.default,
//            headers: DataManager.HEADER)
//            .responseJSON { (response) in // response from server
//                // check success or failure
//                switch response.result {
//                case .success(let value):
//                    completion(response, nil)
//                    print("response: \(response)")
//                    let json = JSON(value)
//                    let newsty =  json["objects"].arrayValue.map{ NewsType($0) }
//                    //newsty = newsType!
//                    newsType?.append(newsty)
//                case .failure(let error):
//                    completion(nil, error)
//                    print("Error: \(error)")
//                }
//        }
//    }
}
