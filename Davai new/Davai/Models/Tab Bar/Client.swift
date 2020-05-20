////
////  Client.swift
////  Davai
////
////  Created by Apple on 4/23/19.
////  Copyright © 2019 Moataz Mamdouh. All rights reserved.
////
//
//import Foundation
//class Client {
//    var _id :String?
//    var updatedAt :String?
//    var createdAt :String?
//    var brandName :String?
//    var ownerName :Double?
//    var VendorMobile :String?
//    var workingDays :String?
//    var description :String?
//    var workingHours :String?
//    var VendorAddress :Double?
//
//    var _id :String?
//    var updatedAt :String?
//    var createdAt :String?
//    var brandName :String?
//    var ownerName :Double?
//    var VendorMobile :String?
//    var workingDays :String?
//    var description :String?
//    var workingHours :String?
//    var VendorAddress :Double?
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            self._id = try container.decode(String.self, forKey: ._id)
//            self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
//            self.createdAt = try container.decode(String.self, forKey: .createdAt)
//            self.brandName = try container.decode(String.self, forKey: .brandName)
//            self.ownerName = try container.decode(Double.self, forKey: .ownerName)
//            self.VendorMobile = try container.decode(String.self, forKey: .VendorMobile)
//            self.workingDays = try container.decode(String.self, forKey: .workingDays)
//            self.description = try container.decode(String.self, forKey: .description)
//            self.workingHours = try container.decode(String.self, forKey: .workingHours)
//            self.VendorAddress = try container.decode(Double.self, forKey: .VendorAddress)
//
//            self._id = try container.decode(String.self, forKey: ._id)
//            self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
//            self.createdAt = try container.decode(String.self, forKey: .createdAt)
//            self.brandName = try container.decode(String.self, forKey: .brandName)
//            self.ownerName = try container.decode(Double.self, forKey: .ownerName)
//            self.VendorMobile = try container.decode(String.self, forKey: .VendorMobile)
//            self.workingDays = try container.decode(String.self, forKey: .workingDays)
//            self.description = try container.decode(String.self, forKey: .description)
//            self.workingHours = try container.decode(String.self, forKey: .workingHours)
//            self.VendorAddress = try container.decode(Double.self, forKey: .VendorAddress)
//
//
//        } catch DecodingError.typeMismatch {
//            let value = try container.decode(Int.self, forKey: .totalRate)
//            self.totalRate = Double(value)
//        }
//    }
//}
