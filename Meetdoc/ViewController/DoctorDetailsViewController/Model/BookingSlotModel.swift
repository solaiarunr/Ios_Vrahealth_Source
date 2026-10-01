//
//  BookingSlotModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class BookingSlotModel{

    var result : BookingSlotResultModel!
    var status : Bool!
    var doctorStatus: Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = BookingSlotResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
        doctorStatus = json["doctor_status"].bool ?? true
    }
}
class BookingSlotResultModel{
    var stripePublishkey : String!
    var consultFees : String!
    var currency : String!
    var slots : [BookingSlotSubModel]!
    var holiday : [String]!
    var grandTotal : String!
    var sitefees : String!
    var tax : String!
    var policy_id : String!
    var policy_name : String!
    var content : String!
    var bookedTime: [BookedTimeModel]!
    var rescheduled_time: [RescheduledTimeModel]!
    var accepted_bookings: [AcceptedTimeModel]!
    var currencycode: String!
    var convertedcurrencycode: String!
    var price: String!
    var paymentprice: String!
    var usercurrencyrate: String!
    var doctorcurrencyrate: String!
    var cancelpercentage: String!
    var results : ResultSlotArrayModel!



    init(consultFees : String = "", currency : String = "", grandTotal : String = "", sitefees : String = "", tax : String = "", currencycode: String = "", price: String, convertedcurrencycode: String = "", paymentprice: String = "", usercurrencyrate: String = "", doctorcurrencyrate: String = "", cancelpercentage: String = "", results: ResultSlotArrayModel = ResultSlotArrayModel()) {
        self.consultFees = consultFees
        self.currency = currency
        self.grandTotal = grandTotal
        self.sitefees = sitefees
        self.tax = tax
        self.stripePublishkey = ""
        self.slots = [BookingSlotSubModel]()
        self.holiday = [String]()
        self.policy_id = ""
        self.policy_name = ""
        self.content = ""
        self.bookedTime = [BookedTimeModel]()
        self.rescheduled_time = [RescheduledTimeModel]()
        self.accepted_bookings = [AcceptedTimeModel]()
        self.currencycode = currencycode
        self.convertedcurrencycode = convertedcurrencycode
        self.price = price
        self.paymentprice = paymentprice
        self.cancelpercentage = cancelpercentage
        self.doctorcurrencyrate = doctorcurrencyrate
        self.usercurrencyrate = usercurrencyrate
        self.results = results
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let fee = json["doctor_fees"].stringValue.replacingOccurrences(of: ",", with: "")
        print(fee)
        print(fee.doubleValue)
        consultFees = json["doctor_fees"].stringValue
        currency = json["currency"].stringValue
        slots = [BookingSlotSubModel]()
        let slotsArray = json["results"].arrayValue
        for slotsJson in slotsArray{
            let value = SlotResultModel(fromJson: slotsJson)
            slots.append(contentsOf: value.slots)
        }
        holiday = [String]()
        let holidayArray = json["holiday"].arrayValue
        for holidayJson in holidayArray{
            holiday.append(holidayJson.stringValue)
        }
        bookedTime = [BookedTimeModel]()
        let bookedTimeArray = json["booked_time"].arrayValue
        for bookedTimeJson in bookedTimeArray{
            let value = BookedTimeModel(fromJson: bookedTimeJson)
            bookedTime.append(value)
        }
        rescheduled_time = [RescheduledTimeModel]()
        let rescheduledTimeArray = json["rescheduled_time"].arrayValue
        for rescheduledTimeJson in rescheduledTimeArray{
            let value = RescheduledTimeModel(fromJson: rescheduledTimeJson)
            rescheduled_time.append(value)
        }
        accepted_bookings = [AcceptedTimeModel]()
        let acceptedTimeArray = json["accepted_bookings"].arrayValue
        for acceptedTimeJson in acceptedTimeArray{
            let value = AcceptedTimeModel(fromJson: acceptedTimeJson)
            accepted_bookings.append(value)
        }
        stripePublishkey = json["stripe_publishkey"].stringValue
        grandTotal = json["grand_total"].stringValue
        sitefees = json["sitefees"].stringValue
        tax = json["tax"].stringValue
        policy_id = json["policy_id"].stringValue
        policy_name = json["policy_name"].stringValue
        content = json["content"].stringValue
        currencycode = json["currencycode"].stringValue
        convertedcurrencycode = json["convertedcurrencycode"].stringValue
        price = json["price"].stringValue
        paymentprice = json["paymentprice"].stringValue
        usercurrencyrate = json["usercurrencyrate"].stringValue
        doctorcurrencyrate = json["doctorcurrencyrate"].stringValue
        cancelpercentage = json["cancelpercentage"].stringValue
        let resultsJson = json["results"]
        if !resultsJson.isEmpty{
            results = ResultSlotArrayModel(fromJson: resultsJson)
        }
    }
}
class BookedTimeModel{

