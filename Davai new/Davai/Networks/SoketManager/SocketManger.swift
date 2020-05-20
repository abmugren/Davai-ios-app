//
//  SocketManger.swift
//  Request
//
//  Created by Basem Elgendy on 11/20/17.
//  Copyright © 2017 basem. All rights reserved.
//

import Foundation
import Alamofire
import SocketIO
//import SwiftyJSON

class MySocket {
    
    static let instance = MySocket()
    let manager = SocketManager(socketURL: URL(string: "http://104.248.175.110")!)
    var socket:SocketIOClient
    init (){
        self.socket = self.manager.defaultSocket
    }
    func connect(){
         socket.connect()
    }
    func disconnect()  {
        socket.disconnect()
    }

    func joinRoom(){
        
        
        
    }
   
    
    
}
