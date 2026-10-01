//
//  ReportModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReportModel {

    var result : [ReportResultModel]!
    var status : Bool!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [ReportResultModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = ReportResultModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
class ReportResultModel{

    var reportDes : String!
    var reportId : Int!
    var reportName : String!
    var type : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        reportDes = json["report_des"].stringValue
        reportId = json["report_id"].intValue
        reportName = json["report_name"].stringValue
        type = json["type"].stringValue
    }
}
