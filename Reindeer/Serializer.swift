//
//  Serializer.swift
//  Reindeer
//
//  Created by Kyaw Than Mong on 9/11/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import ObjectMapper

class UserId : Mappable{
    var groudID : String?
    var title : String?
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        groudID <- map["groupID"]
        title <- map["title"]
        
    }
    
}


class Interest : Mappable {
    var id : String?
    var name : String?
    //var categoryId : String
    
    required init?(_ map: Map) {
        mapping(map)
        
    }
     func mapping(map: Map) {
        id <- map["folderID"]
        name <- map["title"]
        //categoryId <- map[""]
        
        
        
    }
}

class Search : Mappable {
    var id : String?
    var pharse : String?
    var interestID : String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        pharse <- map["search_name"]
        interestID <- map["folder_id"]
    }
}

