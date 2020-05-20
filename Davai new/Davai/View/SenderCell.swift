//
//  SenderCell.swift
//  Davai
//
//  Created by Apple on 4/17/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgSender: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
