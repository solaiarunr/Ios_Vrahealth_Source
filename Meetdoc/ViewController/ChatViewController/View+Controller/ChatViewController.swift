//
//  ChatViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import CoreGraphics
//import MLKitSmartReply
//import iRecordView
import AVFoundation

import Photos
import PhotosUI
import QuickLook
import MobileCoreServices
import ImageSlideshow
import WebKit
import SwiftUI
import ZegoUIKit
import Toast_Swift
import ZegoUIKitPrebuiltCall
import ZegoUIKitSignalingPlugin


class ChatViewController: UIViewController {
    
    @IBOutlet weak var smartReplyCollectionView: UICollectionView!
    @IBOutlet weak var expireLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var sendStackView: UIStackView!
    @IBOutlet weak var stackViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var textViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typeingTextLbl: UILabel!
    
    
    
    @IBOutlet weak var square: UIView!
    @IBOutlet weak var allMenuBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var cameraLbl: UILabel!
    @IBOutlet weak var mediaLbl: UILabel!
    @IBOutlet weak var fileLbl: UILabel!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var mediaBtn: UIButton!
    @IBOutlet weak var fileBtn: UIButton!
    @IBOutlet weak var chatTypetextView: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    var imagePicker = UIImagePickerController()
    var imageModel = [ImageResultModel]()
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate? = nil
    var doctype = ""
    var docname = ""
    var openType = ""
    
    // AddOns: Voice messages
//    @IBOutlet weak var recordView: RecordView!
//    @IBOutlet weak var recordButton: RecordButton!
//    let recorderView = RecordView()

    let IS_AUDIO = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioduration = ""
    var selectedAudio = ""
    var audioPlayer = AVAudioPlayer()
    var timer = Timer()
    var counter = 0
    var imageArray = NSMutableArray()
    var hide_status = ""
    var slotStartTime = 0
    var videoStartTime = 0
    var slotEndTime = 0
    let videoBtn: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.videoCall.rawValue)
    let audioBtn: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
    let videooffBtn = UIButton()
    let audiooffBtn = UIButton()
    let dotsBtn = UIButton()
    var callType = ""


    

    // Gif
    @IBOutlet weak var gifButton: UIButton!
    let IS_GIF = false

    var viewModel = ChatViewModel()
    var viewModel1 = DoctorViewModel()
    var viewModel2 = BookingHistoryViewModel()
    var id = ""
    var userName = ""
    var offset = 0
    var limit = 20
    var isFound = true
    var tempData = [ChatResultModel]()
    var chatData = [ChatResultModel]()
    var refreshControl = UIRefreshControl()
    var status = ""
    var receiverID = ""
    var receiverImage = ""
    var messageID = ""
    var isFromBooking = false
    var isFromPushNotification = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Smart Reply
//    var smartReplyArray = [SmartReplySuggestion]()
    let child = SpinnerViewController()
    var isCancel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableViewLoadAnimation(0)
        self.view.addSubview(indicatorView)
        self.checkReachability()
        self.videooffBtn.isHidden = true
        self.audiooffBtn.isHidden = true
