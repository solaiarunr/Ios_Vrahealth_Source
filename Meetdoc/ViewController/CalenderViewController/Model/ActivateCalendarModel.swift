//
//  ActivateCalendarModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActivateCalendarModel {

    var result : ActivateCalendarResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = ActivateCalendarResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class ActivateCalendarResultModel {

    var bookingType : String!
    var consultFees : Int!
    var consultTime : String!
    var dayoff : String!
    var holiday : [String]!
    var offdate : [Int]!
    var booked_dates : [Int]!
    var policyId : String!
    var policyName : String!
    var unusual_time : String!
    var slots : [SlotModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bookingType = json["booking_type"].stringValue
        consultFees = json["consult_fees"].intValue
        consultTime = json["consult_time"].stringValue
        unusual_time = json["unusual_time"].stringValue
        dayoff = json["dayoff"].stringValue
        holiday = [String]()
        let holidayArray = json["holiday"].arrayValue
        for holidayJson in holidayArray{
            holiday.append(holidayJson.stringValue)
        }
        booked_dates = [Int]()
        let bookedArray = json["booked_dates"].arrayValue
        for offdateJson in bookedArray{
            booked_dates.append(offdateJson.intValue)
        }
        offdate = [Int]()
        let offdateArray = json["offdate"].arrayValue
        for offdateJson in offdateArray{
            offdate.append(offdateJson.intValue)
        }

        policyId = json["policy_id"].stringValue
        policyName = json["policy_name"].stringValue
        slots = [SlotModel]()
        let slotsArray = json["slots"].arrayValue
        for slotsJson in slotsArray{
            let value = SlotModel(fromJson: slotsJson)
            slots.append(value)
        }
    }
    init(bookingType : String = "", consultFees : Int = 0, consultTime : String = "", dayoff : String = "", holiday : [String] = [String](), offdate: [Int] = [Int](), policyId: String = "", policyName: String = "", slots : [SlotModel] = [SlotModel]()) {
        self.bookingType = bookingType
        self.consultFees = consultFees
        self.consultTime = consultTime
        self.dayoff = dayoff
        self.offdate = offdate
        self.policyId = policyId
        self.policyName = policyName
        self.slots = slots
        self.holiday = holiday
    }
}

class SlotModel {
    var slotFromTime: String!
    var slotToTime: String!
    var type: String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        slotFromTime = json["slot_fromtime"].stringValue
        slotToTime = json["slot_totime"].stringValue
        type = json["type"].stringValue
    }
    init(slotFromTime: String = "", slotToTime: String = "", type: String = "") {
        self.slotFromTime = slotFromTime
        self.slotToTime = slotToTime
        self.type = type
    }
}
