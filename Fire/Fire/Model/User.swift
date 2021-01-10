//
//  User.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/9/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

struct User {
    var name:String
    var age:Int
    var email:String
    var uid:String
    var imageURLs:[String]
    var profession : String
    var maxSeekingAge :Int
    var minSeekingAge :Int
    var bio : String
    

    init(dic : [String:Any]) {
        self.name = dic["fullname"] as? String ?? ""
        self.age = dic["age"] as? Int ?? 0
        self.email = dic["email"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.imageURLs = dic["imageURLs"] as? [String] ?? [String]()
        self.profession = dic["profession"] as? String ?? ""
        self.bio = dic["bio"] as? String ?? ""
        self.maxSeekingAge = dic["maxSeekingAge"] as? Int ?? 40
        self.minSeekingAge = dic["minSeekingAge"] as? Int ?? 18


    }
    
    
}
