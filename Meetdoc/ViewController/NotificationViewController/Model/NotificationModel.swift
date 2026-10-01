//
//  NotificationModel.swift
//  AirFinch_Swift
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationModel {

    var status : Bool!

    var emailReservation : String!
    var notificationMessages : String!
    var notificationReservation : String!
    var pushNotification : String!
    var textNotification : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            emailReservation = resultJson["email_reservation"].stringValue
            notificationMessages = resultJson["notification_messages"].stringValue
            notificationReservation = resultJson["notification_reservation"].stringValue
            pushNotification = resultJson["push_notification"].stringValue
            textNotification = resultJson["text_notification"].stringValue
        }
        status = json["status"].boolValue
    }
    
}

class getAllNotificationModel {
    var result : [NotificationResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [NotificationResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = NotificationResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}

class NotificationResultModel {
    var block : String!
    var date : Int!
    var listId : Int!
    var listImage : String!
    var listName : String!
    var message : String!
    var notificationId : Int!
    var notifymessage : String!
    var time : Int!
    var type : String!
    var userId : Int!
    var userImage : String!
    var userName : String!
    var booking_id: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        block = json["block"].stringValue
        date = json["date"].intValue
        listId = json["list_id"].intValue
        listImage = json["list_image"].stringValue
        listName = json["list_name"].stringValue
        message = json["message"].stringValue
        notificationId = json["notification_id"].intValue
        notifymessage = json["notifymessage"].stringValue
        time = json["time"].intValue
        type = json["type"].stringValue
        userId = json["user_id"].intValue
        userImage = json["user_image"].stringValue
        userName = json["user_name"].stringValue
        booking_id = json["booking_id"].stringValue
    }
}
