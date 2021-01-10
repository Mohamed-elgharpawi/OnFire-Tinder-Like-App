//
//  MatchCellViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

struct MatchCellViewModel {
    let name : String
    var imgUrl :URL?
    let uid : String
    init(match : Match) {
        name = match.name!
        imgUrl = URL(string: match.profileImageURL!)
        uid = match.uid!
        
        
       
        
        
    }
}
