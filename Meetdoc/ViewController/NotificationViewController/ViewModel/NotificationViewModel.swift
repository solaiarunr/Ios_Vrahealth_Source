//
//  NotificationViewModel.swift
//  AirFinch_Swift
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//
 
import Foundation

class NotificationViewModel {
    
    var notificationSetting: NotificationModel?
    var getAllNotification: getAllNotificationModel?

    public func getCheckBoxDetails(user_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: getSettings_URL, params: parameter, onSuccess: { (result) in
            
            let rootclass = NotificationModel.init(fromJson: result)
            self.notificationSetting = rootclass
            if (self.notificationSetting?.status ?? false) {
                success("Success")
            }
            else {
                failure("Failed to load Data")
            }

        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func setCheckBoxDetails(params: Parameters, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        ParsingFunction().postDataCall(subURl: setSettings_URL, params: params, onSuccess: { (result) in
            
            let rootclass = NotificationModel.init(fromJson: result)
            self.notificationSetting = rootclass
            if (self.notificationSetting?.status ?? false) {
                success("Success")
            }
            else {
                failure("Failed to load Data")
            }

        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getAllNotification(user_id: String,type: String, offset: String,limit: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id": user_id,"type": type, "offset":offset, "limit":limit, "language": Utility.shared.getLanguageCode()]
        
        ParsingFunction().postDataCall(subURl: Get_user_notification, params: parameter, onSuccess: { (result) in
            
            let rootclass = getAllNotificationModel.init(fromJson: result)
            self.getAllNotification = rootclass
            success("Success")

        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
