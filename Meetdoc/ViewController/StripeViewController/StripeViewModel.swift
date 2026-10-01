//
//  StripeViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 24/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class StripeViewModel {
    
    var currencyData: SettingCurrencyModel?
    var settingData: SettingModel?
    
    public func addHostAccount(user_id: String, country_code: String, country_name: String,currency_code: String,first_name: String,last_name:String, phone:String,account_no:String, routing_no: String, personal_id_no:String,ssn_no: String,  address_line_one: String, address_line_two: String,city: String,state: String, zipcode: String,birth_day: String,birth_month: String, birth_year:String,email:String,stripe_proof:String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        var parameter: [String: Any] = ["user_id": user_id, "country_code":country_code,"country_name":country_name, "currency_code":currency_code, "first_name": first_name, "last_name":last_name, "phone": phone, "email": email,"stripe_proof": stripe_proof, "language": Utility.shared.getLanguageCode()]
        if account_no != "" {
            parameter["account_no"] = account_no
        }
        if routing_no != "" {
            parameter["routing_no"] = routing_no
        }
        if personal_id_no != "" {
            parameter["personal_id_no"] = personal_id_no
        }
        if address_line_one != "" {
            parameter["address_line_one"] = address_line_one
        }
        if ssn_no != "" {
            parameter["ssn_no"] = ssn_no
        }
        if address_line_two != "" {
            parameter["address_line_two"] = address_line_two
        }
        if city != "" {
            parameter["city"] = city
        }
        if state != "" {
            parameter["state"] = state
        }
        if zipcode != "" {
            parameter["zipcode"] = zipcode
        }
        if birth_day != "" {
            parameter["birth_day"] = birth_day
        }
        if birth_month != "" {
            parameter["birth_month"] = birth_month
        }
        if birth_year != "" {
            parameter["birth_year"] = birth_year
            parameter["date_of_birth"] = "\(birth_day)-\(birth_month)-\(birth_year)"
        }

        ParsingFunction().postDataCall(subURl: API_CREATE_HOST_ACCOUNT, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.settingData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }

}
