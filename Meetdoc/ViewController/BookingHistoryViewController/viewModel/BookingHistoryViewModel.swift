//
//  HostListViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 04/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class BookingHistoryViewModel {
    
    var historyModel: BookingHistoryModel?
    var actionModel: UserLoginModel?
    var dayoffModel : DayoffModel?

    public func viewList(user_id: String,type: String, date: Int, booking_type:String, offset: String, limit: String , onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
           
           let tm = "\(TimeZone.autoupdatingCurrent.description)"
                  let zone = tm.components(separatedBy: " ")
                  let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
           let parameter: [String: Any] = ["user_id":user_id, "type": type, "booking_type": booking_type,"offset":offset,"date":date, "limit":limit,"language": Utility.shared.getLanguageCode(),"timeZone":timeZoneString]
        ParsingFunction().postDataCall(subURl: getBookingURL, params: parameter, onSuccess: { (result) in
            let rootclass = BookingHistoryModel.init(fromJson: result)
            self.historyModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func viewBookingDetails(user_id: String,type: String, booking_id:String ,booking_schedule:String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id":user_id, "type": type, "booking_id": booking_id, "language": Utility.shared.getLanguageCode(), "booking_schedule":booking_schedule,"timeZone":timeZoneString]
        ParsingFunction().postDataCall(subURl: GET_BOOKING_DETAILS, params: parameter, onSuccess: { (result) in
            let rootclass = BookingHistoryModel.init(fromJson: result)
            self.historyModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func CancelBooking(user_id: String,type: String, booking_id:String, status: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id":user_id, "type": type, "booking_id": booking_id, "language": Utility.shared.getLanguageCode(), "status": status]
        ParsingFunction().postDataCall(subURl: CANCEL_BOOKING_API, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.actionModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func reschudlebooking(user_id: String,type: String, booking_id:String, status: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let timeZone = "+\(secondsFromGMT/3600).\(secondsFromGMT%3600)"
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZonecode = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id":user_id, "type": type, "booking_id": booking_id, "language": Utility.shared.getLanguageCode(), "status": status, "timezone": timeZoneString]
        ParsingFunction().postDataCall(subURl: RESCHEDULE_BOOKING, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.actionModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func dayoffCall(user_id: String,Dayoff : String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZone = "\(zone.first ?? "")"
        let parameter: [String: Any] = ["userid":user_id, "dayoff": Dayoff]
        ParsingFunction().postDataCall(subURl: DayOffCheck, params: parameter, onSuccess: { (result) in
            let rootclass = DayoffModel.init(fromJson: result)
            self.dayoffModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func callinitate(sender_id: String,receiver_id: String,call_id: String,type: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["sender_id":sender_id,"receiver_id":receiver_id,"call_id":call_id,"type":type]
        ParsingFunction().postDataCall(subURl: CALL_INITIATE, params: parameter, onSuccess: { (result) in
            let rootclass = BookingHistoryModel.init(fromJson: result)
            self.historyModel = rootclass
            success("Success")
        })  { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
        
    }
    public func callend(sender_id: String,receiver_id: String,call_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["sender_id":sender_id,"receiver_id":receiver_id,"call_id":call_id]
        ParsingFunction().postDataCall(subURl: CALL_END, params: parameter, onSuccess: { (result) in
            let rootclass = BookingHistoryModel.init(fromJson: result)
            self.historyModel = rootclass
            success("Success")
        })  { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
        
    }
    public func missedcall(sender_id: String,receiver_id: String,call_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["sender_id":sender_id,"receiver_id":receiver_id,"call_id":call_id]
        ParsingFunction().postDataCall(subURl: MISSED_CALL, params: parameter, onSuccess: { (result) in
            let rootclass = BookingHistoryModel.init(fromJson: result)
            self.historyModel = rootclass
            success("Success")
        })  { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
        
    }
}
