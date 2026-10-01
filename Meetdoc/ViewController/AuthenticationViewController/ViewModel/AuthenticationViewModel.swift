 //
 //  AuthenticationViewModel.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 13/10/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import Foundation
 
 class AuthenticationViewModel {
    
    var resultModel: SettingModel?
    var loginModel: UserLoginModel?
    var languageModel: AdminListPropertyModel?
    var specialitiesModel: DoctorLanguageModel?
    var hospitalModel: HospitalModel?
    var insuranceModel: InsuranceModel?
    var addHospitalModel: AddHospitalModel?
    var illnessModel: IllnessModel?
    var dcModel: DCLoginModel?
    var adminData: AdminDataModel?
    
    public func Report(onSuccess success: @escaping (String) -> Void, onFailure failure: @escaping (String) -> Void){
        
        let parameter: [String: Any] = ["":""]
        
        ParsingFunction().postDataCall(subURl: GetReportList_URL, params: parameter, onSuccess: { (result) in
            print(result)
            success("Success")
            
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func SocialLogin(first_name: String, last_name: String, email: String, id: String, type: String, gender: String, language: String, image_url: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let parameter: [String: Any] = ["first_name":first_name, "last_name": last_name, "email": email, "id": id, "type": type,"gender": gender, "language": language, "image_url": image_url]
        
        ParsingFunction().postDataCall(subURl: social_login_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func loginData(email: String, password: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let parameter: [String: Any] = ["email":email, "password": password, "language": Utility.shared.getLanguageCode(), "type": type]
        
        ParsingFunction().postDataCall(subURl: Login_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            DispatchQueue.main.async {
                if (UserDefaultModule.shared.getLoginData().userId ?? "") != "" {
                    SettingViewModel().getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), onSuccess: { (success) in
                        print(success)
                    }) { (fail) in
                        print(fail)
                    }
                }
            }
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
     public func DcLoginData(email: String, password: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
         
         let parameter: [String: Any] = ["email":email, "password": password, "language": Utility.shared.getLanguageCode(), "type": type]
         
         ParsingFunction().postDataCall(subURl: Login_URL, params: parameter, onSuccess: { (result) in
             let rootclass = UserLoginModel.init(fromJson: result)
             self.loginModel = rootclass
             print(result)
             DispatchQueue.main.async {
                 if (UserDefaultModule.shared.getLoginData().userId ?? "") != "" {
                     SettingViewModel().getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), onSuccess: { (success) in
                         print(success)
                     }) { (fail) in
                         print(fail)
                     }
                 }
             }
             success(rootclass.status)
         }) { (error) in
             print(error?.localizedDescription ?? "")
             failure(error?.localizedDescription ?? "")
         }
     }
     public func MobileLogin(mobilenumber: String, type: String,currency_code: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
         let parameter: [String: Any] = ["mobilenumber":mobilenumber, "type": type, "language": Utility.shared.getLanguageCode(),"currency_code": currency_code]
        
        ParsingFunction().postDataCall(subURl: MOBILE_LOGIN_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            DispatchQueue.main.async {
                if (UserDefaultModule.shared.getLoginData().userId ?? "") != "" {
                    SettingViewModel().getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), onSuccess: { (success) in
                        print(success)
                    }) { (fail) in
                        print(fail)
                    }
                }
            }
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
     public func emailValidate(inputvalue: String,type: String,currency_code: String,  onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
//        let parameter: [String: Any] = ["email":inputvalue, "language": Utility.shared.getLanguageCode()]
         let parameter: [String: Any] = ["inputvalue":inputvalue, "type": type, "language": Utility.shared.getLanguageCode(),"currency_code":currency_code]

        ParsingFunction().postDataCall(subURl: email_Validate, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
     public func SignUpData(first_name: String, last_name: String, email: String, password: String, phoneNumber: String = "",type: String,currency_code: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
         var parameter: [String: Any] = ["first_name":first_name, "last_name": last_name, "email": email, "password": password, "language": Utility.shared.getLanguageCode(),"type":type,"currency_code":currency_code]
 
        parameter["phone_number"] = phoneNumber
        
        ParsingFunction().postDataCall(subURl: Signup_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            if rootclass.status != nil{
                success(rootclass.status)
             }
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
     public func DcSignUpData(full_name: String,last_name: String, email: String, password: String, phoneNumber: String = "", address: String, profile_img: String,type:String,currency_code: String,gender: String, onsuccess success: @escaping (DCLoginModel) -> Void, onFailure failure: @escaping (String) -> Void) {
         
         var parameter: [String: Any] = ["full_name":full_name, "email": email, "password": password,"address": address, "profile_image": profile_img, "language": Utility.shared.getLanguageCode(),"type":type,"currency_code":currency_code,"last_name":last_name,"gender":gender]
         
         parameter["phone_number"] = phoneNumber
         
         ParsingFunction().postDataCall(subURl: DCSIGNUP_URL, params: parameter, onSuccess: { (response) in
             let rootclass = DCLoginModel.init(fromJson: response)
             self.dcModel = rootclass
             print(response)
             if rootclass.status != nil{
                 success(rootclass)
              }
         }) { (error) in
             print(error?.localizedDescription ?? "")
             failure(error?.localizedDescription ?? "")
         }
     }
    public func getLangugageData( onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["language": Utility.shared.getLanguageCode()]

        ParsingFunction().postDataCall(subURl: Get_admin_datas, params: parameter, onSuccess: { (result) in
            let rootclass = AdminListPropertyModel.init(fromJson: result)
            self.languageModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getSpecialistiesData(illnessId: String, hospitalId: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["illness_id":illnessId, "hospital_id": hospitalId, "language": Utility.shared.getLanguageCode()]
        ParsingFunction().postDataCall(subURl: Get_specialities_datas, params: parameter, onSuccess: { (result) in
            let rootclass = DoctorLanguageModel.init(fromJson: result)
            self.specialitiesModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func forgotData(email: String, type: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        
        let parameter: [String: Any] = ["email":email, "type": type, "language": Utility.shared.getLanguageCode()]
        
        ParsingFunction().postDataCall(subURl: Forgot_Password_URL, params: parameter, onSuccess: { (result) in
            let rootclass = UserLoginModel.init(fromJson: result)
            self.loginModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getHospitalData(search: String, offset: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["offset":offset, "search": search, "limit":"150", "language": Utility.shared.getLanguageCode()]
        ParsingFunction().postDataCall(subURl: Get_hospital_datas, params: parameter, onSuccess: { (result) in
            let rootclass = HospitalModel.init(fromJson: result)
            self.hospitalModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getInsurenceData(offset: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["offset":offset, "limit":"20","language": Utility.shared.getLanguageCode()]
        ParsingFunction().postDataCall(subURl: Get_Insurance_datas, params: parameter, onSuccess: { (result) in
            let rootclass = InsuranceModel.init(fromJson: result)
            self.insuranceModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func getIllnessDatas(speciality_id: [Int], offset: String,limit: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["speciality_id": "\(speciality_id)", "offset":offset, "limit":"20", "language": Utility.shared.getLanguageCode()]
        ParsingFunction().postDataCall(subURl: GET_DOCTOR_ILLNESS_LIST_API, params: parameter, onSuccess: { (result) in
            let rootclass = IllnessModel.init(fromJson: result)
            self.illnessModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    public func AddHospital(hospital_name: String, description: String, location: String,latitude: String, longitude: String, speciality_id: String, insurance_id: String, hospital_logo: String, onSuccess success: @escaping (Bool) -> Void, onFailure failure: @escaping (String) -> Void) {
        let parameter: [String: Any] = ["hospital_name":hospital_name, "description": description, "location":location, "latitude": latitude, "longitude": longitude, "speciality_id": speciality_id, "insurance_id": insurance_id, "hospital_logo": hospital_logo, "language": Utility.shared.getLanguageCode()]
        
        ParsingFunction().postDataCall(subURl: Add_hospital_datas, params: parameter, onSuccess: { (result) in
            let rootclass = AddHospitalModel.init(fromJson: result)
            self.addHospitalModel = rootclass
            print(result)
            success(rootclass.status)
        }) { (error) in
            print(error?.localizedDescription ?? "")
            failure(error?.localizedDescription ?? "")
        }
    }
    
 }
 
