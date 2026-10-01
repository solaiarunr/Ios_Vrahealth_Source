//
//  HospitalModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 15/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class HospitalModel{

    var result : [HospitalResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [HospitalResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = HospitalResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
class HospitalResultModel{

    var id : Int!
    var locations : [LocationModel]!
    var name : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        locations = [LocationModel]()
        let locationsArray = json["locations"].arrayValue
        for locationsJson in locationsArray{
            let value = LocationModel(fromJson: locationsJson)
            locations.append(value)
        }
        name = json["name"].stringValue
    }
    init(id: Int = 0, name: String = "") {
        self.id = id
        self.name = name
    }
}
class LocationModel{

    var id : Int!
    var location : String!
    var latitude : String!
    var longitude : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        latitude = json["latitude"].stringValue
        location = json["location"].stringValue
        longitude = json["longitude"].stringValue
    }
    init(id: Int = 0, location: String = "") {
        self.id = id
        self.location = location
    }
}
class AddHospitalModel {

    var result : AddHospitalResultModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = AddHospitalResultModel(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class AddHospitalResultModel {

    var hospitalId : Int!
    var hospitalName : String!
    var location : String!
    var locationId : Int!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        hospitalId = json["hospital_id"].intValue
        hospitalName = json["hospital_name"].stringValue
        location = json["location"].stringValue
        locationId = json["location_id"].intValue
    }
}
