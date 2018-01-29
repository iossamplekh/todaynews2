//
//  NewsType.swift
//  TodayNews
//
//  Created by Ron Rith on 1/18/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsType{
    var id: Int
    var desEn: String
    var secUser: SecUser
    
    init(_ data: JSON) {
        id = data["id"].int ?? 0
        desEn = data["desEn"].string ?? ""
        secUser = SecUser(data["secUser"])
    }
    init(){
        id = 0
        desEn = ""
        secUser = SecUser()
    }
    
}
