//
//  VendorNotifyCell.swift
//  Davai
//
//  Created by Mac on 5/22/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class VendorNotifyCell: UITableViewCell {
    
    @IBOutlet weak var notifyImage: UIImageView!
    @IBOutlet weak var notifyTitle: UILabel!
    @IBOutlet weak var notifyMessage: UILabel!
    @IBOutlet weak var NotifyDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
