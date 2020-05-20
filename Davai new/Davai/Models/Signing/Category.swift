//
//  Category.swift
//  Davai
//
//  Created by Apple on 3/26/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class Category: Codable {
    
    var categID :String
    var updatedAt :String
    var createdAt :String
    var titleAr :String
    var titleEN :String
    var imgPath :String
    var v__ :Int
    var status :Int
    
    enum CodingKeys: String, CodingKey{
        case categID = "_id"
        case v__ = "__v"
        case updatedAt,createdAt,titleAr,titleEN,imgPath,status
    }
}

