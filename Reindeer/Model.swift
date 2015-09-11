//
//  Model.swift
//  Reindeer
//
//  Created by Kyaw Than Mong on 9/10/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation


class Data {
    var searchPharseDic : Dictionary<String, [SearchPhrase]>
    var InterestDic : Dictionary<String , [InterestName]>
    var Category : [CategoryName]
    var data : [Model]
    
    init(cat : [CategoryName], interest : Dictionary<String , [InterestName]>, search : Dictionary<String, [SearchPhrase]>) {
        self.Category = cat
        self.InterestDic = interest
        self.searchPharseDic = search
        self.data = []
        
    }
    
    func flatten() -> [Model]{
        if self.Category.count > 0 {
            for i in self.Category {
                data.append(Model(any: i, t: .CAT))
                if let ok = self.InterestDic[i.id] {
                    for interesting in ok {
                        data.append(Model(any: interesting, t: .INTEREST))
                        if let okOk = self.searchPharseDic[interesting.id] {
                            for pharse in okOk {
                                data.append(Model(any: pharse, t: .SEARCH))
                            }
                        }
                    }
                }
            }
            // do some
        }else {
            return self.data
        }
        return self.data
        
    }
    
    
  
}

class  Model
{
    
    var categoryName : CategoryName?
    var interestedNames : InterestName?
    var searchPharses : SearchPhrase?
    var dataType : type
    
    init(any : AnyObject, t : type){
        self.dataType = t
        switch(t){
        case .CAT:
            self.categoryName = any as? CategoryName
            break
        case .INTEREST:
            self.interestedNames = any as? InterestName
            break
        case .SEARCH:
            self.searchPharses = any as? SearchPhrase
            break
        }
    }
    
    
 
    
    
    
    
}

enum  type {
    case CAT
    case INTEREST
    case SEARCH
}

class CategoryName {
    var id : String
    var name : String
    init(id: String, name : String){
        self.id = id
        self.name = name
    }
    
}

class InterestName {
    var id : String
    var categoryId : String
    var name : String
    init(id: String, catId : String, name : String){
        self.id = id
        self.categoryId = catId
        self.name = name
    }
}
class SearchPhrase {
    var id : String
    var interestId : String
    var phrase : String
    init(id : String, interestId : String, phrase : String){
        self.id = id
        self.interestId = interestId
        self.phrase = phrase
    }
    
}


