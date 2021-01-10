//
//  SettingsViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/21/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

enum SettingsSections : Int ,CaseIterable{
    case name
    case profession
    case age
    case bio
    case ageRange
    var description: String {
        switch self {
            
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
             return "Age Range"
        }
        
    }
   
    
    
    
}
struct SettingsViewModel {
    let user:User
    let section:SettingsSections
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    var shouldHideAgeRange : Bool {
        return section != .ageRange
    }
    var placeholderText:String
    var value :String?
    
    init(user: User,section: SettingsSections) {
        self.section = section
        self.user = user
        self.placeholderText = "Enter \(section.description)"
        switch section{
            
        case .name:
            value = user.name
        case .profession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .ageRange:
            break
            
        }
        
    }
    
    func minAgeLabelText ( forValue value :Float)->String{
        return "Min: \(Int(value))"
    }
    func maxAgeLabelText ( forValue value :Float)->String{
           return "Max: \(Int(value))"
       }
    var maxAgeSliderValue:Float {
           
        return Float(user.maxSeekingAge)
           
       }
    var minAgeSliderValue:Float {
        
     return Float(user.minSeekingAge)
        
    }
    
}
