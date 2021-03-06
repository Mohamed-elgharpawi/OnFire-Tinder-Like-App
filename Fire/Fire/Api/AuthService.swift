//
//  AuthService.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/13/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import Firebase

struct  AuthCredentials {
    let email:String
    let fullname:String
    let password:String
    let image:UIImage
}
struct AuthService {
    
    static func logUserIn(withEmail email:String ,password: String ,completion :AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)

    }
    
    static func registerUser (withCredentials credentials:AuthCredentials , completion: @escaping (Error?)->Void){
        // here we get the image url after upload has been completed
        Service.uploadImage(image: credentials.image) { (imageUrl, error) in

            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                 if let error = error {
                               print("Error Create User \(error.localizedDescription)")
                               return
                            }

                guard let uid = result?.user.uid else{return}
                let data = ["email": credentials.email,
                            "fullname":credentials.fullname,
                            "imageURLs":[imageUrl],
                            "uid":uid,
                            "age":18] as [String : Any]
                
                USERS_COLLECTION.document(uid).setData(data, completion: completion)
                
            }
            
        }
    }
}
