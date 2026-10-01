 //
 //  ParsingFunction.swift
 //  Meetdoc
 //
 //  Created by BTMani on 23/03/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import Foundation
 import SwiftyJSON
 import SystemConfiguration
 
 public typealias Parameters = [String: Any]
 
 
 class ParsingFunction: NSObject {
    var blockResponse = Bool()
     var prescriptionDataModel: PrescriptionDataModel?
    // POST METHOD
    public func ParsingFunctionCall(subURl: NSString, params: Parameters?, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = URL(string: siteurl+(subURl as String))
        
        print("BASE URL : \(siteurl+(subURl as String))")
        print("PARAMETER : \(params)")
        
        //webservice call
        Alamofire.request(BaseUrl!, method:.post, parameters: params!, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            //sucesss block
            let JSON = response.result.value as? NSDictionary
            if((JSON) != nil)
            {
                //      print("RESPONSE\(JSON!)")
                if(JSON?.value(forKey: "status")as! String == "false") {
                    success(JSON!)
                }else{
                    success(JSON!)
                }
            }else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if response.result.error?.localizedDescription ?? "" == "The Internet connection appears to be offline." || response.result.error?.localizedDescription ?? "" == "Could not connect to the server." {
                    let alertController = UIAlertController(title: Utility().language().value(forKey: "network_error") as? String ?? "", message: Utility().language().value(forKey: "neterror") as? String ?? "", preferredStyle: .actionSheet)
                    let okAction = UIAlertAction(title: Utility().language().value(forKey: "cancel") as? String ?? "", style: .cancel, handler: nil)
                    let settingAction = UIAlertAction(title: Utility().language().value(forKey: "setting") as? String ?? "", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alertController.addAction(settingAction)
                    alertController.addAction(okAction)
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
                failure(response.result.error)
            }
        }
        
    }
    
    public func WithOutParamParsingFunctionCall(subURl: NSString, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void) {
        let BaseUrl = URL(string: siteurl+(subURl as String))
        
        print("BASE URL : \(siteurl+(subURl as String))")
        //print("PARAMETER : \(params!)")
        
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(BaseUrl!, method:.post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                //sucesss block
                let JSON = response.result.value as? NSDictionary
                if((JSON) != nil){
                    //print("RESPONSE\(JSON!)")
                    if(JSON?.value(forKey: "status")as! String == "false") {
                        if !self.blockResponse{
                            success(JSON!)
                        }
                        // self.showAlertWith(msg: ACC_BLOCKED_MSG, type: "blocked")
                    }else{
                        success(JSON!)
                    }
                }else{
                    //                    self.showAlertWith(msg: SERVER_ISSUES_ALERT, type: "normal")
                }
            }
        }else{
            //            let offLineViewObj = OfflinePage()
            //            UIApplication.shared.keyWindow?.rootViewController?.present(offLineViewObj, animated: false, completion: nil)
        }
    }
    public func postResCall(subURl: String, params: Parameters, encodingType: ParameterEncoding = URLEncoding.httpBody,  onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void){
        let BaseUrl = URL(string:subURl)
        print("BASE URL : \(subURl)")
        print("PARAMETER : \(params)")
        let headers = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": (Bundle.main.bundleIdentifier ?? "")
        ]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        Alamofire.request(BaseUrl!, method:.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            //sucesss block
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json["status"].boolValue == false {
                    if json["message"].stringValue == "Your account is blocked, please contact Admin to unblock" {
                        let alertController = UIAlertController(title: "VRA Health", message: json["message"].stringValue, preferredStyle: .actionSheet)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            // appDelegate.setInitialViewController(initialView: SigninFrontPage())
                            UserDefaultModule.shared.userLogout()
                        }
                        alertController.addAction(okAction)
                        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
                success(json)
            case .failure(let error):
                print(error)
                if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "Could not connect to the server." {
                    let alertController = UIAlertController(title: Utility().language().value(forKey: "network_error") as? String ?? "", message: Utility().language().value(forKey: "neterror") as? String ?? "", preferredStyle: .actionSheet)
                    
                    let okAction = UIAlertAction(title: Utility().language().value(forKey: "cancel") as? String ?? "", style: .cancel, handler: nil)
                    let settingAction = UIAlertAction(title: Utility().language().value(forKey: "setting") as? String ?? "", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alertController.addAction(settingAction)
                    alertController.addAction(okAction)
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")
                failure(error)
            }
            
        }
    }
    public func postDataCall(subURl: String, params: Parameters, encodingType: ParameterEncoding = URLEncoding.httpBody,  onSuccess success: @escaping (JSON) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = URL(string: siteurl+(subURl as String))
        
        print("BASE URL : \(siteurl+subURl)")
        print("PARAMETER : \(params)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        Alamofire.request(BaseUrl!, method:.post, parameters: params, encoding: encodingType, headers: nil).responseJSON { response in
            //sucesss block
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                if json["status"].boolValue == false {
                    if json["message"].stringValue == "Your account is blocked, please contact Admin to unblock" {
                        let alertController = UIAlertController(title: "VRA Health", message: json["message"].stringValue, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            UserDefaultModule.shared.userLogout()
                        }
                        alertController.addAction(okAction)
                        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                        failure(response.result.error)
                    }
                    else {
                        success(json)
                    }
                }
                else {
                    success(json)
                }
            case .failure(let error):
                print(error)
                if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "Could not connect to the server." {
                    let alertController = UIAlertController(title: Utility().language().value(forKey: "network_error") as? String ?? "", message: Utility().language().value(forKey: "neterror") as? String ?? "", preferredStyle: .actionSheet)
                    
                    let okAction = UIAlertAction(title: Utility().language().value(forKey: "cancel") as? String ?? "", style: .cancel, handler: nil)
                    let settingAction = UIAlertAction(title: Utility().language().value(forKey: "setting") as? String ?? "", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alertController.addAction(settingAction)
                    alertController.addAction(okAction)
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")
                failure(error)
            }
            
        }
    }
    
    public func postCall(subURl: String, params: Parameters, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (_ error: Error?) -> Void)
    {
        let BaseUrl = URL(string: siteurl+(subURl as String))
        
        print("BASE URL : \(siteurl+subURl)")
        print("PARAMETER : \(params)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if Utility().isConnectedToNetwork(){
            //webservice call
            Alamofire.request(BaseUrl!, method:.post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
                //sucesss block
                let JSON = response.result.value as? NSDictionary
                if((JSON) != nil)
                {
                    if(JSON?.value(forKey: "status")as! String == "false") {
                        if !self.blockResponse{
                            success(JSON!)
                        }
                    }else{
                        success(JSON!)
                    }
                }else{
                    
                    if response.result.error?.localizedDescription ?? "" == "The Internet connection appears to be offline." || response.result.error?.localizedDescription ?? "" == "Could not connect to the server." {
                        let alertController = UIAlertController(title: Utility().language().value(forKey: "network_error") as? String ?? "", message: Utility().language().value(forKey: "neterror") as? String ?? "", preferredStyle: .actionSheet)
                        
                        let okAction = UIAlertAction(title: Utility().language().value(forKey: "cancel") as? String ?? "", style: .cancel, handler: nil)
                        let settingAction = UIAlertAction(title: Utility().language().value(forKey: "setting") as? String ?? "", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                        alertController.addAction(settingAction)
                        alertController.addAction(okAction)
                        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
        else
        {
        }
    }
     public func uploadDoc(fileData:Data, uploaddoctype:String,fileName:String, type: String,user_id:String, onSuccess success: @escaping (ImageModel) -> Void, onFailure failure: @escaping (String) -> Void) {
        let BaseUrl = URL(string: ImageURL)
        print("BASE URL : \(ImageURL)")
        var parameters = ["user_id":user_id,"type":type,"sitename":webURL] as [String : Any]
        
        if UserDefaultModule().getCurrentUserID() != nil {
            parameters["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
        }
        
        print("REQUEST : \(parameters)")
        print("data\(fileData)")
        var mime_type = String()
        if uploaddoctype == ".jpeg" || uploaddoctype.lowercased() == "jpeg"{
            mime_type = "image/jpg"
        }else{
            mime_type = "application/pdf"
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileData, withName: "images", fileName:fileName, mimeType: mime_type)
            for (key, value) in parameters {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        }, to:BaseUrl!,method:.post)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let jsonVal = response.result.value as? NSDictionary
                    print("RESPONSE \(response)")
                    if jsonVal != nil {
                        let json = JSON(jsonVal)
                        let rootclass = ImageModel.init(fromJson: json)
                        success(rootclass)
                    }
                    else {
                        failure("failed")
                    }
                }
            case .failure(let error):
                print("FAILURE RESPONSE: \(error.localizedDescription)")
                if error._code == NSURLErrorTimedOut{
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                }else{
                }
                failure(error.localizedDescription)
            }
        }
    }
     public func uploadprescription(fileData:[Data], uploaddoctype:String,params: Parameters!, onSuccess success: @escaping (PrescriptionModel) -> Void, onFailure failure: @escaping (String) -> Void) {
             let BaseUrl = URL(string: prescriptionURL)
              print("BASE URL : \(BaseUrl)")
              print("PARAMETER : \(params)")
             var mime_type = String()
             if uploaddoctype == ".jpeg" || uploaddoctype.lowercased() == "jpeg"{
                 mime_type = "image/jpg"
             }else{
                 mime_type = "application/pdf"
             }
             
             Alamofire.upload(multipartFormData: { (multipartFormData) in
                 fileData.indices.forEach {
                     multipartFormData.append(fileData[$0], withName: "images[]", fileName: ".jpeg", mimeType: mime_type)
                         }
                 for (key, value) in params {
                     multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                 }
             }, to:BaseUrl!,method:.post)
             { (result) in
                 switch result {
                 case .success(let upload, _, _):
                     upload.uploadProgress(closure: { (progress) in
                     })
                     upload.responseJSON { response in
                         let jsonVal = response.result.value as? NSDictionary
                         print("RESPONSE \(response)")
                         if jsonVal != nil {
                             let json = JSON(jsonVal)
                             let rootclass = PrescriptionModel.init(fromJson: json)
                             success(rootclass)
                         }
                         else {
                             failure("failed")
                         }
                     }
                 case .failure(let error):
                     print("FAILURE RESPONSE: \(error.localizedDescription)")
                     if error._code == NSURLErrorTimedOut{
                         
                     }else if error._code == NSURLErrorNotConnectedToInternet{
                     }else{
                     }
                     failure(error.localizedDescription)
                 }
             }
         }
 }
 
