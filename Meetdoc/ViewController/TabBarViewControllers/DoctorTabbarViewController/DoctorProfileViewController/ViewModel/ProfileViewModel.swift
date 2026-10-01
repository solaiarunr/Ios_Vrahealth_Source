 //
 //  ProfileViewModel.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 16/10/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import Foundation

 class ProfileViewModel {
    
    var profileModel: DoctorProfileDetailsModel?
    var userProfileModel: UserLoginModel?
    var loginModel: UserLoginModel?
     var deletionModel: UserLoginModel?
    
    public func loadDoctorProfileData(userid: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":userid, "language": Utility.shared.getLanguageCode()]
        
        ParsingFunction().postDataCall(subURl: DOCTOR_PROFILE_API, params: parameter, onSuccess: { (result) in
            let rootclass = DoctorProfileDetailsModel.init(fromJson: result)
            self.profileModel = rootclass
            if rootclass.status && (UserDefaultModule.shared.getLoginData().userId ?? "") == userid {
                let userModel = UserLoginResultModel(email: rootclass.result.email, emailVerified: true, firstName: rootclass.result.fullName, gender: rootclass.result.gender, lastName: rootclass.result.lastName,phoneNumber: "\(rootclass.result.phoneNumber ?? 0)", phoneVerified: true, referalUrl: (UserDefaultModule.shared.getLoginData().referalUrl ?? ""), type: (UserDefaultModule.shared.getLoginData().type ?? ""), userId: userid, userImage: rootclass.result.userImage, message: "", dateOfBirth: (UserDefaultModule.shared.getLoginData().dateOfBirth ?? ""), qualification: rootclass.result.qualification)
                UserDefaultModule.shared.setUserLoginData(userModel)
                
            }
            print(result)
            success(rootclass.status)
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func loadProfileData(userid: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["user_id":userid, "language": Utility.shared.getLanguageCode()]
        
        ParsingFunction().postDataCall(subURl: Get_profile, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.userProfileModel = rootclass
            if rootclass.status && (UserDefaultModule.shared.getLoginData().userId ?? "") == userid {
                let userModel = UserLoginResultModel(email: rootclass.result.email, emailVerified: true, firstName: rootclass.result.firstName, gender: rootclass.result.gender, lastName: rootclass.result.lastName, phoneNumber: "\(rootclass.result.phoneNumber ?? "0")", phoneVerified: true, referalUrl: (UserDefaultModule.shared.getLoginData().referalUrl ?? ""), type: (UserDefaultModule.shared.getLoginData().type ?? ""), userId: userid, userImage: rootclass.result.userImage, message: "", dateOfBirth: (UserDefaultModule.shared.getLoginData().dateOfBirth ?? ""), qualification: rootclass.result.qualification)
                UserDefaultModule.shared.setUserLoginData(userModel)
            }
            print(result)
            success(rootclass.status)
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
     public func accountdeletion(userid: String, onSuccess success: @escaping (UserLoginModel) -> Void, onFailure failure: @escaping (String) -> Void){
         let parameter: [String: Any] = ["user_id":userid, "language": Utility.shared.getLanguageCode()]
         ParsingFunction().postDataCall(subURl: ACCOUNT_DELETION_API, params: parameter, onSuccess: { (result) in
             let rootclass = UserLoginModel.init(fromJson: result)
             self.deletionModel = rootclass
            print(result)
             success(rootclass)
         }){(error) in
             print(error?.localizedDescription ?? "")
             failure(error?.localizedDescription ?? "")
         }
     }
     public func saveProfileData(userid: String, full_name: String, gender: String, phone_number: String, qualification: String, doctor_language: String, certification_upload: String, portfolio_images: String, speciality_id: String, skills: String, bio_description: String, banking_details: String,location_id: String,hospital_id: String,country: String,institute_name: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
             
         let parameter: [String: Any] = ["user_id":userid, "full_name": full_name, "gender": gender, "phone_number": phone_number, "qualification": qualification, "doctor_language": doctor_language, "certification_upload": certification_upload, "portfolio_images": portfolio_images, "speciality_id": speciality_id, "skills": skills, "bio_description": bio_description, "banking_details": banking_details, "language": Utility.shared.getLanguageCode(),"location_id":location_id,"hospital_id":hospital_id,"country":country,"institute_name":institute_name]
             
             ParsingFunction().postDataCall(subURl: DOCTOR_EDIT_PROFILE_URL, params: parameter, onSuccess: { (result) in
                 let rootclass = UserLoginModel.init(fromJson: result)
                 self.loginModel = rootclass
                 print(result)
                 success(rootclass.status)
                 
             }) { (error) in
                 print(error?.localizedDescription ?? "")
                 failure(error?.localizedDescription ?? "")
             }
         }
     public func saveUserProfileData(userid: String, first_name: String, gender: String, phone_number: String,location: String, latitude: String,longitude: String, last_name: String, countryCode: String,address:String,currency_code:String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void){
         let parameter: [String: Any] = ["user_id":userid, "first_name": first_name, "gender": gender, "phone_number": phone_number, "location": location, "latitude": latitude, "longitude": longitude, "last_name":last_name, "language": Utility.shared.getLanguageCode(), "country_code": countryCode,"address":address,"currency_code":currency_code]
        ParsingFunction().postDataCall(subURl: Edit_profile, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    
 }

