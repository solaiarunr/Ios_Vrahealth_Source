//
//  HelpModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class HelpModel{
    var result : [HelpResult]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [HelpResult]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = HelpResult(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
class HelpResult{
    var helpId : Int!
    var mainContent : String!
    var subContent : String!
    var title : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        helpId = json["help_id"].intValue
        mainContent = json["main_content"].stringValue
        subContent = json["sub_content"].stringValue
        title = json["title"].stringValue
    }
}

