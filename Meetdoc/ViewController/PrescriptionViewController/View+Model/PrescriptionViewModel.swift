//
//  PrescriptionViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class PrescriptionViewModel {
    
    var prescriptionListModel: PrescriptionListModel?
    var addPrescriptionModel: AddPrescriptionResultModel?
    var prescriptionDataModel: PrescriptionDataModel?

    public func getPrescriptionList(user_id: String, booking_id: String,type:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id": user_id,"booking_id": booking_id, "language": Utility.shared.getLanguageCode(),"type":type]
        ParsingFunction().postDataCall(subURl: GET_PRESCRIPTION_URL, params: parameter, onSuccess: { (result) in
            let rootclass = PrescriptionListModel.init(fromJson: result)
            self.prescriptionListModel = rootclass
            success(rootclass.status)
        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func AddPrescription(user_id: String, booking_id: String, medicine_name: String, drug_strength: String, frequency: String, duration: String, route: String, direction: String, instruction: String, prescription_id: String,type: String,prescription_image:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id": user_id,"booking_id": booking_id, "medicine_name": medicine_name, "drug_strength": drug_strength, "frequency": frequency, "duration": duration, "route": route, "direction": direction, "instruction": instruction, "prescription_id": prescription_id, "language": Utility.shared.getLanguageCode(),"type":type,"prescription_image":prescription_image]
        ParsingFunction().postDataCall(subURl: SAVE_PRESCRIPTION_URL, params: parameter, onSuccess: { (result) in
            let rootclass = AddPrescriptionResultModel.init(fromJson: result)
            self.addPrescriptionModel = rootclass
            success((rootclass.status != nil))
        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func deletePrescription(user_id: String, id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id": user_id,"id": id, "language": Utility.shared.getLanguageCode()]
        ParsingFunction().postDataCall(subURl: DELETE_PRESCRIPTION_URL, params: parameter, onSuccess: { (result) in
            let rootclass = AddPrescriptionResultModel.init(fromJson: result)
            self.addPrescriptionModel = rootclass
            success((rootclass.status != nil))
        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func prescriptioList(user_id: String,offset: String,limit: String,key: String,onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        let parameter: [String: Any] = ["user_id": user_id,"language": Utility.shared.getLanguageCode(),"offset": offset,"limit": limit,"key": key]
        ParsingFunction().postDataCall(subURl: PRESCRIPTIONLIST_URL, params: parameter, onSuccess: { (result) in
            let rootclass = PrescriptionDataModel.init(fromJson: result)
            self.prescriptionDataModel = rootclass
            success((rootclass.status != nil))
        }) { (error) in
            failure("Failed to load Data")
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
