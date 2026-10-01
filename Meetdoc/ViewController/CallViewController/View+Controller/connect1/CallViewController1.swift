//
//  CallViewController1.swift
//  Meetdoc
//
//  Created by APPLE on 28/03/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit
import ConnectyCube
import ConnectyCubeCalls
import Alamofire
import SwiftyJSON


class CallViewController1: UIViewController,CallClientDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var endBtn: UIButton!
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var camBtn: UIButton!
    @IBOutlet weak var userIMgView: UIImageView!
    @IBOutlet weak var UserNameLbl: UILabel!
    
    @IBOutlet weak var timerLbl: UILabel!
    
    private var localVideoView: LocalVideoView?
    var remoteVideoView: RemoteConnectionView?
    private var didBecomeActiveObserver: Any?
    
    open var session: CallSession?
    open var callUUID: UUID?

    private var videoCapture: CallCameraCapture!
    var myNumber : NSNumber!
    var user_img = ""
    var call_type : String!
    var receiverId : String!
    var chatData: BookingHistoryResultModel?
    var userData: UserLoginResultModel?
    var viewModel = CallViewModel()
    var userType = ""
    var userName = ""
    var timerStart : Bool = false
    var countTimer = Timer()
    var startTime = 0
    
    var call_id = ""
    var caller_id = ""
    var callee_id = ""
    var caller_name = ""
    var redirect_url = ""

    var viewType = ""

    private lazy var isInitiator: Bool = {
        Profile.currentProfile?.id == session!.initiatorID.uintValue
    }()
    
    private lazy var isVideoCall: Bool = {
        session!.conferenceType == .video
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userIMgView.cornerViewRadius()
//        self.appDelegate.callUUID = self.callUUID
//        self.appDelegate.session = self.session
        self.UserNameLbl.text = self.userName
        self.timerLbl.text = "Connecting..."
        assert(session != nil, "Attempt to instatiate call controller without correct session")
        CallClient.instance().add(self)
        //SocketClass.sharedInstance.connect(self.chatData?.bookingId ?? "")
        //SocketClass.sharedInstance.delegate1 = self
        
        if isInitiator
        {
            session!.startCall(nil)
            assert(callUUID != nil, "uuid must always be generated whenever callkit is in use")
            CallKitAdapter.shared.updateCall(with: callUUID!, connectingAt: Date())
            self.makeCallToReceiver()
            
        }
        else
        {
            session!.acceptCall(nil)
            let requestDict = NSMutableDictionary()
            requestDict.setValue("accepted", forKey: "status")
            requestDict.setValue(appDelegate.callModel.call_id, forKey: "call_id")
            SocketClass.sharedInstance.acceptcall(requestDict: requestDict)
        }
        
        if (isVideoCall) {
            cofigureVideo()
            self.view.backgroundColor = .black
            self.userIMgView.isHidden = true
            self.UserNameLbl.isHidden = true
            self.timerLbl.isHidden = true
        }else{
            self.camBtn.setImage(UIImage(named: "speaker"), for: .normal)
            if self.user_img != ""{
                let url = URL(string: self.user_img)
                self.userIMgView.sd_setImage(with: url)
            }else{
                self.userIMgView.image = UIImage(named: "profile")
            }

        }
        configureAudio()
        
        // observer for audio route
        didBecomeActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { [weak self] (note) in
            
            if self?.session!.conferenceType == .video
            {
                let audioSession = CallAudioSession.instance()
                if (audioSession.currentAudioDevice != .speaker)
                {
                    audioSession.currentAudioDevice = .speaker
                }
            }
        }
        self.configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        //self.navigationController!.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //SocketClass.sharedInstance.connect(self.chatData?.bookingId ?? "")
//        SocketClass.sharedInstance.delegate1 = self
       // SocketClass.sharedInstance.connect()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        self.resumeVideoCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isVideoCall
    }
    
    func configUI(){
        
        self.endBtn.layer.cornerRadius = self.endBtn.frame.height / 2
        self.endBtn.clipsToBounds = true
        
        self.micBtn.layer.cornerRadius = self.micBtn.frame.height / 2
        self.micBtn.clipsToBounds = true
        
        self.camBtn.layer.cornerRadius = self.camBtn.frame.height / 2
        self.camBtn.clipsToBounds = true

    }
    
    //set timer count
            @objc func updateTimer()  {
                self.startTime += 1
                DispatchQueue.main.async {
                    self.timerLbl.text = self.timeString(time: TimeInterval(self.startTime))
                }
            }
        func timeString(time:TimeInterval)-> String {
                let hours = Int(time) / 3600
                let minutes = Int(time) / 60 % 60
                let seconds = Int(time) % 60
                return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            }
    
    func makeCallToReceiver()  {
       var id = (self.chatData?.chatId ?? "")

       if UserDefaultModule.shared.getLoginData().type == "doctor" {
          // id = self.room_id
           id = (self.chatData?.bookingId ?? "")
       }
        self.viewModel.makeCall(sender_id: (UserDefaultModule.shared.getLoginData().userId), receiver_id: self.receiverId, booking_id: id, trigger_type: self.call_type, call_type: self.call_type, onSuccess: { (success) in
            /*type: self.userType,*/
          // Response.
           
           if self.viewModel.MakeCall?.status ?? false {
               self.call_id = self.viewModel.MakeCall?.call_id ?? ""
               self.redirect_url = self.viewModel.MakeCall?.redirect_url ?? ""
               self.caller_name = (UserDefaultModule.shared.getLoginData().firstName)
               
               let requestDict = NSMutableDictionary()
               requestDict.setValue("initiatecall", forKey: "status")
               requestDict.setValue(self.chatData?.bookingId, forKey: "booking_id")
               requestDict.setValue((UserDefaultModule.shared.getLoginData().userId), forKey: "caller_id")
               requestDict.setValue(self.receiverId, forKey: "callee_id")
               requestDict.setValue(self.caller_name, forKey: "caller_name")
               requestDict.setValue(self.redirect_url, forKey: "redirect_url")
               requestDict.setValue(self.call_id, forKey: "call_id")
               SocketClass.sharedInstance.initiatecall(requestDict: requestDict)
               
           }
           
        }) { (failure) in
            
        }

        //self.perform(#selector(automaticallyDisConnectCall), with: nil, afterDelay: 30.0)

    }
    
    @IBAction func didPressMicSwitchButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        session!.localMediaStream.audioTrack.isEnabled = !sender.isSelected
        if !session!.localMediaStream.audioTrack.isEnabled{
         //   self.micBtn.backgroundColor = UIColor.black
            self.micBtn.setImage(UIImage(named: "mute 1"), for: .normal)
        }else{
           // self.micBtn.backgroundColor = UIColor.gray
            self.micBtn.setImage(UIImage(named: "unmute"), for: .normal)
        }
    }
    
    
    
    @IBAction func didPressCameraRotationButton(_ sender: UIButton) {
        //speaker.wave.1.fill speaker btn icon
                sender.isSelected = !sender.isSelected
                if isVideoCall{
                    self.videoCapture.position = self.videoCapture.position == .back ? .front : .back
                    print("raja:\(self.videoCapture.position)")
                    if self.videoCapture.position == .back{
             //           self.camBtn.backgroundColor = UIColor.black
                    }else{
               //         self.camBtn.backgroundColor = UIColor.gray
                    }
                }else{
                    let audioSession = CallAudioSession.instance()
                    audioSession.currentAudioDevice = audioSession.currentAudioDevice == .speaker ? .receiver : .speaker
                    if audioSession.currentAudioDevice == .speaker{
                        self.camBtn.setImage(UIImage(named: "speaker_off"), for: .normal)
                    }else{
                        self.camBtn.setImage(UIImage(named: "speaker"), for: .normal)
                    }
                }
    }
    
    @IBAction func didPressEnd(_ sender: UIButton) {
        
        session!.hangUp(nil)
        if self.videoCapture != nil {
            self.countTimer.invalidate()
            self.videoCapture.stopSession(nil)
            let requestDict = NSMutableDictionary()
            requestDict.setValue("end", forKey: "status")
            requestDict.setValue(appDelegate.callModel.call_id, forKey: "call_id")
            print(appDelegate.callModel.call_id)
            SocketClass.sharedInstance.endcall(requestDict: requestDict)
            self.viewModel.endCall(call_id: appDelegate.callModel.call_id)
            CallKitAdapter.shared.endCall(with: self.callUUID!)
        }
        
    }
    

    
    // MARK: - Preparations and configurations
    func cofigureVideo() {
        CallConfig.mediaStreamConfiguration().videoCodec = .h264Baseline
        let videoFormat = Profile.videoFormat!
        self.videoCapture = CallCameraCapture(videoFormat: videoFormat, position: .front)
        self.videoCapture.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoCapture.startSession
        {
            let localView = LocalVideoView(withPreviewLayer:self.videoCapture.previewLayer)
            localView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.localVideoView = localView
            self.view.addSubview(self.localVideoView!)
            self.view.bringSubviewToFront(self.endBtn)
            self.view.bringSubviewToFront(self.micBtn)
            self.view.bringSubviewToFront(self.camBtn)
            self.relayout()
        }
        session!.localMediaStream.videoTrack.videoCapture = self.videoCapture
    }
    
    
    func configureAudio() {
        
        let audioSession = CallAudioSession.instance()
        if (!audioSession.isInitialized)
        {
            audioSession.initialize { (configuration: CallAudioSessionConfiguration) -> () in
                
                configuration.categoryOptions = [configuration.categoryOptions, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay]
                
                if (self.isVideoCall)
                {
                    configuration.mode = AVAudioSession.Mode.videoChat.rawValue
                }
            }
        }
    }
    
    // MARK: - CallClientDelegate protocol
    func session(_ session: CallSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        
        if session.id == self.session!.id {
            if isVideoCall
            {
                self.removeRemoteView(with: userID.uintValue)
            }
            if userID == session.initiatorID
            {
                self.session!.hangUp(nil)
            }
        }
    }
    
    func session(_ session: CallBaseSession, connectedToUser userID: NSNumber) {
        
        if (session as! CallSession).id == self.session!.id {
            
            if isInitiator
            {
                CallKitAdapter.shared.updateCall(with: self.callUUID!, connectedAt: Date())
            }
        }
    }
    
    func session(_ session: CallBaseSession, receivedRemoteVideoTrack videoTrack: CallVideoTrack, fromUser userID: NSNumber) {
        
        if (session as! CallSession).id == self.session!.id {
            let remoteView = RemoteConnectionView()
            remoteView.setVideoTrack(videoTrack)
            remoteView.tag = userID.intValue
            /*
            if let user: User = Cache.users.object(forKey: userID.stringValue) {
                remoteView.userName = user.fullName
            }
            else {
                remoteView.userName = userID.stringValue
            }
             */
            self.remoteVideoView = remoteView
            self.view.addSubview(self.remoteVideoView!)
            self.relayout()
        }
        else {
            print("Issue in connect remote view")
        }
    }
    
    func session(_ session: CallBaseSession, didChange state: CallConnectionState, forUser userID: NSNumber) {
        if (session as! CallSession).id == self.session!.id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                           self.updateTimer()
                                           if !self.timerStart{
                                               self.countTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self,selector:#selector(self.updateTimer), userInfo: nil, repeats: true)
                                               self.timerStart = true
                                           }
                                       }
            if self.remoteVideoView != nil{
            self.remoteVideoView!.connectionState = state
                
//            if let i = self.views.index(where: { $0.tag == userID.uintValue }) {
//                let view = self.views[i] as! RemoteConnectionView
//                view.connectionState = state
//            }
            }
        }
    }
    
    func sessionDidClose(_ session: CallSession) {
        
        if session.id == self.session!.id {
            self.countTimer.invalidate()
            CallKitAdapter.shared.endCall(with: self.callUUID!)
            if self.videoCapture != nil {
                self.videoCapture.stopSession(nil)
            }
        
            //self.appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    func session(_ session: CallSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        if session.id == self.session!.id {
            self.countTimer.invalidate()
            CallKitAdapter.shared.endCall(with: self.callUUID!)
            if self.videoCapture != nil {
                self.videoCapture.stopSession(nil)
            }
        
            //self.appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.appDelegate.window?.makeToast("Patient on call with another doctor, please try again later")
        }else{
            self.appDelegate.window?.makeToast("Doctor on call with another patient, please try again later")
        }
    }
    
    // MARK: - Helpers
    
    func resumeVideoCapture() {
        // ideally you should always stop capture session
        // when you are leaving controller in any way
        // here we should get its running state back
        if self.videoCapture != nil && !self.videoCapture.hasStarted {
            session!.localMediaStream.videoTrack.videoCapture = self.videoCapture
            self.videoCapture.startSession(nil)
        }
    }
    
    func removeRemoteView(with userID: UInt)
    {
        self.remoteVideoView!.removeFromSuperview()
//        if let i = self.views.index(where: { $0.tag == userID })
//        {
//            self.views.remove(at: i)
//            self.relayout(with: self.views)
//        }
    }
    
    func relayout() {
        if isVideoCall && self.remoteVideoView != nil
        {
            self.remoteVideoView?.removeFromSuperview()
            self.localVideoView?.removeFromSuperview()
            
            if self.localVideoView != nil {
                self.view.addSubview(self.remoteVideoView!)
                self.view.addSubview(self.localVideoView!)
                
                if UIDevice.current.hasNotch{
                    
//                    self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+105), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                    self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:60, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                    self.remoteVideoView!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    
                }else{
                    
//                    self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+75), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                    self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:20, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                    self.remoteVideoView!.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                self.view.bringSubviewToFront(remoteVideoView!)
                self.view.bringSubviewToFront(localVideoView!)
                self.view.bringSubviewToFront(micBtn)
                self.view.bringSubviewToFront(endBtn)
                self.view.bringSubviewToFront(camBtn)
                let localtobig = MyTapGesture(target: self, action: #selector(self.localtobig))
                self.localVideoView!.addGestureRecognizer(localtobig)

                let remotetobig = MyTapGesture(target: self, action: #selector(self.remotetobig))
                self.remoteVideoView!.addGestureRecognizer(remotetobig)
                
                
            }
            else {
                print("View Returs Nil:: Local: \(self.localVideoView), remote: \(self.remoteVideoView)")
            }
        }
        else {}
    }
    
    @objc func localtobig(_ sender: MyTapGesture) {
        if isVideoCall
        {
 
            self.view.bringSubviewToFront(self.localVideoView!)
            self.localVideoView!.frame = self.view.bounds
            
            if UIDevice.current.hasNotch{
//                self.remoteVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+105), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                self.remoteVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:60, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
            }else{
//                self.remoteVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+75), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                self.remoteVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:20, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
            }
        
            self.view.bringSubviewToFront(self.remoteVideoView!)
            self.view.bringSubviewToFront(endBtn)
            self.view.bringSubviewToFront(micBtn)
            self.view.bringSubviewToFront(camBtn)

        }
    }

    @objc func remotetobig(_ sender: MyTapGesture) {
        if isVideoCall
        {
            self.remoteVideoView!.frame = self.view.bounds
            
            if UIDevice.current.hasNotch{
                
//                self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+105), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:60, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
            }else{
                
//                self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y: self.view.frame.height-((((self.view.frame.width/2)-30)*1.3)+75), width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
                self.localVideoView!.frame = CGRect(x: ((self.view.frame.width/2)), y:20, width: ((self.view.frame.width/2)-15), height: (((self.view.frame.width/2)-30)*1.3))
            }

            self.view.bringSubviewToFront(self.localVideoView!)
            self.view.bringSubviewToFront(endBtn)
            self.view.bringSubviewToFront(micBtn)
            self.view.bringSubviewToFront(camBtn)
        
        }
      
    }

}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

class MyTapGesture: UITapGestureRecognizer {
    
}
