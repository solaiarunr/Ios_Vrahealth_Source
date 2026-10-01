//
//  HospitalModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class HospitalDetailsModel{

    var result : HospitalResultDetailsModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = HospitalResultDetailsModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class HospitalResultDetailsModel{

    var descriptionField : String!
    var hospitalName : String!
    var image : String!
    var insurance : [InsuranceResultModel]!
    var location : [LocationModel]!
    var shareUrl : String!
    var speciality : [LanguageModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        descriptionField = json["description"].stringValue
        hospitalName = json["hospital_name"].stringValue
        image = json["image"].stringValue
        insurance = [InsuranceResultModel]()
        let insuranceArray = json["insurance"].arrayValue
        for insuranceJson in insuranceArray{
            let value = InsuranceResultModel(fromJson: insuranceJson)
            insurance.append(value)
        }
        location = [LocationModel]()
        let locationArray = json["location"].arrayValue
        for locationJson in locationArray{
            let value = LocationModel(fromJson: locationJson)
            location.append(value)
        }
        shareUrl = json["share_url"].stringValue
        speciality = [LanguageModel]()
        let specialityArray = json["speciality"].arrayValue
        for specialityJson in specialityArray{
            let value = LanguageModel(fromJson: specialityJson)
            speciality.append(value)
        }
    }
}

class StripeDataModel{
    var status: Bool!
    var customer: String!
    var ephemeralKey: String!
    var paymentIntent: String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].boolValue
        customer = json["customer"].stringValue
        ephemeralKey = json["ephemeralKey"].stringValue
        paymentIntent = json["paymentIntent"].stringValue
    }
    init(status: Bool = false,customer: String = "", ephemeralKey: String = "", paymentIntent: String = "") {
        self.status = status
        self.customer = customer
        self.ephemeralKey = ephemeralKey
        self.paymentIntent = paymentIntent
    }
}

class paymentVerifyModel{
    var status : Bool!
    var message : String!
    var slottype: String!
    var type: String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        self.message = json["message"].stringValue
        self.status = json["status"].boolValue
        self.slottype = json["slot_type"].stringValue
        self.type = json["type"].stringValue
    }
    init(status: Bool = false ,message: String = "", slottype: String = "", type: String = "") {
        self.status = status
        self.message = message
        self.slottype = slottype
        self.type = type
    }
}

class RazorpayDataModel{
    var status: Bool!
    var order_id: String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].boolValue
        order_id = json["order_id"].stringValue
    }
    init(status: Bool = false,orderid: String = "") {
        self.status = status
        self.order_id = orderid
    }
}
