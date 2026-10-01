//
//  FilterModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class FilterModel {
    var result : [ExploreListing]!
    var resultCount : Int!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [ExploreListing]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = ExploreListing(fromJson: resultJson)
            result.append(value)
        }
        resultCount = json["result_count"].intValue
        status = json["status"].boolValue
    }
}

class FilterData {

    var user_id: String!
    var search: String!
    var speciality_id: LanguageModel!
    var latitude: String!
    var longitude: String!
    var location: String!
    var insurance_id: InsuranceResultModel!
    var illness_id: IllnessResultModel!
    var availability: String!
    var doctor_language: [LanguageModel]!
    var gender: String!
    var isVideovisit: Bool!
    var isNearby: Bool!

    init(user_id:String = UserDefaultModule().getCurrentUserID() as String? ?? "", search:String = "" , speciality_id:LanguageModel = LanguageModel(), latitude:String = "", longitude:String = "", insurance_id:InsuranceResultModel = InsuranceResultModel(), illness_id:IllnessResultModel = IllnessResultModel(), availability:String = "", doctor_language:[LanguageModel] = [LanguageModel](), gender:String = "", isVideovisit:Bool = false, isNearby:Bool = false, location: String = "") {
        self.user_id = user_id
        self.search = search
        self.speciality_id = speciality_id
        self.longitude = longitude
        self.insurance_id = insurance_id
        self.latitude = latitude
        self.illness_id = illness_id
        self.availability = availability
        self.doctor_language = doctor_language
        self.gender = gender
        self.isVideovisit = isVideovisit
        self.isNearby = isNearby
        self.location = location
    }
}
