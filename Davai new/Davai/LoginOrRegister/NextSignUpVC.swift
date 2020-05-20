//
//  NextSignUpVC.swift
//  Davai
//
//  Created by MacBook  on 2/3/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import UICheckbox_Swift
import PKHUD

class NextSignUpVC: UIViewController ,UITextViewDelegate{
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var vendorDescriptionTV: UITextView!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var checkboxBtn: UICheckbox!
    @IBOutlet weak var signInBtn: UIButton!
    
    var dic = [String:Any]()
    var termAccepted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vendorDescriptionTV.delegate = self
        checkboxBtn.onSelectStateChanged = { (checkbox, selected) in
            debugPrint("Clicked - \(selected)")
            self.termAccepted = true
        }
        setupViews()
    }
    //
    func textViewDidEndEditing(_ textView: UITextView) {
        if  vendorDescriptionTV.text == ""{
            vendorDescriptionTV.text = "VendorDescription".localized
            vendorDescriptionTV.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if vendorDescriptionTV.text == "VendorDescription".localized{
            vendorDescriptionTV.text = ""
            vendorDescriptionTV.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let SignInVC = segue.destination as? SignInVC
        {
            if (segue.identifier == "vendorToSignIn") {
                SignInVC.emailStr = dic["email"] as! String
            }
        }
    }
    //
    var phoneNumber: String?
    @IBAction func SignUpAction(_ sender: Any) {
        var isEmail = false
        
       
        
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        if let final = Formatter.number(from: mobileTF.text ?? "") {
            mobileTF.text = "0" + "\(final)"
            phoneNumber = "0" + "\(final)"
        }
         isEmail =  Validate.isValidEmail(testStr: emailTF.text ?? "")
        
        if self.userNameTF.text == nil || self.userNameTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryourusername".localized), delay: 1.5)
        }
        else if (self.mobileTF.text?.isEmpty)! || self.mobileTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enterphonenumber".localized), delay: 1.5)
        }
  
        else if (self.emailTF.text?.isEmpty)! || self.emailTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Enteryouremail".localized), delay: 1.5)
        }
        else if (self.vendorDescriptionTV.text?.isEmpty)! || self.vendorDescriptionTV.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "WriteyourDescription".localized), delay: 1.5)
        }
        else if self.vendorDescriptionTV.text.count  <= 10 {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "validDescription".localized), delay: 2)
        }
        else if !isEmail{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "entervalidateemail".localized), delay: 1.5)
        }
            //
        else if passwordTF.text == nil || passwordTF.text == ""{
            HUD.flash(.labeledError(title: "Wrong", subtitle: "Enteryourpassword".localized), delay: 1.5)
        }
        else if passwordTF.text == nil || passwordTF.text == ""{
            HUD.flash(.labeledError(title:"ERROR".localized, subtitle: "validatePassword".localized), delay: 2)
        }
        else if confirmPasswordTF.text == nil || confirmPasswordTF.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "conifrmationPass".localized), delay: 2)
        }
        else if passwordTF.text !=  confirmPasswordTF.text {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "MatchPass".localized), delay: 1.5)
        }
        else if termAccepted == false{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "TermsConditions".localized), delay: 2)
        }
        else {
            print("services. \(dic)")
            
            dic["description"] = vendorDescriptionTV.text
            dic["OwnerEmail"] = emailTF.text
            dic["ownerMobile"] = mobileTF.text
            dic["password"] = passwordTF.text
            dic["ownerName"] = userNameTF.text
            
            WebService.instance.postVendorSignUp(params: dic) { (onSucess) in
                if onSucess{
                    print("success")
                    HUD.hide()
                    
                    self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                    self.performSegue(withIdentifier: "vendorToSignIn", sender: nil)
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened"), delay: 2)
                }
            }
        }
    }
    
    
    func setupViews(){
        userNameTF.layer.borderColor = UIColor.lightGray.cgColor
        userNameTF.layer.borderWidth = 2
        userNameTF.attributedPlaceholder = NSAttributedString(string: "UserName".localized,
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        mobileTF.layer.borderColor = UIColor.lightGray.cgColor
        mobileTF.layer.borderWidth = 2
        mobileTF.attributedPlaceholder = NSAttributedString(string: "Mobile".localized,
                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        emailTF.layer.borderColor = UIColor.lightGray.cgColor
        emailTF.layer.borderWidth = 2
        emailTF.attributedPlaceholder = NSAttributedString(string: "Emailaddress".localized,
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        passwordTF.layer.borderColor = UIColor.lightGray.cgColor
        passwordTF.layer.borderWidth = 2
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password".localized,
                                                              attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        confirmPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTF.layer.borderWidth = 2
        confirmPasswordTF.attributedPlaceholder = NSAttributedString(string: "ConfirmPassword".localized,
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        vendorDescriptionTV.layer.borderWidth = 2
        vendorDescriptionTV.layer.borderColor = UIColor.lightGray.cgColor
        vendorDescriptionTV.text = "VendorDescription".localized
        
        termsBtn.setTitle("AcceptTerms".localized, for: .normal)
        signInBtn.setTitle("signup".localized, for: .normal)
        signInBtn.layer.borderWidth = 2
        signInBtn.layer.borderColor = UIColor.white.cgColor
        signInBtn.layer.masksToBounds = true
    }
}


