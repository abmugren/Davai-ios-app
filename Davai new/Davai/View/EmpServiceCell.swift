//
//  EmpServiceCellTableViewCell.swift
//  Davai
//
//  Created by Apple on 3/26/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class EmpServiceCell: UITableViewCell {
    @IBOutlet weak var txtEmpName: TextField!
    
    @IBOutlet weak var btnRemoveEmp: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