    var time : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        time = json["time"].stringValue
    }
}

class RescheduledTimeModel{
    var time : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        time = json["time"].stringValue
    }
}

class AcceptedTimeModel{
    var time : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        time = json["time"].stringValue
    }
}

class SlotResultModel {

    var slots : [BookingSlotSubModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        slots = [BookingSlotSubModel]()
        let slotsArray = json["slots"].arrayValue
        for slotsJson in slotsArray{
            let value = BookingSlotSubModel(fromJson: slotsJson)
            if !slots.contains(where: {$0.startTime == value.startTime}) {
                slots.append(value)
            }
        }
    }
}

class BookingSlotSubModel{

    var id : String!
    var startTime : String!
    var endTime : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        startTime = json["start_time"].stringValue
        endTime = json["end_time"].stringValue
    }
}
extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = ","
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = "."
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

class ResultSlotArrayModel{

    var afternoon : [BookingSlotSubModel]!
    var earlymorning : [BookingSlotSubModel]!
    var evening : [BookingSlotSubModel]!
    var morning : [BookingSlotSubModel]!
    var night : [BookingSlotSubModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        afternoon = [BookingSlotSubModel]()
        let afternoonArray = json["afternoon"].arrayValue
        for afternoonJson in afternoonArray{
            let value = BookingSlotSubModel(fromJson: afternoonJson)
            afternoon.append(value)
        }
        earlymorning = [BookingSlotSubModel]()
        let earlymorningArray = json["earlymorning"].arrayValue
        for earlymorningJson in earlymorningArray{
            let value = BookingSlotSubModel(fromJson: earlymorningJson)
            earlymorning.append(value)
        }
        evening = [BookingSlotSubModel]()
        let eveningArray = json["evening"].arrayValue
        for eveningJson in eveningArray{
            let value = BookingSlotSubModel(fromJson: eveningJson)
            evening.append(value)
        }
        morning = [BookingSlotSubModel]()
        let morningArray = json["morning"].arrayValue
        for morningJson in morningArray{
            let value = BookingSlotSubModel(fromJson: morningJson)
            morning.append(value)
        }
        night = [BookingSlotSubModel]()
        let nightArray = json["night"].arrayValue
        for nightJson in nightArray{
            let value = BookingSlotSubModel(fromJson: nightJson)
            night.append(value)
        }
    }
    init(afternoon : [BookingSlotSubModel] = [BookingSlotSubModel](), night : [BookingSlotSubModel] = [BookingSlotSubModel](), morning : [BookingSlotSubModel] = [BookingSlotSubModel](), evening : [BookingSlotSubModel] = [BookingSlotSubModel](), earlymorning : [BookingSlotSubModel] = [BookingSlotSubModel]()) {
        self.earlymorning = earlymorning
        self.afternoon = afternoon
        self.night = night
        self.morning = morning
        self.evening = evening
    }
}

