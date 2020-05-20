//
//  OrderDetail.swift
//  Davai
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
class OrderUpdate {
    var date :String?
    var img :String?
    var brandName :String?
    var clientId :String?
}
//
class ServiceLang {
    var ar :String?
    var en :String?
    var id :String?
    var price :Int?
    var empName :String?
    var empID :String?
    var emps :[Emp]?
    init(ar :String,en :String,id :String , price :Int){
        self.ar = ar
        self.en = en
        self.id = id
        self.price = price
//        self.empID = empID
//        self.empName = empName
    }
}
//
class ServiceLangg {
    var ar :String?
    var en :String?
    var id :String?
    var price :Int?
    var empName :String?
    var empID :String?
    var emps :[Emp]?
    init(ar :String,en :String,id :String , price :Int,empID:String,empName:String){
        self.ar = ar
        self.en = en
        self.id = id
        self.price = price
        self.empID = empID
        self.empName = empName
    }
}

