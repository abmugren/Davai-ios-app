//
//  Favorite.swift
//  Davai
//
//  Created by Apple on 4/6/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class Favorite: Codable {
    
    var _id :String
    var updatedAt :String
    var createdAt :String
    var clientID :clientID
    
    var __v :Int
    var userID :String
    var status :Int
}
//
class clientID: Codable {
    
    var _id :String?
    var brandName :String?
    var logo :String?
    var cover :String?
    var totalRate :Double?
 
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self._id = try container.decode(String.self, forKey: ._id)
            self.brandName = try container.decode(String.self, forKey: .brandName)
            self.logo = try container.decode(String.self, forKey: .logo)
            self.cover = try container.decode(String.self, forKey: .cover)
            self.totalRate = try container.decode(Double.self, forKey: .totalRate)
        } catch DecodingError.typeMismatch {
            let value = try container.decode(Int.self, forKey: .totalRate)
            self.totalRate = Double(value)
        }
    }
}
