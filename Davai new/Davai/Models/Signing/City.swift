//
//  City.swift
//  Davai
//
//  Created by Apple on 3/25/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class City: Codable {
    
    var cityID :String
    var updatedAt :String
    var createdAt :String
    var titleAr :String
    var titleEN :String
    var countryID :String
    var status :Int
    
    enum CodingKeys: String, CodingKey{
        case cityID = "_id"
        case updatedAt,createdAt,titleAr,titleEN,countryID,status
    }
}
