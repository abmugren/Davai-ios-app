//
//  VendorServiceCell.swift
//  Davai
//
//  Created by Apple on 3/31/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class VendorServiceCell: UITableViewCell {

  
    @IBOutlet weak var btnReomve: UIButton!
    @IBOutlet weak var txtService: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
