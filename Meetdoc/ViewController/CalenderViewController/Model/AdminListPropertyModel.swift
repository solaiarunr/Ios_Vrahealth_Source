//
//  AdminListPropertyModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class AdminListPropertyModel {

    var result : [AdminPropertyResultModel]!
    var languages : [LanguageModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [AdminPropertyResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = AdminPropertyResultModel(fromJson: resultJson)
            result.append(value)
        }
        languages = [LanguageModel]()
        let languagesArray = json["languages"].arrayValue
        for languagesJson in languagesArray{
            let value = LanguageModel(fromJson: languagesJson)
            languages.append(value)
        }
        status = json["status"].boolValue
    }
}

class AdminPropertyResultModel {

    var content : String!
    var id : Int!
    var policyName : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        content = json["content"].stringValue
        id = json["id"].intValue
        policyName = json["policy_name"].stringValue
    }
    init(content: String = "", id: Int = 0, policyName: String = "") {
        self.policyName = policyName
        self.content = content
        self.id = id
    }
}
