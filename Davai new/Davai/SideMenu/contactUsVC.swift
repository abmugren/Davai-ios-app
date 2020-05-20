//
//  contactUsVC.swift
//  Davai
//
//  Created by Apple on 2/18/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class contactUsVC: UIViewController,UITextFieldDelegate ,UITextViewDelegate{
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    @IBOutlet weak var btnSend: GradientButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtMessageType: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    
    let arrayMessagesType = ["opinion".localized,"spam".localized,"other".localized]
    let pickerView = UIPickerView()
    var selectedType :Int?
    var arrayfSetting :[Setting]?
    var dic :[String:Any] = [:]
    let myTab = MyTabBarController()
    override func viewDidLoad() {
        myTab.selectedIndex = 3
        super.viewDidLoad()
        setBtnMenu()
        btnSend.setTitle("btnSend".localized, for: .normal)
        txtMessageType.delegate = self
        txtMessage.delegate = self
        setPickerToField(pickerView :pickerView,textField: txtMessageType, title: "Messagetype".localized)
        //
        if CheckInternet.Connection(){
            HUD.show(.progress)
                WebService.instance.getSetting { (onSuccess, settings) in
                    if onSuccess{
                        self.arrayfSetting = settings
                        HUD.hide()
                    }
                    else{
                        HUD.hide()
                        HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                    }
                }
            }
        else{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
        ///
       
        //setupView()
     
    }
    //
    private func setBtnMenu(){
        if APPLANGUAGE == "ar"{
            if revealViewController() != nil {
                btnMenu.target = revealViewController()
                btnMenu.action = #selector(SWRevealViewController().rightRevealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
        else{
            if revealViewController() != nil {
                btnMenu.target = revealViewController()
                btnMenu.action = #selector(SWRevealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setPickerToField(pickerView :pickerView,textField: txtMessageType, title: "Messagetype".localized)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtMessage.text = ""
        txtMessage.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text == "" || txtMessage.text == nil {
             txtMessage.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            txtMessage.text = "Typehere".localized
        }
    }
   
    @IBAction func btnSendPressed(_ sender: Any) {
        if txtMessageType.text == nil || txtMessageType.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "choosemessagetype".localized), delay: 1.5)
        }
        else if txtMessage.text == nil || txtMessage.text == ""{
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "typeyourmessage".localized), delay: 1.5)
        }
        else if selectedType == nil {
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "choosemessagetype".localized), delay: 1.5)
        }
        else {
            //userType
             
            if Helper.getFromUserDefault(key: "userType") == "user"{
                let userId = Helper.getFromUserDefault(key: "userId")
                dic = ["userID":userId ?? "","msg":txtMessage.text,"type":selectedType ?? ""] as [String : Any]
            }
            else{
                let clientId = Helper.getFromUserDefault(key: "clientId")
                dic = ["clientID":clientId ?? "","msg":txtMessage.text,"type":selectedType ?? ""] as [String : Any]
            }
            WebService.instance.contactUs(params: dic) { (onScusess) in
                if onScusess{
                    self.view.makeToast("sucessfully".localized, duration: 2.0, position: .center)
                }
            }
        }
    }
    @IBAction func btnGooglePressed(_ sender: Any) {
        if arrayfSetting?.count ?? 0 > 0{
            for item in arrayfSetting!{
                if item.key == "google"{
                    let urlString = item.value
                    if let url = NSURL(string:urlString ){
                        UIApplication.shared.openURL(url as URL)
                    }
                }
            }
        }
       
    }
    @IBAction func btnFBPressed(_ sender: Any) {
        if arrayfSetting?.count ?? 0 > 0{
            for item in arrayfSetting!{
                if item.key == "facebook"{
                    let urlString = item.value
                    if let url = NSURL(string:urlString ){
                        UIApplication.shared.openURL(url as URL)
                    } 
                }
            }
        }
     
    }
    @IBAction func btnTwittPressed(_ sender: Any) {
        if arrayfSetting?.count ?? 0 > 0{
            for item in arrayfSetting!{
                if item.key == "twitter"{
                    let urlString = item.value
                    if let url = NSURL(string:urlString ){
                        UIApplication.shared.openURL(url as URL)
                    }
                }
            }
        }
    }
    func setupView(){
        navigationItem.title = "ContactUs".localized
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = 15
    }
    
}
// MARK:_  Fill PickerView
extension contactUsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayMessagesType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayMessagesType[row]
        
        
    }
    // didSelect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = row + 1
        txtMessageType.text = arrayMessagesType[row]
    }
}
