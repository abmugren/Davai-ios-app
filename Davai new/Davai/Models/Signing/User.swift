//
//  User.swift
//  Davai
//
//  Created by Apple on 3/31/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
// user check email
class User: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var firstName :String
    var lastName :String
    var mobile :Int?
    var email :String
    var __v :Int?
    
    var countryID :countryID?
    var cityID :cityID?
    var userKey :String?
    var userType :Int?
    var gender :Int?
    var status :Int?
    enum CodingKeys: String, CodingKey{
        case _id,updatedAt,createdAt,firstName,lastName,mobile,email,__v,countryID,cityID,userKey,userType,gender,status
    }
    init( email:String , firstName :String , lastName : String) {
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        
    }
}

class countryID :Codable {
    var _id :String
    var titleAr :String
    var titleEN :String
    enum CodingKeys: String, CodingKey{
        case _id,titleAr,titleEN
    }
}

class cityID :Codable{
    var _id :String
    var titleAr :String
    var titleEN :String
    enum CodingKeys: String, CodingKey{
        case _id,titleAr,titleEN
    }
}
class categoryID :Codable{
    var _id :String
    var titleAr :String
    var titleEN :String
    enum CodingKeys: String, CodingKey{
        case _id,titleAr,titleEN
    }
}
// user sign in
class UserSignIn: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var firstName :String
    var lastName :String
    var mobile :String?
    var email :String
    var password :String?
    
    var countryID :String?
    var cityID :String?
    var __v :Int?
    var userKey :String?
    var userType :Int?
    var gender :Int?
    var status :Int?
    enum CodingKeys: String, CodingKey{
        case _id,updatedAt,createdAt,firstName,lastName,mobile,email,__v,password,countryID,cityID,userKey,userType,gender,status
    }
    init( email:String , firstName :String , lastName : String) {
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        
    }
}
class Vendor: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var email :String
    var password :String?
    
    var brandName :String
    var ownerName :String
    var VendorMobile :String?
    var workingDays :String
    var description :String?
    var workingHours :String
    var VendorAddress :String?
    var website :String
    var ownerMobile :String?
    var OwnerEmail :String
    var countryID :String
    var categoryID :String?
    var cityID :String
    var logo :String?
    var cover :String
    var __v :Int?
    var userKey :String?
    var userType :Int?
    var status :Int?
    enum CodingKeys: String, CodingKey{
        case _id,updatedAt,createdAt,brandName,ownerName,VendorMobile,email,__v,password,countryID,cityID,userKey,userType,status,workingDays,description,workingHours,VendorAddress,website,ownerMobile,OwnerEmail,logo,cover,categoryID
    }
}
///
class ClientTest{
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var brandName :String?
    var ownerName :String?
    var VendorMobile :String?
    var workingDays :String?
    var description :String?
    var workingHours :String?
    var VendorAddress :String?
    var website :String?
    var ownerMobile :String?
    var email :String?
    var OwnerEmail :String?
    var password :String?
    var countryID :countryID?
    var categoryID :categoryID?
    var cityID :cityID?
    var logo :String?
    var cover :String?
    var __v :Int?
    var userKey :String?
    var to :Int?
    var from :Int?
    var offDay :Int?
    var totalRateD :Double?
    var totalRateI :Int?
    var userType :Int?
    var status :Int?
    var countryId :String?
    var countryTitleAr :String?
    var countryTitleEn :String?
    var cityId :String?
    var ccityTitleAr :String?
    var cityTitleEn :String?
    
}
///
class Client: Codable {
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var brandName :String?
    var ownerName :String?
    var VendorMobile :String?
    var workingDays :String?
    var description :String?
    var workingHours :String?
    var VendorAddress :String?
    var website :String?
    var ownerMobile :String?
    var email :String?
    var OwnerEmail :String?
    var password :String?
    var ccountryID :countryID?
    var ccategoryID :categoryID?
    var ccityID :cityID?
    var logo :String?
    var cover :String?
    var __v :Int?
     var userKey :String?
    var to :Int?
    var from :Int?
    var offDay :Int?
    var totalRate :Double?
    var userType :Int?
    var status :Int?

