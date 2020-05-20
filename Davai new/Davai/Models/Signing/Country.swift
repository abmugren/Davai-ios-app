//
//  Country.swift
//  Davai
//
//  Created by Apple on 3/25/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation

class Country: Codable {
    
    var countryID :String
    var updatedAt :String
    var createdAt :String
    var titleAr :String
    var titleEN :String
    var status :Int
    
    enum CodingKeys: String, CodingKey{
        case countryID = "_id"
        case updatedAt,createdAt,titleAr,titleEN,status
    }
}

