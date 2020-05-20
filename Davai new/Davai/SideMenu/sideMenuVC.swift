//
//  sideMenuVC.swift
//  Davai
//
//  Created by Apple on 2/4/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import UIKit
import PKHUD

class sideMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var lblProfile: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let userId = Helper.getFromUserDefault(key: "userId")
    let clientId = Helper.getFromUserDefault(key: "clientId")
    let userType = UserDefaults.standard.string(forKey: "userType")
    var index = 1
    var arrSkipLogin = ["Sign In","Home","About Davai","Terms & Conditions","Share App","Rate App"]
    var arrSkipLoginArabic = ["تسجيل الدخول","الصفحة الرئيسية","حول التطبيق","الشروط والاحكام","شارك التطبيق","تقييم التطبيق"]
    var arrSkipLoginImages = ["sign-in","Home","about","terms","share","rate"]
    var arrVendor = ["My Vendor","Home","Notification","Create Ads","About Davai","Terms & Conditions","Contact Us","Share App","Rate App","Sign Out"]
    var arrVendorArabic = ["البائع الخاص بي","الصفحة الرئيسية","إخطارات","إنشاء إعلانات","حول التطبيق",
                           "الشروط والاحكام","اتصل بنا","شارك التطبيق","تقييم التطبيق","خروج"]
    var arrVendorImages = ["user","house","bell-button","ads","about","terms","phone","share","rate","signOut"]
    var logoImages = [
        UIImage(named: "userSide"),
        UIImage(named: "Home"),
        UIImage(named: "about"),
        UIImage(named: "terms"),
        UIImage(named: "phone"),
        UIImage(named: "share"),
        UIImage(named: "rate"),
        UIImage(named: "signOut")
        
    ]
    
    var labels = [
        "My Profile"
        ,"Home",
         "About Davai",
         "Terms & Conditions",
         "Contact Us",
         "Share App",
         "Rate App",
         "Sign Out"
    ]
    var arrayUserArabic =
        [
            "ملفي"
            ,"الصفحة الرئيسية",
             "حول التطبيق",
             "الشروط والاحكام",
             "اتصل بنا",
             "شارك التطبيق",
             "تقييم التطبيق",
             "خروج"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userType == "user"{
            getUserInfo(userId: userId ?? "")
        }
        else if userType == "vendor"{
            WebService.instance.getClientVendorById(clientId: clientId ?? "") { (onScucess, client) in
                if onScucess{
                    self.imgProfile?.sd_setImage(with: URL(string: (client?.logo ?? "")), placeholderImage: UIImage(named: "user"))
                    self.lblProfile.text = "\(client?.brandName ?? "")"
                }
                else{
                    
                }
            }
        }
        else if userType == "skip"{
            self.lblProfile.text = "UserName".localized
        }
        Helper.circleImg(image: imgProfile)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    ///
    private func getUserInfo(userId :String){
        if CheckInternet.Connection(){
            HUD.show(.progress)
            
            WebService.instance.getUSerProfile(userId: userId) { (onSuccess, userProfile) in
                if onSuccess{
                    self.imgProfile?.sd_setImage(with: URL(string: (userProfile?.personalImg ?? "")), placeholderImage: UIImage(named: "user"))
                    self.lblProfile.text = "\(userProfile?.firstName ?? "") \(userProfile?.lastName ?? "")"
                    HUD.hide()
                }
                else{
                    HUD.hide()
                    HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "ErrorHappened".localized))
                }
            }
            
        }
        else{
            HUD.hide()
            HUD.flash(.labeledError(title: "ERROR".localized, subtitle: "Connection".localized))
        }
    }
    ///
    private func rateApp(){
        guard let url = URL(string:"https://apps.apple.com/eg/app/davaiapp/id1466514400") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    private func shareApp(){
        let textToShare = "downloadDavai".localized
        if let myWebsite = NSURL(string: "https://apps.apple.com/eg/app/davaiapp/id1466514400") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    private func logOut(){
        Helper.removeInUserDefault(key: "aboutPlace")
        Helper.removeInUserDefault(key: "token")
        Helper.removeInUserDefault(key: "userType")
        Helper.removeInUserDefault(key: "userId")
        Helper.removeInUserDefault(key: "firstName")
        Helper.removeInUserDefault(key: "lastName")
        Helper.removeInUserDefault(key: "email")
        Helper.removeInUserDefault(key: "userName")
        Helper.removeInUserDefault(key: "clientCover")
        Helper.removeInUserDefault(key: "clientId")
        Helper.removeInUserDefault(key: "userId")
        Helper.removeInUserDefault(key: "countryId")
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "lang")
        self .present(controller!, animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if APPLANGUAGE == "en"{
            if userType == "skip"{
                return arrSkipLogin.count
            }
            else if userType == "user"{
                return logoImages.count
            }
            else {
                return arrVendor.count
            }
        }
        else{
            if userType == "skip"{
                return arrSkipLoginArabic.count
            }
            else if userType == "user"{
                return logoImages.count
            }
            else {
                return arrVendorArabic.count
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! sideMenuCell
        if APPLANGUAGE == "en"{
            if userType == "skip"{
                cell.logoImage.image = UIImage(named: arrSkipLoginImages[indexPath.row])
                cell.nameLabel.text = arrSkipLogin[indexPath.row]
                return cell
            }
            else if userType == "user"{
                cell.logoImage.image = logoImages[indexPath.row]
                cell.nameLabel.text = labels[indexPath.row]
                return cell
            }
            else {
                cell.logoImage.image = UIImage(named: arrVendorImages[indexPath.row])
                cell.nameLabel.text = arrVendor[indexPath.row]
                return cell
            }
        }
        else{
            if userType == "skip"{
                cell.logoImage.image = UIImage(named: arrSkipLoginImages[indexPath.row])
                cell.nameLabel.text = arrSkipLoginArabic[indexPath.row]
                return cell
            }
            else if userType == "user"{
                cell.logoImage.image = logoImages[indexPath.row]
                cell.nameLabel.text = arrayUserArabic[indexPath.row]
                return cell
            }
            else{
                cell.logoImage.image = UIImage(named: arrVendorImages[indexPath.row])
                cell.nameLabel.text = arrVendorArabic[indexPath.row]
                return cell
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if userType == "user"{
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "userProfile", sender: nil)
            case 1:
                let HomeController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNC")
                self .present(HomeController!, animated: true, completion: nil)
            case 2:
                performSegue(withIdentifier: "about", sender: nil)
            case 3:
                performSegue(withIdentifier: "terms", sender: nil)
            case 4:
                performSegue(withIdentifier: "contactUs", sender: nil)
            case 5:
                shareApp()
            case 6:
                rateApp()
            case 7:
                self.logOut()
                
            default:
                break
            }
        }
            
        else if userType == "skip"{
            switch indexPath.row {
            case 0:
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginOrRegisterVC")
                self .present(controller!, animated: true, completion: nil)
            case 1:
                performSegue(withIdentifier: "homeh", sender: nil)
                
            case 2:
                performSegue(withIdentifier: "about", sender: nil)
            case 3:
                performSegue(withIdentifier: "terms", sender: nil)
            case 4:
                shareApp()
            case 5:
                self.rateApp()
                
            default:
                break
            }
        }
        else {
            switch indexPath.row {
            case 0:
                let story = UIStoryboard(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "AboutPlaceVC") as! AboutPlaceVC
                
                navigationController?.pushViewController(vc, animated: true)
//                print("")
                
//                performSegue(withIdentifier: "vendorAboutt", sender: nil)
            case 1:
                let HomeController = self.storyboard?.instantiateViewController(withIdentifier: "HomeNC")
                self .present(HomeController!, animated: true, completion: nil)
            case 2:
                print("")
                performSegue(withIdentifier: "notification", sender: nil)
            case 3:
                print("")
                performSegue(withIdentifier: "createADS", sender: nil)
            case 4:
                performSegue(withIdentifier: "about", sender: nil)
            case 5:
                performSegue(withIdentifier: "terms", sender: nil)
            case 6:
                performSegue(withIdentifier: "contactUs", sender: nil)
            case 7:
                shareApp()
                
            case 8:
                rateApp()
            case 9:
                self.logOut()
                
            default:
                break
            }
        }
    }
}
