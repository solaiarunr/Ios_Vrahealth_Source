//
//  ZegoCallViewController.swift
//  Meetdoc
//
//  Created by suriya on 11/07/23.
//  Copyright © 2023 BTMani. All rights reserved.
//
/*
import UIKit
import ZegoUIKit
import Toast_Swift
import ZegoUIKitPrebuiltCall
import ZegoUIKitSignalingPlugin

class ZegoCallViewController: UIViewController {

    var callType = ""
    var TargetUserID = ""
    var TargetUserName = ""
    let appID: UInt32 = 406858947
    var viewModel = CallViewModel()
    var chatData: BookingHistoryResultModel?
    var userData: UserLoginResultModel?
    let appSign: String = "cdd7428d73ddb4ee3b2e404407c6a3a65dc7e52f762b1ce30b5db12d91b62f44"
    let selfUserID: String = UserDefaultModule.shared.getLoginData().userId ?? ""
    
    let voiceCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
    let videoCallButton: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.videoCall.rawValue)
    
    @IBOutlet weak var voiceCallView: UIView! {
        didSet {
            voiceCallButton.frame = CGRect(x: 0, y: 0, width: voiceCallView.bounds.size.width, height: voiceCallView.bounds.size.height)
            voiceCallButton.delegate = self
            voiceCallView.addSubview(voiceCallButton)
        }
    }
    @IBOutlet weak var videoCallView: UIView! {
        didSet {
            videoCallButton.frame = CGRect(x: 0, y: 0, width: videoCallView.bounds.size.width, height: videoCallView.bounds.size.height)
            videoCallButton.delegate = self
            videoCallView.addSubview(videoCallButton)
        }
    }
    
    @IBOutlet weak var inviteesTextField: UITextField! {
        didSet {
            inviteesTextField.delegate = self
            inviteesTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var yourUserIDLabel: UILabel! {
        didSet {
            yourUserIDLabel.text = String(format: "Your UserID:%@", selfUserID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
        // Do any additional setup after loading the view.
    }
    @objc func textDidChange(_ textField: UITextField) {
        guard let userIDString = textField.text else { return }
        let userIDList = userIDString.components(separatedBy: ",")
        self.TargetUserID = userIDString
        var inviteesList: [ZegoUIKitUser] = []
        for userID in userIDList {
            let userName: String = String(format: "%@", userID)
            if userID == "" {
                continue
            }
            let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
            inviteesList.append(user)
        }
        self.voiceCallButton.inviteeList = inviteesList
        self.videoCallButton.inviteeList = inviteesList
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inviteesTextField.endEditing(true)
    }
    
}

extension ViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate {
    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                return config
            }
        } else {
            if data.invitees?.count ?? 0 > 1 {
                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                return config
            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                return config
            }
        }
    }
    
    //MARK: -ZegoSendCallInvitationButtonDelegate
    func onPressed(_ errorCode: Int, errorMessage: String?, errorInvitees: [ZegoUIKitPrebuiltCall.ZegoCallUser]?) {
        var toastMessage: String?
        if errorCode != 0 {
            toastMessage = String(format: "Failed to send a call invitation. code: %d,message:%@",errorCode, errorMessage ?? "")
            self.view.makeToast(toastMessage, duration: 2.0, position: .center)
        } else {
            let errorInvitees: [ZegoCallUser]? = errorInvitees
            guard let errorInvitees = errorInvitees else { return }
            var errorUsers: String = ""
            var index: Int = 0
            for user in errorInvitees {
                if index > 4 {
                    errorUsers.append(contentsOf: "...")
                    break
                }
                if index == 0 {
                    errorUsers.append(contentsOf: String(format: "%@", user.id ?? ""))
                } else {
                    errorUsers.append(contentsOf: String(format: ",%@", user.id ?? ""))
                }
                index = index + 1
            }
            toastMessage = String(format: "User doesn't exist or is offline: %@", errorUsers)
            if errorInvitees.count > 0 {
                getCurrentViewController()?.view.makeToast(toastMessage, duration: 2.0, position: .center)
            }
        }
    }
    
    func getCurrentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.keyWindow
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return vc
    }
}
extension ViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate {
    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
//            if data.invitees?.count ?? 0 > 1 {
//                let config = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//                return config
//            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                return config
        //    }
        } else {
//            if data.invitees?.count ?? 0 > 1 {
//                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                return config
//            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                return config
         //   }
        }
    }
    
    //MARK: -ZegoSendCallInvitationButtonDelegate
    func onPressed(_ errorCode: Int, errorMessage: String?, errorInvitees: [ZegoUIKitPrebuiltCall.ZegoCallUser]?) {
        var toastMessage: String?
        if errorCode != 0 {
            toastMessage = String(format: "Failed to send a call invitation. code: %d,message:%@",errorCode, errorMessage ?? "")
            self.view.makeToast(toastMessage, duration: 2.0, position: .center)
        } else {
            let errorInvitees: [ZegoCallUser]? = errorInvitees
            guard let errorInvitees = errorInvitees else { return }
            var errorUsers: String = ""
            var index: Int = 0
            for user in errorInvitees {
                if index > 4 {
                    errorUsers.append(contentsOf: "...")
                    break
                }
                if index == 0 {
                    errorUsers.append(contentsOf: String(format: "%@", user.id ?? ""))
                } else {
                    errorUsers.append(contentsOf: String(format: ",%@", user.id ?? ""))
                }
                index = index + 1
            }
            toastMessage = String(format: "User doesn't exist or is offline: %@", errorUsers)
            if errorInvitees.count > 0 {
                getCurrentViewController()?.view.makeToast(toastMessage, duration: 2.0, position: .center)
            }
        }
    }
    
    func getCurrentViewController() -> (UIViewController?) {
       var window = UIApplication.shared.keyWindow
       if window?.windowLevel != UIWindow.Level.normal{
         let windows = UIApplication.shared.windows
         for  windowTemp in windows{
           if windowTemp.windowLevel == UIWindow.Level.normal{
              window = windowTemp
              break
            }
          }
        }
       let vc = window?.rootViewController
       return vc
    }
}
*/
