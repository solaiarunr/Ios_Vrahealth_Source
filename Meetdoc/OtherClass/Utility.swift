 //
 //  Utility.swift
 //  Meetdoc
 //
 //  Created by BTMani on 22/03/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //

 import UIKit
 import SystemConfiguration
 import NVActivityIndicatorView
import SwiftyJSON

 let FULL_WIDTH = UIScreen.main.bounds.width
 let FULL_HEIGHT = UIScreen.main.bounds.height


/*
 Primary color:
 #1aaaaf (R:26, G:170, B:175)

 Chat color:
 #BBF5F7 (R:187, G:245, B:247)
 */

 let AppGreen = UIColor(red: 0.0 / 255.0, green: 125.0 / 255.0, blue: 140.0 / 255.0, alpha: 1)
 let AppRed = UIColor(red: 26.0 / 255.0, green: 170.0 / 255.0, blue: 175.0 / 255.0, alpha: 1)
 let AppTextColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1)
 let AppSecondaryColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1)

 var indicatorView = NVActivityIndicatorView.init(frame: CGRect(x:FULL_WIDTH/2-30,y:FULL_HEIGHT/2-30,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: UIColor(named: "AppColor") ?? .white, padding: 50)
var indicatorView1 = NVActivityIndicatorView.init(frame: CGRect(x:FULL_WIDTH/2-30,y:FULL_HEIGHT/2-70,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: UIColor(named: "AppColor") ?? .white, padding: 50)

 let BoldCondesedFontName = "Poppins-ExtraBold"
 let boldFontName = "Poppins-Bold"
 let regularFontName = "Poppins-Regular"
 let lightFontName = "Poppins-Light"

 //semi-bold
 let boldLargeFont = UIFont(name: boldFontName, size: 32.0)
 let semiBold22 = UIFont(name: boldFontName, size: 22.0)
 let titleFont = UIFont(name: boldFontName, size: 27.0)
let new_titleFont = UIFont(name: boldFontName, size: 23.0)
 let fontsemi25 = UIFont(name: boldFontName, size: 25.0)
 let tableHeaderFont = UIFont(name: boldFontName, size: 20.0)
 let largeFont = UIFont(name: boldFontName, size: 17.0)
 let fontsemi16 = UIFont(name: boldFontName, size: 16.0)
 let headerFont = UIFont(name: boldFontName, size: 15.0)
 let smallFont = UIFont(name: boldFontName, size: 12.0)
 let fontSemi14 = UIFont(name: boldFontName, size: 14.0)
 let fontSemi9 = UIFont(name: boldFontName, size: 9.0)
let fontSemi10 = UIFont(name: boldFontName, size: 10.0)
let smallFont5 = UIFont(name: boldFontName, size: 2.0)

 //regular
 let regular22 = UIFont(name: regularFontName, size: 22.0)
 let regularFont = UIFont(name: regularFontName, size: 15.0)
 let regular17 = UIFont(name: regularFontName, size: 17.0)
 let regularVerySmall = UIFont(name: regularFontName, size: 9.0)
 let fontRegular18 = UIFont(name: regularFontName, size: 18.0)
 let fontRegular = UIFont(name: regularFontName, size: 20.0)
 let fontRegular16 = UIFont(name: regularFontName, size: 16.0)
 let regular14 = UIFont(name: regularFontName, size: 14.0)
let fontRegular15 = UIFont(name: regularFontName, size: 15.0)
 let fontRegular13 = UIFont(name: regularFontName, size: 13.0)
 let fontRegular12 = UIFont(name: regularFontName, size: 12.0)
 let fontRegular10 = UIFont(name: regularFontName, size: 10.0)

 //medium
 let WebViewFont = "Poppins-Regular"
 //Light
 let light12 = UIFont(name: lightFontName, size: 12.0)
 var navVC = UIViewController()

 class Utility: NSObject {
     
     static let shared = Utility()
     
     func configureLanguage(){
         if let Path = Bundle.main.path(forResource: UserDefaultModule.shared.getAppLanguage().capitalized, ofType: "json"){
             do{
                 let data = try Data(contentsOf: URL(fileURLWithPath: Path), options: .mappedIfSafe)
                 let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                    UIDatePicker.appearance().semanticContentAttribute = .forceLeftToRight
                    UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
                }
                 else {
                     UIView.appearance().semanticContentAttribute = .forceLeftToRight
                     UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
                 }
                getLanguage = jsonResult as! Dictionary<String, String>
                 self.setDefaultLanguage(LanguageDict: jsonResult as! NSDictionary)
             }catch{
                 // handle error
                 print(error)
             }
         }
         
     }
     //regisert for push services
     func registerPushServices()  {
         if UserDefaultModule.shared.getLoginData().userId != "" {
            let parameter: [String: Any] = ["device_token":UserDefaultModule.shared.getFCMToken() ?? "", "device_type":0, "device_id": UIDevice.current.identifierForVendor!.uuidString, "device_mode":DEVICE_MODE, "user_id": (UserDefaultModule.shared.getLoginData().userId ?? ""), "voip_token": (UserDefaultModule.shared.getPushToken() ?? ""), "language": Utility.shared.getLanguageCode()]
             ParsingFunction().postDataCall(subURl: API_ADD_DEVICE_ID, params: parameter, onSuccess: { (result) in
                 print(result)
             }) { (error) in
                 print(error?.localizedDescription ?? "")
             }
         }
     }
     
    func pushLogoutService(type: String)  {
        let parameter: [String: Any] = ["device_id": UIDevice.current.identifierForVendor!.uuidString, "type": type, "language": Utility.shared.getLanguageCode()]
         
         ParsingFunction().postDataCall(subURl: API_SIGN_OUT, params: parameter, onSuccess: { (result) in
             print(result)
         }) { (error) in
             print(error?.localizedDescription ?? "")
         }
     }
     
     func setDefaultLanguage(LanguageDict:NSDictionary){
         print(LanguageDict)
         UserDefaults.standard.set(LanguageDict, forKey: "app_language")
     }
     func language() -> NSDictionary{
         if let language = UserDefaults.standard.value(forKey: "app_language") as? NSDictionary {
             return language
         }
         else {
             UserDefaultModule().setAppLanguage(language: DEFAULT_LANGUAGE)
             Utility.shared.configureLanguage()
             return self.language()
         }
     }
     
     //MARK: Network rechability
     func isConnectedToNetwork() -> Bool {
         var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)
         
         let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
             $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                 SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
             }
         }
         var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
         if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
             return false
         }
         
         // Working for Cellular and WIFI
         let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
         let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
         let ret = (isReachable && !needsConnection)
         return ret
         
     }
     
     func unixTimeStamptoDate(timeStamp:String) -> String
     {
         //        let timeStampValue = NumberFormatter().number(from: timeStamp)?.doubleValue
         
         let timeStampValue = Double(timeStamp)
         
         //to convert in regular format
         let stampdate = Date(timeIntervalSince1970: timeStampValue!)
         let dateFormatterGet = DateFormatter()
         dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
         
         // to convert from regular format to required format
         let dateFormatterPrint = DateFormatter()
         dateFormatterPrint.dateFormat = "MMM dd,yyyy"
         
         let stampDateStr = dateFormatterGet.string(from: stampdate)
         
         let date: NSDate? = dateFormatterGet.date(from: stampDateStr) as NSDate?
         
         //converting the date to string in required format
         let finalDate = dateFormatterPrint.string(from: date! as Date)
         
         return finalDate
     }
     func timeStampWithDateFormat(timeStamp: String, dateFormat: String) -> String {
         let timeStampValue = Double(timeStamp)
         //to convert in regular format
        let stampdate = Date(timeIntervalSince1970: timeStampValue ?? Date().timeIntervalSince1970)
         let dateFormatterGet = DateFormatter()
         dateFormatterGet.timeZone = TimeZone(abbreviation: "GMT+0:00")
         dateFormatterGet.dateFormat = dateFormat
         let finalDate = dateFormatterGet.string(from: stampdate)
         return finalDate
     }
     func timeStampWithDateFormat1(timeStamp: String, dateFormat: String) -> String {
         let timeStampValue = Double(timeStamp)
         //to convert in regular format
        let stampdate = Date(timeIntervalSince1970: timeStampValue ?? Date().timeIntervalSince1970)
         let dateFormatterGet = DateFormatter()
         dateFormatterGet.timeZone = TimeZone.current
         dateFormatterGet.dateFormat = dateFormat
         let finalDate = dateFormatterGet.string(from: stampdate)
         return finalDate
     }
    func convertTimeStampWithDateFormat(timeStamp: String, dateFormat: String) -> String {
        let timeStampValue = Double(timeStamp)
        //to convert in regular format
       let stampdate = Date(timeIntervalSince1970: timeStampValue ?? Date().timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let dateObj = dateFormatter.string(from: stampdate)
        dateFormatter.dateFormat = dateFormat
//        let dateVal = dateFormatter.date(from: dateObj)
        return dateObj
    }
     func convertTimeStampWithDateFormat1(timeStamp: String, dateFormat: String) -> String {
         let timeStampValue = Double(timeStamp)
         //to convert in regular format
        let stampdate = Date(timeIntervalSince1970: timeStampValue ?? Date().timeIntervalSince1970)
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = dateFormat
    //     dateFormatter.locale = Locale.init(identifier: "en_GB")
         dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
         let dateObj = dateFormatter.string(from: stampdate)
         dateFormatter.dateFormat = dateFormat
 //        let dateVal = dateFormatter.date(from: dateObj)
         return dateObj
     }
     func newconvertTimeStampWithDateFormat(timeStamp: String, dateFormat: String) -> Date{
         let timeStampValue = Double(timeStamp)
         //to convert in regular format
        let stampdate = Date(timeIntervalSince1970: timeStampValue ?? Date().timeIntervalSince1970)
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = dateFormat
         dateFormatter.locale = NSLocale.current
         dateFormatter.timeZone = TimeZone.current
         let dateObj = dateFormatter.string(from: stampdate)
         dateFormatter.dateFormat = dateFormat
 //        let dateVal = dateFormatter.date(from: dateObj)
         return stampdate
     }
     
     func toJSON(array: [[String: Any]]) throws -> String {
             let data = try JSONSerialization.data(withJSONObject: array, options: [])
             return String(data: data, encoding: .utf8)!
         }
     
     func toJSON1(array: [String: Any]) throws -> String {
             let data = try JSONSerialization.data(withJSONObject: array, options: [])
             return String(data: data, encoding: .utf8)!
         }
     
     
     func convertSendModel(from string: String) -> [medicineListModel]?{
         var tempresult = [medicineListModel]()
         var data = ["medicine_details": string]
         let string = data["medicine_details"]
         let orderData = string!.data(using: .utf8)!
         do {
             if let jsonArray = try JSONSerialization.jsonObject(with: orderData, options : .allowFragments) as? [NSDictionary]
             {
               
                                             
                 tempresult = [medicineListModel]()
                 let resultArray = jsonArray
                 for resultJson in resultArray{
                     let value = medicineListModel(fromJson: JSON(rawValue: resultJson) ?? "")
                     tempresult.append(value)
                 }
             } else {
                 print("bad json")
             }
         } catch let error as NSError {
             print(error)
         }
         print("tempresult:\(tempresult)")
         return tempresult
     }
     
     func convertSendModel1(from string: String) -> filesModel?{
         var tempresult : filesModel?
         let data = ["files": string]
         let string = data["files"]
         let orderData = string!.data(using: .utf8)!
         do {
             if let jsonArray = try JSONSerialization.jsonObject(with: orderData, options : .allowFragments) as? NSDictionary
             {
               
                 let resultArray = jsonArray
                 let reservationJson = resultArray
                 let value = filesModel(fromJson: JSON(rawValue: reservationJson) ?? "")
                 tempresult = value
             } else {
                 print("bad json")
             }
         } catch let error as NSError {
             print(error)
         }
         print("tempresult1:\(tempresult)")
         return tempresult
     }
     func getLanguageCode() -> String {
         var lancode = "en"
         if let language = (UserDefaults.standard.value(forKey: "language")) as? String{
             if language.lowercased() == "english" {
                 lancode = "en"
             }
             else if language.lowercased() == "french" {
                 lancode = "fr"
             }
             else {
                 lancode = "ar"
             }
         }
         return lancode
     }
     func getTimeAgo(millis: Double, currentMills: Double) -> String {
         let utilityLang = Utility().language()
         let diff = currentMills - millis
         var suffix = utilityLang.value(forKey: "time_ago_suffix") as? String ?? ""
         let seconds = abs(diff)
         let minutes = seconds / 60
         let hours = minutes / 60
         let days = hours / 24
         let years = days / 365
         var words = ""
         if(diff<60){
             suffix = ""
             words = utilityLang.value(forKey: "time_ago_seconds") as? String ?? ""
         } else if (diff>60 && diff<3600){
             words = "\(Int(minutes))" + (utilityLang.value(forKey: "time_ago_minutes") as? String ?? "")
         } else if(diff>3600 && diff < 7200) {
             words = utilityLang.value(forKey: "time_ago_hour") as? String ?? ""
         } else if(diff>7200 && diff < 86400){
             words = "\(Int(hours))" + (utilityLang.value(forKey: "time_ago_hours") as? String ?? "")
         }  else if(diff>86400 && diff < 172800){
             words = utilityLang.value(forKey: "time_ago_day") as? String ?? ""
         }  else if(diff>172800 && diff < 2592000){
             words = "\(Int(days))" + (utilityLang.value(forKey: "time_ago_days") as? String ?? "")
         }  else if(diff>2592000 && diff < 5184000){
             words = utilityLang.value(forKey: "time_ago_month") as? String ?? ""
         } else if(diff>5184000 && diff < 31536000){
             words = "\(Int(diff/172800))" + (utilityLang.value(forKey: "time_ago_months") as? String ?? "")
         } else if(diff>31536000 && diff < 63072000){
             words = utilityLang.value(forKey: "time_ago_year") as? String ?? ""
         } else {
             words = "\(Int(years))" + (utilityLang.value(forKey: "time_ago_years") as? String ?? "")
         }
         
         return "\(words) \(suffix)"
     }
     
     //MARK: Indicator view
     func setIndicatorView(x: CGFloat, y: CGFloat) -> UIView{
        indicatorView = NVActivityIndicatorView.init(frame: CGRect(x:x,y:y,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: UIColor(named: "AppColor") ?? .white, padding: 50)
         return indicatorView
     }
     func setIndicatorView1(x: CGFloat, y: CGFloat) -> UIView{
        indicatorView1 = NVActivityIndicatorView.init(frame: CGRect(x:x,y:y,width:60,height:60), type: NVActivityIndicatorType.ballPulse, color: UIColor(named: "AppColor") ?? .white, padding: 50)
         return indicatorView1
     }
     
     //MARK: start and stop loader
     func startAnimation(viewController:UIViewController) {
         indicatorView.startAnimating()
         UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = false
         viewController.view.isUserInteractionEnabled =  false
     }
     func stopAnimation(viewController:UIViewController)
     {
         indicatorView.stopAnimating()
         UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
         viewController.view.isUserInteractionEnabled =  true
     }
     func startAnimation1(viewController:UIViewController) {
         indicatorView1.startAnimating()
         UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = false
         viewController.view.isUserInteractionEnabled =  false
     }
     func stopAnimation1(viewController:UIViewController)
     {
         indicatorView1.stopAnimating()
         UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
         viewController.view.isUserInteractionEnabled =  true
     }
     func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
         let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
         label.numberOfLines = 0
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.font = font
         label.text = text
         label.sizeToFit()
         
         return label.frame.height
     }
     
     func loadImageFromCell(imgStr: String, imgViewNam: UIImageView){
         imgViewNam.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: ""))
     }
     func getTodayString() -> String{
         
         let date = Date()
         let calender = Calendar.current
         let components = calender.dateComponents([.hour,.minute], from: date)
         let hour = components.hour
         let minute = components.minute
         
         let today_string = String(hour!)  + ":" + String(minute!)
         
         return today_string
         
     }
     func getCurrentMonth() -> String{
         let now = Date()
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "LLLL"
         let nameOfMonth = dateFormatter.string(from: now)
         return nameOfMonth
     }
     
     static var calendar: Calendar {
         get {
             var c = Calendar.current
//             c.timeZone = TimeZone(abbreviation: "UTC")!
             c.timeZone = TimeZone.current
             return c
         }
     }
     func filterDictToString(_ filterData: [SlotModel]) -> String {
         var dictArray = [[String:String]]()
         for val in filterData {
             dictArray.append(["slot_fromtime": val.slotFromTime, "slot_totime": val.slotToTime, "type": val.type])
         }
         do {
             let jsonData = try JSONEncoder().encode(dictArray)
             let jsonString = String(data: jsonData, encoding: .utf8)!
             print(jsonString)
             return jsonString
         } catch {
             print(error)
         }
         return ""
     }
     
     func setfiledata(item: filesModel) {
             let jsonData = try! JSONEncoder().encode(item)
             let jsonString = String(data: jsonData, encoding: .utf8)!
             UserDefaults.standard.set(jsonString, forKey: "files")
         }
         func getfiledata() -> filesModel? {
             let itemData = UserDefaults.standard.value(forKey: "files") as? String ?? ""
             if itemData != "" {
                 let jsonData = itemData.data(using: .utf8)!
                 let item = try! JSONDecoder().decode(filesModel.self, from: jsonData)
                 return item
             }
             return nil
         }
     func jsonString(from object:Any) -> String {
         guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
             return "nil"
         }
         return String(data: data, encoding: String.Encoding.utf8) ?? ""
     }
     func topController(_ parent:UIViewController? = nil) -> UIViewController {
         if let vc = parent {
             if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                 return topController(selected)
             } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                 return topController(top)
             } else if let presented = vc.presentedViewController {
                 return topController(presented)
             } else {
                 return vc
             }
         } else {
             return topController(UIApplication.shared.keyWindow!.rootViewController!)
         }
     }
     //get random number
     func random() -> String {
         let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
         let len = UInt32(letters.length)
         var randomString = ""
         for _ in 0 ..< 10 {
             let rand = arc4random_uniform(len)
             var nextChar = letters.character(at: Int(rand))
             randomString += NSString(characters: &nextChar, length: 1) as String
         }
         let userData = UserDefaultModule.shared.getLoginData()
         return "\(userData.userId ?? "")\(randomString)"
     }
 }

 extension UINavigationController {
    func customNavigationBarView(title: String, fColor: String, fontName: UIFont?, vc: UIViewController) {
        navVC = vc
        vc.title = title
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: fontName ?? UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor(named: fColor) ?? .black]
        self.updateTransparantBackGround(false, vc: vc)
    }
     func NavigationBarWithBackButtonAndTitle(title: String, fColor: String, fontName: UIFont?, imageName: String?, isLeft: Bool, vc: UIViewController, transparantView: Bool) {
         navVC = vc
         let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         barButton.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
         barButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 4, right: 3)
         barButton.setImage(UIImage(named: imageName ?? "back"), for: .normal)
         barButton.tintColor = UIColor(named: fColor)
         if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
             barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
         }
         let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
         barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        if UserDefaultModule.shared.getAppLanguage().capitalized == "French" {
            barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         }
        barButton1.titleLabel?.lineBreakMode = .byTruncatingTail
         barButton1.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
         barButton1.contentHorizontalAlignment = .leading
         barButton1.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
         barButton1.setTitle(title, for: .normal)
         
         barButton.tag = 0
