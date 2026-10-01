//
//  PrescriptionModel.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import SwiftyJSON

class PrescriptionListModel {

    var results : [PrescriptionResultModel]!
    var reservation : ReservationModel!
    var status : Bool!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        let reservationJson = json["reservation"]
        if !reservationJson.isEmpty{
            reservation = ReservationModel(fromJson: reservationJson)
        }
        results = [PrescriptionResultModel]()
        let resultsArray = json["results"].arrayValue
        for resultsJson in resultsArray{
            let value = PrescriptionResultModel(fromJson: resultsJson)
            results.append(value)
        }
        status = json["status"].boolValue
    }
}
class PrescriptionResultModel {

    var direction : [String]!
    var drugStrength : String!
    var duration : String!
    var frequency : String!
    var id : String!
    var instruction : String!
    var medicineName : String!
    var route : String!
    var type : String!
    var prescription_images : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        direction = [String]()
        let directionArray = json["direction"].arrayValue
        for directionJson in directionArray{
            direction.append(directionJson.stringValue)
        }
        drugStrength = json["drug_strength"].stringValue
        duration = json["duration"].stringValue
        frequency = json["frequency"].stringValue
        id = json["id"].stringValue
        instruction = json["instruction"].stringValue
        medicineName = json["medicine_name"].stringValue
        type = json["type"].stringValue
        prescription_images = json["prescription_images"].stringValue
        route = json["route"].stringValue
    }
    init(direction: [String] = [String](), drugStrength: String = "", duration: String = "", frequency: String = "", id: String = "", instruction: String = "", medicineName: String = "", route: String = "") {
        self.direction = direction
        self.drugStrength = drugStrength
        self.duration = duration
        self.frequency = frequency
        self.id = id
        self.instruction = instruction
        self.medicineName = medicineName
        self.route = route
    }
}
class PrescriptionDataModel {
    
    var status : String!
    var results : [PrescriptionDetailsModel]!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        results = [PrescriptionDetailsModel]()
        let resultsArray = json["result"].arrayValue
        for resultsJson in resultsArray{
            let value = PrescriptionDetailsModel(fromJson: resultsJson)
            results.append(value)
        }
        status = json["status"].stringValue
    }
    
}
class PrescriptionDetailsModel {
    
    var medicine_name : String!
    var dosage : String!
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        medicine_name = json["medicine_name"].stringValue
        dosage = json["dosage"].stringValue
    }
    
}
class AddPrescriptionResultModel {

    var message : String!
    var status : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        message = json["message"].stringValue
        status = json["status"].stringValue
    }
}
class ReservationModel {

    var address : String!
    var firstname : String!
    var hostid : String!
    var profileImage : String!
    var slotType : String!

    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        address = json["address"].stringValue
        firstname = json["firstname"].stringValue
        hostid = json["hostid"].stringValue
        profileImage = json["profile_image"].stringValue
        slotType = json["slot_type"].stringValue
    }
}
class medicineListModel : Codable {
    var name : String!
    var medicine_strength : String!
    var frequency : String!
    var duration : String!
    var route : String!
    var direction : [String]!
    var investigation : String!
    var id : String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        medicine_strength = json["medicine_strength"].stringValue
        frequency = json["frequency"].stringValue
        duration = json["duration"].stringValue
        route = json["route"].stringValue
        direction = [String]()
        let imageArray = json["direction"].arrayValue
        for imageData in imageArray{
            direction.append(imageData.stringValue)
        }
        investigation = json["investigation"].stringValue
        id = json["id"].stringValue
    }
}

class filesModel : Codable {
    var symptoms : String!
    var provisional_diagnosis : String!
    var clinical_details : String!
    var instruction : String!
    var additional_instructions : String!
    var medicine_details : [medicineListModel]!
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        symptoms = json["symptoms"].stringValue
        provisional_diagnosis = json["provisional_diagnosis"].stringValue
        clinical_details = json["clinical_details"].stringValue
        instruction = json["instruction"].stringValue
        additional_instructions = json["additional_instructions"].stringValue
        medicine_details = [medicineListModel]()
        let resultsArray = json["medicine_details"].arrayValue
        for resultsJson in resultsArray{
            let value = medicineListModel(fromJson: resultsJson)
            medicine_details.append(value)
        }
        
    }
    
}
