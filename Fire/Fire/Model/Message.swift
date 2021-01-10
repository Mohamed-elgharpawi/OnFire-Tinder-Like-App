//
//  Message.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/6/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Firebase

struct Message {
    let text : String
    let fromId : String
    let toId : String
    var timestamp : Timestamp!
    let isFromCurrentUser:Bool
    var chatPartenerId : String {
        
        return isFromCurrentUser ? toId : fromId
    }
    var user : User?
    init(dic : [String:Any]) {
        self.text = dic["text"] as? String ?? ""
        self.fromId = dic["fromId"] as? String ?? ""
        self.toId = dic["toId"] as? String ?? ""
        self.timestamp = dic["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid

    }
    
}
