//
//  Notification .swift
//  Davai
//
//  Created by Apple on 4/16/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class userNotification: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var msg :String
    var clientID :ClientID
    var userID :userID?
    var type :Int
    var __v :Int?
    var status :Int?
  
}

class ClientID :Codable {
    var _id :String
    var logo :String
    var brandName :String
}

class userID :Codable {
    var _id :String
    var firstName :String
    var lastName :String
    var password :String
    var personalImg :String
}