    enum CodingKeys: String, CodingKey{
        case ccountryID = "countryID"
        case ccategoryID = "categoryID"
        case ccityID = "cityID"
        case _id,updatedAt,createdAt,brandName,ownerName,VendorMobile,workingDays,description,workingHours,VendorAddress,website,ownerMobile,email,OwnerEmail,password,logo,cover,__v,userKey,to,from,offDay,totalRate,userType,status
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self._id = try container.decode(String.self, forKey: ._id)
            self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
            self.createdAt = try container.decode(String.self, forKey: .createdAt)
            self.brandName = try container.decode(String.self, forKey: .brandName)
            self.ownerName = try container.decode(String.self, forKey: .ownerName)
            self.VendorMobile = try container.decode(String.self, forKey: .VendorMobile)
            self.workingDays = try container.decode(String.self, forKey: .workingDays)
            self.description = try container.decode(String.self, forKey: .description)
            //
            self.workingHours = try container.decode(String.self, forKey: .workingHours)
            self.VendorAddress = try container.decode(String.self, forKey: .VendorAddress)
            self.website = try container.decode(String.self, forKey: .website)
            self.ownerMobile = try container.decode(String.self, forKey: .ownerMobile)
            self.email = try container.decode(String.self, forKey: .email)
            self.OwnerEmail = try container.decode(String.self, forKey: .OwnerEmail)
            self.password = try container.decode(String.self, forKey: .password)
            self.logo = try container.decode(String.self, forKey: .logo)
            //
            self.cover = try container.decode(String.self, forKey: .cover)
            self.userKey = try container.decode(String.self, forKey: .userKey)
            self.ccountryID = try container.decode(countryID.self, forKey: .ccountryID)
            self.ccategoryID = try container.decode(categoryID.self, forKey: .ccategoryID)
            self.ccityID = try container.decode(cityID.self, forKey: .ccityID)
            self.__v = try container.decode(Int.self, forKey: .__v)
            self.to = try container.decode(Int.self, forKey: .to)
            self.from = try container.decode(Int.self, forKey: .from)
            self.offDay = try container.decode(Int.self, forKey: .offDay)
            self.userType = try container.decode(Int.self, forKey: .userType)
            self.status = try container.decode(Int.self, forKey: .status)
            self.totalRate = try container.decode(Double.self, forKey: .totalRate)
        } catch DecodingError.typeMismatch {
            let value = try container.decode(Int.self, forKey: .totalRate)
            self.totalRate = Double(value)
        }
    }
}

class Clientt :Codable{
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var brandName :String?
    var ownerName :String?
    var VendorMobile :String?
    var workingDays :String?
    var description :String?
    var workingHours :String?
    var VendorAddress :String?
    var website :String?
    var ownerMobile :String?
    var email :String?
    var OwnerEmail :String?
    var password :String?
    var countryID :String?
    var categoryID :String?
    var cityID :String?
    var logo :String?
    var cover :String?
    var __v :Int?
    var userKey :String?
//    var to :Int?
//    var from :Int?
//    var offDay :Int?
    var totalRate :Int?
    var userType :Int?
    var status :Int?
    
