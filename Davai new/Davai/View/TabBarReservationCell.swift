//
//  TabBarReservationCell.swift
//  Davai
//
//  Created by Apple on 4/11/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class TabBarReservationCell: UITableViewCell {
    @IBOutlet weak var btnChecked: UIButton!
    
    @IBOutlet weak var view2: ANCustomView!
    @IBOutlet weak var txtEmpp: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
