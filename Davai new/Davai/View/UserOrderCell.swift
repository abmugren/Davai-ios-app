//
//  UserOrderCell.swift
//  Davai
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class UserOrderCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
