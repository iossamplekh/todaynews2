//
//  NewsService.swift
//  TodayNews
//
//  Created by Ron Rith on 1/19/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

protocol NewsServiceDelegate {
    func didResivedNews(with news: [News]?,pagination: Pagination?,error: Error?)
    
    func SaveNews(error: Error?)
}

extension NewsServiceDelegate{
    func didResivedNews(with news: [News]?,pagination: Pagination?,error: Error?){}
    
    func SaveNews(error: Error?){}
}

class NewsService{
    var delegate: NewsServiceDelegate?
    
    func getData(pageNumber: Int){
        Alamofire.request(DataManager.URL.NEWS,
                          method: .get,
                          parameters:  ["page":pageNumber, "pageSize":10],
                          encoding: URLEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
            switch response.result{
            case .success(let value):
                //print(value)
                let json = JSON(value)
                guard let id = json["totalElements"].int else {
                    // Report any error
                    let dictionary = [NSLocalizedDescriptionKey: json["name"].string ?? "unknown"]
                    let host = response.request?.url?.host ?? "unknown"
                    let error = NSError(domain: host, code: 400, userInfo: dictionary)
                    self.delegate?.didResivedNews(with: nil, pagination: nil,error: error)
                    return
                }
                var page: Int = json["number"].int ?? 0
                var pageSize: Int = json["size"].int ?? 0
                var totalElements: Int = json["totalElements"].int ?? 0
                var totalPages: Int = json["totalPages"].int ?? 0

                let pagination = Pagination()
                
                pagination.page = page
                pagination.pageSize = pageSize
                pagination.totalElements = totalElements
                pagination.totalPages = totalPages
                
                let news =  json["content"].arrayValue.map{ News($0) }
                self.delegate?.didResivedNews(with: news, pagination: pagination, error: nil)
//                SCLAlertView().showInfo("Done", subTitle: "Done")
            case .failure(let error):
                self.delegate?.didResivedNews(with: nil, pagination: nil,error: error)
            }
        }
    }
    
    func saveNews(paramaters: [String: Any]) {
        
        Alamofire.request(DataManager.URL.NEWS_SAVE_DEAUL,
                          method: .post,
                          parameters:  paramaters,
                          //encoding: URLEncoding.default,
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
                        self.delegate?.SaveNews(error: error)
                        SCLAlertView().showInfo("No data", subTitle: "No value")
                        return
                    }
                    // Success
                    SCLAlertView().showInfo("Have", subTitle: "OK")
                    self.delegate?.SaveNews(error: nil)
                case .failure(let error):
                    self.delegate?.SaveNews(error: error)
                }
        }
    }
    
    func uploadFile(file : Data, completion: @escaping (String?, Error?) -> ()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
           multipartFormData.append(file, withName: "file", fileName: "fileName.jpg", mimeType: "image/jpeg") // append image
            
        }, to: DataManager.URL.FILE,
           method: .post,
           headers: DataManager.HEADER,
           encodingCompletion: { (encodingResult) in
            print("encodingResult\(encodingResult)")
            switch encodingResult {
            case .success(let upload, _, _):
                print("upload.request: \(upload.request!)")
                print("upload.response: \(upload.response)")
                upload.responseJSON { response in
                    print("Respons: \(response)")
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        guard let code = json["code"].int, code == 2222 else {
                            // Report any error we got.
                            let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                            let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                            completion(nil, error)
                             SCLAlertView().showInfo("Image problem code", subTitle: "Imageprobelm code")
                            return
                        }
                        
                        guard let url = json["object"].string else {
                            // Report any error we got.
                            let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                            let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                            completion(nil, error)
                          SCLAlertView().showInfo("Image problem object", subTitle: "Imageprobelm object")
                            return
                        }
                         SCLAlertView().showInfo("Save", subTitle: "Data have been save")
                        completion(url, nil)
                    }
                }
            case .failure(let error):
                completion(nil, error)
                print("Error failure: \(error)")
            }
        })
    }
}
