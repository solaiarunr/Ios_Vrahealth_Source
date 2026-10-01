//
//  InboxModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class InboxModel {

    var result : [InboxResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [InboxResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = InboxResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}

class InboxResultModel {

    var appointmentDate : String!
    var bookingDate : Int!
    var createdDate : Int!
    var booking_time: String!
    var bookingId : String!
    var bookingReason : [BookingReasonModel]!
    var chatId : String!
    var lastMessage : String!
    var read : String!
    var status : String!
    var time : String!
    var userId : String!
    var userImage : String!
    var userName : String!
    var chatTime: Int!
    var isVideovisit: Bool!
    var slotBookingType : String!
    var chatType: String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        createdDate = json["createddate"].intValue
        appointmentDate = json["appointment_date"].stringValue
        bookingDate = json["booking_date"].intValue
        bookingId = json["booking_id"].stringValue
        booking_time = json["booking_time"].stringValue
        bookingReason = [BookingReasonModel]()
        let bookingReasonArray = json["booking_reason"].arrayValue
        for bookingReasonJson in bookingReasonArray{
            let value = BookingReasonModel(fromJson: bookingReasonJson)
            bookingReason.append(value)
        }
        chatId = json["chat_id"].stringValue
        lastMessage = json["last_message"].stringValue
        read = json["read"].stringValue
        status = json["status"].stringValue
        time = json["time"].stringValue
        userId = json["user_id"].stringValue
        userImage = json["user_image"].stringValue
        userName = json["user_name"].stringValue
        chatTime = json["chat_time"].intValue
        isVideovisit = json["isVideovisit"].boolValue
        slotBookingType = json["slot_bookingtype"].stringValue
        chatType = json["chat_type"].stringValue
    }
}
