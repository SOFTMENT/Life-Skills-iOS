//
//  VideosTableViewCell.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit

class VideosTableViewCell : UITableViewCell {
    
    @IBOutlet weak var deleteView: UIImageView!
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mName: UILabel!
    
    @IBOutlet weak var mDuration: UILabel!
    override class func awakeFromNib() {
        
    }
}
