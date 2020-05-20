//
//  Service.swift
//  Davai
//
//  Created by Apple on 3/26/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class Service: Codable {
    
    var serviceID :String
    var updatedAt :String
    var createdAt :String
    var titleAr :String
    var titleEN :String
    var categoryID :String
    var __v :Int
    var status :Int
    
    enum CodingKeys: String, CodingKey{
        case serviceID = "_id"
        case updatedAt,createdAt,titleAr,titleEN,categoryID,__v,status
    }
}
