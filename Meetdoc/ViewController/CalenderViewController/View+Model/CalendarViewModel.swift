//
//  CalendarViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class CalendarViewModel {
    
    var adminModel: AdminListPropertyModel?
    var activateCalendwdarModel: ActivateCalendarModel?
    var setCalenderModel: UserLoginModel?

    public func getCalenderData(user_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
                let zone = tm.components(separatedBy: " ")
                let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id":user_id, "language": Utility.shared.getLanguageCode(),"timezone": timeZoneString]
    
        ParsingFunction().postDataCall(subURl: calendar_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ActivateCalendarModel.init(fromJson: result)
            self.activateCalendwdarModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getAdminListProperties(onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["language": Utility.shared.getLanguageCode()]

        ParsingFunction().postDataCall(subURl: Get_admin_datas, params: parameter, onSuccess: { (result) in
            let rootclass = AdminListPropertyModel.init(fromJson: result)
            self.adminModel = rootclass
            print(result)
            success(rootclass.status)
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func setCalendarSetting(user_id: String,caledarData: ActivateCalendarResultModel,dayoff:String,days:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let timeZone = Bool((caledarData.dayoff ?? "false")) ?? false ? "" : "+\(secondsFromGMT/3600).\(secondsFromGMT%3600)"
        var holiday = Utility.shared.jsonString(from: caledarData.holiday)
        if caledarData.holiday.count == 0 {
            holiday = ""
        }
        var slots = Utility.shared.filterDictToString(caledarData.slots)
        if caledarData.slots.count == 0 {
            slots = ""
        }

        let parameter: [String: Any] = ["user_id":user_id, "booking_type": caledarData.bookingType ?? "", "slots": slots, "consult_time": caledarData.consultTime ?? "", "offdate": days, "consult_fees": (caledarData.consultFees ?? ""), "holiday": holiday, "policy_id": caledarData.policyId ?? "", "timezone": timeZone, "dayoff": dayoff, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: SET_CALENDAR_SETTING_API, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.setCalenderModel = rootclass
            print(result)
            success(rootclass.status)
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func unusualbooking(doctor_id: String,unusualtime_status: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
        let zone = tm.components(separatedBy: " ")
        let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["doctor_id": doctor_id,"unusualtime_status":unusualtime_status,"timezone": timeZoneString]
        ParsingFunction().postDataCall(subURl: UNUSUAL_BOOKING, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.setCalenderModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
