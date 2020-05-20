//
//  SignInVC.swift
//  Davai
//
//  Created by MacBook  on 1/29/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD


class SignInVC: UIViewController {
	
    @IBOutlet weak var forgetPaswordLBL: UILabel!
	@IBOutlet weak var signInBtn: UIButton!
	@IBOutlet weak var emailTF: UITextField!
    var emailStr :String?
	@IBOutlet weak var passwordTF: UITextField!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        signInBtn.setTitle("signin".localized, for: .normal)
        forgetPaswordLBL.text = "forgetPaswordLBL".localized

        forgetPaswordLBL.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self, action: #selector(forgetPassword))
        forgetPaswordLBL.addGestureRecognizer(tap)
        if emailStr != nil {
            emailTF.text = emailStr
        }
		
		setupView()
	}
    @objc func forgetPassword(sender:UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "ERROR".localized, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enteryouremail".localized
        }
        let saveAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let emailTextField = alertController.textFields![0] as UITextField
            var isEmail = false
            isEmail =  Validate.isValidEmail(testStr: emailTextField.text ?? "")
            if emailTextField.text == nil || emailTextField.text == ""{
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryouremail".localized), delay: 1.5)
            }
            else if isEmail == false {
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "entervalidateemail".localized), delay: 1.5)
            }
            else{
                if CheckInternet.Connection(){
                    HUD.show(.progress)
                    WebService.instance.forgetPassword(email: emailTextField.text!) { (onSuccess, done) in
                        if onSuccess{
                            if done {
                                HUD.hide()
                                self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                                //HUD.hide()
                            }
                            else{
                                 HUD.hide()
                                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "emailisntexist".localized), delay: 1.5)
                               
                            }
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized), delay: 1.5)
                            
                        }
                    }
                }
                else{
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized), delay: 1.5)
                    HUD.hide()
                    
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
            self.present(alertController, animated: true, completion: nil)
        print("tap working")
    }
    @IBAction func btnSignInPressed(_ sender: Any) {
    
        var isEmail = false
        isEmail =  Validate.isValidEmail(testStr: emailTF.text ?? "")
         if self.emailTF.text == nil || self.emailTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enter your email"), delay: 1.5)
        }
        else if self.passwordTF.text == nil || self.passwordTF.text == ""{
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enteryourpassword".localized), delay: 1.5)
        }
         else if isEmail == false {
              HUD.flash(.labeledError(title: "Wrong", subtitle: "entervalidateemail".localized), delay: 1.5)
         }
         else {
            if CheckInternet.Connection(){
                
                let fcmToken = Helper.getFromUserDefault(key: "token")
                let param = ["val":emailTF.text!,
                             "password":passwordTF.text!,
                             "userKey":fcmToken]
                HUD.show(.progress)
                WebService.instance.signIn(params: param as! [String : String]) { (onSuccess, signed, user,vendor) in
                    if onSuccess{
                        if signed && user != nil{
                            HUD.hide()
                            self.emailTF.text = ""
                            self.passwordTF.text = ""
                            UserDefaults.standard.set("user", forKey: "userType")
                            
                            Helper.saveInUserDefault(value: (user?._id)!, key: "userId")
                             Helper.saveInUserDefault(value: (user?.countryID ?? ""), key: "countryId")
                            Helper.saveInUserDefault(value: "\(user?.firstName ?? "") \(user?.lastName  ?? "")", key: "userName")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController") as! MyTabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController = mainViewController
                            appDelegate.window?.makeKeyAndVisible()
                        }
                        else if signed && user == nil{
                            HUD.hide()
                            self.emailTF.text = ""
                            self.passwordTF.text = ""
                             UserDefaults.standard.set("vendor", forKey: "userType")
                            Helper.saveInUserDefault(value: (vendor?.countryID ?? "") , key: "countryId")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MyTabBarController") as! MyTabBarController
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController = mainViewController
                            appDelegate.window?.makeKeyAndVisible()
                        }
                        else{
                            HUD.hide()
                            self.emailTF.text = ""
                            self.passwordTF.text = ""
                             HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "emailorpasswordisntcorrect".localized), delay: 1.5)
                        }
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened"), delay: 1.5)
                        
                        self.emailTF.text = ""
                        self.passwordTF.text = ""
                        }
                }
            }
            else {
                 HUD.hide()
                HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized), delay: 1.5)
            }
          
        }
        
    }
    func setupView(){
		signInBtn.layer.borderWidth = 2
		signInBtn.layer.borderColor = UIColor.white.cgColor
		signInBtn.layer.cornerRadius = 20
		
		emailTF.layer.cornerRadius = 20
		emailTF.layer.borderWidth = 2
		emailTF.layer.borderColor = UIColor.lightGray.cgColor
		emailTF.attributedPlaceholder = NSAttributedString(string: "Emailaddress".localized,
														   attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
		passwordTF.layer.cornerRadius = 20
		passwordTF.layer.borderWidth = 2
		passwordTF.layer.borderColor = UIColor.lightGray.cgColor
		passwordTF.attributedPlaceholder = NSAttributedString(string: "*******",
															  attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
	}
	
	
}
