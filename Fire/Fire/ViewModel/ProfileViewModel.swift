//
//  ProfileViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

struct ProfileViewModel {
    private let user :User
    let userDetailsAtrributedStr : NSAttributedString
    let profission : String
    let bio : String

//    let imageURLS : [String]
//    var imageURLs : [URL]{
//        return user.imageURLs.map { (url) -> URL in
//            URL(string: url)!
//        }
//    }
    
    var imageURLs : [URL]{
        return user.imageURLs.reversed().map {
            URL(string: $0)!
        }
    }
    var imageCount:Int{
        return user.imageURLs.count
    }
    
    
    
    init(user:User) {
        self.user=user
        let attributedString = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "  \(user.age)", attributes: [.font:UIFont.systemFont(ofSize: 22)]))
        userDetailsAtrributedStr = attributedString
        profission = user.profession
        bio = user.bio
       // imageURLS = user.imageURLs
    
    
    }
}
