//
//  CallViewModel.swift
//  Howzu_swift
//
//  Created by Hitasoft on 01/06/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import Foundation
import SwiftyJSON
class CallViewModel {
    
    var statusModel: CheckChatModel?
    var MakeCall: MakeCallModel?
    var Intimate: IntimateModel?

//    public func makeCall(sender_id: String,receiver_id: String,room_id: String,trigger_type: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
//
//        var language = "";
//        if(UserDefaultModule.shared.getAppLanguage().count > 2)
//        {
//            language   = String(UserDefaultModule.shared.getAppLanguage().lowercased().prefix(2));
//        }
//        let parameter: [String: Any] = ["senderId":sender_id, "receiverId": receiver_id, "room_id":room_id, "platform":"ios","language" : "\(language)", "trigger_type": trigger_type] // , "type": type
//
//        CallParsingFunction().postDataCall(subURl: MAKE_CALL_URL, params: parameter, onSuccess: { (response) in
//            print(response)
//            //            let rootClass = PremiumListModel.init(fromJson: response)
//            //            success(rootClass.status ?? false)
//        }) { (error) in
//            failure(error?.localizedDescription ?? "")
//        }
//    }
    public func makeCall(sender_id: String,receiver_id: String,booking_id: String,trigger_type: String,call_type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {

        var language = "";
        if(UserDefaultModule.shared.getAppLanguage().count > 2)
        {
            language   = String(UserDefaultModule.shared.getAppLanguage().lowercased().prefix(2));
        }
        let parameter: [String: Any] = ["senderId":sender_id, "receiverId": receiver_id, "booking_id":booking_id, "platform":"ios","language" : "\(language)", "trigger_type": trigger_type,"call_type":call_type] // , "type": type
        print(parameter)

        CallParsingFunction().postDataCall(subURl: MAKE_CALL_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = MakeCallModel.init(fromJson: response)
            self.MakeCall = rootClass
            success(rootClass.status ?? false)


            //            let rootClass = PremiumListModel.init(fromJson: response)
            //            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    public func checkChat(sender_id: String,chat_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        var language = "";
        if(UserDefaultModule.shared.getAppLanguage().count > 2)
        {
            language   = String(UserDefaultModule.shared.getAppLanguage().lowercased().prefix(2));
        }
        let parameter: [String: Any] = ["senderId":sender_id, "chat_id": chat_id]
        
        CallParsingFunction().postDataCall(subURl: CHECK_CHAT_ROOM_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = CheckChatModel.init(fromJson: response)
            self.statusModel = rootClass
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
//    public func missedCall(fromId: String,toId: String,token:String, chatId: String,type: String, room_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
//        let parameter: [String: Any] = ["senderId":fromId, "receiverId":toId, "room_id": room_id]
    public func missedCall(fromId: String,toId: String,token:String, chatId: String,type: String, booking_id: String,call_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["senderId":fromId, "receiverId":toId, "booking_id": booking_id]

        CallParsingFunction().postDataCall(subURl: MISSED_CALL_URL, params: parameter, onSuccess: { (response) in
            print(response)
            let rootClass = UserLoginModel.init(fromJson: response)
            if (rootClass.status ?? false) {
                //                self.endCall(sender_id: fromId, receiver_id: toId, room_id: room_id, type: "")
//                self.endCall(sender_id: fromId, receiver_id: toId, room_id: room_id, type: "", trigger_type: "call", chat_id: room_id)
                self.endCall(call_id: call_id)
            }
            success(rootClass.status ?? false)
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    //    public func endCall(sender_id: String,receiver_id: String,room_id:String, type: String, trigger_type: String, chat_id: String) {
    //
    //        var language = "";
    //        if(UserDefaultModule.shared.getAppLanguage().count > 2)
    //        {
    //            language   = String(UserDefaultModule.shared.getAppLanguage().lowercased().prefix(2));
    //        }
    //        let parameter: [String: Any] = ["senderId":sender_id, "receiverId":receiver_id, "room_id": room_id, "chat_id": chat_id, "trigger_type": trigger_type]
    //        CallParsingFunction().postDataCall(subURl: END_CALL_URL, params: parameter, onSuccess: { (response) in
    //            print(response)
    //        }) { (error) in
    //        }
    //    }
    
    public func endCall(call_id: String) {
        
        var language = "";
        if(UserDefaultModule.shared.getAppLanguage().count > 2)
        {
            language   = String(UserDefaultModule.shared.getAppLanguage().lowercased().prefix(2));
        }
        let parameter: [String: Any] = ["call_id": call_id,"user_id": (UserDefaultModule.shared.getLoginData().userId ?? "")]
        CallParsingFunction().postDataCall(subURl: END_CALL_URL, params: parameter, onSuccess: { (response) in
            print(response)
        }) { (error) in
        }
    }
}


class CheckChatModel {
    var call_status: String!
    var status: Bool!
    var message: String!
    var room_id: String!
    init(fromJson json: JSON!) {
        call_status = json["call_status"].stringValue
        status = json["status"].boolValue
        room_id = json["room_id"].stringValue
        message = json["message"].stringValue
    }
}

class IntimateModel {

    var status: Bool!
    var message: String!

    init(fromJson json: JSON!) {
 
        status = json["status"].boolValue
        message = json["message"].stringValue
    }
}

class MakeCallModel {

    
    var status: Bool!
    var call_id: String!
    var redirect_url: String!
    var message: String!
    
    init(fromJson json: JSON!) {
        status = json["status"].boolValue
        call_id = json["call_id"].stringValue
        redirect_url = json["redirect_url"].stringValue
        message = json["message"].stringValue
    }
}
