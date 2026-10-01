//
//  ProgressModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProgressModel {

    var result : ProgressResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = ProgressResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class ProgressResultModel{

    var averageRating : Int!
    var emailVerified : Bool!
    var listings : [ListingModel]!
    var phoneVerified : Bool!
    var totalBooking : String!
    var totalEarning : String!
    var totalEarningCount : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        averageRating = json["average_rating"].intValue
        emailVerified = json["email_verified"].boolValue
        listings = [ListingModel]()
        let listingsArray = json["listings"].arrayValue
        for listingsJson in listingsArray{
            let value = ListingModel(fromJson: listingsJson)
            listings.append(value)
        }
        phoneVerified = json["phone_verified"].boolValue
        totalBooking = json["total_booking"].stringValue
        totalEarning = json["total_earning"].stringValue
        totalEarningCount = json["total_earning_count"].intValue
    }
}
class ListingModel{

    var instantBook : Bool!
    var listId : Int!
    var listImage : String!
    var listName : String!
    var requests : Int!
    var reservations : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        instantBook = json["instant_book"].boolValue
        listId = json["list_id"].intValue
        listImage = json["list_image"].stringValue
        listName = json["list_name"].stringValue
        requests = json["requests"].intValue
        reservations = json["reservations"].intValue
    }
}
