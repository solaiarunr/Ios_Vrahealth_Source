//
//  ReviewViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 17/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class ReviewViewModel {
    
    var resultModel: SettingModel?
    var reviewModel: ReviewModelList?

    public func writeReview(user_id: String,doctor_id: String, reservation_id: String,rating: String,review: String,review_id: String, language: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "doctor_id":doctor_id, "reservation_id": reservation_id, "rating": rating, "review": review, "review_id": review_id, "language": Utility.shared.getLanguageCode()]

    
        ParsingFunction().postDataCall(subURl: API_WRITE_REVIEW, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.resultModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getReviewList(user_id: String,type: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":user_id, "type":type, "language": Utility.shared.getLanguageCode()]
       
        ParsingFunction().postDataCall(subURl: get_review, params: parameter, onSuccess: { (result) in
            let rootclass = ReviewModelList.init(fromJson: result)
            self.reviewModel = rootclass
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }

    }
}
