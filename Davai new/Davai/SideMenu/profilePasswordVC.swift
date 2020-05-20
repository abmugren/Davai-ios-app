//
//  profilePasswordVC.swift
//  Davai
//
//  Created by Apple on 2/19/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class profilePasswordVC: UIViewController {

    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var securityBtn: UIButton!
    @IBOutlet weak var currentPasswordTF: TextField!
    @IBOutlet weak var newPasswordTF: TextField!
    @IBOutlet weak var repeatPasswordTF: TextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet var changePasswordView: UIView!
    @IBOutlet weak var dismissVuewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    @IBAction func securityBtn(_ sender: Any) {
        animateIn()
    }
    
    func animateIn(){
        self.view.addSubview(changePasswordView)
        changePasswordView.center = self.view.center
        changePasswordView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        changePasswordView.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.dismissVuewBtn.isHidden = false
            self.changePasswordView.alpha = 1
            self.changePasswordView.transform = CGAffineTransform.identity
        }
    }
    @IBAction func dismissView(_ sender: Any) {
        animateOut()
    }
    
    func animateOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.changePasswordView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.changePasswordView.alpha = 0
            self.dismissVuewBtn.isHidden = true
        }) { (success: Bool) in
            self.changePasswordView.removeFromSuperview()
        }
    }
    
    func setupView(){
        dismissVuewBtn.isHidden = true
        changePasswordView.layer.cornerRadius = 15
        changePasswordView.layer.borderWidth = 2
        changePasswordView.layer.borderColor = UIColor.darkGray.cgColor
        mobileTF.layer.borderWidth = 2
        mobileTF.layer.borderColor = UIColor.lightGray.cgColor
        mobileTF.attributedPlaceholder = NSAttributedString(string: "Mobile",
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        
        emailTF.layer.borderWidth = 2
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        
        countryTF.layer.borderWidth = 2
        countryTF.layer.borderColor = UIColor.lightGray.cgColor
        countryTF.attributedPlaceholder = NSAttributedString(string: "Country",
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        
        
        cityTF.layer.borderWidth = 2
        cityTF.layer.borderColor = UIColor.lightGray.cgColor
        cityTF.attributedPlaceholder = NSAttributedString(string: "City",
                                                             attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        currentPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        currentPasswordTF.attributedPlaceholder = NSAttributedString(string: "Current Password",
                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        newPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        newPasswordTF.attributedPlaceholder = NSAttributedString(string: "New Password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        repeatPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        repeatPasswordTF.attributedPlaceholder = NSAttributedString(string: "Repeat Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        
        saveBtn.layer.cornerRadius = 15
        saveBtn.layer.borderWidth = 1
        saveBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        

        securityBtn.layer.cornerRadius = 15
        securityBtn.layer.borderWidth = 2
        securityBtn.layer.borderColor = UIColor.darkGray.cgColor
        

    }
}
