//
//  Author.swift
//  TodayNews
//
//  Created by Ron Rith on 1/18/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import SwiftyJSON

class Author{
    var id: Int
    var name: String
    var email: String
    var image_url: String
    var secUser: SecUser
    
    init(_ data: JSON) {
        id = data["id"].int ?? 0
        name = data["name"].string ?? ""
        email = data["email"].string ?? ""
        image_url = data["realImageUrl"].string ?? ""
        secUser = SecUser(data["secUser"])
    }
    
    init(){
        id = 0
        name = ""
        email = ""
        image_url = ""
        secUser = SecUser()
    }
    
}
