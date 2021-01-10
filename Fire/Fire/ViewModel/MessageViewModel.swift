//
//  MessageViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/6/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

struct MessageViewModel {
    private let message : Message
    var messageBackgroundColor : UIColor {
        
        return message.isFromCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    var textColor : UIColor {
        return message.isFromCurrentUser ? .black  : .white
        
    }
    var rightAnchorIsActive : Bool{
        return message.isFromCurrentUser
    }
    var leftAnchorIsActive : Bool {
        return !message.isFromCurrentUser
        
    }
    var shouldHideProfileImage : Bool {
        return message.isFromCurrentUser
    }
    var profileImage : String {
        guard let user = message.user else { return ""}
        return user.imageURLs.last ?? ""
        
    }
    
    
    init(message :Message) {
        self.message = message
    }
}
