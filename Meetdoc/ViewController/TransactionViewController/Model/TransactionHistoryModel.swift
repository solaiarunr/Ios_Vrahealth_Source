//
//  TransactionHistoryModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class TransactionHistoryModel{

    var result : [TransactionResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [TransactionResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = TransactionResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}

class TransactionResultModel{

    var checkIn : Int!
    var checkOut : String!
    var currency : String!
    var currencyCode : String!
    var durationType : String!
    var grandTotal : String!
    var guestName : String!
    var listId : String!
    var listName : String!
    var noOfGuests : String!
    var noOfNights : String!
    var orderedDate : Int!
    var orderid : Int!
    var price : Int!
    var status : String!
    var transactionId : String!
    var doctor_fees : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        checkIn = json["check_in"].intValue
        checkOut = json["check_out"].stringValue
        currency = json["currency"].stringValue
        currencyCode = json["currency_code"].stringValue
        durationType = json["duration_type"].stringValue
        grandTotal = String(format: "%.2f", (json["grand_total"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)
        guestName = json["guest_name"].stringValue
        listId = json["list_id"].stringValue
        listName = json["list_name"].stringValue
        noOfGuests = json["no_of_guests"].stringValue
        noOfNights = json["no_of_nights"].stringValue
        orderedDate = json["ordered_date"].intValue
        orderid = json["orderid"].intValue
        price = json["price"].intValue
        status = json["status"].stringValue
        transactionId = json["transaction_id"].stringValue
        doctor_fees = json["doctor_fees"].stringValue
    }
}

