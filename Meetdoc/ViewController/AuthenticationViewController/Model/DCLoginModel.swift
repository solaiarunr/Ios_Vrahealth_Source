//
//  DCLoginModel.swift
//  Meetdoc
//
//  Created by HTS-49 on 12/09/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class DCProfileModel {
    let title: String!
    let image: String!
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}
class DCLoginModel {

    var result : DCLoginResultModel!
    var status : Bool!
    var message : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = DCLoginResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
        message = json["message"].string ??  json["result"].stringValue
    }

}
class DCLoginResultModel: Codable {

    var email : String!
    var emailVerified : Bool!
    var fullName : String!
    var phoneNumber : String!
    var phoneVerified : Bool!
    var referalUrl : String!
    var type : String!
    var userId : String!
    var userImage : String!
    var bankingdetails : String!
    var message : String!
    var location : String!
    var latitude : String!
    var longitude : String!
    var razorpayID : String!
    var razorpaySecret : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].stringValue
        emailVerified = json["email_verified"].boolValue
        fullName = json["first_name"].string ?? json["full_name"].stringValue
        if json["phone_number"].stringValue != "" {
            phoneNumber = json["phone_number"].stringValue
        }
        else {
            phoneNumber = json["phone"].stringValue
        }
        
        phoneVerified = json["phone_verified"].boolValue
        referalUrl = json["referal_url"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        userImage = json["user_image"].stringValue
        bankingdetails = json["banking_details"].stringValue
        message = json["message"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        razorpayID = json["razor_public_key"].stringValue
        razorpaySecret = json["razor_secret_key"].stringValue
    }
    init(email: String = "", emailVerified: Bool = false, fullName: String = "", phoneNumber: String = "", phoneVerified: Bool = false, referalUrl: String = "", bankingdetails: String = "", type: String = "", userId: String = "1", userImage: String = "", message: String = "", razorpayID: String = "", razorpaysecret: String = "") {
        self.email = email
        self.emailVerified = emailVerified
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.phoneVerified = phoneVerified
        self.referalUrl = referalUrl
        self.type = type
        self.userId = userId
        self.userImage = userImage
        self.message = message
        self.longitude = ""
        self.latitude = ""
        self.bankingdetails = bankingdetails
        self.razorpayID = razorpayID
        self.razorpaySecret = razorpaysecret
    }
}
