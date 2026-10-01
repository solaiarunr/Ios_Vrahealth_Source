//
//  CallParsingFunction.swift
//  Meetdoc
//
//  Created by BTMani on 23/03/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit
import SwiftyJSON

class CallParsingFunction: ParsingFunction {
    var blockStatus = Bool()
    
    public func getExplorePageData(user_id:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: home_Page_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func listDetailData(user_id: String, list_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: ListDetails_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getMessagePageData(user_id:String,type:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Get_Message_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
//    public func getMyListing(user_id:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
//        // Prepare params
//        let requestDict = NSMutableDictionary.init()
//        requestDict.setValue(user_id, forKey: "user_id")
//        requestDict.setValue(offset, forKey: "offset")
//        requestDict.setValue(limit, forKey: "limit")
//        
//        self.blockResponse = self.blockStatus
//        
//        //make base method call
//        self.ParsingFunctionCall(subURl: MyListingURL as NSString, params: requestDict as! Parameters, onSuccess: {response in
//            success(response)
//        }, onFailure: {errorResponse in
//            failure(errorResponse)
//        })
//    }
    
    public func getSavedList(user_id:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus

 
        self.ParsingFunctionCall(subURl: Get_saved_lists as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getSearchData(user_id:String, check_in:String, check_out:String, search_key:String, lat:String, lon:String, accommodates:String, property_type:String, duration_type:String, room_type:String, bathrooms:String, beds:String, bedrooms:String, price_range:String, amenities:String, offset: String, limit: String, searchtype: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(lat, forKey: "lat")
        requestDict.setValue(lon, forKey: "lon")
        requestDict.setValue(price_range, forKey: "price_range")
        requestDict.setValue(bedrooms, forKey: "bedrooms")
        requestDict.setValue(beds, forKey: "beds")
        requestDict.setValue(bathrooms, forKey: "bathrooms")
        requestDict.setValue(amenities, forKey: "amenities")
        requestDict.setValue(property_type, forKey: "property_type")
        requestDict.setValue(room_type, forKey: "room_type")
        //        requestDict.setValue(instant_book, forKey: "instant_book")
        requestDict.setValue(accommodates, forKey: "accommodates")
        requestDict.setValue(search_key, forKey: "search_key")
        requestDict.setValue(check_in, forKey: "check_in")
        requestDict.setValue(check_out, forKey: "check_out")
        requestDict.setValue(duration_type, forKey: "duration_type")
        requestDict.setValue(limit, forKey: "limit")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(searchtype, forKey: "searchtype")
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Get_search as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    public func getwishListDetail(user_id:String,wish_id:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(wish_id, forKey: "wish_id")
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Get_wish_list_listings as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getUserProfileDetails(user_id:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
//        let requestDict = NSMutableDictionary.init()
//        requestDict.setValue(user_id, forKey: "user_id")
         self.blockResponse = self.blockStatus
        let parameter: [String: Any] = ["user_id": user_id, "language": Utility.shared.getLanguageCode()]

        //make base method call
        self.ParsingFunctionCall(subURl: Get_profile as NSString, params: parameter, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func editProfileData(user_id:String,first_name:String,last_name:String,gender:String,phone_number: String,languages:String, location:String,latitude: String,longitude: String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(first_name, forKey: "first_name")
        requestDict.setValue(last_name, forKey: "last_name")
        requestDict.setValue(gender, forKey: "gender")
         requestDict.setValue(phone_number, forKey: "phone_number")
        requestDict.setValue(languages, forKey: "languages")
        requestDict.setValue(location, forKey: "location")
        requestDict.setValue(latitude, forKey: "latitude")
        requestDict.setValue(longitude, forKey: "longitude")
          self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Edit_profile as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func editUserDescription(user_id:String,about_me:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(about_me, forKey: "about_me")
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Edit_profile as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func editProfileData1(param:Parameters?, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        var requestDict = param
        requestDict?["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
        self.ParsingFunctionCall(subURl: Edit_profile as NSString, params: requestDict!, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func editProfileImageData(param:Parameters?, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        var requestDict = param
        requestDict?["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
        self.ParsingFunctionCall(subURl: API_CHANGE_USERIMAGE as NSString, params: requestDict!, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getSavedListData(user_id:String,list_id:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue("0", forKey: "list_id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Get_saved_lists as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getTripMainPageData(user_id:String,recent:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(recent, forKey: "recent")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: Get_TRIPS_URL as NSString, params: requestDict as? Parameters, onSuccess:
            {
                response in
                success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getNotificationMainPageData(user_id:String,offset:String ,limit :String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        //        let requestDict = NSMutableDictionary.init()
        //        requestDict.setValue(user_id, forKey: "user_id")
        //        requestDict.setValue(offset, forKey: "offset")
        //        requestDict.setValue(limit, forKey: "limit")
        //        self.blockResponse = self.blockStatus
        
        let requestDict:Parameters = ["user_id":user_id, "offset":offset, "limit":limit]
        //make base method call
        self.ParsingFunctionCall(subURl: Get_user_notification as NSString, params: requestDict , onSuccess:
            {
                response in
                success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    public func userLogin(email:String,password :String,language: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(password, forKey: "password")
        requestDict.setValue(language, forKey: "language")
        self.blockResponse = self.blockStatus
        //make base method call
        self.ParsingFunctionCall(subURl: Login_URL as NSString, params: requestDict as? Parameters, onSuccess:
            {
                response in
                success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func socialLogin(first_name: String, last_name: String,email: String,id: String, type: String,  language: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(first_name, forKey: "first_name")
        requestDict.setValue(last_name, forKey: "last_name")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(id, forKey: "id")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(language, forKey: "language")
        
        self.blockStatus = self.blockResponse
        
        self.ParsingFunctionCall(subURl: social_login_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse!)
            failure(errorResponse)
        })
    }
    
    
    public func getAdminList(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.WithOutParamParsingFunctionCall(subURl: Get_admin_datas as NSString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getLanguageDatas(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.WithOutParamParsingFunctionCall(subURl: Get_language_datas as NSString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getSpecialitiesDatas(illness_id: String,hospital_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(illness_id, forKey: "illness_id")
        requestDict.setValue(hospital_id, forKey: "hospital_id")
        
        self.ParsingFunctionCall(subURl: Get_specialities_datas as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    
    public func gethospitalDatas(search: String, offset: String,limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(search, forKey: "search")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        
        self.ParsingFunctionCall(subURl: Get_hospital_datas as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func getInsuranceDatas(offset: String,limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        
        self.ParsingFunctionCall(subURl: Get_Insurance_datas as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func getIllnessDatas(speciality_id: String, offset: String,limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(speciality_id, forKey: "speciality_id")
        requestDict.setValue(offset, forKey: "offset")
         requestDict.setValue(limit, forKey: "limit")
         self.ParsingFunctionCall(subURl: Get_illness_datas as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func addHospitalDatas(hospital_name: String,description: String,location:String,latitude: String,longitude: String,speciality_id: String,insurance_id: String, hospital_logo: String,language:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(hospital_name, forKey: "hospital_name")
        requestDict.setValue(description, forKey: "description")
        requestDict.setValue(location, forKey: "location")
        requestDict.setValue(latitude, forKey: "latitude")
        requestDict.setValue(longitude, forKey: "longitude")
        requestDict.setValue(speciality_id, forKey: "speciality_id")
        requestDict.setValue(insurance_id, forKey: "insurance_id")
        requestDict.setValue(hospital_logo, forKey: "hospital_logo")
        requestDict.setValue(language, forKey: "language")

         self.ParsingFunctionCall(subURl: Add_hospital_datas as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func getInviteFriendsData(user_id: String, email_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(email_id, forKey: "email_id")
        requestDict.setValue(Utility.shared.getLanguageCode(), forKey: "language")
        
        self.ParsingFunctionCall(subURl: Invite_URL as NSString, params: (requestDict as! Parameters), onSuccess: { response in
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    
    
    public func getAdminData(user_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        var userID = user_id
        if user_id == "" {
            userID = "1"
        }
        requestDict.setValue(userID, forKey: "user_id")
        
        self.WithOutParamParsingFunctionCall(subURl: Admin_URL as NSString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
            
        })
    }
 
    public func getHelpData(language: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        self.blockResponse = self.blockStatus
        requestDict.setValue(language, forKey: "language")
        //make base method call
        self.WithOutParamParsingFunctionCall(subURl: Help_URL as NSString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func saveListImages(user_id:String,list_id:String,photo:String,video_url: String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(photo, forKey: "photo")
        requestDict.setValue(video_url, forKey: "video_url")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func addListName(user_id:String,list_id:String,list_name:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(list_name, forKey: "list_name")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func addListDescription(user_id:String,list_id:String,list_des:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(list_des, forKey: "list_des")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func addListNightPrice(user_id:String,list_id:String,price:String,currency_id:String,security_deposit:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(price, forKey: "price")
        requestDict.setValue(currency_id, forKey: "currency_id")
        requestDict.setValue(security_deposit, forKey: "security_deposit")
        
        
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func addListHourlyPrice(user_id:String,list_id:String,hour_price:String,currency_id:String,security_deposit:String,onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(hour_price, forKey: "hour_price")
        requestDict.setValue(currency_id, forKey: "currency_id")
        requestDict.setValue(security_deposit, forKey: "security_deposit")
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getCheckBoxDetails(user_id: String, onSuccess success: @escaping (NotificationSetting) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        
        self.blockResponse = self.blockStatus
        let parameters: Parameters = ["user_id": user_id]
        
        self.postDataCall(subURl: getSettings_URL, params: parameters, onSuccess: { (response) in
            if response["status"].boolValue {
                let setting = NotificationSetting(push_notification: response["result"]["push_notification"].stringValue, text_notification: response["result"]["text_notification"].stringValue, notification_messages: response["result"]["notification_messages"].stringValue, notification_reservation: response["result"]["notification_reservation"].stringValue, email_reservation: response["result"]["email_reservation"].stringValue)
                success(setting)
            }
            else {
            }
            
        }) { (error) in
            failure(error)
        }
        
    }
    
    public func setCheckBoxDetails(user_id: String,requestDict: NSMutableDictionary, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        
        requestDict.setValue(user_id, forKey: "user_id")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: setSettings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
        
    }
    
    public func ChangePassword(user_id: String, oldPassword: String, newPassword: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(oldPassword, forKey: "old_password")
        requestDict.setValue(newPassword, forKey: "new_password")
        
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: changePassword_URL as NSString, params: requestDict as? Parameters, onSuccess: { response in
            print(response)
            success(response)
        }, onFailure: { errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    
    public func getCurrencyList(user_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: CurrencyList_URL as NSString, params: requestDict as? Parameters, onSuccess: { response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    
    public func changeCurrency(user_id: String, Currency_id: String, Currency_name:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(Currency_id, forKey: "currency_id")
        self.ParsingFunctionCall(subURl: ChangeCurrency_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: { errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    public func CreateListing(user_id: String, home_type: String, room_type: String, accomodates: String, city:String, bedrooms: String, beds: String, bathrooms: String, duration_type: String, latitude: String, longitude: String, state: String, country_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFaliure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(home_type, forKey: "home_type")
        requestDict.setValue(room_type, forKey: "room_type")
        requestDict.setValue(accomodates, forKey: "accomodates")
        requestDict.setValue(city, forKey: "city")
        requestDict.setValue(bedrooms, forKey: "bedrooms")
        requestDict.setValue(beds, forKey: "beds")
        requestDict.setValue(bathrooms, forKey: "bathrooms")
        requestDict.setValue(duration_type, forKey: "duration_type")
        requestDict.setValue(latitude, forKey: "latitude")
        requestDict.setValue(longitude, forKey: "longitude")
        requestDict.setValue(state, forKey: "state")
        requestDict.setValue(country_id, forKey: "country_id")
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    public func AmenitiesUpdate(user_id: String, list_id: String, common_amenities: String, additional_amenities: String, safety_features: String, safety_checklist: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(common_amenities, forKey: "common_amenities")
        requestDict.setValue(additional_amenities, forKey: "additional_amenities")
        requestDict.setValue(safety_features, forKey: "special_features")
        requestDict.setValue(safety_checklist, forKey: "safety_checklist")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    public func homeSafeties(user_id: String, list_id: String, fire_extinguisher: String, fire_alarm: String, gas_shutoff: String, emergency_instruction: String, emergency_medical: String, emergency_police: String, emergency_fire: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(fire_extinguisher, forKey: "fire_extinguisher")
        requestDict.setValue(fire_alarm, forKey: "fire_alarm")
        requestDict.setValue(gas_shutoff, forKey: "gas_shutoff")
        requestDict.setValue(emergency_instruction, forKey: "emergency_exit")
        requestDict.setValue(emergency_medical, forKey: "emergency_medical")
        requestDict.setValue(emergency_police, forKey: "emergency_police")
        requestDict.setValue(emergency_fire, forKey: "emergency_fire")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    public func cancellationPolicy(user_id: String, list_id: String, cancellationId: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(cancellationId, forKey: "cancellation_policy")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            print(errorResponse ?? "Error")
            failure(errorResponse)
        })
    }
    public func BookingDetails(user_id: String, list_id: String, BookingStatus: String, homeRules: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(BookingStatus, forKey: "instant_book")
        requestDict.setValue(homeRules, forKey: "home_rules")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func setAddress(user_id: String, list_id: String, country_id: String, street_address: String, apt_address: String, city: String, state: String, zipcode: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(country_id, forKey: "country_id")
        requestDict.setValue(street_address, forKey: "street_address")
        requestDict.setValue(apt_address, forKey: "apt_address")
        requestDict.setValue(city, forKey: "city")
        requestDict.setValue(state, forKey: "state")
        requestDict.setValue(zipcode, forKey: "zipcode")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func listingType(user_id: String, list_id: String, room_id: String, onSuccess success : @escaping (NSDictionary) -> Void, onFailure failure: @escaping(_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(room_id, forKey: "room_type")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess:{response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func propertyType(user_id: String, list_id: String, property_id : String, onSuccess success : @escaping (NSDictionary) -> Void, onFailure failure: @escaping(_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(property_id, forKey: "home_type")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess:{response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func durationType(user_id: String, list_id: String, duration_type: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(duration_type, forKey: "duration_type")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: createListings_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func checkAvailability(list_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(list_id, forKey: "list_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: CheckAvailability_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func checkWishListings(user_id: String, list_id : String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: Get_saved_lists as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func CreateWishListing(user_id: String, wish_name: String, wish_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(wish_name, forKey: "wish_name")
        requestDict.setValue(wish_id, forKey: "wish_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: CreateWishList_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure (errorResponse)
        })
    }
    public func AddandRemoveWishList(user_id: String, list_id: String, wish_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(wish_id, forKey: "wish_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: AddandRemoveWishList_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getSavedWishList(user_id : String, list_id : String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: Get_saved_lists as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getReportList(onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        self.WithOutParamParsingFunctionCall(subURl: GetReportList_URL as NSString, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    public func getReview(user_id: String, type: String, onSuccess success: @escaping ([ReviewStruct]) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
         self.blockResponse = self.blockStatus
        var reviewDataArray = [ReviewStruct]()
        self.ParsingFunctionCall(subURl: get_review as NSString, params: requestDict as? Parameters, onSuccess: {response in
            if let status = response.value(forKey: "status") as? String  {
//                if status != "false" {
//                    let reviewArr = response.value(forKey: "review") as! [Any]
//                    for review in reviewArr {
//                        let reviewData = review as! NSDictionary
//                        let reviewVal = ReviewStruct(list_id: "\(list_id)", list_name: "\(reviewData.value(forKey: "list_name") as? String ?? "")", reviewer_image: "\(reviewData.value(forKey: "reviewer_image")!)", review_date: "\(reviewData.value(forKey: "review_date")!)", review_rating: "\(reviewData.value(forKey: "review_rating")!)", reviewer_id: "\(reviewData.value(forKey: "reviewer_id")!)", reviewer_name: "\(reviewData.value(forKey: "reviewer_name")!)", reviewer_type: "\(reviewData.value(forKey: "reviewer_type") as? String ?? "")", user_review: "\(reviewData.value(forKey: "user_review")!)")
//                        reviewDataArray.append(reviewVal)
//                    }
//                    success(reviewDataArray)
//                }
//                else {
//                    success(reviewDataArray)
//                }
            }        }, onFailure: {errorResponse in
                failure(errorResponse)
        })
    }
    
    public func readReview(user_id: String, list_id: String, offset: String, limit: String, onSuccess success: @escaping ([ReviewStruct]) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus
        var reviewDataArray = [ReviewStruct]()
        self.ParsingFunctionCall(subURl: Read_Review_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            if let status = response.value(forKey: "status") as? String  {
                if status != "false" {
                    let reviewArr = response.value(forKey: "review") as! [Any]
                    for review in reviewArr {
                        let reviewData = review as! NSDictionary
                        let reviewVal = ReviewStruct(list_id: "\(list_id)", list_name: "\(reviewData.value(forKey: "list_name") as? String ?? "")", reviewer_image: "\(reviewData.value(forKey: "reviewer_image")!)", review_date: "\(reviewData.value(forKey: "review_date")!)", review_rating: "\(reviewData.value(forKey: "review_rating")!)", reviewer_id: "\(reviewData.value(forKey: "reviewer_id")!)", reviewer_name: "\(reviewData.value(forKey: "reviewer_name")!)", reviewer_type: "\(reviewData.value(forKey: "reviewer_type") as? String ?? "")", user_review: "\(reviewData.value(forKey: "user_review")!)")
                        reviewDataArray.append(reviewVal)
                    }
                    success(reviewDataArray)
                }
                else {
                    success(reviewDataArray)
                }
            }        }, onFailure: {errorResponse in
                failure(errorResponse)
        })
    }
    public func readHostReview(user_id: String, offset: String, limit: String, onSuccess success: @escaping ([ReviewStruct]) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        var reviewDataArray = [ReviewStruct]()
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: Read_Host_Review_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            if let status = response.value(forKey: "status") as? String  {
//                if status != "false" {
//                    let dict = response.value(forKey: "result") as! NSDictionary
//                    let reviewArr = dict.value(forKey: "review") as! [Any]
//                    for review in reviewArr {
//                        let reviewData = review as! NSDictionary
//                        let reviewVal = ReviewStruct(list_id: "\(reviewData.value(forKey: "list_id")!)", list_name: "\(reviewData.value(forKey: "list_name")!)", reviewer_image: "\(reviewData.value(forKey: "reviewer_image")!)", review_date: "\(reviewData.value(forKey: "review_date")!)", review_rating: "\(reviewData.value(forKey: "review_rating")!)", reviewer_id: "\(reviewData.value(forKey: "reviewer_id")!)", reviewer_name: "\(reviewData.value(forKey: "reviewer_name")!)", reviewer_type: "\(reviewData.value(forKey: "reviewer_type")!)", user_review: "\(reviewData.value(forKey: "user_review")!)")
//                        reviewDataArray.append(reviewVal)
//                    }
//                    success(reviewDataArray)
//                }
//                else {
//                    success(reviewDataArray)
//                }
            }
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getListBookingDetails(user_id: String, list_id: String, start_date: String, end_date: String,type:String,booking_timing:String,id:String,guest_count:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(start_date, forKey: "start_date")
        requestDict.setValue(end_date, forKey: "end_date")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(booking_timing, forKey: "booking_timing")
        requestDict.setValue(id, forKey: "id")
        requestDict.setValue(guest_count, forKey: "guest_count")
        
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: ListBookingDetails as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getDashboardData(user_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: getDashBoard_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
        
    }
    public func getCalendarData(user_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.ParsingFunctionCall(subURl: calendar_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func getBookingData(user_id: String, recent: String, offset: String, time: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue("3", forKey: "user_id")
        requestDict.setValue(recent, forKey: "recent")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(time, forKey:  "limit")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: reservation_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func reportListing(user_id: String, list_id: String, report_id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(list_id, forKey: "list_id")
        requestDict.setValue(report_id, forKey: "report_id")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: REPORT_DOCTOR_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    //public func signUp(first_name: String, last_name: String, email: String, password: String, language: String,
    //                       params: NSMutableDictionary, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
    public func signUp(first_name: String, last_name: String, email: String, password: String, language: String,
                       onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(first_name, forKey: "first_name")
        requestDict.setValue(last_name, forKey: "last_name")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(password, forKey: "password")
        requestDict.setValue(language, forKey: "language")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: Signup_URL as NSString, params: requestDict as? Parameters, onSuccess: { response in
            
            print(response)
            success(response)
        }, onFailure: {errorResonse in
            failure(errorResonse)
        })
    }
    
    
    public func doctorsignUp(full_name: String, email: String, gender: String, password: String,qualification: String, location_id: String, speciality_id: String,doctor_language: String,register_number: String,certification_upload: String,  portfolio_images: String, skills: String, language: String, country: String, phone_number: String, hospital_id: String, bio_description: String, profileImage: String,type:String,currency_code: String,institute_name: String,
                             onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(full_name, forKey: "full_name")
        requestDict.setValue(gender, forKey: "gender")
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(password, forKey: "password")
        requestDict.setValue(qualification, forKey: "qualification")
        requestDict.setValue(location_id, forKey: "location_id")
        requestDict.setValue(speciality_id, forKey: "speciality_id")
        requestDict.setValue(doctor_language, forKey: "doctor_language")
        requestDict.setValue(register_number, forKey: "register_number")
        requestDict.setValue(certification_upload, forKey: "certification_upload")
        requestDict.setValue(portfolio_images, forKey: "portfolio_images")
        requestDict.setValue(skills, forKey: "skills")
        requestDict.setValue(language, forKey: "language")
        requestDict.setValue(country, forKey: "country")
        requestDict.setValue(phone_number, forKey: "phone_number")
        requestDict.setValue(hospital_id, forKey: "hospital_id")
        requestDict.setValue(bio_description, forKey: "bio_description")
        requestDict.setValue(profileImage, forKey: "profile_image")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(currency_code, forKey: "currency_code")
        requestDict.setValue(institute_name, forKey: "institute_name")
//
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: Doctor_SignUp as NSString, params: requestDict as? Parameters, onSuccess: { response in
            
            print(response)
            success(response)
            
        }, onFailure: {errorResonse in
            failure(errorResonse)
        })
    }
    
    public func forgotPassword(email: String,type: String, language: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(email, forKey: "email")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(language, forKey: "language")
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: Forgot_Password_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func searchResult(user_id: String,search_key: String, lat: String, lon: String, offset: String, limit: String, searchtype: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        //        requestDict.setValue(check_in, forKey: "check_in")
        //        requestDict.setValue(check_out, forKey: "check_out")
        requestDict.setValue(search_key, forKey: "search_key")
        requestDict.setValue(lat, forKey: "lat")
        requestDict.setValue(lon, forKey: "lon")
        //        requestDict.setValue(accommodates, forKey: "accommodates")
        //        requestDict.setValue(property_type, forKey: "property_type")
        //        requestDict.setValue(duration_type, forKey: "duration_type")
        //        requestDict.setValue(room_type, forKey: "room_type")
        //        requestDict.setValue(bedrooms, forKey: "bedrooms")
        //        requestDict.setValue(beds, forKey: "beds")
        //        requestDict.setValue(bathrooms, forKey: "bathrooms")
        //        requestDict.setValue(price_range, forKey: "price_range")
        //        requestDict.setValue(amenities, forKey: "amenities")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        requestDict.setValue(searchtype, forKey: "searchtype")
        
        self.blockResponse = self.blockStatus
        
        self.ParsingFunctionCall(subURl: Get_search as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func searchCountryResult(user_id: String, search_key: String, country_id: String,offset: String, limit: String, searchtype: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(search_key, forKey: "search_key")
        requestDict.setValue(country_id, forKey: "country_id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        requestDict.setValue(searchtype, forKey: "searchtype")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: Get_search as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func showAllBtnSearch(user_id: String, type: String, offset: String, limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(type, forKey: "type")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: type_search_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func filterSearch(user_id: String, searchtype: String, accomodates: String, bedrooms: String, beds: String, bathrooms: String, duration_type: String, Price_range: String, room_type: String, amenities: String, property_type: String, offset: String, limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(searchtype, forKey: "searchtype")
        requestDict.setValue(accomodates, forKey: "accomodates")
        requestDict.setValue(bedrooms, forKey: "bedrooms")
        requestDict.setValue(beds, forKey: "beds")
        requestDict.setValue(bathrooms, forKey: "bathrooms")
        requestDict.setValue(duration_type, forKey: "duration_type")
        requestDict.setValue(Price_range, forKey: "Price_range")
        requestDict.setValue(room_type, forKey: "room_type")
        requestDict.setValue(amenities, forKey: "amenities")
        requestDict.setValue(property_type, forKey: "property_type")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: Get_search as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
        
    }
    
    public func cancellationAPI(user_id: String, status: String, id: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(status, forKey: "status")
        requestDict.setValue(id, forKey: "id")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: change_Reservation_Status_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print(response)
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    public func getConversation(user_id: String, id: String, offset: String, limit: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping(_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(id, forKey: "id")
        requestDict.setValue(offset, forKey: "offset")
        requestDict.setValue(limit, forKey: "limit")
        self.blockResponse = self.blockStatus
        self.ParsingFunctionCall(subURl: get_Conversation_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print("response : \(response)")
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func sendConversation(user_id: String, id: String, message: String, receiverId: String, listingId: String, onSuccess success: @escaping(NSDictionary) -> Void, onFailure failure:@escaping(_ error: Error?) -> Void){
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(user_id, forKey: "user_id")
        requestDict.setValue(id, forKey: "id")
        requestDict.setValue(message, forKey: "message")
        requestDict.setValue(receiverId, forKey: "receiverId")
        requestDict.setValue(listingId, forKey: "listingId")
        self.blockResponse = self.blockStatus
        //send_Conversation_URL
        self.ParsingFunctionCall(subURl: send_Conversation_URL as NSString, params: requestDict as? Parameters, onSuccess: {response in
            print("response : \(response)")
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    
    
    // Stripe Acc
    public func getStripeDetails(user_id:String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        let parameters: Parameters = ["user_id": user_id]
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.postCall(subURl: API_GET_HOST_COUNTRY, params: parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
    public func updateStripeDetails(parameters: Parameters, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        // Prepare params
        
        
        self.blockResponse = self.blockStatus
        
        //make base method call
        self.postCall(subURl: API_CREATE_HOST_ACCOUNT, params: parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
            failure(errorResponse)
        })
    }
}

