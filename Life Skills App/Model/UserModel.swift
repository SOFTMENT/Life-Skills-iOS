//
//  UserModel.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit

class UserModel : NSObject, Codable {
    
    var fullName : String?
    var email : String?
    var uid : String?
    var registredAt : Date?
    var regiType : String?
    var lastQuotesId : Int?
    var lastQuotesDate : Date?
    var notiToken : String?
    var membership : Bool?
    
    private static var userData : UserModel?
   
    static var data : UserModel? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }


    override init() {
        
    }
    
}
