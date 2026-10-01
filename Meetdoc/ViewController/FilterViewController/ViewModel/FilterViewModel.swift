//
//  FilterViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation

class FilterViewModel {
    
    var filterData: FilterModel?
    
    public func getFilterData(filterStuct: FilterData, offset: String, limit: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
//        let parameter: [String: Any] = ["user_id":filterStuct.user_id!, "check_in":filterStuct.check_in!, "check_out":filterStuct.check_out!, "search_key":filterStuct.search_key!, "lat":filterStuct.lat!, "lon":filterStuct.lon!, "accommodates":filterStuct.accommodates!, "property_type":filterStuct.property_type!, "duration_type": filterStuct.duration_type!, "room_type":filterStuct.room_type!, "bedrooms":filterStuct.bedrooms!, "beds":filterStuct.beds!,"bathrooms":filterStuct.bathrooms!, "price_range":filterStuct.price_range!, "amenities":filterStuct.amenities!, "offset":offset, "limit":limit, "searchtype": filterStuct.searchtype!]
//    print(parameter)
//        ParsingFunction().postDataCall(subURl: Get_search, params: parameter, onSuccess: { (result) in
//            let rootclass = FilterModel.init(fromJson: result)
//            self.filterData = rootclass
//            success("Success")
//
//        }) { (error) in
//            print(error?.localizedDescription ?? "")
//            failure(error?.localizedDescription ?? "")
//        }
    }
}
