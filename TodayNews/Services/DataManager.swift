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
        static let BASE = "https://newiosapi.herokuapp.com/rest"
        
        static let NEWS = BASE + "/news/"
        
        static let NEWS_SAVE = NEWS + "save/{newsTypeDesEn}/{email}/{authorEmail}"
        
        static let FILE = "https://newiosapi.herokuapp.com/rest/uploadfile"
        
        static let NEWS_SAVE_DEAUL = "https://newiosapi.herokuapp.com/rest/news/save/Sport/rithronlkh%40gmail.com/author1%40gmail.com"
        static let NEWS_SAVE_DEFAUL = "https://newiosapi.herokuapp.com/rest/news/save"
        
        static let NEWS_SEARCH = "https://newiosapi.herokuapp.com/rest/news/find/"
        
        //user
        static let USER_LOGIN = "https://newiosapi.herokuapp.com/rest/users/login"
        static let USER_SIGNUP = "https://newiosapi.herokuapp.com/rest/users"
        //newstype
        static let NEWSTYPE = "https://newiosapi.herokuapp.com/rest/newstype"
        //author
        static let AUTHOR = "https://newiosapi.herokuapp.com/rest/authors"
        //newstype and author
        static let NEWSTYPE_AUTHOR = "https://newiosapi.herokuapp.com/rest/newstypeandauthors"
        
    }
    static let HEADER = ["Authorization":"Basic cml0aHJvbmxraEBnbWFpbC5jb206MTIzNDU2"]
    //https://newiosapi.herokuapp.com/rest/news/14
}
