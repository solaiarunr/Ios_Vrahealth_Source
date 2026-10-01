//
//  LanguageViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 15/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class DoctorLanguageModel{

    var result : [LanguageModel]!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        result = [LanguageModel]()
        let resultArray = json["result"].arrayValue
        for resultJson in resultArray{
            let value = LanguageModel(fromJson: resultJson)
            result.append(value)
        }
        status = json["status"].boolValue
    }
}
