//
//  NetworkCall.swift
//  Reindeer
//
//  Created by Kyaw Than Mong on 9/10/15.
//  Copyright © 2015 Meera Solution Inc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper


protocol callback {
    func onSucceed(data : [Model])
    func onFailed()
}

class NetworkCall  {
    var delegate : callback
    
    var searchPharseDic : Dictionary<String, [SearchPhrase]>
    var InterestDic : Dictionary<String , [InterestName]>
    var Category : [CategoryName]
    
    init (delegate : callback){
        self.delegate = delegate
        self.searchPharseDic = Dictionary<String, [SearchPhrase]>()
        self.InterestDic = Dictionary<String, [InterestName]>()
        self.Category = []
        shouldGetData()
        
        
    }
    
    private func writeOrUpdateSeachPhare(s : SearchPhrase){
        let key = s.interestId
        if let _ = self.searchPharseDic[key] {
            self.searchPharseDic[key]?.append(s)
        }else {
            self.searchPharseDic[key] = [s]
        }
        
    }
    
    private func writeOrUpdateInterest(i : InterestName) {
        let key = i.categoryId
        if let _ = self.InterestDic[key] {
            self.InterestDic[key]?.append(i)
        }else {
            self.InterestDic[key] = [i]
        }
        
    }
    
    
    
    
    private func shouldGetData() {
        
        Alamofire.request(.POST, "http://api.linkboard.com/groups/getGroupsByUserID?userID=398")
            .responseString { _, _, result in
                print("Response String: \(result.value)")
            }
            .responseJSON { _, response, result in
                if let users = Mapper<UserId>().mapArray(result.value) {
        
                    for item in users {
                        self.Category.append(CategoryName(id: item.groudID!, name: item.title!))
                        Alamofire.request(.POST, "http://api.linkboard.com/folders/getFoldersByGroupID?groupID=\(item.groudID!)")
                            .responseJSON{ _, _, resultOne in
                                if let groupList = Mapper<Interest>().mapArray(resultOne.value) {
                                    for i in groupList {
                                        let interest = InterestName(id: i.id!, catId: item.groudID!, name: i.name!)
                                        self.writeOrUpdateInterest(interest)
                                        Alamofire.request(.POST, "http://api.linkboard.com/folders/getFoldersSearches?folderID=\(i.id!)")
                                            .responseJSON{ _, _, resultTwo in
                                                print("response from \(i.id!) : \(JSON(resultTwo.value!))")
                                                if let searchs = Mapper<Search>().mapArray(resultTwo.value){
                                                    for j in searchs {
                                                        let search = SearchPhrase(id: j.id!, interestId: j.interestID!, phrase: j.pharse!)
                                                        self.writeOrUpdateSeachPhare(search)
                                                        let data = Data(cat: self.Category, interest: self.InterestDic, search: self.searchPharseDic)
                                                        self.delegate.onSucceed(data.flatten())
                                                    }
                                                }

                                                
                                        }
                                       
                                    }
                                }
                        }
                        
                    }
                
                }
        }
        
    }
    
}