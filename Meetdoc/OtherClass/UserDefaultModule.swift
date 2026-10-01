//
//  UserDefaultModule.swift
//  Meetdoc
//
//  Created by BTMani on 23/03/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit
import ConnectyCube
import ConnectyCubeCalls
import ZegoUIKitPrebuiltCall
import ZegoUIKit

class UserDefaultModule: NSObject {
    
    static let shared = UserDefaultModule()

    //MARK: store & get VOIP notification token
    func setPushToken(fcm_token: String){
        UserDefaults.standard.set(fcm_token, forKey: "voip_token")
    }
    func getPushToken() -> String? {
        return UserDefaults.standard.value(forKey: "voip_token") as? String
    }
    func getCurrentUserID() -> NSString?
    {
        return UserDefaults.standard.value(forKey: "user_id") as? NSString
    }
    func setUserID(userID: NSString){
        UserDefaults.standard.set(userID, forKey: "user_id")
    }
    //MARK: store & get user details
    
    func getLocationSearch() -> [locationData] {
        if let data = UserDefaults.standard.value(forKey:"location_search") as? Data {
            if let locArr = try? PropertyListDecoder().decode(Array<locationData>.self, from: data) {
                return locArr
            }
        }
        return [locationData]()
    }
    
    //MARK: store & get approve details
    func setApproveDict(adminDict: NSDictionary){
        UserDefaults.standard.set(adminDict, forKey: "admin_approve")
    }
    func getApprove() -> NSDictionary {
        return (UserDefaults.standard.value(forKey: "admin_approve") as? NSDictionary)!
    }
    
