//
//  SettingViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class SettingViewModel {
    
    var settingData: SettingModel?
    var adminListData: AdminListCallModel?
    var adminData: AdminDataModel?
    var currencyData: SettingCurrencyModel?
    public func changePassword(user_id: String, old_password: String, new_password: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "old_password":old_password,"new_password":new_password, "language": Utility.shared.getLanguageCode()]
         ParsingFunction().postDataCall(subURl: changePassword_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.settingData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getCurrencyList(user_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: CurrencyList_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingCurrencyModel.init(fromJson: result)
            self.currencyData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func changeCurrency(user_id: String,currency_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "currency_id":currency_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: ChangeCurrency_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.settingData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }

    public func adminlistingproperties(onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let parameter: [String: Any] = ["language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: Get_admin_datas, params: parameter, onSuccess: { (result) in
            let rootclass = AdminListCallModel.init(fromJson: result)
            self.adminListData = rootclass
            if rootclass.mapKey != "" {
                GOOGLE_API_KEY = rootclass.mapKey
            }
            success(rootclass.status)
         }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getAdminData(user_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let date = Date()
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let toDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let localDate = Int(toDate.timeIntervalSince1970 + Double(timezoneOffset))

        let parameter: [String: Any] = ["user_id": (UserDefaultModule().getCurrentUserID() as String? ?? "1"), "currentdate": localDate, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: Admin_URL, params: parameter, onSuccess: { (result) in
            let rootclass = AdminDataModel.init(fromJson: result)
            if rootclass.status  {
                self.adminData = rootclass
                APP_RTC_URL = "http://\(self.adminData?.result.turnBaseUrl ?? APP_RTC_URL)"
                hospitalStatus = (self.adminData?.result.hospitalStatus ?? false)
                isCalendar = (self.adminData?.result.isCalendar ?? false)
                isPayout = (self.adminData?.result.ispayout ?? false)
                isProfileUpdate = (self.adminData?.result.isProfileUpdate ?? false)
                if let adminVal = self.adminData?.result {
                    selectedCurrency = Currencylist(countryCode: adminVal.countryCode, countryName: adminVal.countryCode, currencyCode: adminVal.currencyCode, currencyId: selectedCurrency.currencyId, currencyName: selectedCurrency.currencyName, currencySymbol: adminVal.currencySymbol, minimum_amount: selectedCurrency.minimum_amount)
                }
                let appid = UInt32(self.adminData?.result.zego_appID ?? "") ?? 0
                UserDefaults.standard.set(appid, forKey: "zego_appId")
                UserDefaults.standard.set((self.adminData?.result.zego_appSign ?? ""), forKey: "zego_appSignin")
                UserDefaults.standard.set((self.adminData?.result.zego_resourceID ?? ""), forKey: "zego_resourceID")
                success(rootclass.status)
                
            }
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func EmailVerification(user_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: API_EMAIL_VERIFICATION, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.settingData = rootclass
            success("Success")
         }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}

