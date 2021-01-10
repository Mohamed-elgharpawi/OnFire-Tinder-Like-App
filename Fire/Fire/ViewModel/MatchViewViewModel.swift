//
//  MatchViewViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/31/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

struct MatchViewViewModel {
    //MARK:- Proprities
    private let currentUser:User
      let matchedUser:User
    let descriptionText:String
    var currentUserImg:URL?
    var matchedUserImg:URL?
    
    

    init(currentUser:User,matchedUser:User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        descriptionText="You and \(matchedUser.name) has liked each other!"
        
        guard let currentUserImage = currentUser.imageURLs.last
        else {return}
        guard let matchedUserImage = matchedUser.imageURLs.last else {return}

        currentUserImg = URL(string: currentUserImage)

        matchedUserImg = URL(string: matchedUserImage)
    }
    
    
}
