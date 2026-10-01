//
//  AdminDataModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class AdminDataModel{
    var result : AdminDataResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = AdminDataResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class AdminDataResultModel{

    var about : String!
    var appointment : String!
    var blog : String!
    var bookingCount : String!
    var contact : String!
    var contactDoctor : String!
    var contactDetails : ContactDetailModel!
    var cookiesPolicy : String!
    var copyrightInformation : String!
    var countryCode : String!
    var currencyCode : String!
    var currencySymbol : String!
    var findADentist : String!
    var findAPractitioner : String!
    var help : String!
    var helpAndCreate : String!
    var hospitalStatus : Bool!
    var hourlyBook : String!
    var isCalendar : Bool!
    var ispayout : Bool!
    var licenseAggrement : String!
    var listYourPractice : String!
    var messageCount : String!
    var notificationCount : String!
    var onlineDoctors : String!
    var onlineGps : String!
    var policies : String!
    var press : String!
    var privacyPolicy : String!
    var reviewCount : String!
    var stunBaseUrl : String!
    var termsConditions : TermsConditionModel!
    var newprivacyPolicy : NewPrivacyPolicyModel!
    var turnBaseUrl : String!
    var turnPwd : String!
    var turnUsr : String!
    var zego_appID: String!
    var zego_appSign: String!
    var zego_resourceID: String!
    var isProfileUpdate: Bool!
    var prescription: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        about = json["About"].stringValue
        isProfileUpdate = json["isProfileUpdate"].boolValue
        appointment = json["Appointment"].stringValue
        blog = json["Blog"].stringValue
        bookingCount = json["booking_count"].stringValue
        contact = json["Contact"].stringValue
        contactDoctor = json["Contact doctor"].stringValue
        let contactDetailsJson = json["contact_details"]
        if !contactDetailsJson.isEmpty{
            contactDetails = ContactDetailModel(fromJson: contactDetailsJson)
        }
        cookiesPolicy = json["Cookies Policy"].stringValue
        copyrightInformation = json["Copyright information"].stringValue
        countryCode = json["country_code"].stringValue
        currencyCode = json["currency_code"].stringValue
        currencySymbol = json["currency_symbol"].stringValue
        findADentist = json["Find a Dentist"].stringValue
        findAPractitioner = json["Find a practitioner"].stringValue
        help = json["Help"].stringValue
        helpAndCreate = json["Help and create"].stringValue
        hospitalStatus = json["hospital_status"].boolValue
        hourlyBook = json["hourly_book"].stringValue
        isCalendar = json["isCalendar"].boolValue
        ispayout = json["ispayout"].boolValue
        licenseAggrement = json["License Aggrement"].stringValue
        listYourPractice = json["List Your practice"].stringValue
        messageCount = json["message_count"].stringValue
        notificationCount = json["notification_count"].stringValue
        onlineDoctors = json["Online Doctors"].stringValue
        onlineGps = json["Online Gps"].stringValue
        policies = json["Policies"].stringValue
        press = json["Press"].stringValue
        privacyPolicy = json["Privacy policy"].stringValue
        reviewCount = json["review_count"].stringValue
        stunBaseUrl = json["stun_base_url"].stringValue
        let termsConditionsJson = json["terms_conditions"]
        if !termsConditionsJson.isEmpty{
            termsConditions = TermsConditionModel(fromJson: termsConditionsJson)
        }
        let newprivacyPolicyJson = json["new_privacypolicy"]
        if !newprivacyPolicyJson.isEmpty{
            newprivacyPolicy = NewPrivacyPolicyModel(fromJson: newprivacyPolicyJson)
        }
        turnBaseUrl = json["turn_base_url"].stringValue
        turnPwd = json["turn_pwd"].stringValue
        turnUsr = json["turn_usr"].stringValue
        zego_appID = json["zego_appID"].stringValue
        zego_appSign = json["Zego_appsignin"].stringValue
        zego_resourceID = json["zego_resourceID"].stringValue
        prescription = json["prescription"].stringValue
    }
}
class TermsConditionModel{
    var mainContent : String!
    var subContent : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        mainContent = json["main_content"].stringValue
        subContent = json["sub_content"].stringValue
    }
}
class NewPrivacyPolicyModel{
    var mainContent : String!
    var subContent : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        mainContent = json["main_content"].stringValue
        subContent = json["sub_content"].stringValue
    }
}
class ServiceFeeModel{
    var maxValue : String!
    var minValue : String!
    var percentage : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        maxValue = json["max_value"].stringValue
        minValue = json["min_value"].stringValue
        percentage = json["percentage"].stringValue
    }
}
class ContactDetailModel{
    var address : String!
    var email : String!
    var phone : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        email = json["email"].stringValue
        phone = json["phone"].stringValue
    }
}

