//
//  MessageTableViewCell.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit

class MessageTableViewCell : UITableViewCell {
    
   
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var deleteBtn: UIImageView!
    override class func awakeFromNib() {
        
    }
}
