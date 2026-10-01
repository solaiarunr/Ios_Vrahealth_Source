//
//  LoginModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserProfileModel {
    let title: String!
    let image: String!
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}
class DayoffModel {

    
    var status : String!
    var result : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].stringValue
        result = json["result"].stringValue
    }

}

class UserLoginModel {

    var result : UserLoginResultModel!
    var status : Bool!
    var message : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = UserLoginResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
        message = json["message"].string ??  json["result"].stringValue
    }

}
class UserLoginResultModel: Codable {

    var email : String!
    var emailVerified : Bool!
    var firstName : String!
    var qualification : String!
    var gender : String!
    var lastName : String!
    var phoneNumber : String!
    var phoneVerified : Bool!
    var referalUrl : String!
    var type : String!
    var userId : String!
    var userImage : String!
    var bankingdetails : String!
    var dateOfBirth : String!
    var message : String!
    var location : String!
    var latitude : String!
    var longitude : String!
    var razorpayID : String!
    var razorpaySecret : String!
    var address : String!
    var connecty_userlogin : String!
    var connecty_userId : String!
    var connecty_password : String!
    var registerNumber : String!
    var currency_code : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].stringValue
        emailVerified = json["email_verified"].boolValue
        firstName = json["first_name"].string ?? json["full_name"].stringValue
        gender = json["gender"].stringValue
        lastName = json["last_name"].stringValue
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
        dateOfBirth = json["date_of_birth"].stringValue
        bankingdetails = json["banking_details"].stringValue
        message = json["message"].stringValue
        qualification = json["qualification"].stringValue
        location = json["location"].stringValue
        latitude = json["latitude"].stringValue
        longitude = json["longitude"].stringValue
        razorpayID = json["razor_public_key"].stringValue
        razorpaySecret = json["razor_secret_key"].stringValue
        registerNumber = json["register_number"].stringValue
        address = json["address"].stringValue
        connecty_userlogin = json["connecty_userlogin"].stringValue
        connecty_userId = json["connecty_userId"].stringValue
        connecty_password = json["connecty_password"].stringValue
        currency_code = json["currency_code"].stringValue

    }
    init(email: String = "", emailVerified: Bool = false, firstName: String = "", gender: String = "", lastName: String = "", phoneNumber: String = "", phoneVerified: Bool = false, referalUrl: String = "", bankingdetails: String = "", type: String = "", userId: String = "1", userImage: String = "", message: String = "", dateOfBirth: String = "", qualification: String = "", razorpayID: String = "", razorpaysecret: String = "",connecty_userlogin: String = "",connecty_userId: String = "",connecty_password: String = "",registerNumber: String = "",currency_code: String = "") {
        self.email = email
        self.emailVerified = emailVerified
        self.firstName = firstName
        self.gender = gender
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.phoneVerified = phoneVerified
        self.referalUrl = referalUrl
        self.type = type
        self.userId = userId
        self.userImage = userImage
        self.message = message
        self.dateOfBirth = dateOfBirth
        self.qualification = qualification
        self.longitude = ""
        self.latitude = ""
        self.bankingdetails = bankingdetails
        self.razorpayID = razorpayID
        self.razorpaySecret = razorpaysecret
        var connecty_userlogin : String!
        var connecty_userId : String!
        var connecty_password : String!
        self.registerNumber = registerNumber
        self.currency_code = currency_code

    }
}
