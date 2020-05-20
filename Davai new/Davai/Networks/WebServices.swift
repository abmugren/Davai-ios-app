//
//  SigningApi.swift
//  Davai
//
//  Created by Apple on 3/24/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import PKHUD
import SwiftyJSON
// SigningProtocol
protocol SigningApiDelegate: class {
    func didSuccess(item: [String:Any]) // this is called when success request
    func didFail(with error: String) // this is called when fail request
}

class WebService {
    var delegate :SigningApiDelegate?
    static let instance = WebService()
    
    // MARK:- SIGN UP
    
    func signUp(params :[String:Any]){ 
        Alamofire.request(Constant.SING_UP_URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let jsonx = JSON(json)
                    
                    if jsonx["message"].stringValue == "sorry is email exsist" {
                        HUD.flash(.labeledError(title: "Wrong", subtitle: "aaaaaaaaaaaaaaa".localized), delay: 1.5)
                        break
                    }else if jsonx["message"].stringValue == "sorry is mobile exsist" {
                        HUD.flash(.labeledError(title: "Wrong", subtitle: "aaaaaaaaaaaaaaa".localized), delay: 1.5)
                        break
                    }else{
                        self.delegate?.didSuccess(item: json)
                    }

                }
                break
                
            case .failure(_):
                self.delegate?.didFail(with: response.result.error as! String)
                break
                
            }
        }
    }
    // MARK:- getCountries
    func getCountries(completion: @escaping (_ onSucess :Bool, _ countries :[Country]?) -> ()){
        Alamofire.request(Constant.COUNTRIES_URL, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("countirs data \(data)")
                        let decodedCountries : [Country]
                        decodedCountries = try JSONDecoder().decode([Country].self, from: data)
                        completion(true , decodedCountries)
                    } catch {
                        print("parsing error")
                    }
                }
                break
                
            case .failure(_):
                completion(false,nil)
                break
                
            }
        }
    }
    // MARK:- Get Cities
    func getCities(countryId :String ,completion: @escaping (_ onSucess :Bool, _ cities :[City]?) -> ()){
        Alamofire.request("\(Constant.CITIES_URL)\(countryId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("\(Constant.CITIES_URL)\(countryId)")
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("cities data \(data)")
                        let decodedCites : [City]
                        decodedCites = try JSONDecoder().decode([City].self, from: data)
                        completion(true , decodedCites)
                    } catch {
                        print("parsing error")
                    }
                }
                break
                
            case .failure(_):
                completion(false,nil)
                break
                
            }
        }
    }
    // MARK:- getCategories
    func getCategories(completion: @escaping (_ onSucess :Bool, _ countries :[Category]?) -> ()){
        Alamofire.request(Constant.CATEGORIES, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(Constant.CATEGORIES)
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedCategories : [Category]
                        decodedCategories = try JSONDecoder().decode([Category].self, from: data)
                        completion(true , decodedCategories)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //MARK:- getServices
    func getServices(categoryId :String,completion: @escaping (_ onSucess :Bool, _ countries :[Service]?) -> ()){
        Alamofire.request("\(Constant.SERVICES_BY_CATEGORY_ID)\(categoryId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("services data \(data)")
                        let decodedService : [Service]
                        decodedService = try JSONDecoder().decode([Service].self, from: data)
                        completion(true , decodedService)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //MARK:- uoplad pic
    typealias CompletionHandler = (_ success:Bool,_ response:Any? ,_ error:String?) -> Void
    
    func uploadThumbnail(thumbnail:UIImage ,completionHandler: @escaping CompletionHandler)  {
        
        let imageData:Data = UIImageJPEGRepresentation(thumbnail, 0.2)!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let result = formatter.string(from: date)
        let URL = try! URLRequest(url:Constant.UPLOAD_IMG_URL, method: .post, headers: nil)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "\(result).jpg", mimeType: "image/jpg")
        },
            with: URL ,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
                        completionHandler(response.response?.statusCode == 200 ,dataString as Any,nil)
                        }
                        .uploadProgress { progress in
                            HUD.show(.labeledProgress(title: "Loading", subtitle: "\(progress.fractionCompleted * 100)%" ))
                            print("Upload Progress: \(progress.fractionCompleted * 100)")
                    }
                    break
                case .failure(let encodingError):
                    completionHandler(false ,encodingError,encodingError.localizedDescription)
                    break
                }
        })
    }
    func checkEmailExist(email :String, completion :@escaping (_ onSucess :Bool, _ exist :Bool, _ user:User?) -> ()){
        Alamofire.request("\(Constant.CHECK_EMAIL_EXIST)\(email)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let message = json["message"] as? String
                    if message == "User not found."{
                        print("not foud")
                        completion(true , false,nil)
                    }
                    else{
//                        do {
//                            // Convert from JSON to nsdata
//                            let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
//                            print("services data \(data)")
//                            let decodedUser : User
//                            decodedUser = try JSONDecoder().decode(User.self, from: data)
                          completion(true,true,nil)
//                        } catch {
//                            print("parsing error")
//                        }
                        
                    }
                }
                break
                
            case .failure(_):
                completion(false , true, nil)
                break
                
            }
        }
    }
    
    
    
    
    ///
    func signIn(params :[String:String], completion :@escaping (_ onSucess :Bool, _ signed :Bool, _ user :UserSignIn?,_ vendor :Vendor?) -> ()){
        Alamofire.request(Constant.SIGN_IN, method: .get,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(Constant.SIGN_IN)
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    let message = json["message"] as? String
                    if message == "Authentication failed. User not found."{
                        completion(true , false,nil,nil)
                    }
                    else if json["userType"] as? Int == 1{
                        do {
                            // Convert from JSON to nsdata
                            let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                            print("services data \(data)")
                            let decodedUser : UserSignIn
                            decodedUser = try JSONDecoder().decode(UserSignIn.self, from: data)
                            completion(true,true,decodedUser,nil)
                        } catch {
                            print("parsing error")
                        }
                    }
                    else if json["userType"] as? Int == 2{
                        let vendorID = json["_id"] as? String
                        let ownername = json["ownerName"] as? String
                        Helper.saveInUserDefault(value: vendorID!, key: "clientId")
                        Helper.saveInUserDefault(value: ownername ?? "" , key: "userName")
                        completion(true,true,nil,nil)
                    }
                    else{
                    }
                }
                break
                
            case .failure(_):
                completion(false , true, nil,nil)
                break
                
            }
        }
    }
    ///
    func forgetPassword(email :String, completion :@escaping (_ onSucess :Bool, _ done :Bool) -> ()){
        Alamofire.request("\(Constant.FORGET_PASSWORD)\(email)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let message = json["message"] as? String
                    if message == "DONE"{
                        completion(true , true)
                    }
                        
                    else{
                        completion(true , false)
                    }
                }
                break
                
            case .failure(_):
                completion(false , false)
                break
                
            }
        }
    }
    ///
    // MARK:- getCategories
    func getAds(completion: @escaping (_ onSucess :Bool, _ ads :[Ads]?) -> ()){
        Alamofire.request(Constant.ADS_URL, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedAds : [Ads]
                        decodedAds = try JSONDecoder().decode([Ads].self, from: data)
                        completion(true , decodedAds)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    ///
    func getUserFavorite(userId :String, completion :@escaping (_ onSucess :Bool, _ favorites:[Favorite]?) -> ()){
        Alamofire.request("\(Constant.USER_FAVORITE)\(userId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [[String:Any]]{
                    
                    
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("favoritee data \(data)")
                        let decodedUserFav : [Favorite]?
                        decodedUserFav = try JSONDecoder().decode([Favorite].self, from: data)
                        completion(true,decodedUserFav)
                    } catch {
                        print("parsing error")
                    }
                }
                break
                
            case .failure(_):
                completion(false , nil)
                break
                
            }
        }
    }
    func getClientVendorById(clientId :String, completion :@escaping (_ onSucess :Bool, _ client:ClientTest?) -> ()){
        Alamofire.request("\(Constant.VENDOR_BY_ID)\(clientId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print("\(Constant.VENDOR_BY_ID)\(clientId)")
            switch(response.result) {
            case .success(_):
                if let json = JSON(response.result.value ?? [:]).dictionary{
                    let client = ClientTest()
                    client._id = json["id"]?.stringValue
                    client.updatedAt = json["updatedAt"]?.stringValue
                    client.website = json["website"]?.stringValue
                    client.createdAt = json["createdAt"]?.stringValue
                    client.brandName = json["brandName"]?.stringValue
                    client.ownerName = json["ownerName"]?.stringValue
                    client.VendorMobile = json["VendorMobile"]?.stringValue
                    client.workingDays = json["workingDays"]?.stringValue
                    client.description = json["description"]?.stringValue
                    client.workingHours = json["workingHours"]?.stringValue
                    client.VendorAddress = json["VendorAddress"]?.stringValue
                    client.ownerMobile = json["ownerMobile"]?.stringValue
                    client.email = json["email"]?.stringValue
                    client.OwnerEmail = json["OwnerEmail"]?.stringValue
                    client.password = json["password"]?.stringValue
                    client.workingDays = json["workingDays"]?.stringValue
                    client.description = json["description"]?.stringValue
                    if let countryID  = json["countryID"]?.dictionary{
                        if let _id = countryID["_id"]?.string {
                            client.countryID?._id = _id
                        }
                        if let titleAr = countryID["titleAr"]?.string {
                            client.countryTitleAr = titleAr
                            
                        }
                        if let titleEN = countryID["titleEN"]?.string {
                            client.countryTitleEn = titleEN
                        }
                        if let _id = countryID["_id"]?.string {
                            client.countryId = _id
                        }
                    }
                    if let cityID  = json["cityID"]?.dictionary{
                        if let _id = cityID["_id"]?.string {
                            client.cityId = _id
                        }
                        if let titleAr = cityID["titleAr"]?.string {
                            client.ccityTitleAr = titleAr
                        }
                        if let titleEN = cityID["titleEN"]?.string {
                            client.cityTitleEn = titleEN
                        }
                    }
                    if let categoryID  = json["categoryID"]?.dictionary{
                        if let _id = categoryID["_id"]?.string {
                            client.categoryID?._id = _id
                        }
                        if let titleAr = categoryID["titleAr"]?.string {
                            client.categoryID?.titleAr = titleAr
                        }
                        if let titleEN = categoryID["titleEN"]?.string {
                            client.categoryID?.titleEN = titleEN
                        }
                    }
                    //
                    client.logo = json["logo"]?.stringValue
                    client.cover = json["cover"]?.stringValue
                    client.__v = json["__v"]?.intValue
                    client.userKey = json["userKey"]?.stringValue
                    client.to = json["to"]?.intValue
                    client.from = json["from"]?.intValue
                    client.offDay = json["offDay"]?.intValue
                    if let totalRate = json["totalRate"]?.double {
                        client.totalRateD = totalRate
                    }
                    if let totalRate = json["totalRate"]?.int {
                        client.totalRateI = totalRate
                    }
                    client.userType = json["userType"]?.intValue
                    client.status = json["status"]?.intValue
                    completion(true , client)
                   
                }
            case .failure(_):
                completion(false , nil)
                break
                
            }
        }
    }
    
    func addFav(params:[String:Any], completion :@escaping (_ onSucess :Bool, _ liked:Bool) -> ()){
        Alamofire.request(Constant.ADD_FAV, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    completion(true,true)
                }
                break
                
            case .failure(_):
                completion(false , false)
                HUD.hide()
                break
                
            }
        }
    }
    func rateVendor(params:[String:Any], completion :@escaping (_ onSucess :Bool, _ rate:Int?) -> ()){
        Alamofire.request(Constant.RATE, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let rate = json["totalRate"] as? Int
                    completion(true , rate)
                }
                break
                
            case .failure(_):
                completion(false , nil)
                HUD.hide()
                break
                
            }
        }
    }
    //
    func deleteFav(clientId :String,userId :String, completion :@escaping (_ onSucess :Bool) -> ()){
        Alamofire.request("\(Constant.DELETE_FAV)\(userId)&clientID=\(clientId)", method: .get,encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let message = json["message"] as? String
                    if message == "deleted"{
                        completion(true )
                    }
                }
                break
                
            case .failure(_):
                completion(false )
                HUD.hide()
                break
            }
        }
    }
    //
    func getTotalClinetFav(clientID:String, completion :@escaping (_ onSucess :Bool, _ numFav:Int?) -> ()){
        Alamofire.request("\(Constant.TOTAL_CLIENT_FAV)\(clientID)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let numFav = json["message"] as? Int
                    completion(true , numFav)
                }
                break
                
            case .failure(_):
                completion(false , nil)
                HUD.hide()
                break
                
            }
        }
    }
    //
  
    // user call this func to get client services
    func getClientServies(clientId:String, completion :@escaping (_ onSucess :Bool, _ clients:[ServiceClient]?) -> ()){
        Alamofire.request("\(Constant.CLIENT_SERVICES)\(clientId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [[String:Any]]{
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("clients data \(data)")
                        let decodedClients : [ServiceClient]?
                        
                        decodedClients = try JSONDecoder().decode([ServiceClient].self, from: data)
                        completion(true,decodedClients)
                        print("countt \(decodedClients?.count)")
                    } catch {
                        print("parsing error")
                        HUD.hide()
                    }
                }
                break
                
            case .failure(_):
                completion(false , nil)
                HUD.hide()
                break
                
            }
        }
    }
    //
    func postReservedService(params:[String:Any], completion :@escaping (_ onSucess :Bool) -> ()){
        Alamofire.request(Constant.RESERVE_SERVICE, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                let statusCode = response.response?.statusCode
                print("statusCode \(statusCode)")
                 print("jjson \(response.result.value)")
                if statusCode == 200{
                    completion(true)
                }
                else{
                    completion(false)
                }
                break
                
            case .failure(_):
                completion(false)
                HUD.hide()
                break
                
            }
        }
    }
    func ppostReservedService(params:[String:Any], completion :@escaping (_ onSucess :Bool) -> ()){
        Alamofire.request(Constant.RESERVE_SERVICE, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                let statusCode = response.response?.statusCode
                print("statusCode \(statusCode) jsonn \(response.result.value)")
                if statusCode == 200{
                    completion(true)
                }
                else{
                    completion(false)
                }
                break
                
            case .failure(_):
                completion(false)
                HUD.hide()
                break
                
            }
        }
    }
    // MARK:- getUSerProfile
    func getUSerProfile(userId :String,completion: @escaping (_ onSucess :Bool, _ ads :UserProfile?) -> ()){
        Alamofire.request("\(Constant.USER_PROFILE)\(userId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedAds :UserProfile
                        decodedAds = try JSONDecoder().decode(UserProfile.self, from: data)
                        completion(true , decodedAds)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    // MARK:- updateProfile
    func updateProfile(params: [String:String],userId :String,completion: @escaping (_ onSucess :Bool, _ ads :updateUser?) -> ()){
        Alamofire.request("\(Constant.UPDATE_USER_INFO)\(userId)", method: .put,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedAds :updateUser
                        decodedAds = try JSONDecoder().decode(updateUser.self, from: data)
                        completion(true , decodedAds)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //
    func updateClient(params: [String:Any],clientId :String,completion: @escaping (_ onSucess :Bool, _ ads :updateUser?) -> ()){
        Alamofire.request("\(Constant.UPDATE_CLIENT)\(clientId)", method: .put,parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                
                print("res \(response)")
                completion(true , nil)
//                if let json = response.result.value as? [String:Any]{
//                    print(json)
//                    do {
//                        // Convert from JSON to nsdata
//                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
//                        print("categires data \(data)")
//                        let decodedAds :updateUser
//                        decodedAds = try JSONDecoder().decode(updateUser.self, from: data)
//                        completion(true , decodedAds)
//                    } catch {
//                        print("parsing error")
//                    }
//                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    // user notification
    func getUserNotification(userId :String,completion: @escaping (_ onSucess :Bool, _ ads :[userNotification]?) -> ()){
        Alamofire.request("\(Constant.USER_NOTIFICATION)\(userId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedNotification :[userNotification]
                        decodedNotification = try JSONDecoder().decode([userNotification].self, from: data)
                        completion(true , decodedNotification)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    // user chat list
    func getUserChatList(userId :String,completion: @escaping (_ onSucess :Bool, _ chatList :[ChatList]?) -> ()){
        Alamofire.request("\(Constant.USER_CHAT_LIST)\(userId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedChatList :[ChatList]
                        decodedChatList = try JSONDecoder().decode([ChatList].self, from: data)
                        completion(true , decodedChatList)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    ///
    func getUserHistoryChat(clientId :String,userId :String, completion : @escaping (_ onSucess :Bool, _ message :[message]?) -> ()){
        
        Alamofire.request("\(Constant.USER_HISTORY_CHAT)\(userId)&clientID=\(clientId)", method: .get,encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                 print("ressssss \(response.result.value)")
                 let json = JSON(value).arrayValue
                 var arrayOfmessages: [message] = []
                 for item in json {
                    let msg = message()
                    msg.from = item["from"].intValue
                    msg.msg = item["msg"].stringValue
                    if let chatID = item["chatID"].dictionary {
                        msg._id = chatID["_id"]?.stringValue
                    }
                  
                   arrayOfmessages.append(msg)
                    completion(true,arrayOfmessages)
                    
                 }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    /////
    func getClientHistoryChat(clientId :String,userId :String, completion : @escaping (_ onSucess :Bool, _ message :[message]?) -> ()){
        
        Alamofire.request("\(Constant.USER_HISTORY_CHAT)\(userId)&clientID=\(clientId)", method: .get,encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                print("ressssss \(response.result.value)")
                let json = JSON(value).arrayValue
                var arrayOfmessages: [message] = []
                for item in json {
                    let msg = message()
                    msg.from = item["from"].intValue
                    msg.msg = item["msg"].stringValue
                    if let chatID = item["chatID"].dictionary {
                        msg._id = chatID["_id"]?.stringValue
                    }
                    
                    arrayOfmessages.append(msg)
                    completion(true,arrayOfmessages)
                    
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    func createChatChannel(params:[String:Any], completion :@escaping (_ onSucess :Bool, _ rate:String?) -> ()){
        Alamofire.request(Constant.CRATE_CHAT__CHANNEL, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    let chatId = json["_id"] as? String
                    completion(true , chatId)
                }
                break
                
            case .failure(_):
                completion(false , nil)
                HUD.hide()
                break
                
            }
        }
    }
    ///
    func contactUs(params:[String:Any], completion :@escaping (_ onSucess :Bool) -> ()){
        Alamofire.request(Constant.CONTACT_US, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    completion(true)
                }
                break
                
            case .failure(_):
                completion(false)
                HUD.hide()
                break
                
            }
        }
    }
    // get setting
    func getSetting(completion: @escaping (_ onSucess :Bool, _ setting :[Setting]?) -> ()){
        Alamofire.request(Constant.SETTING, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedSetting :[Setting]
                        decodedSetting = try JSONDecoder().decode([Setting].self, from: data)
                        completion(true , decodedSetting)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    func getAbout(type: String ,completion: @escaping (_ onSucess :Bool, _ setting :[About]?) -> ()){
        Alamofire.request("\(Constant.ABOUT)\(type)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedSetting :[About]
                        decodedSetting = try JSONDecoder().decode([About].self, from: data)
                        completion(true , decodedSetting)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    func getTerms(type: String ,completion: @escaping (_ onSucess :Bool, _ setting :[About]?) -> ()){
        Alamofire.request("\(Constant.ABOUT)\(type)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedSetting :[About]
                        decodedSetting = try JSONDecoder().decode([About].self, from: data)
                        completion(true , decodedSetting)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    func getAboutVideo(type: String ,completion: @escaping (_ onSucess :Bool, _ setting :[AboutVedio]?) -> ()){
        Alamofire.request(Constant.ABOUT_VIDEO, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                print("res \(response)")
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        print("categires data \(data)")
                        let decodedSetting :[AboutVedio]
                        decodedSetting = try JSONDecoder().decode([AboutVedio].self, from: data)
                        completion(true , decodedSetting)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //
    func getClients(completion: @escaping (_ onSucess :Bool, _ setting :[Clientt]?) -> ()){
        Alamofire.request(Constant.CLIENTS, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let JSON = response.result.value as? [[String:Any]]{
                    print("myDic \(JSON)")
                    var decodedVendorClient :[Clientt] = []
                    for dic in JSON{
                        let client = Clientt.init(with: dic)
                        decodedVendorClient.append(client)
                        print("print \(decodedVendorClient)")
                    }
                completion(true , decodedVendorClient)
 
                }
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    ///
    func getUserOrders(userId :String ,completion: @escaping (_ onSucess :Bool, _ setting :[UserOrder]?) -> ()){
        Alamofire.request("\(Constant.USER_ORDERS)\(userId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                 let json = JSON(value).arrayValue
                print("res \(response)")

                    var arrayOrders: [UserOrder] = []
                    for item in json {
                        let order = UserOrder()
                        order._id = item["_id"].stringValue
                        order.__v = item["__v"].intValue
                        order.dateTime = item["dateTime"].stringValue
                        order.status = item["status"].intValue
                        order.userID = item["userID"].stringValue
                        if let clientID  = item["clientID"].dictionary{
                            if let _id = clientID["_id"]?.string {
                                order.clientId = _id
                            }
                            if let brandName = clientID["brandName"]?.string {
                                order.brandName = brandName
                            }
                            if let logo = clientID["logo"]?.string {
                                order.logo = logo
                            }
                        }
                        arrayOrders.append(order)
                    }
                 completion(true,arrayOrders)
                
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //
    func postVendorSignUp(params:[String:Any], completion :@escaping (_ onSucess :Bool) -> ()){
        Alamofire.request(Constant.CLIENT_SIGN_UP, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                let statusCode = response.response?.statusCode
                print("resss \(response.result.value)")
                if statusCode == 200{
                    completion(true)
                }
                else{
                    completion(false)
                }
                break
                
            case .failure(_):
                completion(false)
                HUD.hide()
                break
                
            }
        }
    }
    // get venndor chat list
    func getVendorChatList(clientId :String ,completion: @escaping (_ onSucess :Bool, _ setting :[VendorChatItem]?) -> ()){
        Alamofire.request("\(Constant.CLIENT_CHAT_LIST)\(clientId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                let json = JSON(value).arrayValue
                    var arrayOfCatItems: [VendorChatItem] = []
                    for item in json {
                        let chatItem = VendorChatItem()
                        chatItem._id = item["_id"].stringValue
                        chatItem.__v = item["__v"].intValue
                        chatItem.clientID = item["clientID"].stringValue
                        if let userID  = item["userID"].dictionary{
                            if let _id = userID["_id"]?.string {
                                chatItem.userId = _id
                            }
                            if let firstName = userID["firstName"]?.string {
                                chatItem.firstName = firstName
                            }
                            if let personalImg = userID["personalImg"]?.string {
                                chatItem.personalImg = personalImg
                            }
                        }
                        arrayOfCatItems.append(chatItem)
                    }
                completion(true,arrayOfCatItems)
           
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    // GET VENDOR NOTIFICATION
    func allVendorNotifications(id :String ,completion: @escaping (_ status: [Notifications]) -> ())
    {
        Alamofire.request("\(Constant.VENDOR_NOTIFICATION)\(id)", method: .get ,  encoding: URLEncoding.default).responseJSON { response in
            print("\(Constant.VENDOR_NOTIFICATION)\(id)")
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->NOTIFICATION",json)
                var vendorNOT: [Notifications] = []
                for x in json {
                    let notify = Notifications()
                    notify.text = x["msg"].stringValue
                    notify.date = x["createdAt"].stringValue
                    if let userID  = x["userID"].dictionary{
                        if let username = userID["firstName"]?.string {  notify.title = username
                        }
                        if let image = userID["personalImg"]?.string {  notify.logoPath = image
                        }
                    }
                    vendorNOT.append(notify)
                }
                completion(vendorNOT)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    //
    func getClientts(completion: @escaping (_ onSucess :Bool, _ setting :[VendorClientt]?) -> ()){
        Alamofire.request(Constant.CLIENTS, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(let value):
                
                    let json = JSON(response.result.value).arrayValue
                    print("myDic \(json)")
                    var decodedVendorClient :[VendorClientt] = []
                    for client in json {
                        let notify = VendorClientt()
                        
                        
                        notify._id = client["_id"].stringValue
                        notify.updatedAt = client["updatedAt"].stringValue
                        notify.createdAt = client["createdAt"].stringValue
                        notify.brandName = client["brandName"].stringValue
                        notify.ownerName = client["ownerName"].stringValue
                        notify.VendorMobile = client["VendorMobile"].stringValue
                        notify.workingDays = client["workingDays"].stringValue
                        notify.description = client["description"].stringValue
                        notify.workingHours = client["workingHours"].stringValue
                        notify.VendorAddress = client["VendorAddress"].stringValue
                        notify.website = client["website"].stringValue
                        notify.ownerMobile = client["ownerMobile"].stringValue
                        notify.email = client["email"].stringValue
                        notify.OwnerEmail = client["OwnerEmail"].stringValue
                        notify.password = client["password"].stringValue
                        notify.countryID = client["countryID"].stringValue
                        notify.categoryID = client["categoryID"].stringValue
                        notify.cityID = client["cityID"].stringValue
                        
                        notify.logo = client["logo"].stringValue
                        notify.cover = client["cover"].stringValue
                        notify.__v = client["__v"].intValue
                        notify.userKey = client["userKey"].stringValue
                        notify.to = client["to"].intValue
                        notify.from = client["from"].intValue
                        notify.offDay = client["offDay"].intValue
                        notify.userType = client["userType"].intValue
                        notify.status = client["status"].intValue
                        
                        notify.totalRate = client["totalRate"].doubleValue
                        
                        decodedVendorClient.append(notify)
                    completion(true , decodedVendorClient)
                    
                }
                
                break
            case .failure(_):
                completion(false,nil)
                break
            }
        }
    }
    //
    func getClientByCateogryID(categoryId:String, completion :@escaping (_ onSucess :Bool, _ clients:[VendorClientt]?) -> ()){
        Alamofire.request("\(Constant.CLIENT_BY_CATEGORY_ID)\(categoryId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                let json = JSON(response.result.value).arrayValue
                print("myDic \(json)")
                var decodedVendorClient :[VendorClientt] = []
                for client in json {
                    let notify = VendorClientt()
                    

                    notify._id = client["_id"].stringValue
                    notify.updatedAt = client["updatedAt"].stringValue
                    notify.createdAt = client["createdAt"].stringValue
                    notify.brandName = client["brandName"].stringValue
                    notify.ownerName = client["ownerName"].stringValue
                    notify.VendorMobile = client["VendorMobile"].stringValue
                    notify.workingDays = client["workingDays"].stringValue
                    notify.description = client["description"].stringValue
                    notify.workingHours = client["workingHours"].stringValue
                    notify.VendorAddress = client["VendorAddress"].stringValue
                    notify.website = client["website"].stringValue
                    notify.ownerMobile = client["ownerMobile"].stringValue
                    notify.email = client["email"].stringValue
                    notify.OwnerEmail = client["OwnerEmail"].stringValue
                    notify.password = client["password"].stringValue
                    notify.countryID = client["countryID"].stringValue
                    notify.categoryID = client["categoryID"].stringValue
                    notify.cityID = client["cityID"].stringValue
                    
                    notify.logo = client["logo"].stringValue
                    notify.cover = client["cover"].stringValue
                    notify.__v = client["__v"].intValue
                    notify.userKey = client["userKey"].stringValue
                    notify.to = client["to"].intValue
                    notify.from = client["from"].intValue
                    notify.offDay = client["offDay"].intValue
                    notify.userType = client["userType"].intValue
                    notify.status = client["status"].intValue
                    
                    notify.totalRate = client["totalRate"].doubleValue
                    
                    decodedVendorClient.append(notify)
                    completion(true , decodedVendorClient)
                }
                
                     break
                
            case .failure(_):
                completion(false , nil)
                HUD.hide()
                break
                
            }
        }
    }
    /////
    func getVendorOrders(clientId :String ,completion: @escaping (_ onSucess :Bool, _ setting :[VenodrOrder]?) -> ()){
        Alamofire.request("\(Constant.VENDOR_ORDERS)\(clientId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                print("-->NOTIFICATION",json)
                var vendorOrders: [VenodrOrder] = []
                for item in json {
                    let order = VenodrOrder()
                    order._id = item["_id"].stringValue
                    order.dateTime = item["dateTime"].stringValue
                    order.updatedAt = item["updatedAt"].stringValue
                    order.createdAt = item["createdAt"].stringValue
                     order.clientID = item["clientID"].stringValue
                    if let userID  = item["userID"].dictionary{
                        print("userID \(userID)")
                        if let firstName = userID["firstName"]?.string {
                            
                            order.firstname = firstName
                            print("firstName \(firstName)")

                        }
                        if let image = userID["personalImg"]?.string {  order.userID?.personalImg = image
                            order.img = image
                        }
                        if let _id = userID["_id"]?.string {
                            order.userId = _id
                        }
                    }
                    vendorOrders.append(order)
                }
                completion(true ,vendorOrders)
            case .failure(let error):
                print(error)
                completion(false , nil)
            }
        }
    }
    //
    /////
    func getOrderDetail(bookingId :String ,completion: @escaping (_ onSucess :Bool, _ setting :[ServiceLangg]?,OrderUpdate?) -> ()){
        Alamofire.request("\(Constant.ORDER_DETAIL)\(bookingId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).arrayValue
                var serivces: [ServiceLangg] = []
                print("jsonn \(json)")
                let order = OrderUpdate()
                for item in json {
                    if let servicesID  = item["servicesID"].dictionary{
                         let employeeID  = item["employeeID"].dictionary
                        
                        let serivceLang = ServiceLangg(ar: servicesID["titleAr"]?.stringValue ?? "", en: servicesID["titleEN"]?.stringValue ?? "", id: servicesID["_id"]?.stringValue ?? "testId", price: item["price"].intValue, empID: employeeID?["_id"]?.stringValue ?? "", empName: employeeID!["fullname"]?.stringValue ?? "")
                        serivces.append(serivceLang)
                    }
                    if let bookingID  = item["bookingID"].dictionary{
                        order.date = bookingID["dateTime"]?.stringValue
                        if let clientID = bookingID["clientID"]?.dictionary{
                            order.img = clientID["logo"]?.stringValue
                            order.brandName = clientID["brandName"]?.stringValue
                            order.clientId = clientID["_id"]?.stringValue
                        }
                    }
                    if let userID  = item["userID"].dictionary{
                        order.img = userID["personalImg"]?.stringValue
                    }
                }
                completion(true ,serivces, order)
            case .failure(let error):
                print(error)
                completion(false , nil,nil)
            }
        }
    }
    //
    func GetServicesById(clientId :String ,completion: @escaping (_ onSucess :Bool, _ setting :[ServiceClient]?) -> ()){
        Alamofire.request("\(Constant.GET_SERVICES_BY_ID)\(clientId)", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let json = response.result.value as? [[String:Any]]{
                    print(json)
                    do {
                        // Convert from JSON to nsdata
                        let data = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let decodedServicesList :[ServiceClient]
                        decodedServicesList = try JSONDecoder().decode([ServiceClient].self, from: data)
                        completion(true , decodedServicesList)
                    } catch {
                        print("parsing error")
                    }
                }
                break
            case .failure(let error):
                print(error)
                completion(false , nil)
            }
        }
    }
    /////
    func cancelOrder(id :String ,bookingId :String,orderType:String,completion: @escaping (_ onSucess :Bool) -> ()){
        var url :String?
        if orderType == "user"{
url = "\(Constant.CANCEL_ORDER)userCancelBooking?id=\(bookingId)&userID=\(id)"
        }
        else if orderType == "vendor"{
url = "\(Constant.CANCEL_ORDER)clientCancelBooking?id=\(bookingId)&clientID=\(id)"
            
        }
        
        Alamofire.request(url ?? "", method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completion(true )
            case .failure(let error):
                print(error)
                completion(false )
            }
        }
    }
    func updateReservedService(type:String,params:[String:Any], completion :@escaping (_ onSucess :Bool) -> ()){
       
        Alamofire.request("\(Constant.UPDATE_ORDER)\(type)", method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                let statusCode = response.response?.statusCode
                print("statusCode \(statusCode)")
                if statusCode == 200{
                    completion(true)
                }
                else{
                    completion(false)
                }
                break
                
            case .failure(_):
                completion(false)
                HUD.hide()
                break
                
            }
        }
    }
//
    func createAds(params:[String:Any], completion :@escaping (_ onSucess :Bool, _ liked:Bool) -> ()){
        Alamofire.request(Constant.CREATE_ADS, method: .post,parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let json = response.result.value as? [String:Any]{
                    print(json)
                    completion(true,true)
                }
                break
                
            case .failure(_):
                completion(false , false)
                HUD.hide()
                break
                
            }
        }
    }
    //

    // End of the class
}
