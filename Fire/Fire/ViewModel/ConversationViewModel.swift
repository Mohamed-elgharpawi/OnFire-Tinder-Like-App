//
//  ConversationViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/7/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    let conversation : Conversation
    
//    var username : String {
//        
//        return conversation.message.user!.name
//        
//    }
//    var message : String {
//        
//        return conversation.message.text
//    }
    var profileImage : String {
        return conversation.user.imageURLs.last!
    }
    var timestame : String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation : Conversation) {
        self.conversation = conversation
    }
    
}
