//
//  SecUser.swift
//  TodayNews
//
//  Created by Ron Rith on 1/18/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import SwiftyJSON

class SecUser{
    var id: Int
    var email: String
    var image_url: String
    
    init(_ data: JSON) {
        id = data["id"].int ?? 0
        email = data["email"].string ?? ""
        image_url = data["image_jurl"].string ?? ""
    }
    init(){
        id = 0
        email = ""
        image_url = ""
    }
}
