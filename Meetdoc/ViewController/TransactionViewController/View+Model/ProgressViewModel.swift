//
//  ProgressViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class ProgressViewModel {
    
    var transactionModel: TransactionHistoryModel?
    var progressModel: ProgressModel?

    public func getTransactionData(user_id: String,offset: String, limit: String, option: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "offset":offset, "limit":limit, "option":option, "time_zone": "\(Date().timeIntervalSince1970)", "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: API_TRANSACTION_HISTORY, params: parameter, onSuccess: { (result) in
            let rootclass = TransactionHistoryModel.init(fromJson: result)
            self.transactionModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getProgressData(user_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: getDashBoard_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ProgressModel.init(fromJson: result)
            self.progressModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
