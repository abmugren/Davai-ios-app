//
//  Helper.swift
//  Davai
//
//  Created by Apple on 3/25/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
class Helper{
     static let  userDef = UserDefaults.standard
//    func showProgressIndicator()  {
//        MBProgressHUD.showAdded(to: view, animated: true)
//
//    }
//
//    func hideProgressIndicator()  {
//        MBProgressHUD.hide(for: view, animated: true)
//    }
//
//    func showDefaultAlert(with title: String, message: String)  {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let dismissAction = UIAlertAction(title: "Dismisss", style: .default, handler: nil)
//        alert.addAction(dismissAction)
//        present(alert, animated: true, completion: nil)
//    }
    class func saveInUserDefault(value :String,key:String){
        
        userDef.set(value, forKey: key)
    }
    class func getFromUserDefault(key:String)->String?{
            return userDef.string(forKey: key) ?? ""
    }
    class func removeInUserDefault(key:String){
        
        userDef.removeObject(forKey: key)
    }
    class func convertStrToDate(str:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy" //Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
         let date = dateFormatter.date(from: str)
        let dateStr = dateFormatter.string(from: date!)
        return dateStr
    }
    //
    class func makeImgRaduis(img:UIImageView){
        img.layer.cornerRadius = 5
        img.layer.shadowOpacity = 1.5
        img.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    class func circleImg(image :UIImageView){
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        //image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
}
