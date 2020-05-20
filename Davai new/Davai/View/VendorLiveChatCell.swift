//
//  VendorLiveChatCell.swift
//  Davai
//
//  Created by Apple on 5/8/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class VendorLiveChatCell: UICollectionViewCell {
    @IBOutlet weak var imChatCell: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        Helper.circleImg(image: imChatCell)
    }
}