    init(_id: String, updatedAt: String, createdAt: String, brandName: String,ownerName: String, VendorMobile: String, workingDays: String, description: String, workingHours: String, VendorAddress: String, website: String,ownerMobile: String, password: String, OwnerEmail: String, countryID: String, email: String,categoryID: String, cityID: String, logo: String, cover: String, userKey: String, __v: Int, userType: Int, status: Int,totalRate :Int) {
        self._id = _id
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.brandName = brandName
        self.ownerName = ownerName
        self.VendorMobile = VendorMobile
        self.workingDays = workingDays
        self.description = description
        self.workingHours = workingHours
        self.VendorAddress = VendorAddress
        self.website = website
        self.ownerMobile = ownerMobile
        self.OwnerEmail = OwnerEmail
        self.countryID = countryID
        self.password = password
        self.email = email
        self.categoryID = categoryID
        self.cityID = cityID
        self.logo = logo
        self.cover = cover
        self.userKey = userKey
        self.__v = __v
//        self.to = to
//        self.from = from
//        self.offDay = offDay
        self.userType = userType
        self.status = status
        self.totalRate = totalRate
    }
    convenience init(with json: [String: Any]) {
        let _id = json["_id"] as? String ?? ""
        let updatedAt = json["updatedAt"] as? String ?? ""
        let createdAt = json["createdAt"] as? String ?? ""
        let brandName = json["brandName"] as? String ?? ""
        let ownerName = json["ownerName"] as? String ?? ""
        let VendorMobile = json["VendorMobile"] as? String ?? ""
        let workingDays = json["workingDays"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let workingHours = json["workingHours"] as? String ?? ""
        let VendorAddress = json["VendorAddress"] as? String ?? ""
        let website = json["website"] as? String ?? ""
        let ownerMobile = json["ownerMobile"] as? String ?? ""
        let OwnerEmail = json["OwnerEmail"] as? String ?? ""
        let countryID = json["countryID"] as? String ?? ""
        let password = json["password"] as? String ?? ""
        let email = json["email"] as? String ?? ""
        let categoryID = json["categoryID"] as? String ?? ""
        let cityID = json["cityID"] as? String ?? ""
        let logo = json["logo"] as? String ?? ""
        let cover = json["cover"] as? String ?? ""
        let userKey = json["userKey"] as? String ?? ""
        let __v = json["__v"] as? Int ?? 0
//        let to = json["to"] as? Int ?? 0
//        let from = json["from"] as? Int ?? 0
//        let offDay = json["offDay"] as? Int ?? 0
        let userType = json["userType"] as? Int ?? 0
        let status = json["status"] as? Int ?? 0
        let totalRate = json["totalRate"] as? Int ?? 0
        self.init(_id: _id, updatedAt: updatedAt, createdAt: createdAt, brandName: brandName, ownerName: ownerName, VendorMobile: VendorMobile, workingDays: workingDays, description: description, workingHours: workingHours, VendorAddress: VendorAddress, website: website, ownerMobile: ownerMobile, password: password, OwnerEmail: OwnerEmail, countryID: countryID, email: email, categoryID: categoryID, cityID: cityID, logo: logo, cover: cover, userKey: userKey, __v: __v, userType: userType, status: status, totalRate: totalRate)
    }
    
}


    class VendorClient :Codable {
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var brandName :String?
    var ownerName :String?
    var VendorMobile :String?
    var workingDays :String?
    var description :String?
    var workingHours :String?
    var VendorAddress :String?
    var website :String?
    var ownerMobile :String?
    var email :String?
    var OwnerEmail :String?
    var password :String?
    var countryID :String?
    var categoryID :String?
    var cityID :String?
    var logo :String?
    var cover :String?
    var __v :Int?
    var userKey :String?
    var to :Int?
    var from :Int?
    var offDay :Int?
    var totalRate :Double?
    var userType :Int?
    var status :Int?
    
}
//

class VendorClientt {
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var brandName :String?
    var ownerName :String?
    var VendorMobile :String?
    var workingDays :String?
    var description :String?
    var workingHours :String?
    var VendorAddress :String?
    var website :String?
    var ownerMobile :String?
    var email :String?
    var OwnerEmail :String?
    var password :String?
    var countryID :String?
    var categoryID :String?
    var cityID :String?
    var logo :String?
    var cover :String?
    var __v :Int?
    var userKey :String?
    var to :Int?
    var from :Int?
    var offDay :Int?
    var totalRate :Double?
    var userType :Int?
    var status :Int?
    
}
class UserProfile :Codable{
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var cityID :cityID
    var countryID :countryID
    var email :String?
    var firstName :String
    var lastName :String?
    var mobile :String
    var password :String?
    var __v :Int?
    var userKey :String
    var personalImg :String?
    var userType :Int?
    var gender :Int?
    var status :Int
}
//
class updateUser: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var firstName :String
    var lastName :String
    var mobile :String?
    var email :String
    var __v :Int?
    
    var countryID :String?
    var cityID :String?
    var userKey :String?
    var userType :Int?
    var gender :Int?
    var status :Int?
  
}