//        videoBtn.resourceID = "76757675"
//        audioBtn.resourceID = "76757675"
        videoBtn.resourceID = UserDefaults.standard.value(forKey: "zego_resourceID") as? String
        audioBtn.resourceID = UserDefaults.standard.value(forKey: "zego_resourceID") as? String
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        let tap = UITapGestureRecognizer(target: self,action: #selector(tappedSquare(_:)))
        self.view.addGestureRecognizer(tap)
//        SocketClass.sharedInstance.connect(self.id)
        SocketClass.sharedInstance.connect()
        SocketClass.sharedInstance.delegate = self
        SocketClass.sharedInstance.connectChat(messageID: self.id)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.configUI()
    }
    @objc func refresh(_ sender:UIRefreshControl) {
        self.offset = self.chatData.count
        if self.offset == 0 {
            self.tempData.removeAll()
        }
        self.loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        SocketClass.sharedInstance.disconnect()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func configUI() {
        self.webView.navigationDelegate = self
        self.webView.isHidden = true
        self.sendButton.isHidden = false
        self.imagePicker.delegate = self
        self.smartReplyCollectionView.isHidden = true
        
        self.square.layer.cornerRadius = 5
        self.square.elevationEffect()
        self.square.isHidden = true
        self.allMenuBtn.cornerViewRadius()
        
        self.cameraLbl.config(color: UIColor(named: "BlackColor"), font: regularFont, align: .left, text: "camera")
        self.statusLabel.config(color: UIColor(named: "BlackColor"), font: regularFont, align: .center, text: "Unable to message because booking has expired")
        self.mediaLbl.config(color: UIColor(named: "BlackColor"), font: regularFont, align: .left, text: "media")
        self.fileLbl.config(color: UIColor(named: "BlackColor"), font: regularFont, align: .left, text: "file")
        self.typeingTextLbl.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, text: "typeing")
        
        
        /*
        self.smartReplyCollectionView.delegate = self
        self.smartReplyCollectionView.dataSource = self
         */
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        self.recordView.isHidden = true
        if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" && userName != ""{
            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "Dr.\(userName)", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
         }
        else {
            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: userName, fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        }
        self.blockView.isHidden = true
        self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "chat has been blocked")
        self.expireLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "expired")
        self.tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.tableView.register(UINib(nibName: "EmojiTableViewCell", bundle: nil), forCellReuseIdentifier: "EmojiTableViewCell")
        self.tableView.register(UINib(nibName: "VoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "VoiceTableViewCell")
        
        
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        self.tableView.register(UINib(nibName: "DocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentTableViewCell")
        self.tableView.register(UINib(nibName: "UploadFileTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadFileTableViewCell")
        self.tableView.register(UINib(nibName: "CallTableViewCell", bundle: nil), forCellReuseIdentifier: "CallTableViewCell")
//        self.recordButton.cornerViewRadius()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        Utility().startAnimation(viewController: self)
        self.chatData.removeAll()
        self.tempData.removeAll()
        self.offset = 0
        self.isFound = true
        self.tableView.reloadData()
        self.chatStackView.isHidden = true
        self.loadData()
        
        // TextView & Send Button
        self.textViewHeightConst.priority = .defaultHigh
        self.textView.config(color: UIColor(named: "BlackColor") ?? .white, font: regularFont, align: .left, text: "type_a_message")
        self.textView.layer.cornerRadius = 20
        self.sendButton.cornerViewRadius()
        self.sendButton.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .right, title: "")
//        self.setRightBarButtonItem()
        
        // Smart Reply
        self.smartReplyCollectionView.register(UINib(nibName: "SmartReplyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SmartReplyCollectionViewCell")
        if let flowLayout = self.smartReplyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        // Gif Addon
        self.gifButton.isHidden = !IS_GIF
        
        
        // MARK: Audio Addon
//        self.recordButton.isHidden = !IS_AUDIO
//        self.configRecordView()
    }
    func setRightBarButtonItem() {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            var timestamp = NSDate().timeIntervalSince1970
            if Int(timestamp) >= self.videoStartTime {
                //MARK: VideoCall Button
                self.videoBtn.delegate = self
                self.videoBtn.setImage(#imageLiteral(resourceName: "new_videocall"), for: UIControl.State.normal)
                self.videoBtn.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
                print("ELSE IF 1")
                //MARK: AudioCall Button
                self.audioBtn.delegate = self
                self.audioBtn.setImage(#imageLiteral(resourceName: "new_call"), for: UIControl.State.normal)
                self.audioBtn.addTarget(self, action: #selector(self.rightBarButtonAct1(_:)), for: .touchUpInside)
            }else{
                self.videoBtn.isHidden = true
                self.audioBtn.isHidden = true
                self.audiooffBtn.isHidden = false
                self.videooffBtn.isHidden = false
                
                self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct3(_:)), for: .touchUpInside)
                self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                print("IF")
                self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct5(_:)), for: .touchUpInside)
                self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            }
        }else{
            var timestamp = NSDate().timeIntervalSince1970
//            if (Int(timestamp) >= self.videoStartTime) && (Int(timestamp) < self.slotStartTime) {
            if (Int(timestamp) < self.slotStartTime) {
                print("IFCONDITION")
                self.videoBtn.isHidden = true
                self.audioBtn.isHidden = true
                self.audiooffBtn.isHidden = false
                self.videooffBtn.isHidden = false
                
                self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct3(_:)), for: .touchUpInside)
                self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                print("IF")
                self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct5(_:)), for: .touchUpInside)
                self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            }
            else if (Int(timestamp) >= self.slotStartTime) && (Int(timestamp) <= self.slotEndTime){
                //MARK: VideoCall Button
                self.videoBtn.delegate = self
                self.videoBtn.setImage(#imageLiteral(resourceName: "new_videocall"), for: UIControl.State.normal)
                self.videoBtn.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
                print("ELSE IF 1")
                //MARK: AudioCall Button
                self.audioBtn.delegate = self
                self.audioBtn.setImage(#imageLiteral(resourceName: "new_call"), for: UIControl.State.normal)
                self.audioBtn.addTarget(self, action: #selector(self.rightBarButtonAct1(_:)), for: .touchUpInside)
            }
            else if (Int(timestamp) > self.slotEndTime){
                self.videoBtn.isHidden = true
                self.audioBtn.isHidden = true
                self.audiooffBtn.isHidden = false
                self.videooffBtn.isHidden = false
                print("ELSE IF 2 \((Int(timestamp))),\(self.slotEndTime),\(self.slotStartTime)")
                self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                
                self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            }
            else{
                print("ELSE \((Int(timestamp))),\(self.slotEndTime),\(self.slotStartTime)")
                self.videoBtn.isHidden = true
                self.audioBtn.isHidden = true
                self.videooffBtn.isHidden = true
                self.audiooffBtn.isHidden = true
            }
        }
        //MARK: VideoCall Button
        self.videoBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.videoBtn.tintColor = UIColor(named: "whitecolor")
        self.videoBtn.tag = 0
        self.videoBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        //MARK: AudioCall Button
        self.audioBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.audioBtn.tag = 1
        self.audioBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.audioBtn.imageView?.tintColor = UIColor(named: "White")
        //MARK: ThreeDots Button
        self.dotsBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.dotsBtn.tintColor = UIColor(named: "whitecolor")
        self.dotsBtn.setImage(#imageLiteral(resourceName: "dots"), for: UIControl.State.normal)
        self.dotsBtn.imageView?.tintColor = UIColor(named: "White")
        self.dotsBtn.tag = 0
        self.dotsBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.dotsBtn.addTarget(self, action: #selector(self.settingButtonAct), for: .touchUpInside)
        
        let stackview = UIStackView.init(arrangedSubviews: [self.videoBtn,self.audioBtn,self.videooffBtn,self.audiooffBtn,self.dotsBtn])
        stackview.distribution = .fillEqually
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 10
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
        /*
        let barButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        barButton2.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton2.addTarget(self, action: #selector(self.settingButtonAct), for: .touchUpInside)
        barButton2.config(color: UIColor(named: "White"), font: regularFont, align: .right, title: "")
        barButton2.imageView?.tintColor = UIColor(named: "White") ?? .white
        barButton2.setImage(#imageLiteral(resourceName: "dots"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton2)
        let videocall_barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        videocall_barButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        videocall_barButton.addTarget(self, action: #selector(self.videoCallBtu), for: .touchUpInside)
        videocall_barButton.config(color: UIColor(named: "White"), font: regularFont, align: .right, title: "")
        videocall_barButton.imageView?.tintColor = UIColor(named: "White") ?? .white
        videocall_barButton.setImage(#imageLiteral(resourceName: "call"), for: .normal)
        
        let audiocall_barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        audiocall_barButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        audiocall_barButton.addTarget(self, action: #selector(self.audioCallBtu), for: .touchUpInside)
        audiocall_barButton.config(color: UIColor(named: "White"), font: regularFont, align: .right, title: "")
        audiocall_barButton.imageView?.tintColor = UIColor(named: "White") ?? .white
        audiocall_barButton.setImage(#imageLiteral(resourceName: "call"), for: .normal)
        */
        // MARK: Add BarButton for Chat Translation
        /*
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        barButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton.addTarget(self, action: #selector(self.locationButtonAct), for: .touchUpInside)
        barButton.config(color: UIColor(named: "White"), font: regularFont, align: .right, title: "")
        barButton.imageView?.tintColor = UIColor(named: "White") ?? .white
        barButton.setImage(#imageLiteral(resourceName: "world-grid"), for: .normal)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barButton2), UIBarButtonItem(customView: barButton)]
         */
        /*
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barButton2), UIBarButtonItem(customView: videocall_barButton),UIBarButtonItem(customView: audiocall_barButton)]
    }
    @objc func videoCallBtu(){
        print("VideoCall")
        self.navigationController?.pushViewController(newprescriptionpageViewController(), animated: true)
    }
    @objc func audioCallBtu(){
        print("AudioCall")
         */
    }
    @objc func locationButtonAct() {
        /*
        self.textView.endEditing(true)
        DispatchQueue.main.async {
            let pageObj = ChatTranslationViewController()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
         */
    }
    @objc func settingButtonAct() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: (getLanguage["check"] ?? "check"), style: .default, handler: { (UIAlertAction) in
            if self.isFromBooking {
                self.timer.invalidate()
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let pageObj = BookingDetailsViewController()
                pageObj.isFromChat = true
                pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
                pageObj.booking_id = self.id
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }))
        var titleVal = "block"
        
        if (self.viewModel.chatModel?.block_id ?? "") == "\(UserDefaultModule.shared.getLoginData().userId ?? "")"{
            titleVal = "unblock"
        }
        if (self.viewModel.chatModel?.block_id ?? "") == "" || (self.viewModel.chatModel?.block_id ?? "") == "0"  || (self.viewModel.chatModel?.block_id ?? "") == "\(UserDefaultModule.shared.getLoginData().userId ?? "")" {
            alert.addAction(UIAlertAction(title: (getLanguage[titleVal] ?? titleVal), style: .default, handler: { (UIAlertAction) in
                self.viewModel.blockUser(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), id: self.id) { (success) in
                    if (self.viewModel.blockModel?.status ?? false) {
                        if titleVal == "unblock"{
                            self.viewModel.chatModel?.block_id = "0"
                            self.sendStackView.isHidden = false
                            self.blockView.isHidden = true
                            if self.hide_status == "expired" {
                                self.blockView.isHidden = false
                                self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has expired")
                                self.chatTypetextView.isHidden = true
                                self.videoBtn.isHidden = true
                                self.audioBtn.isHidden = true
                                self.statusLabel.isHidden = true
                            } else if self.hide_status == "declined" {
                                self.blockView.isHidden = false
                                self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has declined")
                                self.chatTypetextView.isHidden = true
                                self.videoBtn.isHidden = true
                                self.audioBtn.isHidden = true
                                self.statusLabel.isHidden = true
                            }else if self.hide_status == "refunded" {
                                self.blockView.isHidden = false
                                self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has refunded")
                                self.chatTypetextView.isHidden = true
                                self.videoBtn.isHidden = true
                                self.audioBtn.isHidden = true
                                self.statusLabel.isHidden = true
                            }else if self.hide_status == "cancelled" {
                                self.blockView.isHidden = false
                                self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has cancelled")
                                self.chatTypetextView.isHidden = true
                                self.videoBtn.isHidden = true
                                self.audioBtn.isHidden = true
                                self.statusLabel.isHidden = true
                            }else {
                                if self.viewModel.chatModel?.payment_status == "pending"{
                                    self.audioBtn.isHidden = true
                                    self.videoBtn.isHidden = true
                                    self.audiooffBtn.isHidden = true
                                    self.videooffBtn.isHidden = true
                                }
                                self.blockView.isHidden = true
                                self.chatTypetextView.isHidden = false
                                self.statusLabel.isHidden = true
                            }
                        }
                        else {
                            self.viewModel.chatModel?.block_id = (UserDefaultModule.shared.getLoginData().userId ?? "")
                            self.sendStackView.isHidden = true
                            self.blockView.isHidden = false
                            self.statusLabel.isHidden = true
                        }
                        self.view.makeToast(getLanguage[self.viewModel.blockModel?.message ?? ""] ?? (self.viewModel.blockModel?.message ?? ""))
                    }
                } onFailure: { (failure) in
                    
                }

            }))
        }
        else {
            self.smartReplyCollectionView.isHidden = true
        }
        alert.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.stackViewBottomConst.constant = keyboardFrame.height
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.scrollToBottom()
            self.view.layoutIfNeeded()
        })
        print(self.stackViewBottomConst.constant)
        self.viewDidLayoutSubviews()
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.stackViewBottomConst.constant = 0
        print(self.stackViewBottomConst.constant)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        //        self.bgView.frame.size.height = self.view.frame.size.height + keyboardFrame.height
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        
        if self.openType == "document" {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.webView.isHidden = true
                self.openType = ""
            })
        } else {
            if let isLeft = notification.userInfo?["isLeft"] as? Int {
                print(isLeft)
                if isLeft == 0 {
                    if isFromPushNotification {
                        if UserDefaultModule.shared.getLoginData().type.lowercased() == "doctor" {
                            let pageObj = DoctorTabViewController()
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }
                        else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                            let pageObj = DCTabbarViewController()
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }
                        else {
                            let pageObj = UserTabbarController()
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }
                    }
                    self.timer.invalidate()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
//        if let isLeft = notification.userInfo?["isLeft"] as? Int {
//            print(isLeft)
//            if isLeft == 0 {
//                if isFromPushNotification {
//                    if UserDefaultModule.shared.getLoginData().type.lowercased() == "doctor" {
//                        let pageObj = DoctorTabViewController()
//                        self.appDelegate.setInitialViewController(initialView: pageObj)
//                    }
//                    else {
//                        let pageObj = UserTabbarController()
//                        self.appDelegate.setInitialViewController(initialView: pageObj)
//                    }
//                }
//                self.timer.invalidate()
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
    func TableViewLoadAnimation(_ tag: Int) {
        self.scrollToBottom()
        if tag == 0 {
//            self.activityView.isHidden = true
//            self.activityView.stopAnimating()
            self.typeingTextLbl.isHidden = true
        }
        else {
//            self.activityView.isHidden = false
//            self.activityView.startAnimating()
            self.typeingTextLbl.isHidden = false
        }
    }
    func loadData() {
        
        self.viewModel.getChatData(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", offset: "\(offset)", limit: "\(limit)", id: id, onSuccess: { (success) in
            if !(self.viewModel.chatModel?.status ?? false) {
                self.isFound = false
            }
            else {
                self.slotStartTime = Int(self.viewModel.chatModel?.slot_time ?? "") ?? 0
                self.slotEndTime = Int(self.viewModel.chatModel?.slot_Endtime ?? "") ?? 0
                if UserDefaultModule.shared.getLoginData().type == "doctor"{
                    self.videoStartTime = (Int(self.viewModel.chatModel?.slot_time ?? "") ?? 0)-1800
                }else{
                    self.videoStartTime = (Int(self.viewModel.chatModel?.slot_time ?? "") ?? 0)-300
                }
                self.setRightBarButtonItem()
                self.status = self.viewModel.chatModel?.orderStatus ?? ""
                self.receiverID = "\(self.viewModel.chatModel?.userId ?? 0)"
                if self.viewModel.chatModel?.result != nil && (self.viewModel.chatModel?.result.count ?? 0) > 0 {
                    var arr = [ChatResultModel]()
                    if self.tempData.count > 0
                    {
                        for temp in self.viewModel.chatModel?.result ?? [ChatResultModel]() {
                            if !(self.tempData.contains(where: {$0.chatId == temp.chatId})) {
                                arr.append(temp)
                            }
                        }
                        self.tempData += arr
                    }
                    else {
                        self.tempData = self.viewModel.chatModel!.result
                        for temp in self.tempData {
                            
                      //      if !(self.tempData.contains(where: {$0.chatId == temp.chatId})) {
                            if "\(temp.userId ?? 0)" != UserDefaultModule.shared.getLoginData().userId{
                                self.receiverImage = temp.userImage
                            }
                        }
                        print("RECIVERIMAGE:\(self.receiverImage)")
                    }
                    if (self.viewModel.chatModel?.block_id ?? "") != "" && (self.viewModel.chatModel?.block_id ?? "") != "0" {
                        self.blockView.isHidden = false
                        self.statusLabel.isHidden = true
                        self.sendStackView.isHidden = true
                    }
                    else {
                        self.blockView.isHidden = true
                        if self.hide_status == "expired" {
                            self.blockView.isHidden = false
                            self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has expired")
                            self.chatTypetextView.isHidden = true
                            self.statusLabel.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioBtn.isHidden = true
                        } else if self.hide_status == "declined" {
                            self.blockView.isHidden = false
                            self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has declined")
                            self.chatTypetextView.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioBtn.isHidden = true
                            self.statusLabel.isHidden = true
                        }else if self.hide_status == "refunded" {
                            self.blockView.isHidden = false
                            self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has refunded")
                            self.chatTypetextView.isHidden = true
                            self.statusLabel.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioBtn.isHidden = true
                        }else if self.hide_status == "cancelled" {
                            self.blockView.isHidden = false
                            self.blockLabel.config(color: UIColor(named: "White"), font: regularFont, align: .center, text: "Unable to message because booking has cancelled")
                            self.chatTypetextView.isHidden = true
                            self.statusLabel.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioBtn.isHidden = true
                        }else {
                            if self.viewModel.chatModel?.payment_status == "pending"{
                                self.audioBtn.isHidden = true
                                self.videoBtn.isHidden = true
                                self.audiooffBtn.isHidden = true
                                self.videooffBtn.isHidden = true
                            }
                            self.blockView.isHidden = true
                            self.chatTypetextView.isHidden = false
                            self.statusLabel.isHidden = true
                        }
                        self.sendStackView.isHidden = false
                        if self.viewModel.chatModel?.hidechat ?? false{
                            self.expireLabel.isHidden = false
                            self.sendStackView.isHidden = true
                        }
                        else {
                            self.expireLabel.isHidden = true
                            self.sendStackView.isHidden = false
                        }
                    }
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        var inviteesList: [ZegoUIKitUser] = []
                        inviteesList.removeAll()
                        let user: ZegoUIKitUser = ZegoUIKitUser.init("\((self.viewModel.chatModel?.userId ?? 0))", (self.viewModel.chatModel?.userName ?? ""))
                        inviteesList.append(user)
                        self.videoBtn.inviteeList = inviteesList
                        self.audioBtn.inviteeList = inviteesList
                    }else{
                        var inviteesList: [ZegoUIKitUser] = []
                        inviteesList.removeAll()
                        let user: ZegoUIKitUser = ZegoUIKitUser.init((self.viewModel.chatModel?.doctor_id ?? ""), (self.viewModel.chatModel?.userName ?? ""))
                        inviteesList.append(user)
                        self.videoBtn.inviteeList = inviteesList
                        self.audioBtn.inviteeList = inviteesList
                    }
                    self.chatData = self.tempData.reversed()
                    for val in self.chatData{
                        if val.chatType == "chatimage"{
                            self.imageArray.add(val.message)
                        }
                    }
                    self.chatStackView.isHidden = false
                    if self.offset == 0 {
                        self.isFound = false
                    }
                    self.tableView.reloadData()
                    if self.offset == 0 {
                        self.scrollToBottom(true)
                    }
                    let userData = self.chatData.filter({"\($0.userId ?? 0)" != (UserDefaultModule.shared.getLoginData().userId ?? "")}).first
                    if (userData?.userName ?? "") != "" {
                        if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" {
                            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "Dr.\(userData?.userName ?? "")", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
                         }
                        else {
                            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (userData?.userName ?? ""), fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
                        }
                    }
                }
                self.loadSmartReply()
            }
            Utility().stopAnimation(viewController: self)
            self.refreshControl.endRefreshing()
        }) { (failure) in
            Utility().stopAnimation(viewController: self)
        }
    }
    
    @IBAction func allMenuBtnAct(_ sender: UIButton) {
        
        self.view.endEditing(true)
        //self.fadeIn()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.square.isHidden = false
        })
    }
    
    @IBAction func fileButtonAct(_ sender: UIButton) {
        self.square.isHidden = true
       // self.fadeOut()
        self.picDocument()
    }
    @IBAction func cameraButtonAct(_ sender: UIButton) {
       self.square.isHidden = true
       self.imagePicker.sourceType = .camera
       self.imagePicker.modalPresentationStyle = .fullScreen
       self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
    }
    @IBAction func galleryButtonAct(_ sender: UIButton) {
        self.square.isHidden = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func picDocument()  {
        let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeJPEG,"com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document")
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.view.semanticContentAttribute = .forceLeftToRight
        for subview in documentPicker.view.subviews {
            subview.semanticContentAttribute = .forceLeftToRight
        }
        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = .formSheet
        self.navigationController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func sendimage(_ url: String) {
        
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.id, forKey: "listingId")
        requestDict.setValue(self.receiverID, forKey: "receiverId")
        requestDict.setValue(self.id, forKey: "inquiryId")
        requestDict.setValue(UserDefaultModule().getCurrentUserID()!, forKey: "senderId")
        requestDict.setValue(url, forKey: "message")
        requestDict.setValue("", forKey: "audio_duration")
        requestDict.setValue("chatimage", forKey: "chat_type")
        requestDict.setValue("", forKey: "docname")
        requestDict.setValue("", forKey: "lat")
        requestDict.setValue("", forKey: "lon")
        SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
        self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: url, receiverId: self.receiverID, listingId: self.id,id: self.id,chat_type: "chatimage", audio_duration: "", docname: "",lat: "",lon: "",doctype: "", onSuccess: { (success) in
            print(success)
            if (self.viewModel.sendChatModel?.status ?? false) {
              //  if let result = self.viewModel.sendChatModel?.result {
                    
                    // Send chat Act
                /*
                    var data: [String: Any] = [:]
                    data["chat_id"] = self.id
                    let timezoneOffset =  TimeZone.current.secondsFromGMT()
                    let epochDate = (Date().timeIntervalSince1970)
                    let localDate = (epochDate + Double(timezoneOffset))
                    data["date"] = localDate
                    data["time"] = epochDate
                    data["user_id"] = UserDefaultModule().getCurrentUserID()!
                    data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
                    data["user_name"] = self.userName
                    data["message"] = self.viewModel.sendChatModel?.result.message
                    data["audio_duration"] = ""
                    data["chat_type"] = "chatimage"
                    
                    data["docname"] = ""
                    data["doctype"] = ""
                    data["lat"] = ""
                    data["lon"] = ""
                  

                    let chatData = ChatResultModel.init(fromJson: JSON(data))
                    self.chatData.append(chatData)
                    self.chatStackView.isHidden = false
                    self.tableView.reloadData()
                    self.scrollToBottom()
                    self.loadSmartReply()
                 */
             //   }
            }
        }) { (failure) in
            print(failure)
        }
        
        var data: [String: Any] = [:]
        data["chat_id"] = self.id
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = (Date().timeIntervalSince1970)
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: now)
        data["date"] = epochDate
        data["time"] = dateString
        data["user_id"] = UserDefaultModule().getCurrentUserID()!
        data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
        data["user_name"] = self.userName
        data["message"] = url
        data["audio_duration"] = ""
        data["chat_type"] = "chatimage"
        
        data["docname"] = ""
        data["doctype"] = ""
        data["lat"] = ""
        data["lon"] = ""
      

        let chatData = ChatResultModel.init(fromJson: JSON(data))
        self.chatData.append(chatData)
        self.chatStackView.isHidden = false
        self.tableView.reloadData()
        self.scrollToBottom()
        self.loadSmartReply()
        
        

    }
    
    func senddocument(_ url: String,_ docname: String) {
        
//        let value = URL(string: url)?.pathExtension
//        print(value)
        
        
        let file = url
        let fileExtension = file.fileExtension()
        
        print(fileExtension)
        
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.id, forKey: "listingId")
        requestDict.setValue(self.receiverID, forKey: "receiverId")
        requestDict.setValue(self.id, forKey: "inquiryId")
        requestDict.setValue(UserDefaultModule().getCurrentUserID()!, forKey: "senderId")
        requestDict.setValue(url, forKey: "message")
        requestDict.setValue("", forKey: "audio_duration")
        requestDict.setValue("chatdocument", forKey: "chat_type")
        requestDict.setValue(docname, forKey: "docname")
        requestDict.setValue(fileExtension, forKey: "doctype")
        requestDict.setValue("", forKey: "lat")
        requestDict.setValue("", forKey: "lon")
        SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
        self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: url, receiverId: self.receiverID, listingId: self.id,id: self.id,chat_type: "chatdocument", audio_duration: "", docname: docname,lat: "",lon: "",doctype: fileExtension, onSuccess: { (success) in
            print(success)
            print(self.viewModel.sendChatModel?.status)
            self.doctype = (self.viewModel.sendChatModel?.result.doctype) ?? ""
            self.docname = self.viewModel.sendChatModel?.result.docname ?? ""
            if (self.viewModel.sendChatModel?.status ?? false) {
             //   if let result = self.viewModel.sendChatModel?.result {

                
                /*
                
                    var data: [String: Any] = [:]
                    data["chat_id"] = self.id
                    let timezoneOffset =  TimeZone.current.secondsFromGMT()
                    let epochDate = (Date().timeIntervalSince1970)
                    let localDate = (epochDate + Double(timezoneOffset))
                    data["date"] = localDate
                    data["time"] = epochDate
                    data["user_id"] = UserDefaultModule().getCurrentUserID()!
                    data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
                    data["user_name"] = self.userName
                    data["message"] = self.viewModel.sendChatModel?.result.message
                    data["audio_duration"] = ""
                    data["chat_type"] = "chatdocument"
                    data["docname"] = self.docname
                    data["doctype"] = self.doctype
                  
                    data["lat"] = ""
                    data["lon"] = ""

                    let chatData = ChatResultModel.init(fromJson: JSON(data))
                    self.chatData.append(chatData)
                    self.chatStackView.isHidden = false
                    self.tableView.reloadData()
                    self.scrollToBottom()
                    self.loadSmartReply()
                    
                    */
               // }
            }
        }) { (failure) in
            print(failure)
        }
        
        // Send chat Act
         var data: [String: Any] = [:]
         data["chat_id"] = self.id
         let timezoneOffset =  TimeZone.current.secondsFromGMT()
         let epochDate = (Date().timeIntervalSince1970)
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm a"
        let dateString = formatter.string(from: now)
        data["date"] = epochDate
        data["time"] = dateString
         data["user_id"] = UserDefaultModule().getCurrentUserID()!
         data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
         data["user_name"] = self.userName
         data["message"] = url
         data["audio_duration"] = ""
         data["chat_type"] = "chatdocument"
         data["docname"] = docname
         data["doctype"] = fileExtension
         print(data["doctype"])
       
      //  "https://appservices.hitasoft.in/lawtiq/albums/images/chatdocument/1652165349_groupattac.pdf"
        
         data["lat"] = ""
         data["lon"] = ""

         let chatData = ChatResultModel.init(fromJson: JSON(data))
         self.chatData.append(chatData)
         self.chatStackView.isHidden = false
         self.tableView.reloadData()
         self.scrollToBottom()
         self.loadSmartReply()
    }
    @objc func tappedSquare(_ sender: AnyObject){
        
        //self.fadeOut()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
            self.square.isHidden = true
        }, completion: nil)
        
    }
    
    @objc func documentTapped(sender: UIButton){
        self.openType = "document"
        var img_url = self.chatData[sender.tag].message ?? ""
        if !img_url.contains("http") {
            img_url = "\(webURL)\(img_url)"
        }
        if let url = URL(string: img_url) {
            let fileExtension = url.pathExtension
        
        Utility.shared.startAnimation(viewController: self)
        self.webView.isHidden = false
        self.webView.load(URLRequest(url: url))
        }
        
    }
    
    @objc func imageTapped(sender: UIButton){
        // let chatModel = self.chatData[indexPath.row]
        print(self.chatData[sender.tag].chatType)
         print(self.chatData[sender.tag].message)
        
             let fullScreenController = FullScreenSlideshowViewController()
             var imageSource = [SDWebImageSource]()
             //image check
             imageSource.append(SDWebImageSource(urlString: self.chatData[sender.tag].message ?? "", placeholder: #imageLiteral(resourceName: "placeholder"))!)
             fullScreenController.backgroundColor = UIColor(white: 0, alpha: 0.7)
        //image check
             fullScreenController.closeButton.setImage(#imageLiteral(resourceName: "close_x"), for: .normal)
             fullScreenController.closeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
             fullScreenController.closeButton.tintColor = .black
             fullScreenController.inputs = imageSource
             fullScreenController.initialPage = sender.tag
             
        
             fullScreenController.slideshow.currentPageChanged = { [weak self] page in
                 if let cell = self!.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ImageTableViewCell, let imageView = cell.Imageview {
                     self?.slideshowTransitioningDelegate?.referenceImageView = imageView
                     
                 }
             }
             present(fullScreenController, animated: true, completion: nil)
        
    }
    
    @IBAction func sendButtonAct(_ sender: UIButton) {
//        self.sendButton.isUserInteractionEnabled = false
        let message = self.textView.text.trimmingCharacters(in: .whitespaces)
        if self.textView.tag != 0 && message != "" {
            
            let requestDict = NSMutableDictionary()
            requestDict.setValue(self.id, forKey: "listingId")
            requestDict.setValue(self.receiverID, forKey: "receiverId")
            requestDict.setValue(self.id, forKey: "inquiryId")
            requestDict.setValue((UserDefaultModule().getCurrentUserID() as String? ?? ""), forKey: "senderId")
            requestDict.setValue(self.textView.text!, forKey: "message")
            
            requestDict.setValue("text", forKey: "chat_type")
            requestDict.setValue("", forKey: "audio_duration")
            requestDict.setValue("", forKey: "docname")
            requestDict.setValue("", forKey: "doctype")
            requestDict.setValue("", forKey: "lat")
            requestDict.setValue("", forKey: "lon")
            SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
            self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: (self.textView.text!), receiverId: self.receiverID, listingId: self.id,id: self.id, chat_type: "text", audio_duration: "", docname: "",lat: "",lon: "",doctype: "", onSuccess: { (success) in
                print(success)
            }) { (failure) in
                print(failure)
            }
            // Send chat Act
            var data: [String: Any] = [:]
            data["chat_id"] = self.id
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let epochDate = (Date().timeIntervalSince1970)
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "h:mm a"
            let dateString = formatter.string(from: now)
            data["date"] = epochDate
            data["time"] = dateString
            data["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
            data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
            data["user_name"] = self.userName
            data["message"] = self.textView.text!
            
            data["audio_duration"] = ""
            data["chat_type"] = "text"
            data["docname"] = ""
            data["doctype"] = ""
            data["lat"] = ""
            data["lon"] = ""
            
            let chatData = ChatResultModel.init(fromJson: JSON(data))
            self.chatData.append(chatData)
            self.chatStackView.isHidden = false
            self.tableView.reloadData()
            self.scrollToBottom()
            self.loadSmartReply()
            self.textView.text = ""
            print("self.textView.isFirstResponder:: \(self.textView.isFirstResponder)")
            if self.textView.isFirstResponder {
                self.textView.tag = 0
                self.textViewAct(self.textView)
            }
            else {
                self.textViewAct(self.textView)
                self.textView.text = Utility().language().value(forKey: "type_a_message") as? String ?? ""
            }
            
            textView.isScrollEnabled = false
            self.textViewHeightConst.constant = 45
        }
        else {
            let alert = UIAlertController(title: nil, message: (getLanguage["message_should_not_empty"] ?? "message_should_not_empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    @IBAction func sendButtonAct(_ sender: UIButton) {
//        self.sendButton.isUserInteractionEnabled = false
        let message = self.textView.text.trimmingCharacters(in: .whitespaces)
        if self.textView.tag != 0 && message != "" {
            let requestDict = NSMutableDictionary()
            requestDict.setValue(self.id, forKey: "listingId")
            requestDict.setValue(self.receiverID, forKey: "receiverId")
            requestDict.setValue(self.id, forKey: "inquiryId")
            requestDict.setValue((UserDefaultModule().getCurrentUserID() as String? ?? ""), forKey: "senderId")
            requestDict.setValue(self.textView.text!, forKey: "message")
//            requestDict.setValue("text", forKey: "chat_type")
//            requestDict.setValue("", forKey: "audio_duration")
            SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
//            self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: (self.textView.text!), receiverId: self.receiverID, listingId: self.id,id: self.id, chat_type: "text", audio_duration: "", onSuccess: { (success) in
//                print(success)
//            }) { (failure) in
//                print(failure)
//            }
            self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: (self.textView.text!), receiverId: self.receiverID, listingId: self.id,id: self.id, chat_type: "text", audio_duration: "", docname: "",lat: "",lon: "",doctype: "", onSuccess: { (success) in
                print(success)
            }) { (failure) in
                print(failure)
            }
            // Send chat Act
            var data: [String: Any] = [:]
            data["chat_id"] = self.id
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let epochDate = (Date().timeIntervalSince1970)
            let localDate = (epochDate + Double(timezoneOffset))
            data["date"] = localDate
            data["time"] = epochDate
            data["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
            data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
            data["user_name"] = self.userName
            data["message"] = self.textView.text!
            let chatData = ChatResultModel.init(fromJson: JSON(data))
            self.chatData.append(chatData)
            self.chatStackView.isHidden = false
            self.tableView.reloadData()
            self.scrollToBottom()
            self.loadSmartReply()
            self.textView.text = ""
            print("self.textView.isFirstResponder:: \(self.textView.isFirstResponder)")
            if self.textView.isFirstResponder {
                self.textView.tag = 0
                self.textViewAct(self.textView)
            }
            else {
                self.textViewAct(self.textView)
                self.textView.text = Utility().language().value(forKey: "type_a_message") as? String ?? ""
            }
            
            textView.isScrollEnabled = false
            self.textViewHeightConst.constant = 45
        }
        else {
            let alert = UIAlertController(title: nil, message: (getLanguage["message_should_not_empty"] ?? "message_should_not_empty"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    */
    @IBAction func gifButtonAct(_ sender: UIButton) {
        /*
        self.textView.resignFirstResponder()
        Giphy.configure(apiKey: "wUJ7RuHbc0yBZ3etnoqI5ZucdCNZkCjv")
        let giphy = GiphyViewController()
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        if self.appDelegate.checkTheme() == "light" {
            giphy.theme = GPHTheme(type: .light)
        }
        else {
            giphy.theme = GPHTheme(type: .dark)
        }
        giphy.mediaTypeConfig = [.emoji,.gifs,.stickers,.text]
        giphy.modalPresentationStyle = .overCurrentContext
        present(giphy, animated: true, completion: nil)
 */
    }
    
    func loadSmartReply() {
        /*
        self.smartReplyCollectionView.isHidden = true
        // MARK: SMART REPLY
        smartReplyArray.removeAll()
        let userID = "\((UserDefaultModule().getCurrentUserID()!))"
        if userID != "\(chatData.last?.userId ?? 0)" {
            let message = TextMessage(text: "\(chatData.last?.message ?? "")", timestamp: Date().timeIntervalSince1970, userID: "userId", isLocalUser: false)
            SmartReply.smartReply().suggestReplies(for: [message]) { result, error in
                guard error == nil, let result = result else {
                    return
                }
                print("result.status: \(result.status)")
                if (result.status == .notSupportedLanguage) {
                    // The conversation's language isn't supported, so
                    // the result doesn't contain any suggestions.
                } else if (result.status == .success) {
                    self.smartReplyArray = result.suggestions
                    if self.smartReplyArray.count > 0 {
                        self.smartReplyCollectionView.isHidden = false
                        DispatchQueue.main.async {
                            self.smartReplyCollectionView.reloadData()
                            self.scrollToBottom()
                        }
                    }
                    // Successfully suggested smart replies.
                    // ...
                }
            }
        }
 */
    }
    func scrollToBottom(_ isFromLoadData: Bool = false) {
        DispatchQueue.main.async {
            if self.chatData.count > 0 {
                let indexPath = IndexPath(
                    row: (self.chatData.count-1),
                    section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                if isFromLoadData {
                    self.isFound = true
                }
            }
        }
    }
    func selectImageAct(_ selectedIndex: Int) {
        let pageObj = FullImageViewController()
        pageObj.imageModel = self.viewModel1.doctorModel?.result.portfolioImages ?? [ImageResultModel]()
        pageObj.selectedIndex = selectedIndex
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func rightBarButtonAct3(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.videoStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.videoStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }else{
            self.view.makeToast(getLanguage["Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.slotStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.slotStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }
    }
    @objc func rightBarButtonAct4(_ sender: UIButton) {
        self.view.makeToast(getLanguage["your appointment time slot is over, please request a doctor to call if needed"] ?? "your appointment time slot is over, please request a doctor to call if needed")
    }
    @objc func rightBarButtonAct5(_ sender: UIButton){
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.videoStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.videoStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }else{
            self.view.makeToast(getLanguage["Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.slotStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.slotStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }
    }
    @objc func rightBarButtonAct(_ sender: UIButton) {
        var userIDString = ""
             var username = ""
        self.callType = "video"
        self.viewModel2.callinitate(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", type: self.callType, onSuccess: { (success) in
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                userIDString = "\(self.viewModel.chatModel?.userId ?? 0)"
                username = "\(self.viewModel.chatModel?.userName ?? "")"
            }else{
                userIDString = "\(self.viewModel.chatModel?.doctor_id ?? "")"
                username = "\(self.viewModel.chatModel?.userName ?? "")"
            }
            print("USERID:\(userIDString)")
            let userIDList = userIDString.components(separatedBy: ",")
            var inviteesList: [ZegoUIKitUser] = []
            for userID in userIDList {
                let userName: String = String(format: "%@", username)
                if userID == "" {
                    continue
                }
                let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
                inviteesList.append(user)
            }
            self.videoBtn.inviteeList = inviteesList
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
        }
    @objc func rightBarButtonAct1(_ sender: UIButton) {
              var userIDString = ""
               var username = ""
        self.callType = "audio"
        self.viewModel2.callinitate(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", type: self.callType, onSuccess: { (success) in
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                userIDString = "\(self.viewModel.chatModel?.userId ?? 0)"
                username = "\(self.viewModel.chatModel?.userName ?? "")"
            }else{
                userIDString = "\(self.viewModel.chatModel?.doctor_id ?? "")"
                username = "\(self.viewModel.chatModel?.userName ?? "")"
            }
                   print("USERID:\(userIDString)")
                   let userIDList = userIDString.components(separatedBy: ",")
                   var inviteesList: [ZegoUIKitUser] = []
                   for userID in userIDList {
                       let userName: String = String(format: "%@", username)
                       let bookingID: String = "\(self.viewModel.chatModel?.orderId ?? 0)"
                       if userID == "" {
                           print("THIS ISSUE")
                           continue
                       }
                       let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
                       inviteesList.append(user)
                   }
                   self.audioBtn.inviteeList = inviteesList
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
        }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
/*
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.smartReplyArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: SmartReplyCollectionViewCell = Bundle.main.loadNibNamed("SmartReplyCollectionViewCell", owner: self,options: nil)?.first as? SmartReplyCollectionViewCell else {
            return CGSize.zero
        }
        cell.smartReplyLabel.text = self.smartReplyArray[indexPath.row].text
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmartReplyCollectionViewCell", for: indexPath) as! SmartReplyCollectionViewCell
        cell.smartReplyLabel.text = self.smartReplyArray[indexPath.row].text
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.id, forKey: "listingId")
        requestDict.setValue(self.receiverID, forKey: "receiverId")
        requestDict.setValue(self.id, forKey: "inquiryId")
        requestDict.setValue((UserDefaultModule().getCurrentUserID() as String? ?? ""), forKey: "senderId")
        requestDict.setValue(self.smartReplyArray[indexPath.row].text, forKey: "message")
//        requestDict.setValue("text", forKey: "chat_type")
//        requestDict.setValue("", forKey: "audio_duration")
        SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
        self.viewModel.sendChatData(user_id: "\(UserDefaultModule().getCurrentUserID() as String? ?? "")", message: self.smartReplyArray[indexPath.row].text, receiverId: self.receiverID, listingId: self.id,id: self.id,chat_type: "text", audio_duration: "", onSuccess: { (success) in
            print(success)
        }) { (failure) in
            print(failure)
        }
        // Send chat Act
        var data: [String: Any] = [:]
        data["chat_id"] = self.id
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = (Date().timeIntervalSince1970)
        let localDate = (epochDate + Double(timezoneOffset))
        data["date"] = localDate
        data["time"] = epochDate
        data["user_id"] = (UserDefaultModule().getCurrentUserID() as String? ?? "")
        data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
        data["user_name"] = self.userName
        data["message"] = self.smartReplyArray[indexPath.row].text
        let chatData = ChatResultModel.init(fromJson: JSON(data))
        self.chatData.append(chatData)
        self.chatStackView.isHidden = false
        self.tableView.reloadData()
        self.scrollToBottom()
        self.loadSmartReply()
    }
}
 */
extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.frame.height >= 100 {
            textView.isScrollEnabled = true
            self.textViewHeightConst.constant = 100
        }
        else {
            textView.isScrollEnabled = false
            self.textViewHeightConst.constant = textView.frame.height
        }
        if textView.text.count > 0 && textView.tag == 1{
            self.sendButton.isHidden = false
//            self.recordButton.isHidden = true
        }
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.id, forKey: "listingId")
        requestDict.setValue(self.receiverID, forKey: "receiverId")
        requestDict.setValue(self.id, forKey: "inquiryId")
        requestDict.setValue((UserDefaultModule().getCurrentUserID() as String? ?? ""), forKey: "senderId")
        requestDict.setValue("type", forKey: "message")
        SocketClass.sharedInstance.sendTypingStatus(requestDict: requestDict)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewAct(textView)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewAct(textView)
        textViewDidChange(textView)
        
    }
    func textViewAct(_ textView: UITextView) {
        if textView.tag == 0 {
            textView.text = ""
//            self.sendButton.isHidden = true
//            self.recordButton.isHidden = !IS_AUDIO
            textView.tag = 1
        }
        else {
            if textView.text == "" && textView.tag == 1{
                textView.text = Utility().language().value(forKey: "type_a_message") as? String ?? ""
                textView.tag = 0
//                self.sendButton.isHidden = true
//                self.recordButton.isHidden = !IS_AUDIO
            }
            else {
//                self.sendButton.isHidden = false
//                self.recordButton.isHidden = true
//                textView.tag = 1
            }
        }
    }
}
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if self.chatData[indexPath.row].chatType == "gif" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiTableViewCell") as! EmojiTableViewCell
            cell.selectionStyle = .none
            if self.chatData.count > (indexPath.row) {
                cell.loadData(self.chatData[indexPath.row])
            }
            cell.bgViewBottomConst.constant = 20
            if self.chatData.count > 1 {
                if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                    cell.profileImageView.image = nil
                    cell.bgViewBottomConst.constant = 0
                }
            }
            cell.layoutIfNeeded()
            return cell
        }
         else */
        /*
         if self.chatData[indexPath.row].chatType == "audio" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceTableViewCell") as! VoiceTableViewCell
            cell.selectionStyle = .none
            cell.playButton.tag = indexPath.row
            cell.progressSlider.tag = indexPath.row
            cell.progressSlider.addTarget(self, action: #selector(sliderAct(_:)), for: .valueChanged)
            cell.playButton.addTarget(self, action: #selector(self.AudioButtonAct(_:)), for: .touchUpInside)
            if self.chatData.count > (indexPath.row) {
                cell.loadData(self.chatData[indexPath.row])
            }
            cell.bgViewBottomConst.constant = 20
            if self.chatData.count > 1 {
                if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                    cell.profileImageView.image = nil
                    cell.bgViewBottomConst.constant = 0
                }
            }
            cell.layoutIfNeeded()
            return cell
        }

        else {
         */
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
//            let cell1 = tableView.dequeueReusableCell(withIdentifier: "ChatImgTableViewCell") as! ChatImgTableViewCell
            cell.languageButton.tag = indexPath.row
            if self.chatData.count > (indexPath.row) {
                cell.loadData(self.chatData[indexPath.row])
            }
            cell.bgViewBottomConst.constant = 20
            if self.chatData.count > 1 {
                if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                    cell.profileImageView.image = nil
                    cell.bgViewBottomConst.constant = 0
                }
            }
            if self.chatData.count > (indexPath.row) {
                if (self.chatData[indexPath.row].message ?? "") == "Appointment created " || (self.chatData[indexPath.row].message ?? "") == "Booking requested  " {
                    cell.titleLabel.text = "\(getLanguage[self.chatData[indexPath.row].message ?? ""] ?? (self.chatData[indexPath.row].message ?? "")), \(getLanguage["date"] ?? "date"): \(Utility().timeStampWithDateFormat(timeStamp: (self.viewModel.chatModel?.booked_date ?? ""), dateFormat: "dd MMM YYYY")) - \(getLanguage["time"] ?? "time"): \(self.viewModel.chatModel?.booked_time ?? "")"
                    cell.languageButton.isHidden = true
                    cell.titleLabel.layoutIfNeeded()
                }
                else if self.chatData[indexPath.row].chatType == "chatimage"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
                    
                    if self.chatData.count > (indexPath.row) {
                        cell.loadData(self.chatData[indexPath.row])
                        cell.ImageviewBtn.tag = indexPath.row
                        
                        cell.ImageviewBtn.addTarget(self, action: #selector(self.imageTapped), for: .touchUpInside)
                    }
                   // cell.bgViewBottomConst.constant = 20
                    if self.chatData.count > 1 {
                        if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                            //cell.profileImageView.image = nil
                            //cell.bgViewBottomConst.constant = 0
                        }
                    }
                    cell.layoutIfNeeded()
                    return cell
//                    cell.titleLabel.isHidden = true
//                    cell.chatPreviewimage.isHidden = false
//                    let url = (self.chatData[indexPath.row].message)
//                    let imageURL = URL(string: url!)
//                    cell.chatPreviewimage.sd_setImage(with: imageURL!)
////                    if let data = try? Data(contentsOf: imageURL!) {
////                            // Create Image and Update Image View
////                        cell.chatPreviewimage.image = UIImage(data: data)
////                    }
                }
                else if self.chatData[indexPath.row].chatType == "chatdocument" || self.chatData[indexPath.row].chatType == "prescription" {
                     let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell") as! DocumentTableViewCell

                     if self.chatData.count > (indexPath.row) {
                         cell.loadData(self.chatData[indexPath.row])
                         cell.docViewBtn.tag = indexPath.row
                         
                         cell.docViewBtn.addTarget(self, action: #selector(self.documentTapped), for: .touchUpInside)
                     }
                    // cell.bgViewBottomConst.constant = 20
                     if self.chatData.count > 1 {
                         if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                             //cell.profileImageView.image = nil
                             //cell.bgViewBottomConst.constant = 0
                         }
                     }
                     cell.layoutIfNeeded()
                     return cell
                 }
                else if (self.chatData[indexPath.row].chatType == "audiocallstart") || (self.chatData[indexPath.row].chatType == "audiocallend") || (self.chatData[indexPath.row].chatType == "missedaudiocall") || (self.chatData[indexPath.row].chatType == "videocallstart") || (self.chatData[indexPath.row].chatType == "videocallend") || (self.chatData[indexPath.row].chatType == "missedvideocall") {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CallTableViewCell") as! CallTableViewCell
                    
                    if self.chatData.count > (indexPath.row) {
                        cell.loadData(self.chatData[indexPath.row])
                    }
                    if self.chatData.count > 1 {
                        if self.chatData.count > indexPath.row+1, self.chatData[indexPath.row].userId == self.chatData[indexPath.row+1].userId {
                            //cell.profileImageView.image = nil
                            //cell.bgViewBottomConst.constant = 0
                        }
                    }
                    cell.layoutIfNeeded()
                    return cell
                }
                else {
                    cell.titleLabel.isHidden = false
                    cell.chatPreviewimage.isHidden = true
                    var message = (self.chatData[indexPath.row].message ?? "").decode()
                    if !message.containsEmoji {
                        message = (self.chatData[indexPath.row].message ?? "")
                    }
                    cell.titleLabel.text = message
                }
            }
            cell.refreshChat = {
                self.tableView.beginUpdates()
                if self.chatData.count > 1 {
                    self.chatData[indexPath.row].message = cell.titleLabel.text!
                }
                self.tableView.endUpdates()
            }
        /*
            if SwiftGoogleTranslate.shared.selectdLanguage.language.lowercased() == "none" {
                cell.languageButton.isHidden = true
            }
            else {
                cell.languageButton.isHidden = false
            }
 */
            cell.languageButton.isHidden = true
            cell.layoutIfNeeded()
            return cell
//        }
    }
    @objc func sliderAct(_ sender: UISlider) {
        let currentValue: Float = Float(sender.value)
        if self.selectedAudio == "\(sender.tag)" {
            audioPlayer.currentTime = TimeInterval(currentValue)
//            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateUIWithTimer(_:)), userInfo: [sender.tag], repeats: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(self.chatData)
        if indexPath.row == 0 && isFound == true && self.chatData.count >= 10{
            self.refresh(refreshControl)
        }
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.selectImageAct(indexPath.row)
//    }
    
}
extension ChatViewController: socketClassDelegate {
    
    func gotSocketInfo(dict: Array<Any>, type: String) {
        let typingRes = SocketChatModel.init(fromJson: JSON(dict.first))
        if "\(typingRes.receiver ?? 0)" == (UserDefaultModule.shared.getLoginData().userId ?? "") {
            if type == "message" {
                var data: [String: Any] = [:]
                data["chat_id"] = typingRes.inquiry
                let timezoneOffset =  TimeZone.current.secondsFromGMT()
                let epochDate = (Date().timeIntervalSince1970)
                let now = Date()
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "h:mm a"
                let dateString = formatter.string(from: now)
                data["date"] = epochDate
                data["time"] = dateString
                data["user_id"] = typingRes.sender
                data["user_image"] = self.receiverImage
                data["user_name"] = self.userName
                data["message"] = typingRes.message
                data["chat_type"] = typingRes.chatType
                data["audio_duration"] = typingRes.audioDuration
                
                data["docname"] = typingRes.docname
                data["doctype"] = typingRes.doctype
                /*
                if SwiftGoogleTranslate.shared.selectdLanguage.language.lowercased() != "none" {
                    SwiftGoogleTranslate.shared.translate(msg: typingRes.message) { (message) in
                        if message != "error" {
                            data["message"] = message
                        }
                        DispatchQueue.main.async {
                            let chatData = ChatResultModel.init(fromJson: JSON(data))
                            self.chatData.append(chatData)
                            self.chatStackView.isHidden = false
                            self.tableView.reloadData()
                            self.scrollToBottom()
                            self.loadSmartReply()
                        }
                    }
                }
                else {
                 */
                    let chatData = ChatResultModel.init(fromJson: JSON(data))
                    self.chatData.append(chatData)
                    self.chatStackView.isHidden = false
                    self.tableView.reloadData()
                    self.scrollToBottom()
                    self.loadSmartReply()
//                }
            }
            else {
                if typingRes.message == "type" {
                    self.TableViewLoadAnimation(1)
                }
                else if typingRes.message == "untype" {
                    self.TableViewLoadAnimation(0)
                }
            }
        }
    }
}

extension ChatViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            let imageData = (pickedImage.resized(toWidth: 960, isOpaque: true) ?? pickedImage).jpegData(compressionQuality: 0)! as Data
//            let imageData = pickedImage.jpegData(compressionQuality: 0)! as Data // (pickedImage.resized(toWidth: 960, isOpaque: true) ?? pickedImage)
            self.createSpinnerView(self.child)
            
            /*
            var certificateType = "portfolio"
            if self.isCertificateView {
                certificateType = "doctor_certificates"
            }
             */
            var certificateType = "chatimage"

            ParsingFunction().uploadDoc(fileData: imageData, uploaddoctype: ".jpeg", fileName: "profilepic.jpeg", type: certificateType, user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                
                if imageModel.status {
                    
                    imageModel.result.isNew = true
                    self.imageModel.append(imageModel.result)
                    print(imageModel.result)
                    self.sendimage(imageModel.result.image)
                  //self.tableView.reloadData()
                  //self.collectionView.reloadData()
                }
                else {
                    self.removeSpinnerView(self.child)
                    var message = (getLanguage["image_size1"] ?? "")
                    if imageModel.message == "Image doesnot allowed by moderator." {
                        message = (getLanguage[imageModel.message] ?? imageModel.message)
                    }
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                DispatchQueue.main.async {
                    self.updateViewConstraints()
                }
                self.removeSpinnerView(self.child)
            })
            { failure in
                self.removeSpinnerView(self.child)
                let alert = UIAlertController(title: nil, message: (getLanguage["failed_upload_image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK: Document picker delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        if urls.count > 0 {
            do {
                let fileData = try Data(contentsOf: urls[0])
                let fileName = urls[0].lastPathComponent
                print("FILENAME:\(fileData)")
                print("URL:\(urls)")
                
                self.createSpinnerView(self.child)
                
                ParsingFunction().uploadDoc(fileData: fileData, uploaddoctype: urls[0].pathExtension, fileName: fileName, type: "chatdocument", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                    if imageModel.status {
                        imageModel.result.isNew = true
                        self.imageModel.append(imageModel.result)
                        print(imageModel.result.image)
                        
                        self.senddocument(imageModel.result.image,imageModel.result.name)
                        
                       //self.tableView.reloadData()
//                        self.collectionView.reloadData()
                        DispatchQueue.main.async {
                            self.updateViewConstraints()
                        }
                    }
                    else {
                        self.removeSpinnerView(self.child)
                        var message = (getLanguage["doc_size"] ?? "")
                        if imageModel.message == "file doesnot allowed by moderator." {
                            message = (getLanguage[imageModel.message] ?? imageModel.message)
                        }
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.removeSpinnerView(self.child)
                }) { (failure) in
                    self.removeSpinnerView(self.child)
                }
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    //MARK: Upload document function
    func uploadDocument(fileData:Data,fileType:String,fileName:String)  {
        //   let uploadObj = UploadServices()
        
    }
}


extension String {

    func fileName() -> String {
//        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
        return URL(fileURLWithPath: self).lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

extension ChatViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.shared.stopAnimation(viewController: self)
    }
}

extension ChatViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate{
    
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

    //MARK: -ZegoUIKitPrebuiltCallInvitationServiceDelegate
    func requireConfig(_ data: ZegoCallInvitationData) -> ZegoUIKitPrebuiltCallConfig {
        if data.type == .voiceCall {
//            if data.invitees?.count ?? 0 > 1 {
//                let config = ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
//                return config
//            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
            config.topMenuBarConfig.isVisible = true
//            config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
      //      }
        } else {
//            if data.invitees?.count ?? 0 > 1 {
//                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                return config
//            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            config.topMenuBarConfig.isVisible = true
//            config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
          //  }
        }
    }

    func onIncomingCallDeclineButtonPressed() {
        self.viewModel2.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }
    func onIncomingCallAcceptButtonPressed() {

    }
    func onOutgoingCallCancelButtonPressed() {
        self.viewModel2.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }

    func onIncomingCallReceived(_ callID: String, caller: ZegoCallUser, callType: ZegoCallType, callees: [ZegoCallUser]?) {
    }
    func onIncomingCallCanceled(_ callID: String, caller: ZegoCallUser) {
        self.viewModel2.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }
    func onOutgoingCallAccepted(_ callID: String, callee: ZegoCallUser) {

    }
    func onOutgoingCallCutButtonPressed() {
        self.viewModel2.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
        print("Suriya cut btn tapped")
    }
    
    func onOutgoingCallRejectedCauseBusy(_ callID: String, callee: ZegoCallUser) {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["\(self.viewModel.chatModel?.userName ?? "") on call with another doctor, please try again later"] ?? "\(self.viewModel.chatModel?.userName ?? "") on call with another doctor, please try again later")
        }else{
            self.view.makeToast(getLanguage["\(self.viewModel.chatModel?.userName ?? "") on call with another patient,please try again later"] ?? "\(self.viewModel.chatModel?.userName ?? "") on call with another patient,please try again later")
        }
        self.viewModel2.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
         }) { (failure) in
            
        }
        
    }
    func onOutgoingCallDeclined(_ callID: String, callee: ZegoCallUser) {
//        self.viewModel2.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
//
//        }) { (failure) in
//
//        }
    }
    func onIncomingCallTimeout(_ callID: String,  caller: ZegoCallUser){
        self.viewModel2.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
         }) { (failure) in
            
        }
    }
    func onOutgoingCallTimeout(_ callID: String, callees: [ZegoCallUser]) {
        self.viewModel2.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: "\(self.viewModel.chatModel?.userId ?? 0)", call_id: "\(self.viewModel.chatModel?.orderId ?? 0)", onSuccess: { (success) in
            
         }) { (failure) in
            
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
       return currentViewController(vc)
    }

    func currentViewController(_ vc :UIViewController?) -> UIViewController? {
       if vc == nil {
          return nil
       }
       if let presentVC = vc?.presentedViewController {
          return currentViewController(presentVC)
       }
       else if let tabVC = vc as? UITabBarController {
          if let selectVC = tabVC.selectedViewController {
              return currentViewController(selectVC)
           }
           return nil
        }
        else if let naiVC = vc as? UINavigationController {
           return currentViewController(naiVC.visibleViewController)
        }
        else {
           return vc
        }
     }
}

/*
extension ChatViewController: RecordViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func onStart() {
        print("onStart")
        self.isCancel = false
        self.recordView.isHidden = false
        self.textView.isHidden = true
//        self.sendButton.isHidden = true
        self.gifButton.isHidden = true
        startRecording()
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    func onCancel() {
        self.isCancel = true
        print("onCancel")
//        self.textView.isHidden = false
//        self.recordView.isHidden = true
        self.sendButton.isHidden = false
        self.gifButton.isHidden = !IS_GIF
        audioRecorder.deleteRecording()
        self.finishRecording(success: true)
    }
    
    func onFinished(duration: CGFloat) {
        print("onFinished")
        if(duration > 0.0){
            self.recordView.isHidden = true
            self.textView.isHidden = false
            self.sendButton.isHidden = false
            self.gifButton.isHidden = !IS_GIF
            let myIntValue = Int(duration)
            let min = myIntValue/60
            let sec = myIntValue%60
            var minstr="\(min)"
            var secstr="\(sec)"
            if(min<10){
                minstr = "0\(min)"
            }
            if(sec<10){
                secstr = "0\(sec)"
                
            }
            audioduration = minstr+":"+secstr
            finishRecording(success: false)
        }
        else{
            textView.resignFirstResponder()
            self.recordView.isHidden = true
            self.textView.isHidden = false
//            self.sendButton.isHidden = true
            self.gifButton.isHidden = false

//            self.showAlert1(title: "", message: "Hold_release")
        }
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !self.isCancel {
            do {
                print("recorder.url : \(recorder.url)")
                let audioData = try Data(contentsOf: recorder.url)
                print("REQUESTimgData : \(audioData)")
                self.createSpinnerView(child)
                ParsingFunction().uploadDoc(fileData: audioData, uploaddoctype: recorder.url.pathExtension, fileName: recorder.url.path, type: "audio") { (imageModel) in
                    print(imageModel)
                    let requestDict = NSMutableDictionary()
                    requestDict.setValue(self.id, forKey: "listingId")
                    requestDict.setValue(self.receiverID, forKey: "receiverId")
                    requestDict.setValue(self.id, forKey: "inquiryId")
                    requestDict.setValue(UserDefaultModule().getCurrentUserID()!, forKey: "senderId")
                    requestDict.setValue(imageModel.result.image, forKey: "message")
                    requestDict.setValue("audio", forKey: "chat_type")
                    requestDict.setValue(self.audioduration, forKey: "audio_duration")
                    SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
                    self.sendAudio(imageModel.result.image)
                    DispatchQueue.main.async {
                        _ = self.dowloadFile(audioString: (imageModel.result.image), message: "audiomsg")
                    }
                    self.removeSpinnerView(self.child)
                    self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: imageModel.result.image, receiverId: self.receiverID, listingId: self.id,id: self.id, chat_type: "audio", audio_duration: self.audioduration, onSuccess: { (success) in
                        print(success)
                        if (self.viewModel.sendChatModel?.status ?? false) {
                        }
                    }) { (failure) in
                        print(failure)
                    }
                } onFailure: {
                    (failure) in
    //                self.removeSpinnerView(self.child)
                }
                
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    func sendAudio(_ url: String) {
        // Send chat Act
        var data: [String: Any] = [:]
        data["chat_id"] = self.id
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = (Date().timeIntervalSince1970)
        let localDate = (epochDate + Double(timezoneOffset))
        data["date"] = localDate
        data["time"] = epochDate
        data["user_id"] = UserDefaultModule().getCurrentUserID()!
        data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
        data["user_name"] = self.userName
        data["message"] = url
        data["audio_duration"] = self.audioduration
        data["chat_type"] = "audio"
        
        let chatData = ChatResultModel.init(fromJson: JSON(data))
        self.chatData.append(chatData)
        self.chatStackView.isHidden = false
        self.tableView.reloadData()
        self.scrollToBottom()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error playing \(String(describing: error?.localizedDescription))")
    }
    func onAnimationEnd() {
        self.recordView.isHidden = true
        self.textView.isHidden = false
        self.gifButton.isHidden = !IS_GIF
        //when Trash Animation is Finished
        print("onAnimationEnd")
    }
    @objc func AudioButtonAct(_ sender: UIButton) {
        self.textView.resignFirstResponder()
        if "\(sender.tag)" != self.selectedAudio && self.selectedAudio != "" {
            self.stopAudio()
        }
        if let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? VoiceTableViewCell,sender.tag < self.chatData.count {
            let chatData = self.chatData[sender.tag]
            cell.playButton.isHidden = true
            cell.loaderView.isHidden = false
            cell.loaderView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let audioMessage = chatData.message
//                if !chatData.message.contains("file:") {
//                    audioMessage = chatData.message
//                }
                let urlstr = self.dowloadFile(audioString: audioMessage ?? "", message: "audiomsg")
                let escapedString = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let audioURL = URL(string:escapedString!)
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: .mixWithOthers)
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                    try AVAudioSession.sharedInstance().setActive(true)
                    let imageData = try Data(contentsOf: audioURL!)
                    self.audioPlayer = try AVAudioPlayer.init(data: imageData)
                    print("duration \(cell.progressSlider.value)")
                    self.audioPlayer.delegate = self
                    self.audioPlayer.volume = 100
                    cell.loaderView.stopAnimating()
                    cell.loaderView.isHidden = true
                    cell.playButton.isHidden = false
                    if self.counter == 0 {
                        cell.playButton.setImage(#imageLiteral(resourceName: "pause2"), for: .normal)
                        // Start Timer
                        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateUIWithTimer(_:)), userInfo: [sender.tag], repeats: true)
                        let currentValue: Float = Float(cell.progressSlider.value)
                        self.audioPlayer.currentTime = TimeInterval(currentValue)
                        self.audioPlayer.play()
                        self.counter = 1
                        self.selectedAudio = "\(sender.tag)"
                    }
                    else {
                        if self.selectedAudio == "\(sender.tag)" {
                            self.selectedAudio = "\(sender.tag)"
                            self.stopAudio()
                        }
//                        else {
//
//                        }
                    }
                } catch {
                    print("Speaker error : \(error)")
                }
            }
        }
    }
    @objc func updateUIWithTimer(_ timer: Timer){
        //            if info[0] as? Int ?? 0 == tag
        if selectedAudio != "" {
            print("Check player State")
            if audioPlayer.isPlaying {
                if let row = Int(self.selectedAudio), let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VoiceTableViewCell {
                    cell.progressSlider.value = Float(audioPlayer.currentTime)
                    let myIntValue = Int(audioPlayer.currentTime)
                    let min = myIntValue/60
                    let sec = myIntValue%60
                    var minstr="\(min)"
                    var secstr="\(sec)"
                    if(min<10){
                        minstr = "0\(min)"
                    }
                    if(sec<10){
                        secstr = "0\(sec)"
                    }
                    cell.titleLabel.text = minstr+":"+secstr
                    if(audioPlayer.currentTime == audioPlayer.duration) {
                        print("stopTimer")
                        timer.invalidate()
        //                timer = nil
                    }
                    audioPlayer.updateMeters()
                    cell.progressSlider.clipsToBounds = true
                }
            }
            else {
                print("not Start Playing")
            }
        }
    }
    func dowloadFile(audioString:String, message: String) -> String {
        
        if let url = URL.init(string:audioString){
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            // Print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                // Print("The file already exists at path")
                return destinationUrl.absoluteString
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                let group = DispatchGroup()
                group.enter()
                print("Hii")
                URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        group.leave()
                        // Print("File moved to documents folder \(destinationUrl)")
                    } catch let error as NSError {
                        group.leave()
                         print("localerror \(error)")
                    }
                }).resume()
                group.wait()
                print("Hello")
                return destinationUrl.absoluteString
            }
        }
        else {
            return ""
        }
    }
    func stopAudio() {
        if let row = Int(self.selectedAudio), let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VoiceTableViewCell {
            cell.playButton.setImage(#imageLiteral(resourceName: "Play_png"), for: .normal)
            self.audioPlayer.stop()
            self.timer.invalidate()
            self.counter = 0
            self.selectedAudio = ""
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.timer.invalidate()
        self.counter = 0
        if let row = Int(self.selectedAudio), let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? VoiceTableViewCell {
            self.stopAudio()
            cell.progressSlider.value = 0.0
            cell.titleLabel.text = self.chatData[row].audioDuration
            self.selectedAudio = ""
        }
    }
    func configRecordView() {
        /*
        recorderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recorderView)
        recorderView.trailingAnchor.constraint(equalTo: recordView.trailingAnchor, constant: -15).isActive = true
        recorderView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor, constant: 15).isActive = true
        recorderView.topAnchor.constraint(equalTo: recordView.topAnchor, constant: 0).isActive = true
        recorderView.bottomAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 0).isActive = true
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
//            recorderView.isArabic = true
        }
        else {
//            recorderView.isArabic = false
        }
        recorderView.isSoundEnabled = true

        self.recordButton.recordView = recorderView
        recorderView.delegate = self
        recorderView.slideToCancelArrowImage = nil
        recorderView.slideToCancelText = getLanguage["slide_cancel"] ?? "slide_cancel"
        recorderView.durationTimerColor = UIColor(named: "BlackColor") ?? .white
        recorderView.slideToCancelTextColor = UIColor(named: "BlackColor") ?? .white
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
            }
        } catch {
            // failed to record!
        }
 */
    }
}
 */
/*
extension ChatViewController: GiphyDelegate {
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            
            let gifURL : String = media.url(rendition: .fixedWidth, fileType: .gif)!
            print(gifURL)
            self?.sendGif(gifURL)
//            self?.uploadGif(url: gifURL)
            
        })
        GPHCache.shared.clear()
    }
    func sendGif(_ url: String) {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.id, forKey: "listingId")
        requestDict.setValue(self.receiverID, forKey: "receiverId")
        requestDict.setValue(self.id, forKey: "inquiryId")
        requestDict.setValue(UserDefaultModule().getCurrentUserID()!, forKey: "senderId")
        requestDict.setValue(url, forKey: "message")
        requestDict.setValue("", forKey: "audio_duration")
        requestDict.setValue("gif", forKey: "chat_type")
        SocketClass.sharedInstance.sendMsg(requestDict: requestDict)
        self.viewModel.sendChatData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", message: url, receiverId: self.receiverID, listingId: self.id,id: self.id,chat_type: "gif", audio_duration: "", onSuccess: { (success) in
            print(success)
            if (self.viewModel.sendChatModel?.status ?? false) {
                if let result = self.viewModel.sendChatModel?.result {
                }
            }
        }) { (failure) in
            print(failure)
        }
        // Send chat Act
        var data: [String: Any] = [:]
        data["chat_id"] = self.id
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = (Date().timeIntervalSince1970)
        let localDate = (epochDate + Double(timezoneOffset))
        data["date"] = localDate
        data["time"] = epochDate
        data["user_id"] = UserDefaultModule().getCurrentUserID()!
        data["user_image"] = UserDefaultModule.shared.getLoginData().userImage ?? ""
        data["user_name"] = self.userName
        data["message"] = url
        data["audio_duration"] = ""
        data["chat_type"] = "gif"

        let chatData = ChatResultModel.init(fromJson: JSON(data))
        self.chatData.append(chatData)
        self.chatStackView.isHidden = false
        self.tableView.reloadData()
        self.scrollToBottom()
        self.loadSmartReply()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        GPHCache.shared.clear()
    }
}
*/
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()
     

        dateFormatter.dateFormat = "dd/MM/yyyy"
        

        return dateFormatter.string(from: Date())

    }
    static func getCurrentTime() -> String {
        
        let timeFormatter = DateFormatter()
     

        timeFormatter.dateFormat = "h:mm a"
        

        return timeFormatter.string(from: Date())
    }
}
