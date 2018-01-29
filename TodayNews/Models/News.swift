//
//  News.swift
//  TodayNews
//
//  Created by Ron Rith on 1/18/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import SwiftyJSON

class News{
    var id: Int
    var name: String
    var desEn: String
    var image: String
    var newsType: NewsType
    var secUser: SecUser
    //var author: Author
    
    init(_ data: JSON) {
        id = data["id"].int ?? 0
        name = data["name"].string ?? ""
        image = data["image"].string ?? ""
        desEn = data["desEn"].string ?? ""
        newsType = NewsType(data["newsType"])
        secUser = SecUser(data["secUser"])
        //author = Author(data["author"])
    }
    init(){
        id = 0
        name = ""
        desEn = ""
        image = ""
        newsType = NewsType()
        secUser = SecUser()
        //author = Author()
    }
}
