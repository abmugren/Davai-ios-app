//
//  File.swift
//  Davai
//
//  Created by Apple on 4/16/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class message {
    var _id :String?
    var from :Int?
    var msg :String?
}
class Message: Codable {
    var chatIdd :String
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var chatID :chatID
    var from :Int
    var msg :String?
    var __v :Int?
    
}
//
class chatID: Codable {
    
    var _id :String?
    var updatedAt :String?
    var createdAt :String?
    var clientID :clientId
    var userID :userID
    var __v :Int?
    
}
//
class clientId: Codable {
    
    var _id :String?
    var brandName :String?
}

