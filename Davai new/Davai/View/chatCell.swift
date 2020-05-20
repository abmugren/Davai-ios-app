//
//  chatCell.swift
//  Davai
//
//  Created by Apple on 2/7/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class chatCell: UITableViewCell {

    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chatText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        Helper.circleImg(image: chatImage)
    }
   
    

}
