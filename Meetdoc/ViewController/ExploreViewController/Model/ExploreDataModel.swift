//
//  ExploreDataModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 19/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage

class ExploreDataModel {

    var specialities : [SpecialityModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        specialities = [SpecialityModel]()
        let specialitiesArray = json["specialities"].arrayValue
        for specialitiesJson in specialitiesArray{
            let value = SpecialityModel(fromJson: specialitiesJson)
            specialities.append(value)
        }
        status = json["status"].boolValue
    }
}

class SpecialityModel {

    var doctors : [DoctorModel]!
    var specialityId : String!
    var specialityName : String!
    var totalListcount : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        doctors = [DoctorModel]()
        let doctorsArray = json["doctors"].arrayValue
        for doctorsJson in doctorsArray{
            let value = DoctorModel(fromJson: doctorsJson)
            doctors.append(value)
        }
        specialityId = json["speciality_id"].stringValue
        specialityName = json["speciality_name"].stringValue
        totalListcount = json["total_listcount"].stringValue
    }
    static func == (lhs: SpecialityModel, rhs: SpecialityModel) -> Bool {
        return lhs.specialityId == rhs.specialityId
    }
}
class DoctorModel {

    var averageRating : String!
    var doctorId : String!
    var doctorImage : String!
    var doctorName : String!
    var isliked : Bool!
    var totalReview : String!
    var isVideovisit: Bool!
    var institute_name: String!
    var doctor_qualification: String!
    var doctor_location: String!
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
        totalReview = json["total_review"].stringValue
        isVideovisit = json["isVideovisit"].boolValue
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
