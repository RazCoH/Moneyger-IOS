//
//  FirebaseModel.swift
//  Project
//
//  Created by raz cohen on 12/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

protocol FirebaseModel{
    
    //from json:
    init?(dict:[String:Any])
    //to json:
    var dict:[String:Any]{get}
}
