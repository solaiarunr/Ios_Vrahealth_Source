//
//  HelpViewModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation


class HelpViewModel {
    
    var helpData: HelpModel?

    public func getHelpList(language: String, onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
       
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(language, forKey: "language")

       // let parameter: [String: Any] = ["": ""]
    
        ParsingFunction().postDataCall(subURl: Help_URL, params: requestDict as! Parameters, onSuccess: { (result) in
            print(result)
            let rootclass = HelpModel.init(fromJson: result)
            self.helpData = rootclass
            success("Success")
            
        }) { (error) in
            failure(error?.localizedDescription ?? "")
        }
    }
    
}
