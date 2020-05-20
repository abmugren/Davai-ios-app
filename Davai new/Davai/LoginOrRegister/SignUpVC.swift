//
//  SignUpVC.swift
//  Davai
//
//  Created by MacBook  on 1/29/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var userBtn: UIButton!
    @IBOutlet weak var vendorBtn: UIButton!
    @IBOutlet weak var userContainer: UIView!
    @IBOutlet weak var vendorContainer: UIView!
    @IBOutlet weak var nextSignUp: UIView!
    var user :User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userBtn.setTitle("user".localized, for: .normal)
        vendorBtn.setTitle("vendor".localized, for: .normal)

        userBtn.layer.borderWidth = 2
        userBtn.layer.borderColor = UIColor.white.cgColor
        userBtn.layer.cornerRadius = 20
        //vendorBtn.applyGradient(colours: [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)])
        //        userBtn.setTitleColor(UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1), for: .normal)
        ////
        //
        vendorBtn.layer.borderWidth = 2
        vendorBtn.layer.borderColor = UIColor.white.cgColor
        
        vendorBtn.layer.cornerRadius = 20
        //        //vendorBtn.ashrafGradient(colorOne: UIColor(displayP3Red: 30/255, green: 87/255, blue: 118/255, alpha: 1), colorTwo: UIColor(displayP3Red: 11/255, green: 36/255, blue: 71/255, alpha: 1))
        //        vendorBtn.setTitleColor(UIColor.white, for: .normal)

        
    }
    
    
    
    
    @IBAction func changeAction(_ sender: Any) {
        if((sender as AnyObject).tag == 1 ){
            UIView.animate(withDuration: 0.5) {
                
                self.userBtn.backgroundColor = UIColor.white
                self.userBtn.setTitleColor(UIColor(named: "00335A"), for: .normal)
                self.userBtn.backgroundColor = UIColor.white
                
                self.vendorBtn.setTitleColor(UIColor.white, for: .normal)
                self.vendorBtn.backgroundColor = UIColor(named: "00335A")

                self.userContainer.alpha = 1
                self.vendorContainer.alpha = 0
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                self.userBtn.setTitleColor(UIColor.white, for: .normal)
                self.userBtn.backgroundColor = UIColor(named: "00335A")
                self.vendorBtn.setTitleColor(UIColor(named: "00335A"), for: .normal)
                self.vendorBtn.backgroundColor = UIColor.white

                self.userContainer.alpha = 0
                self.vendorContainer.alpha = 1
            }
        }
    }
}


