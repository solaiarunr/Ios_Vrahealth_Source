//
//  FilterListViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON


class FilterListModel {

    var doctors : [WhishedList]!
    var status : Bool!
    var totalListcount : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        doctors = [WhishedList]()
        let doctorsArray = json["doctors"].arrayValue
        for doctorsJson in doctorsArray{
            let value = WhishedList(fromJson: doctorsJson)
            doctors.append(value)
        }
        status = json["status"].boolValue
        totalListcount = json["total_listcount"].stringValue
    }
}

