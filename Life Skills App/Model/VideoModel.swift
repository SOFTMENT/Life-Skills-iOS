//
//  VideoModel.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit

class VideoModel : NSObject, Codable {
    
    var id : String?
    var title : String?
    var thumbnail : String?
    var videoUrl : String?
    var duration : Int?
    var createdDate : Date?
   
    
}