//        vc.navigationController?.navigationBar.isTranslucent = true
         vc.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton), UIBarButtonItem(customView: barButton1)]
        
        vc.navigationController?.updateTransparantBackGround(false, vc: self)
     }
     
      func NavigationBarWithBackButtonAndTitle1(title: String, fColor: String, fontName: UIFont?, imageName: String?, isLeft: Bool, vc: UIViewController, transparantView: Bool) {
          navVC = vc
          let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
          barButton.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
          barButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 4, right: 3)
          barButton.setImage(UIImage(named: imageName ?? "back"), for: .normal)
          barButton.tintColor = UIColor(named: fColor)
          if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
              barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
          }
          let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 400, height: 30))
          barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
         if UserDefaultModule.shared.getAppLanguage().capitalized == "French" {
             barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          }
         barButton1.titleLabel?.lineBreakMode = .byTruncatingTail
          barButton1.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
          barButton1.contentHorizontalAlignment = .leading
          barButton1.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
          barButton1.setTitle(title, for: .normal)
          
          barButton.tag = 0
 //        vc.navigationController?.navigationBar.isTranslucent = true
          vc.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton), UIBarButtonItem(customView: barButton1)]
         
         vc.navigationController?.updateTransparantBackGround(false, vc: self)
      }
     func customRightBarButtonView(title: String, fColor: String, fontName: UIFont?, imageName: String?, isLeft: Bool, vc: UIViewController, transparantView: Bool) {
         navVC = vc
         let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         barButton.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
         
         if (imageName != "" && imageName != nil){
             barButton.setImage(UIImage(named: imageName ?? "back"), for: .normal)
             
             barButton.tintColor = UIColor(named: fColor)
         }
         else {
             barButton.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
             barButton.contentHorizontalAlignment = .trailing
             barButton.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
             barButton.setTitle(title, for: .normal)
         }
         // Mentioned Right Or Left Button
         if isLeft {
             barButton.tag = 0
             vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barButton)
             if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                 barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                 
             }
         }
         else {
             barButton.tag = 1
             vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
         }
         self.updateTransparantBackGround(transparantView, vc: vc)
     }
     func customRightBarButtonView2(title: String, fColor: String, fontName: UIFont?, imageName: String?, isLeft: Bool, vc: UIViewController, transparantView: Bool) {
         navVC = vc
         let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         barButton.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
         
         if (imageName != "" && imageName != nil){
             barButton.setImage(UIImage(named: imageName ?? "back"), for: .normal)
             
             barButton.tintColor = UIColor(named: fColor)
         }
         else {
             barButton.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
             barButton.contentHorizontalAlignment = .trailing
             barButton.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
             barButton.setTitle(title, for: .normal)
         }
         // Mentioned Right Or Left Button
         if isLeft {
             barButton.tag = 0
             vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barButton)
             if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                 barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                 
             }
         }
         else {
             barButton.tag = 1
             vc.navigationItem.rightBarButtonItem = nil
         }
         self.updateTransparantBackGround(transparantView, vc: vc)
     }
     func customRightBarButtonView1(title: String, fColor: String, fontName: UIFont?, imageName: String?,imageName2: String?, isLeft: Bool, vc: UIViewController, transparantView: Bool) {
         navVC = vc
         let barButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         barButton1.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
         let barButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
         barButton2.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
         
         if (imageName != "" && imageName != nil) && (imageName2 != "" && imageName2 != nil){
             barButton1.setImage(UIImage(named: imageName ?? "back"), for: .normal)
             
             barButton1.tintColor = UIColor(named: fColor)
             
             barButton2.setImage(UIImage(named: imageName2 ?? "back"), for: .normal)
             
             barButton2.tintColor = UIColor(named: fColor)
         }
         else {
             barButton1.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
             barButton1.contentHorizontalAlignment = .trailing
             barButton1.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
             barButton1.setTitle(title, for: .normal)
             
             barButton2.titleLabel?.font = fontName ?? UIFont.systemFont(ofSize: 14)
             barButton2.contentHorizontalAlignment = .trailing
             barButton2.setTitleColor(UIColor(named: fColor) ?? .white, for: .normal)
             barButton2.setTitle(title, for: .normal)
         }
         // Mentioned Right Or Left Button
         if isLeft {
             barButton1.tag = 0
             barButton2.tag = 0
             vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barButton1)
             vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barButton2)
             if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                 barButton1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                 barButton2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                 
             }
         }
         else {
             barButton1.tag = 1
             barButton2.tag = 2
             vc.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barButton1), UIBarButtonItem(customView: barButton2)]
         }
         self.updateTransparantBackGround(transparantView, vc: vc)
     }
     func updateTransparantBackGround(_ transparantView: Bool, vc: UIViewController) {
         // Transparant Background
         navVC = vc
         if transparantView {
             vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
             vc.navigationController?.navigationBar.shadowImage = UIImage()
//            vc.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
//             vc.navigationController?.navigationBar.tintColor = UIColor(named: "HeaderColor") ?? .white
            if #available(iOS 13.0, *) {
                vc.navigationController?.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? (UIColor(named: "DarkAppColor") ?? .white) : (UIColor(named: "AppColor") ?? .white)
                vc.navigationController?.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? (UIColor(named: "DarkAppColor") ?? .white) : (UIColor(named: "AppColor") ?? .white)

            } else {
                // Fallback on earlier versions
                vc.navigationController?.navigationBar.barTintColor = UIColor(named: "AppColor") ?? .white
                vc.navigationController?.navigationBar.tintColor = UIColor(named: "AppColor") ?? .white
            }
            vc.navigationController?.navigationBar.isTranslucent = true

         }
         else {
             vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
             vc.navigationController?.navigationBar.shadowImage = UIImage()
            if #available(iOS 13.0, *) {
                vc.navigationController?.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? (UIColor(named: "DarkAppColor") ?? .white) : (UIColor(named: "AppColor") ?? .white)
                vc.navigationController?.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? (UIColor(named: "DarkAppColor") ?? .white) : (UIColor(named: "AppColor") ?? .white)

            } else {
                // Fallback on earlier versions
                vc.navigationController?.navigationBar.barTintColor = UIColor(named: "AppColor") ?? .white
                vc.navigationController?.navigationBar.tintColor = UIColor(named: "AppColor") ?? .white
            }

//                UIColor(named: "HeaderColor") ?? .white

             vc.navigationController?.navigationBar.isTranslucent = false
             vc.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
             vc.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
             vc.navigationController?.navigationBar.layer.shadowRadius = 2.0
             vc.navigationController?.navigationBar.layer.shadowOpacity = 0.2
         }
     }
     @objc func barButtonAct(_ sender: UIButton) {
         let imageDataDict:[String: Int] = ["isLeft": sender.tag]
         NotificationCenter.default.post(name: Notification.Name("BarButtonAction"), object: Utility.shared.topController(NCTRL), userInfo: imageDataDict)
     }
     open override var preferredStatusBarStyle: UIStatusBarStyle {
         return topViewController?.preferredStatusBarStyle ?? .default
     }
     static var calendar: Calendar {
         get {
             var c = Calendar.current
             c.timeZone = TimeZone(abbreviation: "UTC")!
             return c
         }
     }
    var previousViewController: UIViewController? {
        return viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
 }
 extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
         return selectedViewController
     }
 }

