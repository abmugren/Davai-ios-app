//
//  ReservationDetails.swift
//  Davai
//
//  Created by Apple on 2/14/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class ReservationDetails: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var vendorImage: UIImageView!
    
    @IBOutlet weak var reservedBtn: UIButton!
    @IBOutlet weak var cancelledBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var doneBtn: GradientButton!
    
    @IBOutlet weak var selectServiceView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    func setupView(){
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 15
        
        vendorImage.layer.cornerRadius = 10
        vendorImage.layer.masksToBounds = true
        
        cancelledBtn.layer.borderWidth = 2
        cancelledBtn.layer.borderColor = UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1).cgColor
        cancelledBtn.layer.cornerRadius = 10
        
        completedBtn.layer.borderWidth = 2
        completedBtn.layer.borderColor = UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1).cgColor
        completedBtn.layer.cornerRadius = 10
        
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor.lightGray.cgColor
        timeView.layer.borderWidth = 1
        timeView.layer.borderColor = UIColor.lightGray.cgColor
        
        dateTF.attributedPlaceholder = NSAttributedString(string: "Date".localized,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1)])

        timeTF.attributedPlaceholder = NSAttributedString(string: "Time".localized,
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1)])
        
        selectServiceView.layer.borderWidth = 1
        selectServiceView.layer.borderColor = UIColor.lightGray.cgColor
        
        doneBtn.layer.borderWidth = 2
        doneBtn.layer.borderColor = UIColor.white.cgColor
        doneBtn.layer.cornerRadius = 20

    }
}
