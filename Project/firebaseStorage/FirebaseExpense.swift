//
//  FirebaseExpense.swift
//  Project
//
//  Created by raz cohen on 12/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class FirebaseExpense: FirebaseModel {
    var dict:[String:Any]{
        var dict = ["id":id]
        if let imageURL = self.imageURL{
            dict["imageURL"] = imageURL
        }
        return dict
    }
    
    //properties:
    var imageURL:String?
    let id:String
    
    init(imageURL:String? = nil ,id:String){
        self.id =  UUID().uuidString
        self.imageURL = imageURL
    }
    
    required init?(dict: [String : Any]) {
        guard let id = dict["id"] as? String else{return nil}
        self.id = id
        self.imageURL = dict["imageURL"] as? String
    }
}

//ref for firebase:
extension FirebaseExpense{
    //datebase:
    
   static var imageDatabseRef:DatabaseReference{
    let uid = Auth.auth().currentUser?.uid
    return Database.database().reference().child("users").child(uid!).child("images")
    }
    
    var imageRef:StorageReference{
        Storage.storage().reference().child("Images").child(id + ".jpg")
    }
    
    //save fore firebase:
    func save(callback:@escaping(Error?,Bool)->Void){
        FirebaseExpense.imageDatabseRef.child(id).setValue(dict){(err,dbRef) in
            if let err = err{
                callback(err,false)
                return
            }
            callback(nil,true)
        }
    }
    
    func saveImage(image:UIImage,callback: @escaping(Error?,Bool)->Void){
        //(1)convert the image to jpeg data:
        guard let data = image.jpegData(compressionQuality: 1)else{
            callback(nil,false)
            return
        }
        
        //(2)upload:
        imageRef.putData(data,metadata: nil){[weak self](metadata,err) in
            if let err = err{
                callback(err,false)
                  print("Fail!!!")
                return
            }
            print("Saved!!!")
            //(3)save to database:
            self?.imageURL = self!.id + ".jpg"
            self?.save(callback:callback)
        }
    }
}
