//
//  InboxViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class InboxViewModel {
    
    var inboxModel: InboxModel?

    public func getInboxData(user_id: String,offset: String, limit: String, type: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
//        let parameter: [String: Any] = ["user_id":user_id, "offset":offset, "limit":limit, "type":type]
        let parameter: [String: Any] = ["user_id":user_id, "type":type, "language": Utility.shared.getLanguageCode(),"timezone": timeZoneString]

    
        ParsingFunction().postDataCall(subURl: Get_Message_URL, params: parameter, onSuccess: { (result) in
            let rootclass = InboxModel.init(fromJson: result)
            self.inboxModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
