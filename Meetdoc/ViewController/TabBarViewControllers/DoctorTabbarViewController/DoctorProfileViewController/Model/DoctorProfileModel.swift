//
//  DoctorProfileModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON
class DoctorProfileModel {
    let title: String!
    let image: String!
    init(title: String, image: String) {
        self.title = title
        self.image = image
    }
}


class DoctorProfileDetailsModel {

    var result : DoctorProfileResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = DoctorProfileResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}

class DoctorProfileResultModel {

    var bioDescription : String!
    var certificationUpload : [ImageResultModel]!
    var email : String!
    var fullName : String!
    var lastName : String!
    var gender : String!
    var hospitalId : String!
    var location_id : String!
    var hospitalName : String!
    var languages : [LanguageModel]!
    var latitude : String!
    var location : String!
    var longitude : String!
    var phoneNumber : Int!
    var portfolioImages : [ImageResultModel]!
    var qualification : String!
    var institute : String!
    var registerNumber : String!
    var skills : String!
    var speciality : [LanguageModel]!
    var type : String!
    var userId : String!
    var userImage : String!
    var bankdetails : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        bioDescription = json["bio_description"].stringValue.html2String
        bankdetails = json["banking_details"].stringValue
        certificationUpload = [ImageResultModel]()
        let certificationUploadArray = json["certification_upload"].arrayValue
        for certificationUploadJson in certificationUploadArray{
            let value = ImageResultModel(fromJson: certificationUploadJson)
            certificationUpload.append(value)
        }
        email = json["email"].stringValue
        fullName = json["full_name"].stringValue
        lastName = json["last_name"].stringValue
        gender = json["gender"].stringValue
        hospitalId = json["hospital_id"].stringValue
        hospitalName = json["hospital_name"].stringValue
        languages = [LanguageModel]()
        let languagesArray = json["languages"].arrayValue
        for languagesJson in languagesArray{
            let lan = LanguageModel(fromJson: languagesJson)
            languages.append(lan)
        }
        latitude = json["latitude"].stringValue
        location = json["location"].stringValue
        longitude = json["longitude"].stringValue
        phoneNumber = json["phone_number"].intValue
        portfolioImages = [ImageResultModel]()
        let portfolioImagesArray = json["portfolio_images"].arrayValue
        for portfolioImagesJson in portfolioImagesArray{
            let value = ImageResultModel(fromJson: portfolioImagesJson)
            portfolioImages.append(value)
        }
        qualification = json["qualification"].stringValue
        institute = json["institute"].stringValue
        registerNumber = json["register_number"].stringValue
        skills = json["skills"].stringValue
        speciality = [LanguageModel]()
        let specialityArray = json["speciality"].arrayValue
        for specialityJson in specialityArray{
            let value = LanguageModel(fromJson: specialityJson)
            speciality.append(value)
        }
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        userImage = json["user_image"].stringValue
        location_id = json["location_id"].stringValue
    }
}
