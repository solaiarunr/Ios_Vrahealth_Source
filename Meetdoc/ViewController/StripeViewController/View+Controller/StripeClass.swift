//
//  StripeClass.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON


class StripeClass {
    var result : StripeResult!
    var status : Bool!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let resultJson = json["result"]
        if !resultJson.isEmpty{
            result = StripeResult(fromJson: resultJson)
        }
        status = json["status"].boolValue
    }
}
class StripeResult {

    var accountId : String!
    var accountNo : String!
    var accountStatus : String!
    var addressLineOne : String!
    var addressLineTwo : String!
    var chargesEnabled : String!
    var city : String!
    var documentstatus: String!
    var country : [StripeCountry]!
    var countryCode : String!
    var countryName : String!
    var currencyCode : String!
    var dateOfBirth : String!
    var email : String!
    var firstName : String!
    var lastName : String!
    var payoutSchedule : String!
    var payoutStatus : String!
    var phone : String!
    var routingNo : String!
    var state : String!
    var type : String!
    var zipcode : String!
    var personalIdNo: String!
    var ssnNo: String!
    var stripe_pending: String!
    var stripe_doc_reason: [String]!

    var selectedCountry: StripeCountry!
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        stripe_doc_reason = [String]()
        let stripeDoc = json["stripe_doc_reason"].arrayValue
        for stripeVal in stripeDoc{
            stripe_doc_reason.append(stripeVal.stringValue)
        }
        accountId = json["account_id"].stringValue
        accountNo = json["account_no"].stringValue
        accountStatus = json["account_status"].stringValue
        addressLineOne = json["address_line_one"].stringValue
        addressLineTwo = json["address_line_two"].stringValue
        chargesEnabled = json["charges_enabled"].stringValue
        stripe_pending = json["stripe_pending"].stringValue
        documentstatus = json["documentstatus"].stringValue
        personalIdNo = json["personal_id_no"].stringValue
        ssnNo = json["ssn_no"].stringValue

        city = json["city"].stringValue
        country = [StripeCountry]()
        let countryArray = json["country"].arrayValue
        for countryJson in countryArray{
            let value = StripeCountry(fromJson: countryJson)
            country.append(value)
        }
        self.selectedCountry = StripeCountry(fromJson: json)
        countryCode = json["country_code"].stringValue
        countryName = json["country_name"].stringValue
        currencyCode = json["currency_code"].stringValue
        dateOfBirth = json["date_of_birth"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        payoutSchedule = json["payout_schedule"].stringValue
        payoutStatus = json["payout_status"].stringValue
        phone = json["phone"].stringValue
        routingNo = json["routing_no"].stringValue
        state = json["state"].stringValue
        type = json["type"].stringValue
        zipcode = json["zipcode"].stringValue
    }
}
class StripeCountry {

    var countryCode : String!
    var countryName : String!
    var currencyCode : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        countryCode = json["country_code"].stringValue
        countryName = json["country_name"].stringValue
        currencyCode = json["currency_code"].stringValue
    }
}

class StripeCountryDetailsModel {
    var country : [StripeCountryDetails]!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        country = [StripeCountryDetails]()
        let countryArray = json["country_details"].arrayValue
        for countryJson in countryArray{
            let value = StripeCountryDetails(fromJson: countryJson)
            country.append(value)
        }
    }
}


class StripeCountryDetails{

    var countryCode : String!
    var accNo: String!
    var routingNo: String!
    var mobileNo: String!
    var mobileFormat: String!
    var mobileCode: String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        countryCode = json["country_code"].stringValue
        accNo = json["acc_no"].stringValue
        routingNo = json["routing_no"].stringValue
        mobileNo = json["mobile_no"].stringValue
        mobileFormat = json["mobile_format"].stringValue
        mobileCode = json["mobile_code"].stringValue
    }
}

