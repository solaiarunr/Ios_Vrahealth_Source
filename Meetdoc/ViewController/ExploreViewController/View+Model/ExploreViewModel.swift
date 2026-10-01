//
//  ExploreViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class ExploreViewModel {
    
    var exploreData: ExploreDataModel?
    var filterData: FilterListModel?
    var savedList: SavedListModel?
    
    public func getHomeData(user_id: String,offset: String, limit: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "offset": offset, "limit": limit, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: home_Page_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ExploreDataModel.init(fromJson: result)
            self.exploreData = rootclass
            success("Success")
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func likeAct(user_id: String,doctor_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "doctor_id": doctor_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: LIKE_URL, params: parameter, onSuccess: { (result) in
            let rootclass = ExploreDataModel.init(fromJson: result)
//            self.exploreData = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getSearchData(user_id: String,offset: String, speciality_id: String, latitude: String, longitude: String, insurance_id: String, illness_id: String, availability: String, doctor_language: String, gender: String, isVideovisit: String, isNearby: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){

        let parameter: [String: Any] = ["user_id": user_id, "offset": offset, "limit": "10", "speciality_id": speciality_id, "latitude": latitude, "longitude": longitude, "insurance_id": insurance_id, "illness_id": illness_id, "availability": availability, "doctor_language": doctor_language, "gender": gender, "isVideovisit": isVideovisit, "isNearby": isNearby, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: DOCTOR_SEARCH_URL, params: parameter, onSuccess: { (result) in
            let rootclass = FilterListModel.init(fromJson: result)
            self.filterData = rootclass
            success("Success")
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getSpecialistSearchData(user_id: String,offset: String, speciality_id: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "offset": offset, "limit": "20", "speciality_id": speciality_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: FILTER_URL, params: parameter, onSuccess: { (result) in
            let rootclass = FilterListModel.init(fromJson: result)
            self.filterData = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getDoctorSearchData(FilterData: FilterData,offset: String, search: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        

        let languageArray = FilterData.doctor_language.map({"\($0.id ?? 0)"})  ?? [String]()
        var language = [String]()
        for lan in languageArray {
            language.append(lan)
        }
        var totalLanguage = Utility.shared.jsonString(from: language)
        if totalLanguage == "[]" {
            totalLanguage = ""
        }
        let nearby = (FilterData.isNearby ?? false) == false ? "" : "true"
        let videoVisit = (FilterData.isVideovisit ?? false) == false ? "" : "true"
        var insuranceid = "\(FilterData.insurance_id.id ?? 0)"
        insuranceid = insuranceid == "0" ? "" : insuranceid
        var illnessid = "\(FilterData.illness_id.id ?? 0)"
        illnessid = illnessid == "0" ? "" : illnessid
        var speicalityID = ""
        if FilterData.speciality_id != nil {
            speicalityID = "\(FilterData.speciality_id.id ?? 0)"
            speicalityID = speicalityID == "0" ? "" : speicalityID
        }
        

        let parameter: [String: Any] = ["user_id": UserDefaultModule.shared.getLoginData().userId ?? "", "offset": offset, "limit": "20", "speciality_id": speicalityID, "latitude": FilterData.latitude ?? "", "longitude": FilterData.longitude ?? "", "insurance_id": insuranceid, "illness_id": illnessid, "availability": FilterData.availability ?? "", "doctor_language": totalLanguage, "gender": FilterData.gender ?? "male", "isVideovisit": videoVisit, "isNearby": nearby, "language": Utility.shared.getLanguageCode(), "search": search]
    
        ParsingFunction().postDataCall(subURl: DOCTOR_SEARCH_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SavedListModel.init(fromJson: result)
            self.savedList = rootclass
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
