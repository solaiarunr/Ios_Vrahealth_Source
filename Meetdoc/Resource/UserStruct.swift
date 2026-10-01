//
//  UserStruct.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

struct UserData: Codable
{
    //var date_of_birth:String
    var email:String
    var first_name:String
    var last_name:String
    var referal_url:String
    var user_id:String
    var user_image:String

    enum CodingKeys: String, CodingKey {
        case first_name = "first_name"
        case email = "email"
       // case date_of_birth = "date_of_birth"
        case last_name = "last_name"
        case referal_url = "referal_url"
        case user_id = "user_id"
        case user_image = "user_image"
    }
}
struct locationData: Codable
{
    var lat:String
    var long:String
    var location_search:String

    init(lat:String, long:String, location_search:String) {
        self.lat = lat
        self.long = long
        self.location_search = location_search
    }
}
struct ReviewStruct {
    var list_id:String
    var list_name:String
    var review_date:String
    var review_rating:String
    var reviewer_id:String
    var reviewer_image:String
    var reviewer_name:String
    var reviewer_type:String
    var user_review:String

    init(list_id:String, list_name:String, reviewer_image:String, review_date:String, review_rating:String, reviewer_id:String, reviewer_name:String, reviewer_type:String, user_review:String) {
        self.list_id = list_id
        self.list_name = list_name
        self.review_date = review_date
        self.review_rating = review_rating
        self.reviewer_id = reviewer_id
        self.reviewer_image = reviewer_image
        self.reviewer_name = reviewer_name
        self.reviewer_type = reviewer_type
        self.user_review = user_review
    }
}

struct NotificationSetting
{
    var push_notification:String
    var text_notification:String
    var notification_messages:String
    var notification_reservation:String
    var email_reservation:String

    init(push_notification:String, text_notification:String, notification_messages:String, notification_reservation:String, email_reservation:String) {
        self.push_notification = push_notification
        self.text_notification = text_notification
        self.notification_messages = notification_messages
        self.notification_reservation = notification_reservation
        self.email_reservation = email_reservation

    }
}
struct connectycube: Codable
{
    var email:String
    var login:String
    var password: String
    var user_id:String


    enum CodingKeys: String, CodingKey {
        case login = "login"
        case email = "email"
        case password = "password"
        case user_id = "user_id"

    }
}

