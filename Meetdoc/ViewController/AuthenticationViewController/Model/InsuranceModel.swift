//
//  InsuranceModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 15/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class InsuranceModel{

    var result : [InsuranceResultModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [InsuranceResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = InsuranceResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
class InsuranceResultModel{

    var id : Int!
    var name : String!
    var subPlan : [SubPlanModel]!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
        subPlan = [SubPlanModel]()
        let subPlanArray = json["sub_plan"].arrayValue
        for subPlanJson in subPlanArray{
            let value = SubPlanModel(fromJson: subPlanJson)
            subPlan.append(value)
        }
    }
    init(id: Int = 0, name: String = "", subPlan: [SubPlanModel] = [SubPlanModel]()) {
        self.id = id
        self.name = name
        self.subPlan = subPlan
    }
}
class SubPlanModel {

    var id : Int!
    var name : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
    init(id: Int = 0, name: String = "") {
        self.name = name
        self.id = id
    }
}
