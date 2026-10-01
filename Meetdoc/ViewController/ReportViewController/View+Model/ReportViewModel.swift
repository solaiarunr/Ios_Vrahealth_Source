//
//  ReportViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class ReportViewModel {
    
    var resultModel: SettingModel?
    var reportModel: ReportModel?
    public func Report(onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["language":Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: GetReportList_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ReportModel.init(fromJson: result)
            self.reportModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    
    public func setReportList(user_id: String,doctor_id: String, report_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "doctor_id":doctor_id, "report_id": report_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: REPORT_DOCTOR_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.resultModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func setReportUser(user_id: String,reportuser_id: String, report_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "reportuser_id":reportuser_id, "report_id": report_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: Report_User_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.resultModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
