//
//  DoctorModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class DoctorDetailsModel{

    var result : DoctorResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = DoctorResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class DoctorResultModel{

    var averageRating : String!
    var bioDescription : String!
    var bookingType : String!
    var certificationUpload : [ImageResultModel]!
    var doctorId : String!
    var doctorImage : String!
    var doctorName : String!
    var consultFees : String!
    var gender : String!
    var hospitalId : String!
    var hospitalName : String!
    var insurancelist : [InsuranceResultModel]!
    var isliked : Bool!
    var languages : [String]!
    var latitude : String!
    var location : String!
    var longitude : String!
    var portfolioImages : [ImageResultModel]!
    var qualification : String!
    var Institute : String!
    var registerNumber : String!
    var reportId : String!
    var reviews : [ReviewModel]! // Need to change into review Model
    var shareUrl : String!
    var skills : String!
    var slotBookingtype : String!
    var speciality : [LanguageModel]!
    var totalReview : String!
    var offdate : [Int]!
    var isVideovisit : Bool!
    var currencyValue: String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        averageRating = json["average_rating"].stringValue
        bioDescription = json["bio_description"].stringValue
        bookingType = json["booking_type"].stringValue
//        consultFees = json["consult_fees"].intValue
        consultFees = String(format: "%.2f", (json["consult_fees"].stringValue.replacingOccurrences(of: ",", with: "")).doubleValue)

        certificationUpload = [ImageResultModel]()
        let certificationUploadArray = json["certification_upload"].arrayValue
        for certificationUploadJson in certificationUploadArray{
            let value = ImageResultModel(fromJson: certificationUploadJson)
            certificationUpload.append(value)
        }
        offdate = [Int]()
        let offdateArray = json["offdate"].arrayValue
        for offdateJson in offdateArray{
            offdate.append(offdateJson.intValue)
        }
        doctorId = json["doctor_id"].stringValue
        doctorImage = json["doctor_image"].stringValue
        doctorName = json["doctor_name"].stringValue
        gender = json["gender"].stringValue
        hospitalId = json["hospital_id"].stringValue
        hospitalName = json["hospital_name"].stringValue
        insurancelist = [InsuranceResultModel]()
        let insurancelistArray = json["insurancelist"].arrayValue
        for insurancelistJson in insurancelistArray{
            let value = InsuranceResultModel(fromJson: insurancelistJson)
            insurancelist.append(value)
        }
        isliked = json["isliked"].boolValue
        languages = [String]()
        let languagesArray = json["languages"].arrayValue
        for languagesJson in languagesArray{
            languages.append(languagesJson.stringValue)
        }
        latitude = json["latitude"].stringValue
        location = json["location"].stringValue
        longitude = json["longitude"].stringValue
        portfolioImages = [ImageResultModel]()
        let portfolioImagesArray = json["portfolio_images"].arrayValue
        for portfolioImagesJson in portfolioImagesArray{
            let value = ImageResultModel(fromJson: portfolioImagesJson)
            portfolioImages.append(value)
        }
        qualification = json["qualification"].stringValue
        Institute = json["institute_name"].stringValue
        registerNumber = json["register_number"].stringValue
        reportId = json["report_id"].stringValue
        reviews = [ReviewModel]()
        let reviewsArray = json["reviews"].arrayValue
        for reviewsJson in reviewsArray{
            let value = ReviewModel(fromJson: reviewsJson)
            reviews.append(value)
        }
        shareUrl = json["share_url"].stringValue
        skills = json["skills"].stringValue
        slotBookingtype = json["slot_bookingtype"].stringValue
        speciality = [LanguageModel]()
        let specialityArray = json["speciality"].arrayValue
        for specialityJson in specialityArray{
            let value = LanguageModel(fromJson: specialityJson)
            speciality.append(value)
        }
        totalReview = json["total_review"].stringValue
        isVideovisit = json["isVideovisit"].boolValue
        currencyValue = json["currency_value"].stringValue
    }
    init(averageRating : String = "", bioDescription : String = "", bookingType : String = "", certificationUpload: [ImageResultModel] = [ImageResultModel](), doctorId : String = "", doctorImage : String = "", consultFees : String = "", gender : String = "", hospitalId : String = "", hospitalName : String = "", insurancelist : [InsuranceResultModel] = [InsuranceResultModel](), isliked : Bool = false, languages : [String] = [String](), latitude : String = "", location : String = "", portfolioImages : [ImageResultModel] = [ImageResultModel](), qualification : String = "", registerNumber : String = "", reportId : String = "", reviews : [ReviewModel] = [ReviewModel](), shareUrl : String = "", skills : String = "", slotBookingtype : String = "", speciality : [LanguageModel] = [LanguageModel](), totalReview : String = "", offdate : [Int] = [Int](), isVideovisit : Bool = false, currencyValue: String = "") {
        self.averageRating = averageRating
        self.bioDescription = bioDescription
        self.bookingType = bookingType
        self.certificationUpload = certificationUpload
        self.doctorId = doctorId
        self.doctorImage = doctorImage
        self.consultFees = consultFees
        self.gender = gender
        self.hospitalId = hospitalId
        self.hospitalName = hospitalName
        self.insurancelist = insurancelist
        self.isliked = isliked
        self.languages = languages
        self.latitude = latitude
        self.location = location
        self.portfolioImages = portfolioImages
        self.qualification = qualification
        self.registerNumber = registerNumber
        self.reportId = reportId
        self.reviews = reviews
        self.shareUrl = shareUrl
        self.skills = skills
        self.slotBookingtype = slotBookingtype
        self.speciality = speciality
        self.totalReview = totalReview
        self.offdate = offdate
        self.isVideovisit = isVideovisit
        self.currencyValue = currencyValue
    }
}


