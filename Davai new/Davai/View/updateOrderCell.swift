//
//  updateOrderCell.swift
//  Davai
//
//  Created by Mac on 5/28/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class updateOrderCell: UITableViewCell {

    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSeerviceName: UILabel!
    @IBOutlet weak var btnChecked: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
