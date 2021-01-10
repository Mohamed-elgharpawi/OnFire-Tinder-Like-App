//
//  Match.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

struct Match {
    var name : String?
    var profileImageURL : String?
    var user : User?
    var uid : String?
    init(matchDic : [String: Any]) {
        name = matchDic["name"] as? String ?? ""
        profileImageURL = matchDic["profileImageUrl"] as? String ?? ""
        uid = matchDic["uid"] as? String ?? ""
        
    }
    init(user:User) {
        self.user = user
        self.name = user.name
        self.profileImageURL = user.imageURLs.last
        self.uid = user.uid
        
    }
    
}
