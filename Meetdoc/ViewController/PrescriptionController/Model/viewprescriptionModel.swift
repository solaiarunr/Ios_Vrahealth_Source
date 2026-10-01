//
//  viewprescriptionModel.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 10/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ViewPrescriptionListModel {

    var result : [ViewPrescriptionResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        result = [ViewPrescriptionResultModel]()
        let resultsArray = json["result"].arrayValue
        for resultsJson in resultsArray{
            let value = ViewPrescriptionResultModel(fromJson: resultsJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}

class ViewPrescriptionResultModel {
     
    var Id : String!
    var doctor_name : String!
    var date : String!
    var time : String!
    var image_precription_url : String!
    var digital_prescription_url : String!
    

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        
        Id = json["Id"].stringValue
        doctor_name = json["doctor_name"].stringValue
        date = json["date"].stringValue
        time = json["time"].stringValue
        image_precription_url = json["image_precription_url"].stringValue
        digital_prescription_url = json["digital_prescription_url"].stringValue
    }
}
