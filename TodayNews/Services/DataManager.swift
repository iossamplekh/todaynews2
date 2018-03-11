//
//  DataManager.swift
//  TodayNews
//
//  Created by Ron Rith on 1/19/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import Foundation

struct DataManager{
    struct URL{
        static let LOCALHOST = "http://localhost:8080/rest"
        
        static let BASE = "https://newiosapi.herokuapp.com/rest"
        
        static let NEWS = BASE + "/news/"
        
        static let NEWS_SAVE = BASE + "save/{newsTypeDesEn}/{email}/{authorEmail}"
        
        static let FILE = "\(BASE)/uploadfile"
        
        static let NEWS_SAVE_DEAUL = "\(BASE)/news/save/Sport/rithronlkh%40gmail.com/author1%40gmail.com"
        static let NEWS_SAVE_DEFAUL = "\(BASE)/news/save"
        
        static let NEWS_SEARCH = "\(BASE)/news/find/"
        
        //user
        static let USER_LOGIN = "\(BASE)/users/login"
        static let USER_SIGNUP = "\(BASE)/users"
        //newstype
        static let NEWSTYPE = "\(BASE)/newstype"
        //author
        static let AUTHOR = "\(BASE)/authors"
        //newstype and author
        static let NEWSTYPE_AUTHOR = "\(BASE)/newstypeandauthors"
        
    }
    static let HEADER = ["Authorization":"Basic cml0aHJvbmxraEBnbWFpbC5jb206MTIzNDU2"]
    //https://newiosapi.herokuapp.com/rest/news/14
}
