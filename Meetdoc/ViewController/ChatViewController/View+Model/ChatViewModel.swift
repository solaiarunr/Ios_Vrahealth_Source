//
//  ChatViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class ChatViewModel {
    
    var chatModel: ChatModel?
    var sendChatModel: SendChatModel?
    var blockModel: BlockModel?

    
    public func getChatData(user_id: String,offset: String, limit: String, id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id":user_id, "offset":offset, "limit":limit, "id":id, "language": Utility.shared.getLanguageCode(),"timezone": timeZoneString]
    
        ParsingFunction().postDataCall(subURl: get_Conversation_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ChatModel.init(fromJson: result)
            self.chatModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func sendChatData(user_id: String,message: String, receiverId: String, listingId: String,id: String,chat_type: String, audio_duration: String,docname: String,lat: String,lon: String,doctype: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "message":message, "receiverId":receiverId, "listingId":"", "id": id, "language": Utility.shared.getLanguageCode(), "chat_type": chat_type, "audio_duration": audio_duration,"docname":docname,"lat":lat,"lon":lon,"doctype": doctype]
//        let parameter: [String: Any] = ["user_id":user_id, "message":message, "receiverId":receiverId, "listingId":"", "id": id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: send_Conversation_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SendChatModel.init(fromJson: result)
            self.sendChatModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    

//    public func getChatData(user_id: String,offset: String, limit: String, id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
//
//        let parameter: [String: Any] = ["user_id":user_id, "offset":offset, "limit":limit, "id":id, "language": Utility.shared.getLanguageCode()]
//
//        ParsingFunction().postDataCall(subURl: get_Conversation_URL, params: parameter, onSuccess: { (result) in
//            let rootclass = ChatModel.init(fromJson: result)
//            self.chatModel = rootclass
//            print(result)
//            success("Success")
//
//        }) { (error) in
//            print(error?.localizedDescription ?? "")
//            failure(error?.localizedDescription ?? "")
//        }
//    }
//    public func sendChatData(user_id: String,message: String, receiverId: String, listingId: String,id: String,chat_type: String, audio_duration: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
//
//        let parameter: [String: Any] = ["user_id":user_id, "message":message, "receiverId":receiverId, "listingId":"", "id": id, "language": Utility.shared.getLanguageCode(), "chat_type": chat_type, "audio_duration": audio_duration]
////        let parameter: [String: Any] = ["user_id":user_id, "message":message, "receiverId":receiverId, "listingId":"", "id": id, "language": Utility.shared.getLanguageCode()]
//
//        ParsingFunction().postDataCall(subURl: send_Conversation_URL, params: parameter, onSuccess: { (result) in
//            let rootclass = SendChatModel.init(fromJson: result)
//            self.sendChatModel = rootclass
//            print(result)
//            success("Success")
//
//        }) { (error) in
//            print(error?.localizedDescription ?? "")
//            failure(error?.localizedDescription ?? "")
//        }
//    }
    public func blockUser(user_id: String,id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "chat_id": id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: BLOCK_URL, params: parameter, onSuccess: { (result) in
            let rootclass = BlockModel.init(fromJson: result)
            self.blockModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