    func setLocationSearch(_ locArray: [locationData]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(locArray), forKey:"location_search")
    }
    
    func setPassword(password: NSString)
    {
        UserDefaults.standard.set(password, forKey: "password")
    }
    func getPassword() -> NSString {
        return UserDefaults.standard.value(forKey: "password") as! NSString
    }
    /*
    func setChatLanguage(language: Language) {
        print(language)
            let jsonData = try! JSONEncoder().encode(language)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            UserDefaults.standard.set(jsonString, forKey: "ChatLanguage")
    }
    func getChatLanguage() -> Language {
        
            let loginData = UserDefaults.standard.value(forKey: "ChatLanguage") as? String ?? ""
            if loginData != "" {
                let jsonData = loginData.data(using: .utf8)!
                let user = try! JSONDecoder().decode(Language.self, from: jsonData)
                return user
            }
            else {
                let user = Language(language: "none", name: "none")
                return user
            }
    }
 */
    func setAppLanguage(language: String) {
        print(language)
        UserDefaults.standard.set(language, forKey: "language")
    }
    func getAppLanguage() -> String {
        if (UserDefaults.standard.value(forKey: "language") != nil){
            return UserDefaults.standard.value(forKey: "language") as! String
        }
        return "English"
    }
    func setAppTheme(language: String) {
        print(language)
        UserDefaults.standard.set(language, forKey: "theme")
    }
    func getAppTheme() -> String {
        if (UserDefaults.standard.value(forKey: "theme") != nil){
            return UserDefaults.standard.value(forKey: "theme") as! String
        }
        return "light"
    }
    func setCurrencyCode(CurrencyCode: String) {
        UserDefaults.standard.set(CurrencyCode, forKey: "currency_code")
    }
    func getCurrencyCode() -> String {
        return UserDefaults.standard.value(forKey: "currency_code") as! String
    }
    func setEmailVerifyStatus(isVerified: Bool) {
        UserDefaults.standard.set(isVerified, forKey: "isVerified")
    }
    func getEmailVerifyStatus() -> Bool {
        return UserDefaults.standard.value(forKey: "isVerified") as? Bool ?? false
    }
    func userLogout()
    {
        Utility.shared.pushLogoutService(type: "logout")
        CallsApp.logOut {
            print("successfully connectycube logged out in as meet")
            // popping app to login screen
        }
        let registerID = UserDefaultModule.shared.getFCMToken() ?? ""
        let appLanguage = UserDefaultModule.shared.getAppLanguage()
        let voipToken = UserDefaultModule.shared.getPushToken() ?? ""
        let userData = UserDefaultModule.shared.getAppleLoginData()
        let theme = UserDefaultModule.shared.getAppTheme()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        UserDefaultModule.shared.setFCMToken(fcm_token: registerID)
        UserDefaultModule.shared.setAppLanguage(language: appLanguage)
        UserDefaultModule.shared.setPushToken(fcm_token: voipToken)
        UserDefaultModule().setAppLanguage(language: appLanguage)
        UserDefaults.standard.set(APP_RTC_URL, forKey: "web_rtc_web")
        UserDefaultModule.shared.setAppTheme(language: theme)
        UserDefaultModule.shared.setAppleLogin(fName: userData.first_name, lName: userData.last_name, Id: userData.user_id, email: userData.email)
        Utility.shared.configureLanguage()
        ZegoUIKitPrebuiltCallInvitationService.shared.unInit()
        ZegoUIKit.getSignalingPlugin().loginOut()
//        let welcomeObj = DigitalClinicSignupViewController()
//          let welcomeObj = DigitalClinicSigninViewController()
        let welcomeObj = UserSigninViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController(initialView: welcomeObj)
    }
    //MARK: store & get fcm notification token
    func setFCMToken(fcm_token: String) {
        UserDefaults.standard.set(fcm_token, forKey: "fcm_token")
    }
    func getFCMToken() -> String? {
        return UserDefaults.standard.value(forKey: "fcm_token") as? String
    }
    func setAppleLogin(fName: String, lName: String, Id: String, email: String) {
        let user = UserData(email: email, first_name: fName, last_name: lName, referal_url: "", user_id: Id, user_image: "")
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "AppleLoginData")
    }
    func getAppleLoginData() -> UserData {
        let loginData = UserDefaults.standard.value(forKey: "AppleLoginData") as? String ?? ""
        if loginData != "" {
            let jsonData = loginData.data(using: .utf8)!
            let user = try! JSONDecoder().decode(UserData.self, from: jsonData)
            return user
        }
        else {
            let user = UserData(email: "", first_name: "", last_name: "", referal_url: "", user_id: "", user_image: "")
            return user
        }
    }
    func setconnectyLogin(login: String, password: String, Id: String, email: String) {
        let user = connectycube(email: email, login: login,password: password, user_id: Id)
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "getconnectyLoginData")
    }
    
    func getconnectyLoginData() -> connectycube
    {
        let loginData = UserDefaults.standard.value(forKey: "getconnectyLoginData") as? String ?? ""
        if loginData != ""
        {
            let jsonData = loginData.data(using: .utf8)!
            let user = try! JSONDecoder().decode(connectycube.self, from: jsonData)
            return user
        }
        else
        {
            let user = connectycube(email: "", login: "",password: "", user_id: "")
            return user
        }
    }

    func setUserLoginData(_ dict: UserLoginResultModel?) {
        let user = dict
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "LoginData")
    }
    func getLoginData() -> UserLoginResultModel {
        let loginData = UserDefaults.standard.value(forKey: "LoginData") as? String ?? ""
        if loginData != "" {
            let jsonData = loginData.data(using: .utf8)!
            let user = try! JSONDecoder().decode(UserLoginResultModel.self, from: jsonData)
            return user
        }
        else {
            let user = UserLoginResultModel()
            return user
            
        }
    }
    func getData() -> CallMediaStreamConfiguration? {
        let defaults = UserDefaults.standard
        if let mediaConfig = defaults.object(forKey: "mediaStreamConfiguration") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mediaConfig) as? CallMediaStreamConfiguration
            {
                return decodedPeople
            }
        }
        return nil
    }
   
    func getVideo() -> CallVideoFormat? {
        let defaults = UserDefaults.standard
        if let mediaConfig = defaults.object(forKey: "videoFormat") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mediaConfig) as? CallVideoFormat {
                return decodedPeople
            }
        }
        return nil
    }
    
    func getCurrentProfile() -> User? {
        let defaults = UserDefaults.standard
        if let mediaConfig = defaults.object(forKey: "currentProfile") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mediaConfig) as? User {
                return decodedPeople
            }
        }
        return nil
    }
    
}



