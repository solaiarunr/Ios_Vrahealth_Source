//
//  viewprescriptionViewModel.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 10/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import Foundation
class ViewPrescriptionViewModel {
    
    var prescriptionListModel: ViewPrescriptionListModel?
    
    
    public func getviewPrescriptionList(user_id: String, booking_id: String,type:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let tm = "\(TimeZone.autoupdatingCurrent.description)"
               let zone = tm.components(separatedBy: " ")
               let timeZone = "\(zone.first ?? "")"
        let currentTimeZone = TimeZone.current
        let timeZoneString = currentTimeZone.identifier
        let parameter: [String: Any] = ["user_id": user_id,"booking_id": booking_id, "language": Utility.shared.getLanguageCode(),"type":type,"timeZone":timeZoneString]
        ParsingFunction().postDataCall(subURl: VIEW_PRESCRIPTION, params: parameter, onSuccess: { (result) in
            let rootclass = ViewPrescriptionListModel.init(fromJson: result)
            self.prescriptionListModel = rootclass
            success(rootclass.status)
        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
