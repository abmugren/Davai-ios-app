//
//  userNotifactionCell.swift
//  Davai
//
//  Created by Apple on 4/16/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class userNotifactionCell: UITableViewCell {

    @IBOutlet weak var lblVendorName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUserNotification: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
