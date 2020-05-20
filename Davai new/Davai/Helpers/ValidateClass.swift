//
//  ValidateClass.swift
//  Afkar
//
//  Created by Adel on 7/10/18.
//  Copyright © 2018 Other user. All rights reserved.
//

import Foundation

class Validate{
    
    // to valid Email
    class func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        print("asd \(result)")
        return result
    }
    // to check the string and number
    class func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    class func isString(string: String) -> Bool {
        return Int(string) == nil
    }
    // to validate Phone number
    class func isValidatePhone(value: String) -> Bool {
        var result = false
        if value.characters.count >= 5
        {
            let PHONE_REGEX = "^((\\+)|(0))[0-9]{6,14}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            result =  phoneTest.evaluate(with: value)
        }
        return result
    }
    class func isValidMobileNumber(_ mobileNo: String) -> Bool {
        let mobileNumberPattern: String = "^[0-9]{10}$"
        //@"^[7-9][0-9]{9}$";
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
        let isValid: Bool = mobileNumberPred.evaluate(with: mobileNo)
        return isValid
    }
    // Validate URL
    class func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    // MARK:- Verfiy Int
    class func verifyInt(testStr :String) -> Bool{
        let convertedStr = Int(testStr)
        if convertedStr != nil {
            return true
        }
        else{
            return false
        }
    }
    ////
    public func validateString(_ text:String?)->String {
        return text ?? ""
    }
    
    //Validate optional int
    public func validateInt(_ val:Int?)->Int {
        return val ?? 0
    }
    
}
