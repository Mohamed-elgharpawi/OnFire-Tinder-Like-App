//
//  AuthViewModel.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/13/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation

protocol AuthViewModel {
    var isValid:Bool { get }
}
struct LoginViewModel:AuthViewModel {
    var email:String?
    var password:String?
    var isValid:Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false
        
    }
}
struct RegistrationViewModel : AuthViewModel{
    var email:String?
    var fullName:String?
    var password:String?
    var isValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false
        
    }
}
