//
//  PlaceDetailsVC.swift
//  Davai
//
//  Created by Apple on 2/5/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit

class PlaceDetailsVC: ViewController {

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var servicesBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    @IBOutlet var skipview: GradientView!
    @IBOutlet weak var aboutContainer: UIView!
    @IBOutlet weak var serviceContainer: UIView!
    @IBOutlet weak var chatContainer: UIView!
    let fromSideMenu = Helper.getFromUserDefault(key: "aboutPlace")
    let places = Helper.getFromUserDefault(key: "places")
    let userType = Helper.getFromUserDefault(key: "userType")
    var fromPlaces : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatBtn.setTitle("btnChat".localized, for: .normal)
        servicesBtn.setTitle("btnService".localized, for: .normal)
        aboutBtn.setTitle("btnAbout".localized, for: .normal)
        
        if fromPlaces == true &&  userType == "vendor"{
            chatBtn.isHidden = true
        }
        else {
            chatBtn.isHidden = false
        }
        if (self.fromSideMenu == "true") {
            setBtnMenu()
        }
        setUpView()
    }
   
    private func setBtnMenu(){
        if APPLANGUAGE == "ar"{
            if revealViewController() != nil {
                menuBtn.target = revealViewController()
                menuBtn.action = #selector(SWRevealViewController().rightRevealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
        else{
            if revealViewController() != nil {
                menuBtn.target = revealViewController()
                menuBtn.action = #selector(SWRevealViewController().revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    @IBAction func btnSignIn(_ sender: Any) {
    }
    
    @IBAction func btnCancelSkipView(_ sender: Any) {
        
    }
    @IBAction func changeContainerBtn(_ sender: Any) {
        if ((userType == "skip") && ((sender as AnyObject).tag == 2)) ||  ((userType == "skip") && ((sender as AnyObject).tag == 3)) {
            if APPLANGUAGE == "en"{
                
                let alert = UIAlertController(title: "Not Allowed", message: "You should sign in as a user", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                        self.navigationController?.popViewController(animated: true)

                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")


                }}))
                self.present(alert, animated: true, completion: nil)
            }
            else if APPLANGUAGE == "ar"{
                let alert = UIAlertController(title: "غير مسموح", message: "يجب عليك تسجيل الدخول كمستخدم", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                        self.navigationController?.popViewController(animated: true)

                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")


                }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        if((sender as AnyObject).tag == 1){
            UIView.animate(withDuration: 0.5){
            self.aboutContainer.alpha = 1
            self.serviceContainer.alpha = 0
            self.chatContainer.alpha = 0
            
                self.aboutBtn.layer.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                self.aboutBtn.setTitleColor(UIColor.white, for: .normal)
                self.aboutBtn.layer.masksToBounds = true
                
                self.servicesBtn.layer.borderWidth = 2
                self.servicesBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.servicesBtn.layer.cornerRadius = 10
                self.servicesBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.servicesBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
                
                self.chatBtn.layer.borderWidth = 2
                self.chatBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.chatBtn.layer.cornerRadius = 10
                self.chatBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.chatBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
               self.chatBtn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
            }
        }
        else if ((sender as AnyObject).tag == 2){
            
            UIView.animate(withDuration: 0.5) {
            self.serviceContainer.alpha = 1
            self.aboutContainer.alpha = 0
            self.chatContainer.alpha = 0
            
                 self.servicesBtn.layer.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                self.servicesBtn.setTitleColor(UIColor.white, for: .normal)
                self.servicesBtn.layer.masksToBounds = true
                
                self.aboutBtn.layer.borderWidth = 2
                self.servicesBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.aboutBtn.layer.cornerRadius = 10
                self.aboutBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
                self.aboutBtn.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                self.chatBtn.layer.borderWidth = 2
                self.chatBtn.layer.cornerRadius = 10
                self.chatBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.chatBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
                self.chatBtn.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                self.serviceContainer.alpha = 0
                self.aboutContainer.alpha = 0
                self.chatContainer.alpha = 1
                
                self.chatBtn.layer.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                self.chatBtn.setTitleColor(UIColor.white, for: .normal)
                self.chatBtn.layer.masksToBounds = true
        
                self.servicesBtn.layer.borderWidth = 2
                self.servicesBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.servicesBtn.layer.cornerRadius = 10
                self.servicesBtn.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.servicesBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
                
                self.aboutBtn.layer.borderWidth = 2
                self.aboutBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.aboutBtn.layer.cornerRadius = 10
                self.aboutBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
                self.aboutBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
                self.aboutBtn.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
    }
    
    
    func setUpView(){
        
        aboutBtn.layer.borderWidth = 2
        aboutBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
        aboutBtn.layer.cornerRadius = 10
        
        servicesBtn.layer.borderWidth = 2
        servicesBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
        servicesBtn.layer.backgroundColor = UIColor.white.cgColor
        servicesBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
        servicesBtn.layer.cornerRadius = 10
        
        chatBtn.layer.borderWidth = 2
        chatBtn.layer.borderColor = UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1).cgColor
        chatBtn.layer.backgroundColor = UIColor.white.cgColor
        chatBtn.setTitleColor(UIColor(displayP3Red: 51/255, green: 75/255, blue: 93/255, alpha: 1), for: .normal)
        chatBtn.layer.cornerRadius = 10
        
    }

}
