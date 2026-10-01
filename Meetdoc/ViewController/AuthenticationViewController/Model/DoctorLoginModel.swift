//
//  DoctorLoginModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//


import Foundation
import SwiftyJSON


class DoctorLoginModel {

    var result : DoctorLoginResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
//            result = DoctorLoginResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }

}
class DoctorLoginResultModel: Codable {

    var email : String!
    var emailVerified : Bool!
    var firstName : String!
    var gender : String!
    var lastName : String!
    var phoneNumber : String!
    var phoneVerified : Bool!
    var referalUrl : String!
    var type : String!
    var userId : String!
    var userImage : String!
    var dateOfBirth : String!
    var message : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].stringValue
        emailVerified = json["email_verified"].boolValue
        firstName = json["first_name"].stringValue
        gender = json["gender"].stringValue
        lastName = json["last_name"].stringValue
        phoneNumber = json["phone_number"].stringValue
        phoneVerified = json["phone_verified"].boolValue
        referalUrl = json["referal_url"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        userImage = json["user_image"].stringValue
        dateOfBirth = json["date_of_birth"].stringValue
        message = json["message"].stringValue

    }
    init(email: String = "", emailVerified: Bool = false, firstName: String = "", gender: String = "", lastName: String = "", phoneNumber: String = "", phoneVerified: Bool = false, referalUrl: String = "", type: String = "", userId: String = "", userImage: String = "", message: String = "", dateOfBirth: String = "") {
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
    }
}

class DoctorSignupModel: Codable {
    
    var firstName : String!
    var email : String!
    var gender : String!
    var password : String!
    var locationId : String!
    var qualification : String!
    var institute : String!
    var specialitiesId: String!
    var doctorLanguage: [LanguageModel]!
    var registerNumber: String!
    var certificateUpload: String!
    var portfolioUpload: String!
    var skil: String!
    var country: String!
    var phoneNumber : String!
    var hospitalId: String!
    var bioDescription: String!
    var userImage: String!

    init(firstName: String = "", email: String = "", gender: String = "", password: String = "", locationId: String = "", qualification: String = "",institute: String = "" ,specialitiesId: String = "", doctorLanguage: [LanguageModel] = [LanguageModel](), registerNumber: String = "", certificateUpload: String = "", portfolioUpload: String = "", skil: String = "", country: String = "", phoneNumber: String = "", hospitalId: String = "", bioDescription: String = "", userImage: String = "") {
        self.firstName = firstName
        self.email = email
        self.gender = gender
        self.password = password
        self.locationId = locationId
        self.qualification = qualification
        self.institute = institute
        self.specialitiesId = specialitiesId
        self.doctorLanguage = doctorLanguage
        self.registerNumber = registerNumber
        self.certificateUpload = certificateUpload
        self.portfolioUpload = portfolioUpload
        self.skil = skil
        self.country = country
        self.phoneNumber = phoneNumber
        self.hospitalId = hospitalId
        self.bioDescription = bioDescription
        self.userImage = userImage
    }
}
