//
//  SavedListViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 18/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class SavedListViewModel {
    
    var savedData: SavedListModel?
    var whishedData: FilterModel?
    var resultData: SettingModel?

    public func getSavedList(user_id: String,offset: String, limit: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "offset": offset, "limit": limit, "language": Utility.shared.getLanguageCode()]

        ParsingFunction().postDataCall(subURl: Get_saved_lists, params: parameter, onSuccess: { (result) in
            let rootclass = SavedListModel.init(fromJson: result)
            self.savedData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getWishedList(user_id: String, wish_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "wish_id":wish_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: Get_wish_list_listings, params: parameter, onSuccess: { (result) in
            let rootclass = FilterModel.init(fromJson: result)
            self.whishedData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func AddAndRemoveList(user_id: String, wish_id: String, list_id: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "wish_id":wish_id, "list_id": list_id, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: AddandRemoveWishList_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SettingModel.init(fromJson: result)
            self.resultData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func CreateWishList(user_id: String, wish_id: String,wish_name:String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id": user_id, "wish_id":wish_id, "wish_name":wish_name, "language": Utility.shared.getLanguageCode()]
    
        ParsingFunction().postDataCall(subURl: CreateWishList_URL, params: parameter, onSuccess: { (result) in
            let rootclass = SavedListModel.init(fromJson: result)
            self.savedData = rootclass
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
}
