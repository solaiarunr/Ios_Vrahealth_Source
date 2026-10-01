//
//  AdminListModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//


import Foundation
import SwiftyJSON


class AdminListCallModel {
    var result : AdminResultModel!
    var status : Bool!
    var mapKey : String!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = AdminResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
        mapKey = json["googleapikey"].stringValue
    }
}
class AdminResultModel {

    var accommodates : Int!
    var additionalAmenities : [AmenitiesModel]!
    var bathrooms : Int!
    var bedrooms : Int!
    var beds : Int!
    var cancellationPolicy : [CancellationPolicyModel]!
    var commonAmenities : [AmenitiesModel]!
    var country : [CountryModel]!
    var currency : [CurrencyModel]!
    var homeType : [HomeTypeModel]!
    var languages : [LanguageModel]!
    var roomType : [RoomTypeModel]!
    var safetyChecklist : [AmenitiesModel]!
    var safetyFeatures : [AmenitiesModel]!
    var timeZone : [TimeZoneModel]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        accommodates = json["accommodates"].intValue
        additionalAmenities = [AmenitiesModel]()
        let additionalAmenitiesArray = json["additional_amenities"].arrayValue
        for additionalAmenitiesJson in additionalAmenitiesArray{
            let value = AmenitiesModel(fromJson: additionalAmenitiesJson)
            additionalAmenities.append(value)
        }
        bathrooms = json["bathrooms"].intValue
        bedrooms = json["bedrooms"].intValue
        beds = json["beds"].intValue
        cancellationPolicy = [CancellationPolicyModel]()
        let cancellationPolicyArray = json["cancellation_policy"].arrayValue
        for cancellationPolicyJson in cancellationPolicyArray{
            let value = CancellationPolicyModel(fromJson: cancellationPolicyJson)
            cancellationPolicy.append(value)
        }
        commonAmenities = [AmenitiesModel]()
        let commonAmenitiesArray = json["common_amenities"].arrayValue
        for commonAmenitiesJson in commonAmenitiesArray{
            let value = AmenitiesModel(fromJson: commonAmenitiesJson)
            commonAmenities.append(value)
        }
        country = [CountryModel]()
        let countryArray = json["country"].arrayValue
        for countryJson in countryArray{
            let value = CountryModel(fromJson: countryJson)
            country.append(value)
        }
        currency = [CurrencyModel]()
        let currencyArray = json["currency"].arrayValue
        for currencyJson in currencyArray{
            let value = CurrencyModel(fromJson: currencyJson)
            currency.append(value)
        }
        homeType = [HomeTypeModel]()
        let homeTypeArray = json["home_type"].arrayValue
        for homeTypeJson in homeTypeArray{
            let value = HomeTypeModel(fromJson: homeTypeJson)
            homeType.append(value)
        }
        languages = [LanguageModel]()
        let languagesArray = json["languages"].arrayValue
        for languagesJson in languagesArray{
            let value = LanguageModel(fromJson: languagesJson)
            languages.append(value)
        }
        roomType = [RoomTypeModel]()
        let roomTypeArray = json["room_type"].arrayValue
        for roomTypeJson in roomTypeArray{
            let value = RoomTypeModel(fromJson: roomTypeJson)
            roomType.append(value)
        }
        safetyChecklist = [AmenitiesModel]()
        let safetyChecklistArray = json["safety_checklist"].arrayValue
        for safetyChecklistJson in safetyChecklistArray{
            let value = AmenitiesModel(fromJson: safetyChecklistJson)
            safetyChecklist.append(value)
        }
        safetyFeatures = [AmenitiesModel]()
        let safetyFeaturesArray = json["safety_features"].arrayValue
        for safetyFeaturesJson in safetyFeaturesArray{
            let value = AmenitiesModel(fromJson: safetyFeaturesJson)
            safetyFeatures.append(value)
        }
        timeZone = [TimeZoneModel]()
        let timeZoneArray = json["time_zone"].arrayValue
        for timeZoneJson in timeZoneArray{
            let value = TimeZoneModel(fromJson: timeZoneJson)
            timeZone.append(value)
        }
    }
}
class AmenitiesModel{

    var id : Int!
    var image : String!
    var name : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(id : Int = 0, image : String = "", name : String = "") {
        self.id = id
        self.image = image
        self.name = name
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        if let idVal = json["id"].int {
            id = idVal
        }
        else {
            id = json["type_id"].intValue
        }
        if let imageVal = json["image"].string {
            image = imageVal
        }
        else {
            image = json["amenities_image"].stringValue
        }
        
        if let nameVal = json["name"].string {
            name = nameVal
        }
        else {
            name = json["type_name"].stringValue
        }
    }
}
class CancellationPolicyModel{
    var cancelfrom : Int!
    var cancelto : Int!
    var descriptionField : String!
    var id : Int!
    var name : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        cancelfrom = json["cancelfrom"].intValue
        cancelto = json["cancelto"].intValue
        descriptionField = json["description"].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
class CountryModel {
    var id : Int!
    var name : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}
class CurrencyModel{
    var code : String!
    var id : Int!
    var symbol : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        id = json["id"].intValue
        symbol = json["symbol"].stringValue
    }
}
class HomeTypeModel{
    var id : Int!
    var name : String!
    var priority : String!
    
    init(id : Int = 0, name : String = "", priority : String = "") {
        self.id = id
        self.name = name
    }
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        priority = json["priority"].stringValue
    }
}
class LanguageModel: Codable {
    var id : Int!
    var name : String!
    var lname : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].int ?? json["name"].intValue
        name = json["name"].stringValue
        lname = json["lname"].stringValue
    }
    init(id: Int = 0, name: String = "", lname: String = "") {
        self.name = name
        self.id = id
        self.lname = lname
    }
}
class RoomTypeModel {
    var id : Int!
    var name : String!
    
    init(id : Int = 0, name : String = "") {
        self.id = id
        self.name = name
    }
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
}

class TimeZoneModel {
    var country : String!
    var id : Int!
    var zone : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        country = json["country"].stringValue
        id = json["id"].intValue
        zone = json["zone"].stringValue
    }
}
class TimeZoneRsult {
    
    var result : [TimeZoneModel]!
    var status : Bool!
        /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [TimeZoneModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = TimeZoneModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
