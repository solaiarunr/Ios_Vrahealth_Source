//
//  UploadServices.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation
import Alamofire

class UploadServices {
    //MARK: upload profiel pic service
    public func uploadProfilePic(profileimage:Data,user_id:String,type: String,imagecount: String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: ImageURL)
        var parameters = ["user_id":user_id,"type":type,"sitename":webURL]
        if type == "listing" {
            parameters["imagecount"] = imagecount
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(profileimage, withName: "images", fileName: "profilepic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:nil)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    // Print("RESPONSE \(response)")
                    if JSON != nil {
                        success(JSON!)
                    }
                    else {
                        let alert = UIAlertController(title: "", message: Utility().language().value(forKey: "failed_upload_image") as? String ?? "failed_upload_image", preferredStyle: .alert)
                        let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                        }
                        alert.addAction(action)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
    
                }
            case .failure(let error):
                // Print("FAILURE RESPONSE: \(error.localizedDescription)")
                if error._code == NSURLErrorTimedOut{
                    //                    Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "timed_out") as! String)
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    //                        Utility.shared.goToOffline()
                }else{
                    //                        Utility.shared.showAlert(msg: Utility.shared.getLanguage()?.value(forKey: "server_alert") as! String)
                }
            }
        }
    }
    public func uploadListPic(profileData:[Data],user_id:String,type: String,imagecount: String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: ImageURL)
        var parameters = ["user_id":user_id,"type":type,"sitename":webURL]
        if type == "listing" {
            parameters["imagecount"] = imagecount
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for imageData in profileData {
                multipartFormData.append(imageData, withName: "images", fileName: "profilepic.jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:nil)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    // Print("RESPONSE \(response)")
                    if JSON != nil {
                        success(JSON!)
                    }
                    else {
                        let alert = UIAlertController(title: "", message: Utility().language().value(forKey: "failed_upload_image") as? String ?? "failed_upload_image", preferredStyle: .alert)
                        let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                        }
                        alert.addAction(action)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
    
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut{
                }else if error._code == NSURLErrorNotConnectedToInternet{
                }else{
                }
            }
        }
    }
    public func uploadStripePic(profileimage:Data,doctype: String, user_id:String,type: String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: ImageURL)
        let parameters = ["user_id":user_id,"type":type,"sitename":webURL, "doctype":doctype]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(profileimage, withName: "images", fileName: "profilepic.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:nil)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    // Print("RESPONSE \(response)")
                    if JSON != nil {
                        success(JSON!)
                    }
                    else {
                        let alert = UIAlertController(title: "", message: Utility().language().value(forKey: "failed_upload_image") as? String ?? "failed_upload_image", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
                        }
                        alert.addAction(action)
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
    
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut{
                }else if error._code == NSURLErrorNotConnectedToInternet{
                }else{
                }
            }
        }
    }
}
