//
//  SavedListModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 18/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class SavedListModel {

    var result : [WhishedList]!
    var status : Bool!
    var resultCount : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [WhishedList]()
        
        if let resultArray = json["result"].array {
            for resultJson in resultArray{
                let value = WhishedList(fromJson: resultJson)
                result.append(value)
            }
        }
        else {
            if let resultArray = json["result"].dictionary {
                let value = WhishedList(fromJson: json["result"])
                result.append(value)
             }
        }
        resultCount = json["result_count"].intValue

        status = json["status"].boolValue
    }

}

class WhishedList {
    
    var averageRating : String!
    var doctorId : String!
    var doctorImage : String!
    var doctorName : String!
    var isliked : Bool!
    var isVideovisit : Bool!
    var totalReview : String!
    var speciality : [String]!
    var name : String!
    var institute_name : String!
    var doctor_qualification : String!
    var doctor_location : String!
    var languages : [String]!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        averageRating = json["average_rating"].stringValue
        doctorId = json["doctor_id"].stringValue
        doctorImage = json["doctor_image"].stringValue
        doctorName = json["doctor_name"].stringValue
        isliked = json["isliked"].boolValue
        isVideovisit = json["isVideovisit"].boolValue
        speciality = [String]()
        let specialityArray = json["speciality"].arrayValue
        for specialityJson in specialityArray{
            let value = specialityJson["name"].stringValue
            speciality.append(value)
        }
        name = json["name"].stringValue
        totalReview = json["total_review"].stringValue
        institute_name = json["institute_name"].stringValue
        doctor_qualification = json["doctor_qualification"].stringValue
        doctor_location = json["doctor_location"].stringValue
        languages = [String]()
        let languagesArray = json["doctor_languages"].arrayValue
        for languagesJson in languagesArray{
            languages.append(languagesJson.stringValue)
        }
    }
}
 
