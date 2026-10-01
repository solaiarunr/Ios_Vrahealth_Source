//
//  DoctorViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class DoctorViewModel {
    
    var doctorModel: DoctorDetailsModel?
    var hospitalModel: HospitalDetailsModel?
    var bookingSlotModel: BookingSlotModel?
    var bookingModel: UserLoginModel?
    var paymentModel: paymentVerifyModel?
    var stripeModel: StripeDataModel?
    var razorpayModel: RazorpayDataModel?

    public func getDoctorData(user_id: String,doctor_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: DOCTOR_DETAILS_URL, params: parameter, onSuccess: { (result) in
            let rootclass = DoctorDetailsModel.init(fromJson: result)
            self.doctorModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getHospitalData(user_id: String,hospital_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "hospital_id": hospital_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: HOSPITAL_DETAILS_URL, params: parameter, onSuccess: { (result) in
            let rootclass = HospitalDetailsModel.init(fromJson: result)
            self.hospitalModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getSlotData(user_id: String,doctor_id: String, type: String, date: Int, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let date = Date(timeIntervalSince1970: Double(date))
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let toDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let localDate = Int(toDate.timeIntervalSince1970 + Double(timezoneOffset))
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "type": type, "date": localDate, "language": Utility.shared.getLanguageCode(), "timezone_code": timeZoneString]
            
        ParsingFunction().postDataCall(subURl: GET_SLOT_URL, params: parameter, onSuccess: { (result) in
            let rootclass = BookingSlotModel.init(fromJson: result)
            self.bookingSlotModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func reseheduleSlotDate(user_id: String,doctor_id: String, type: String, date: Int, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let date = Date(timeIntervalSince1970: Double(date))
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let toDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
//        let localDate = Int(toDate.timeIntervalSince1970 + Double(timezoneOffset))
        let localDate = Int(toDate.timeIntervalSince1970)
        var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "type": type, "date": localDate, "language": Utility.shared.getLanguageCode(), "timezone_code": timeZoneString]
            
        ParsingFunction().postDataCall(subURl: GET_SLOT_URL, params: parameter, onSuccess: { (result) in
            let rootclass = BookingSlotModel.init(fromJson: result)
            self.bookingSlotModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func bookAppointment(user_id: String,doctor_id: String, paytoken: String,illness_id: String, date: Int, time: String, slot_bookingtype: String, booking_type: String, currency: String, grand_total: String,endTime:String, doctor_fees: String, tax: String, sitefees: String, price: String, currencycode: String, convertedcurrencycode: String, paymentprice: String, usercurrencyrate: String, doctorcurrencyrate: String, cancelpercentage: String,type: String, patient_name: String, patient_age: String, patient_gender: String, patient_weight: String, patient_illness: String, appointment: String, dc_name: String,booking_id: String,patient_phone:String,patient_height:String,patient_bp:String,patient_bprs:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZonecode = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let dateval = Date(timeIntervalSince1970: Double(date))
        let timeZone = "+\(secondsFromGMT/3600).\(secondsFromGMT%3600)"
        var currentData = date
        let toArray = endTime.components(separatedBy: ":")
        if (toArray.count) > 1 {
            let toDate = Utility.calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: dateval)!
            currentData = Int(toDate.timeIntervalSince1970)
        }
        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "paytoken": paytoken, "timezone": timeZone, "illness_id": illness_id, "date": date, "time": time, "slot_bookingtype": slot_bookingtype, "booking_type": booking_type, "currency": currency, "grand_total": grand_total, "language": Utility.shared.getLanguageCode(), "appdate": currentData, "doctor_fees": doctor_fees, "tax": tax, "sitefees": sitefees, "price": price, "currencycode": currencycode, "convertedcurrencycode": convertedcurrencycode, "paymentprice": paymentprice, "cancelpercentage": cancelpercentage, "doctorcurrencyrate": doctorcurrencyrate, "usercurrencyrate": usercurrencyrate, "type": type,"patient_name": patient_name,"patient_age": patient_age,"patient_gender": patient_gender,"patient_weight": patient_weight, "patient_illness": patient_illness,"appointment": appointment,"dc_name": dc_name,"booking_id":booking_id,"patient_phone":patient_phone,"timeZone_code": timeZoneString,"patient_height":patient_height,"patient_bp":patient_bp,"patient_bprs":patient_bprs]
    
        ParsingFunction().postDataCall(subURl: BOOKING_APPOINMENT_API, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.bookingModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func paymentAct(user_id: String,doctor_id: String, paytoken: String, booking_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){

        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "paytoken": paytoken, "language": Utility.shared.getLanguageCode(), "booking_id": booking_id]
    
        ParsingFunction().postDataCall(subURl: PAYMENT_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.bookingModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func payment(booking_id: String,order_id: String, payment_id: String, payment_signature: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){

        let parameter: [String: Any] = ["order_id": order_id, "payment_id": payment_id, "payment_signature": payment_signature, "booking_id": booking_id]
    
        ParsingFunction().postDataCall(subURl: PAYMENT_VERIFICATION, params: parameter, onSuccess: {(status) in
            let rootclass = paymentVerifyModel.init(fromJson: status)
            self.paymentModel = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    
    public func getStripeDetails(amount: String,currency: String,user_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["amount": amount, "currency":currency]
        CallParsingFunction().postDataCall(subURl: BALLENCE_SHEET_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = StripeDataModel.init(fromJson: response)
            self.stripeModel = rootClass
             success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    public func createorderid(amount: String,currency: String,booking_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["amount": amount, "currency_code":currency, "booking_id":booking_id ]
        CallParsingFunction().postDataCall(subURl: CREATE_ORDER_ID, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = RazorpayDataModel.init(fromJson: response)
            self.razorpayModel = rootClass
             success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    public func completbooking(user_id: String,booking_id:String, status: String,patient_status: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let timeZone = "+\(secondsFromGMT/3600).\(secondsFromGMT%3600)"
        let parameter: [String: Any] = ["user_id":user_id,"booking_id": booking_id, "language": Utility.shared.getLanguageCode(), "status": status, "timezone": timeZone, "patient_status":patient_status]
        ParsingFunction().postDataCall(subURl: COMPLETEBOOKING, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.bookingModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

