//
//  File.swift
//  Davai
//
//  Created by Apple on 4/8/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
import Foundation
class ServiceClient: Codable {
    
    var servicesID :String
    var servicesAr :String
    var servicesEN :String
    var brandName :String
    var logo :String
    var cover :String
    
    var employees :[Emp]
    var price :Int
}
class Emp: Codable {
    
    var fullname :String
    var id :String
}
//
class ReservedService {
    
    var servicesID :String?
    var employeeID :String?
    var price :String?
    init(servicesID :String,employeeID:String,price:String){
        self.price = price
        self.employeeID = employeeID
        self.servicesID = servicesID
    }
}
//
class VendorService {
    
    var servicesID :String?
    var emp :[String]?
    var price :Int?
    init(servicesID :String,emp:[String],price:Int){
        self.price = price
        self.emp = emp
        self.servicesID = servicesID
    }
}
