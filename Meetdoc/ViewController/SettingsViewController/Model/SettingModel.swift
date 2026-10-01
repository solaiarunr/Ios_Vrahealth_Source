//
//  SettingModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class SettingModel {

    var result : String!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }

        result = json["result"].string ?? json["message"].rawString()
        status = json["status"].boolValue
    }
}

class SettingCurrencyModel {
    var currencylist : [Currencylist]!
    var defaultCurrency : String!
    var status : Bool!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        currencylist = [Currencylist]()
        let currencylistArray = json["currencylist"].arrayValue
        for currencylistJson in currencylistArray{
            let value = Currencylist(fromJson: currencylistJson)
            currencylist.append(value)
        }
        defaultCurrency = json["default_currency"].stringValue
        status = json["status"].boolValue
    }
}
class Currencylist{
    var countryCode : String!
    var countryName : String!
    var currencyCode : String!
    var currencyId : String!
    var currencyName : String!
    var currencySymbol : String!
    var minimum_amount: String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        countryCode = json["country_code"].stringValue
        countryName = json["country_name"].stringValue
        currencyCode = json["currency_code"].stringValue
        currencyId = json["currency_id"].stringValue
        currencyName = json["currency_name"].stringValue
        currencySymbol = json["currency_symbol"].stringValue
        minimum_amount = json["minimum_amount"].stringValue
    }
    init(countryCode: String = "", countryName: String = "", currencyCode: String = "", currencyId: String = "", currencyName: String = "", currencySymbol: String = "", minimum_amount: String = "") {
        self.minimum_amount = minimum_amount
        self.currencySymbol = currencySymbol
        self.currencyName = currencyName
        self.currencyId = currencyId
        self.currencyCode = currencyCode
        self.countryName = countryName
        self.countryCode = countryCode
    }
}
