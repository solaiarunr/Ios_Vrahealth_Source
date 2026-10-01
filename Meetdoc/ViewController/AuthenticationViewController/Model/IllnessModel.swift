 //
 //  IllnessModel.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 16/10/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import Foundation
 import SwiftyJSON


 class IllnessModel{

     var result : [IllnessResultModel]!
     var status : Bool!

     init(fromJson json: JSON!){
         if json.isEmpty{
             return
         }
         result = [IllnessResultModel]()
         let resultArray = json["result"].arrayValue
         for resultJson in resultArray{
             let value = IllnessResultModel(fromJson: resultJson)
             result.append(value)
          }
         status = json["status"].boolValue
     }
 }
 class IllnessResultModel{
    
    var id : Int!
    var name : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        name = json["name"].stringValue
    }
    init(id: Int = 0, name: String = "") {
        self.name = name
        self.id = id
    }
 }
  

