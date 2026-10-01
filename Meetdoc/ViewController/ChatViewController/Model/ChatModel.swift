//
//  ChatModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatModel {

    var listId : Int!
    var orderId : Int!
    var orderStatus : String!
    var payment_status : String!
    var result : [ChatResultModel]!
    var status : Bool!
    var type : String!
    var userId : Int!
    var userName : String!
    var block_id: String!
    var booked_date : String!
    var booked_time: String!
    var hidechat: Bool!
    var doctor_id: String!
    var slot_time: String!
    var slot_Endtime: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        listId = json["list_id"].intValue
        orderId = json["order_id"].intValue
        orderStatus = json["order_status"].stringValue
        result = [ChatResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = ChatResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
        type = json["type"].stringValue
        userId = json["user_id"].intValue
        block_id = json["block_id"].stringValue
        userName = json["user_name"].stringValue
        booked_date = json["booked_date"].stringValue
        booked_time = json["booked_time"].stringValue
        hidechat = json["hidechat"].boolValue
        doctor_id = json["doctor_id"].stringValue
        slot_time = json["slot_Starttime"].stringValue
        slot_Endtime = json["slot_Endtime"].stringValue
        payment_status = json["payment_status"].stringValue
    }
}
class ChatResultModel {

    var chatId : Int!
    var date : Int!
    var message : String!
    var time : Int!
    var userId : Int!
    var userImage : String!
    var userName : String!
    var audioDuration: String!
    var chatType: String!
    
    var doctype: String!
    var docname: String!
    var slot_time: String!
    var slot_Endtime: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        chatId = json["chat_id"].intValue
        date = json["date"].intValue
        message = json["message"].stringValue
        time = json["time"].intValue
        userId = json["user_id"].intValue
        userImage = json["user_image"].stringValue
        userName = json["user_name"].stringValue
        chatType = json["chat_type"].stringValue
        audioDuration = json["audio_duration"].stringValue
        
        doctype = json["doctype"].stringValue
        docname = json["docname"].stringValue
        slot_time = json["slot_time"].stringValue
        slot_Endtime = json["slot_Endtime"].stringValue
    }
}
class SocketCallModel {
    var status: String!
    var booking_id: String!
    var caller_id: String!
    var callee_id: String!
    var caller_name: String!
    var redirect_url: String!
    var call_id: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        status = json["status"].stringValue
        booking_id = json["booking_id"].stringValue
        caller_id = json["caller_id"].stringValue
        callee_id = json["callee_id"].stringValue
        caller_name = json["caller_name"].stringValue
        redirect_url = json["redirect_url"].stringValue
        call_id = json["call_id"].stringValue
        
    }
    init(status: String = "", booking_id: String = "", caller_id: String = "", callee_id: String = "", redirect_url: String = "", call_id: String = "", caller_name: String = "") {
        self.call_id = call_id
        self.status = status
        self.booking_id = booking_id
        self.caller_id = caller_id
        self.callee_id = callee_id
        self.caller_name = caller_name
        self.redirect_url = redirect_url
    }
}


class SendChatModel {

    var result : ChatResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let resultArray = json["result"].dictionary {
            result = ChatResultModel(fromJson: json["result"])
        }
        status = json["status"].boolValue
    }
}
class SocketChatModel {

    var inquiry: Int!
    var listing: Int!
    var message: String!
    var receiver: Int!
    var sender: Int!
    var chatType: String!
    var audioDuration: String!
    
    var doctype: String!
    var docname: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        listing = json["listing"].intValue
        inquiry = json["inquiry"].intValue
        message = json["message"].stringValue
        receiver = json["receiver"].intValue
        sender = json["sender"].intValue
        chatType = json["chat_type"].stringValue
        audioDuration = json["audio_duration"].stringValue
        
        doctype = json["doctype"].stringValue
        docname = json["docname"].stringValue

    }
}
class BlockModel {

    var message : String!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        message = json["message"].stringValue
        status = json["status"].boolValue
    }
}
