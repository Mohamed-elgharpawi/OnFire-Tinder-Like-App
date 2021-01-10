//
//  Service.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/13/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Service {
    // note that completion plock for returning the img url in  hthe auth serevice register Function 
    static func uploadImage(image : UIImage , completion : @escaping (String?,Error?)->Void ){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else{ return }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        ref.putData(imageData, metadata: nil) { (metadata, error ) in
            
            if let error = error {
                print("Error Uploading Image \(error.localizedDescription)")
                completion(nil,error)
                return
                
            }
            
            ref.downloadURL { (url, error) in
                      guard let url = url?.absoluteString else{return}
                      
                      print("URL YAAD\(url)")
                      completion(url,error)
                  }
            
            
        }
        
        
      
        
        
    }
    static func fetchUser (withUid uid : String ,completion : @escaping (User)->Void){

        USERS_COLLECTION.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else{return}
              let user = User(dic: dictionary)
               completion(user)
            
            
        }
        
    }
    
    static func fetchUsers (forCurrentUser user:User ,completion : @escaping ([User])->Void){
        var users=[User]()
        let query = USERS_COLLECTION
            .whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
            .whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge)
        
        fetchSwipes { (swipedUserIds) in
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else{return}
                snapshot.documents.forEach({ (document) in
                    let dic = document.data()
                    let user = User(dic: dic)
                    guard user.uid != Firebase.Auth.auth().currentUser?.uid else{return}
                    guard swipedUserIds[user.uid] == nil else{return}
                    users.append(user)
//                    if users.count == snapshot.documents.count - 1 {
//                        completion(users)
//                    }
                })
                completion(users)
            }
        }
       
        
        
    }

   static func saveUserData(user:User, completion : @escaping (Error?)->Void) {
        let data = ["uid":user.uid,
                    "fullname": user.name,
                    "imageURLs":user.imageURLs,
                    "age":user.age,
                    "bio":user.bio,
                    "profession":user.profession,
                    "minSeekingAge":user.minSeekingAge,
                    "maxSeekingAge":user.maxSeekingAge] as [String : Any]
        USERS_COLLECTION.document(user.uid).setData(data,completion: completion)
    }
    
    static func saveSwipes (forUser user:User , isLike:Bool,completion : ((Error?)->Void)?){
        guard let uid = Firebase.Auth.auth().currentUser?.uid else {return}
        SWIPES_COLLECTION.document(uid).getDocument { (snapshot, error) in
            
            let data = [user.uid : isLike]
            if snapshot?.exists == true {
                SWIPES_COLLECTION.document(uid).updateData(data,completion: completion)
            }
            else{
                
                SWIPES_COLLECTION.document(uid).setData(data,completion: completion)
            }
            
            
        }
        
    }
    
    static func checkIfMatchExist(forUser user:User , completion : @escaping(Bool)->Void){
        guard let currentUid = Firebase.Auth.auth().currentUser?.uid else {return}
        SWIPES_COLLECTION.document(user.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else{return}
            guard let didMatch = data[currentUid] as? Bool else{return}
            completion(didMatch)
        }
        
        
    }
    
    static func fetchSwipes (completion: @escaping([String:Bool])->Void){
        guard let currentUid = Firebase.Auth.auth().currentUser?.uid else {return}
        SWIPES_COLLECTION.document(currentUid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String:Bool] else{
              completion([String:Bool]())
                return }
            completion(data)
        }
        
        
    }
    //MARK: - Match  Call

    
    static func uploadMatch (currentUser : User , matchedUser: User){
        guard let profileImageUrl = matchedUser.imageURLs.first else{return}
        guard let currentUserProfileImg = currentUser.imageURLs.first else{return}
        
        let matchedUserData = ["uid":matchedUser.uid,
                               "name": matchedUser.name,
                               "profileImageUrl": profileImageUrl]
        
        MATCH_MESSAGES_COLLECTION
            .document(currentUser.uid)
            .collection("matches").document(matchedUser.uid).setData(matchedUserData)

        
        let currentUserData = [
            "uid": currentUser.uid,
            "name" : currentUser.name ,
            "profileImageUrl" : currentUserProfileImg,
                               
        ]
        
        MATCH_MESSAGES_COLLECTION
            .document(matchedUser.uid)
            .collection("matches").document(currentUser.uid).setData(currentUserData)
        
        
        
    }
    
    static func fetchMatches (completion : @escaping ([Match])->Void ){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        MATCH_MESSAGES_COLLECTION.document(uid).collection("matches").getDocuments { (snapshot, error) in
           
            guard let data = snapshot  else {return}
            let matches = data.documents.map({Match(matchDic: $0.data())})
            completion(matches)
        }
        
    }
    
    //MARK: - Messages Calls
    
    static func uploadMessage (_ messsage :String , to user :User,completion : ((Error?)-> Void)? ){
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        
        let data = [
                     "text" : messsage,
                    "fromId" : currentUid,
                    "toId" : user.uid,
                     "timestamp" : Timestamp(date: Date())] as [String : Any]
        
        MESSAGES_COLLECTION.document(currentUid).collection(user.uid).addDocument(data: data) { (error) in
        MESSAGES_COLLECTION.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            MESSAGES_COLLECTION.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            MESSAGES_COLLECTION.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
            
        }
        
        
    }
    
    static func fetchMessages (forUser user : User , completion :@escaping ([Message])->Void ){
        var messages = [Message]()
        guard let currentUid = Firebase.Auth.auth().currentUser?.uid else { return  }
        
        let query = MESSAGES_COLLECTION.document(currentUid).collection(user.uid).order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (change) in
                
                if change.type == .added {
                    let dic = change.document.data()
                    messages.append(Message(dic: dic))
                    completion(messages)
                }
                

            })
        }
    }
    
    //MARK: - Conversation Call
    
   static func fetchConversation (completion : @escaping ([Conversation])->Void ){
        
        var conversations = [Conversation]()
        guard let currentUid = Firebase.Auth.auth().currentUser?.uid else { return }
        
        let query = MESSAGES_COLLECTION.document(currentUid).collection("recent-messages").order(by: "timestamp")
        query.addSnapshotListener { (snapshot, error) in
            
            snapshot?.documentChanges.forEach({ (change) in
                let dic = change.document.data()
                let message = Message(dic: dic)
                
                fetchUser(withUid: message.chatPartenerId) { (user) in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
                
                
                
                
            })
            
        }
    }

    
}
