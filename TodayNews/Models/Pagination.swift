//
//  Pagination.swift
//  TodayNews
//
//  Created by Ron Rith on 1/20/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pagination{
    var page: Int
    var pageSize: Int
    var totalElements: Int
    var totalPages: Int
    init(){
        page = 0
        pageSize = 0
        totalElements = 0
        totalPages = 0
    }
    init(_ data: JSON){
        page = data["numberOfElements"].int ?? 0
        pageSize = data["size"].int ?? 0
        totalElements = data["totalElements"].int ?? 0
        totalPages = data["totalPages"].int ?? 0
    }
}
