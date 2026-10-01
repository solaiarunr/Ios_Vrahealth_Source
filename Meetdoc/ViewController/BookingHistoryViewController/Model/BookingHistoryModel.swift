//
//  HostListModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 04/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class BookingHistoryModel{

    var result : [BookingHistoryResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [BookingHistoryResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = BookingHistoryResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
class BookingHistoryResultModel {

    var bookingDate : Int!
    var bookingId : String!
    var bookingReason : [BookingReasonModel]!
    var bookingType : String!
    var cancelStatus : Bool!
    var chatId : String!
    var consultFees : String!
    var content : String!
    var currency : String!
    var doctorId : String!
    var lastMessage : String!
    var location : String!
    var paytoken : String!
    var policyName : String!
    var rating : String!
    var review : String!
    var reviewId : String!
    var slotBookingtype : String!
    var speciality : String!
    var doctor_qualification : String!
    var status : String!
    var stripePublishkey : String!
    var time : String!
    var end_time: String!
    var reschedule_time : String!
    var doctor_location : String!
    var doctor_speciality : String!
    var patient_phonenumber : String!
    var userId : String!
    var userImage : String!
    var userName : String!
    var type: String!
    var createdDate: Int!
    var isVideovisit: Bool!
    var grandTotal : String!
    var sitefees : String!
    var tax : String!
    var orderstatus: String!
    var currencycode: String!
    var convertedcurrencycode: String!
    var price: String!
    var utcappstart: String!
    var timezone: String!
    var patientname : String!
    var patientillness : String!
    var patientage : String!
    var patientgender : String!
    var patientweight : String!
    var patientstatus : String!
    var doctorqualification : String!
    var doctorname : String!
    var doctormobilenumber : String!
    var doctorgender : String!
    var doctoremail : String!
    var doctorregister : String!
    var dcaddress : String!
    var dcmobilenumber : String!
    var dcname : String!
    var dcemail : String!
    var createdtime : String!
    var client_id: String!
    var patient_height: String!
    var patient_bp: String!
    var patient_bprs: String!
    var prescription_view: Bool!
    var slot_endtime: String!
    var own_username: String!
    
    var connectycube_userlogin: String!   //lawyer
    var connectycube_userid: String!
    var connectycube_password: String!
    
    var ownuser_connectycube_userlogin: String!  //client
    var ownuser_connectycube_userid: String!
    var ownuser_connectycube_password: String!

    init(chatId: String = "", userName: String = "", userImage: String = "", bookingID: String = "") {
        self.chatId = chatId
        self.userName = userName
        self.userImage = userImage
        
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingDate = json["booking_date"].intValue
        bookingId = json["booking_id"].stringValue
        bookingReason = [BookingReasonModel]()
        let bookingReasonArray = json["booking_reason"].arrayValue
        for bookingReasonJson in bookingReasonArray{
            let value = BookingReasonModel(fromJson: bookingReasonJson)
            bookingReason.append(value)
        }
        doctorregister = json["doctor_regno"].stringValue
        doctor_speciality = json["doctor_speciality"].stringValue
        utcappstart = json["utcappstart"].stringValue
        timezone = json["timezone"].stringValue
        bookingType = json["booking_type"].stringValue
        cancelStatus = json["cancel_status"].boolValue
        chatId = json["chat_id"].stringValue
        consultFees = String(format: "%.2f", (json["doctor_fees"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)
        grandTotal = String(format: "%.2f", (json["grand_total"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)
        sitefees = String(format: "%.2f", (json["sitefees"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)
        tax = String(format: "%.2f", (json["tax"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)
        content = json["content"].stringValue
        currency = json["currency"].stringValue
        doctorId = json["doctor_id"].stringValue
        lastMessage = json["last_message"].stringValue
        location = json["location"].stringValue
        paytoken = json["paytoken"].stringValue
        policyName = json["policy_name"].stringValue
        rating = json["rating"].stringValue
        review = json["review"].stringValue
        reviewId = json["review_id"].stringValue
        slotBookingtype = json["slot_bookingtype"].stringValue
        speciality = json["speciality"].stringValue
        status = json["status"].stringValue
        stripePublishkey = json["stripe_publishkey"].stringValue
        time = json["time"].stringValue
        end_time = json["end_time"].stringValue
        reschedule_time = json["reschedule_time"].stringValue
        doctor_location = json["doctor_location"].stringValue
        patient_phonenumber = json["patient_phonenumber"].stringValue
        userId = json["user_id"].stringValue
        userImage = json["user_image"].stringValue
        userName = json["user_name"].stringValue
        type = json["type"].stringValue
        createdDate = json["createddate"].intValue
        isVideovisit = json["isVideovisit"].bool ?? json["visitability"].boolValue
        orderstatus = json["orderstatus"].stringValue
        currencycode = json["currencycode"].stringValue
        convertedcurrencycode = json["convertedcurrencycode"].stringValue
        price = json["price"].stringValue
        patientname = json["patient_name"].stringValue
        patientillness = json["patient_illness"].stringValue
        patientage = json["patient_age"].stringValue
        patientgender = json["patient_gender"].stringValue
        patientweight = json["patient_weight"].stringValue
        patientstatus = json["patient_status"].stringValue
        patient_height = json["patient_height"].stringValue
        patient_bp = json["patient_bp"].stringValue
        patient_bprs = json["patient_bprs"].stringValue
        doctorqualification = json["doctor_qualification"].stringValue
        doctorname = json["doctor_name"].stringValue
        doctormobilenumber = json["doctor_mobilenumber"].stringValue
        doctorgender = json["doctor_gender"].stringValue
        doctoremail = json["doctor_email"].stringValue
        dcaddress = json["dc_address"].stringValue
        dcmobilenumber = json["dc_mobilenumber"].stringValue
        dcname = json["dc_name"].stringValue
        dcemail = json["dc_email"].stringValue
        createdtime = json["createdtime"].stringValue
        client_id = json["client_id"].stringValue
        doctor_qualification = json["doctor_qualification"].stringValue
        slot_endtime = json["slot_endtime"].stringValue
        own_username = json["own_username"].stringValue
        
        
        connectycube_userlogin = json["connectycube_userlogin"].stringValue
        connectycube_userid = json["connectycube_userid"].stringValue
        connectycube_password = json["connectycube_password"].stringValue
        
        ownuser_connectycube_userlogin = json["ownuser_connectycube_userlogin"].stringValue
        ownuser_connectycube_userid = json["ownuser_connectycube_userid"].stringValue
        ownuser_connectycube_password = json["ownuser_connectycube_password"].stringValue
        prescription_view = json["prescription_view"].boolValue

    }
}

class BookingReasonModel {

    var id : Int!
    var name : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
