//
//  SocketIOManagerExample.swift
//  Meetdoc
//
//  Created by HTS-SERVICETEAM on 04/03/19.
//  Copyright © 2019 BTMani. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

var Socket = SocketManager(socketURL: URL(string: socketurl)!, config: [.log(true), .compress])

protocol socketClassDelegate {
    func gotSocketInfo(dict: Array<Any>, type: String)
}
protocol socketClassDelegate1 {
    func gotSocketInfo1(dict: Array<Any>, type: String)
}

class SocketClass{
    static let sharedInstance = SocketClass()
    var delegate : socketClassDelegate?
    var delegate1 : socketClassDelegate1?
    
    var parameterData = String()
    var isConnected: Bool = false

//    func connect(_ id: String){
//        self.disconnect()
//        Socket.defaultSocket.connect()
//        if !isConnected {
//            Socket.defaultSocket.on(clientEvent: .connect) { data, ack in
//                print("Socket Connected Successfully")
//                print("data : \(data)")
//                self.isConnected = true
//                self.addHandler()
//                self.ping()
//                self.connectChat(messageID: id)
//            }
//        }
//
//    }
    func connect(){
        if !isConnected {
            Socket.defaultSocket.connect()
            Socket.defaultSocket.on(clientEvent: .connect) { data, ack in
                print("Socket Connected Successfully")
                print("data : \(data)")
                if !self.isConnected {
                    self.isConnected = true
                    self.addHandler()
                    self.ping()
                }
            }
        }
        
    }
    
    func disconnect(){
        if isConnected {
            self.offSocket()
            Socket.defaultSocket.disconnect()
            isConnected = false
        }
    }
    
    func offSocket(){
        Socket.defaultSocket.off("initiatecall")
        Socket.defaultSocket.off("acceptcall")
        Socket.defaultSocket.off("endcall")
        
        Socket.defaultSocket.off("message")
        Socket.defaultSocket.off("messageTyping")
        Socket.defaultSocket.off("pong")
    }
    
    func connectChat(messageID: String){
        let requestDict = NSMutableDictionary()
        requestDict.setValue(messageID, forKey: "joinId")
        Socket.defaultSocket.emit("join", requestDict)
    }
    
    func ping()  {
        Socket.defaultSocket.emit("ping","")
    }
    func initiatecall(requestDict:NSDictionary) {
        print("initiatecall \(requestDict)")
        Socket.defaultSocket.emit("initiatecall", requestDict)
    }

    func acceptcall(requestDict:NSDictionary) {
        print("acceptcall \(requestDict)")
        Socket.defaultSocket.emit("acceptcall", requestDict)
    }

    func endcall(requestDict:NSDictionary) {
        print("endcall \(requestDict)")
        Socket.defaultSocket.emit("endcall", requestDict)
    }

    func sendMsg(requestDict:NSDictionary) {
        print("SEND MSG \(requestDict)")
        Socket.defaultSocket.emit("message", requestDict)
    }
    
    func sendTypingStatus(requestDict:NSDictionary) {
        Socket.defaultSocket.emit("messageTyping", requestDict)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let requestVal = requestDict
            requestVal.setValue("untype", forKey: "message")
            self.stopTypingStatus(requestDict: requestVal)
        }
    }
    
    func stopTypingStatus(requestDict:NSDictionary) {
        print("MSG STOPED : \(requestDict)")
        Socket.defaultSocket.emit("messageTyping", requestDict)
    }
    // Response for receive, read message
    func addHandler() {
        Socket.defaultSocket.on("pong") { ( data, ack) -> Void in
            print("wwwwww")
            self.ping()
        }
        print("add Handler is worked")
        Socket.defaultSocket.on("messageTyping", callback: { (data, ack) -> Void in
            let chatData = data as Array
            self.delegate?.gotSocketInfo(dict: chatData, type: "messageTyping")
        })
        
        Socket.defaultSocket.on("message", callback: { (data, ack) -> Void in
            print("Hiiiiiiiiii")
            let chatData = data as Array
            self.delegate?.gotSocketInfo(dict: chatData, type: "message")
        })
        
        Socket.defaultSocket.on("initiatecall", callback: { (data, ack) -> Void in
            print("receivecall")
            let chatData = data as Array
            self.delegate1?.gotSocketInfo1(dict: chatData, type: "initiatecall")
        })
        Socket.defaultSocket.on("acceptcall", callback: { (data, ack) -> Void in
            print("acceptcall")
            let chatData = data as Array
            self.delegate1?.gotSocketInfo1(dict: chatData, type: "acceptcall")
        })
        Socket.defaultSocket.on("endcall", callback: { (data, ack) -> Void in
            print("endcall")
            let chatData = data as Array
            self.delegate1?.gotSocketInfo1(dict: chatData, type: "endcall")
        })

    }
}
