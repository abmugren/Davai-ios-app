//
//  userChatCell.swift
//  Davai
//
//  Created by Apple on 4/13/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class userChatCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgChatItem: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgChatItem.layer.cornerRadius = 5
        imgChatItem.layer.shadowOpacity = 1.5
        imgChatItem.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
