//
//  CardViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/9/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
class CardViewModel {
   private var imageIndex = 0
    var index :Int {
        return imageIndex
    }
    //var imageToShow:UIImage?
    var imgUrl:URL?
    var imageURLs:[String]
    let user:User
    let userAtributedText:NSAttributedString
    init(user:User) {

        self.user=user
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy),.foregroundColor:UIColor.white])
              
              attributedText.append(NSAttributedString(string: "   \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24),.foregroundColor:UIColor.white]))
        self.userAtributedText=attributedText
       // self.imgUrl = URL(string: user.profileImage)
        self.imageURLs = user.imageURLs
    }
    
    func showNext() {
        guard imageIndex < imageURLs.count-1 else{return}
        imageIndex+=1
       imgUrl = URL(string: imageURLs[imageIndex])
    }
    
   func showPrev() {
    guard imageIndex > 0 else{return}
    imageIndex-=1
    imgUrl = URL(string: imageURLs[imageIndex])

    }
}
