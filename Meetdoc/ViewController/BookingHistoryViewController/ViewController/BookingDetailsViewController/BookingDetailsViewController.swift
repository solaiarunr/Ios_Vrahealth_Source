//
//  BookingDetailsViewController.swift
//  AirFinch_Swift
//
//  Created by Hitasoft on 28/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos
import Razorpay
import ConnectyCube
import ConnectyCubeCalls
import PushKit
import JTMaterialTransition
import SwiftUI

import ZegoUIKit
import Toast_Swift
import ZegoUIKitPrebuiltCall
import ZegoUIKitSignalingPlugin

class BookingDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var firstStackViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var genderHeight: NSLayoutConstraint!
    
    @IBOutlet weak var illnessHeight: NSLayoutConstraint!
    
    @IBOutlet weak var TopStackView: UIStackView!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var lastStackViewheight: NSLayoutConstraint!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var StackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var prescriptionButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var siteTitleLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxTitleLabel: UILabel!
    @IBOutlet weak var wholeStackView: UIStackView!
   // @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var videoVisitButton: UIButton!
    
    @IBOutlet weak var audioVisitButton: UIButton!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var bookingDateTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingTimeLabel: UILabel!
    @IBOutlet weak var bookingTimeTitleLabel: UILabel!
    @IBOutlet weak var reasonTxt: UITextView!
    @IBOutlet weak var bookingReasonTitleLabel: UILabel!
    @IBOutlet weak var bookingReasonLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var policyTitleLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var prescriptionView: UIView!
    @IBOutlet weak var prescriptionSelectorView: UIView!
    @IBOutlet weak var handwrittingButton: UIButton!
    @IBOutlet weak var onlineButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var checkBoxView: VKCheckbox!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var checkBoxView1: VKCheckbox!
    @IBOutlet weak var checkbox1: UIButton!
    @IBOutlet weak var prescriptionTitleTextView: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var paymentTitleLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var doctordetailsLbl: UILabel!
    @IBOutlet weak var patientdeailsLbl: UILabel!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var doctorNameView: UIView!
    @IBOutlet weak var doctorNameTittleLbl: UILabel!
    @IBOutlet weak var emailTxtView: UITextView!
    @IBOutlet weak var doctorEmailTittleLbl: UILabel!
    @IBOutlet weak var doctorEmailLbl: UILabel!
    @IBOutlet weak var doctorEmailView: UIView!
    @IBOutlet weak var doctorgenderTittleLbl: UILabel!
    @IBOutlet weak var doctorgenderLbl: UILabel!
    @IBOutlet weak var doctorgenderView: UIView!
    @IBOutlet weak var addressTxt: UITextView!
    @IBOutlet weak var doctorQualificationTittleLbl: UILabel!
    @IBOutlet weak var doctorQualificationLbl: UILabel!
    @IBOutlet weak var doctorQualificationView: UIView!
    @IBOutlet weak var doctorMobileTittleLbl: UILabel!
    @IBOutlet weak var doctorMobileLbl: UILabel!
    @IBOutlet weak var doctorMobileView: UIView!
    @IBOutlet weak var patientNameTittleLbl: UILabel!
    @IBOutlet weak var patientNameView: UIView!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var patientAgeTittleLbl: UILabel!
    @IBOutlet weak var patientAgeLbl: UILabel!
    @IBOutlet weak var patientAgeView: UIView!
    @IBOutlet weak var patientgenderTittleLbl: UILabel!
    @IBOutlet weak var patientgenderLbl: UILabel!
    @IBOutlet weak var patientgenderView: UIView!
    @IBOutlet weak var patientweightTittleLbl: UILabel!
    @IBOutlet weak var patientweightLbl: UILabel!
    @IBOutlet weak var patientweightView: UIView!
    @IBOutlet weak var patientillnessTittleLbl: UILabel!
    @IBOutlet weak var patientillnessLbl: UILabel!
    @IBOutlet weak var patientillnessView: UIView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var stauscheckStackView: UIStackView!
    @IBOutlet weak var statuscheckView: UIView!
    @IBOutlet weak var statusCheckTittleLbl: UILabel!
    @IBOutlet weak var statusCHeckLbl: UILabel!
    @IBOutlet weak var resudleStatckView: UIStackView!
    @IBOutlet weak var resudleTittleLbl: UILabel!
    @IBOutlet weak var resudleLbl: UILabel!
    
    @IBOutlet weak var patientgenderStackView: UIStackView!
    @IBOutlet weak var bookingstatusStackView: UIStackView!
    @IBOutlet weak var bookingstatusLbl: UILabel!
    @IBOutlet weak var bookingstatusTittleLbl: UILabel!
    @IBOutlet weak var bookingstatusView: UIView!
    @IBOutlet weak var patientPhnStackView: UIStackView!
    @IBOutlet weak var patientPhnView: UIView!
    @IBOutlet weak var patientPhnTittleLbl: UILabel!
    @IBOutlet weak var statusTxt: UITextView!
    @IBOutlet weak var patientPhnLbl: UILabel!
    @IBOutlet weak var RescheduleBtn: UIButton!
    @IBOutlet weak var RescheduleView: UIView!
    @IBOutlet weak var feedbackTittlelbl: UILabel!
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var feedbackStackView: UIStackView!
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var BpstackView: UIStackView!
    @IBOutlet weak var bprsStackView: UIStackView!
    @IBOutlet weak var heightTittleLbl: UILabel!
    @IBOutlet weak var heightbl: UILabel!
    @IBOutlet weak var bpTittleLbl: UILabel!
    @IBOutlet weak var bpLabel: UILabel!
    @IBOutlet weak var bprsTittleLbl: UILabel!
    @IBOutlet weak var bprsLbl: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var taxStackView: UIStackView!
    @IBOutlet weak var sitechargeStackView: UIStackView!
    @IBOutlet weak var totalStackView: UIStackView!
    @IBOutlet weak var doctorQualificationStackView: UIStackView!
    @IBOutlet weak var patientillnessStackView: UIStackView!
    @IBOutlet weak var doctoremailStackView: UIStackView!
    @IBOutlet weak var doctorMobileStackView: UIStackView!
    @IBOutlet weak var patientWeightStackView: UIStackView!
    @IBOutlet weak var HeaderPatientNameStackView: UIStackView!
    @IBOutlet weak var HeaderPatientNameLabel: UILabel!
    @IBOutlet weak var HeaderPatientNameTittleLabel: UILabel!
    @IBOutlet weak var prescriptionBtnView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeButton: UIButton!
    var client_id = ""
    var viewModel = BookingHistoryViewModel()
    var bookingResultModel: BookingHistoryResultModel?
    var type = ""
    var historyType = ""
    var booking_id = ""
    var user_id = ""
    var isForCall = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromChat = false
    var isChecked = false
    var prescriptiontype = ""
    var completepage = ""
    var prescriptionButtonhide = ""
    var slotStartTime = 0
    var videoStartTime = 0
    var doctorBookingStartTime = 0
    var slotEndTime = 0
    let videoBtn: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.videoCall.rawValue)
    let audioBtn: ZegoSendCallInvitationButton = ZegoSendCallInvitationButton(ZegoInvitationType.voiceCall.rawValue)
    let videooffBtn = UIButton()
    let audiooffBtn = UIButton()
    let dotsBtn = UIButton()
    var testing = "connect"
    var callType = ""
    var myNumber : NSNumber!
    private var session: CallSession?
    private var callUUID: UUID?
//    private var pushRegistry: PKPushRegistry!
    private var backgroundTask: UIBackgroundTaskIdentifier!
    
    //newwork
    var create_invoice = ""
    
//    var getbooking_status = ""
    var complete_status = ""
    
    //invoicedetails
    var lawyer_name = ""
    var client_name = ""
    var previously_paid = ""
    var pending_amount = ""
    var payment_type = ""
    var payingamount_type = ""
    var total_fee = ""
    var bank_details = ""
    var invoice_name = ""
    var taxamount = ""
    
    var total_value = ""
    var term_fee = ""
    var invoice_date = ""
    var paid_status = ""
    var currency_symbol = ""
    var currency_code = ""
    var invoice_id = ""
    var stripe_privatekey = ""
    var stripe_publickey = ""
    
    var lawyerlogin = ""
    var lawyerpassword = ""
    var lawyerconnecty_Id = ""
    var lawyeremail = ""
    var clientlogin = ""
    var clientpassword = ""
    var clientconnecty_Id = ""
    var clientemail = ""
    var somestring = ""
    var prescription_type = ""

    var timer: Timer!
    var sec = 0
    var showtime = 0
    var confrimpage = ""
    var scheduletime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        Utility.shared.startAnimation(viewController: self)
        self.configUI()
        self.addressTxt.isEditable = false
        self.statusTxt.isEditable = false
        self.emailTxtView.isEditable = false
        self.reasonTxt.isEditable = false
        self.configCheckBox()
//        videoBtn.resourceID = "789078"
//        audioBtn.resourceID = "789078"
        videoBtn.resourceID = UserDefaults.standard.value(forKey: "zego_resourceID") as? String
        audioBtn.resourceID = UserDefaults.standard.value(forKey: "zego_resourceID") as? String
        if bookingResultModel?.status.lowercased() ?? "" == "pending"{
            self.resudleStatckView.isHidden = true
            self.feedbackStackView.isHidden = true
            self.audiooffBtn.isHidden = true
            self.videooffBtn.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
        }
        
        if bookingResultModel?.status.lowercased() ?? "" == "rescheduled"{
            self.resudleStatckView.isHidden = true
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatetime1), userInfo: nil, repeats: true)
        }
        if self.testing == "connect"{
            CallClient.initializeRTC()
            Profile.load()
        }
        
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.priceStackView.isHidden = true
            self.taxStackView.isHidden = true
            self.sitechargeStackView.isHidden = true
            self.totalStackView.isHidden = true
            
        }else{
            self.priceStackView.isHidden = false
            self.taxStackView.isHidden = false
            self.sitechargeStackView.isHidden = false
            self.totalStackView.isHidden = false
        }
        ZegoUIKitPrebuiltCallInvitationService.shared.delegate = self
        // Do any additional setup after loading the view.
    }
    func loadData() {
        //        Utility.shared.startAnimation(viewController: self)
        self.viewModel.viewBookingDetails(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: UserDefaultModule.shared.getLoginData().type, booking_id: self.booking_id, booking_schedule: "new", onSuccess: { (success) in            if self.viewModel.historyModel?.result.count ?? 0 > 0 {
            self.bookingResultModel = self.viewModel.historyModel?.result.first
            UserDefaults.standard.set(self.bookingResultModel?.bookingId ?? "", forKey: "BookingID")
            UserDefaults.standard.set(self.bookingResultModel?.userId ?? "", forKey: "ReciverID")
            //connectycube
            self.slotStartTime = Int(self.bookingResultModel?.utcappstart ?? "") ?? 0
            self.slotEndTime = Int(self.bookingResultModel?.slot_endtime ?? "") ?? 0
            self.videoStartTime = (Int(self.bookingResultModel?.utcappstart ?? "") ?? 0)-300
            self.doctorBookingStartTime = (Int(self.bookingResultModel?.utcappstart ?? "") ?? 0) - 1800
            print("DOCTORSTARTDDTAE:\((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.doctorBookingStartTime)", dateFormat: "dd MMM yy HH:mm:ss")))")
            
            self.lawyerlogin = self.bookingResultModel?.connectycube_userlogin ?? ""
            self.lawyerpassword = self.bookingResultModel?.connectycube_password ?? ""
            self.lawyerconnecty_Id = self.bookingResultModel?.connectycube_userid ?? ""
            self.lawyeremail = UserDefaultModule.shared.getLoginData().email ?? ""
            
            if self.bookingResultModel?.prescription_view == true {
                self.prescriptionButton.isHidden = false
                self.prescriptionBtnView.isHidden = false
            }else{
                self.prescriptionButton.isHidden = true
                self.prescriptionBtnView.isHidden = true
            }
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                var inviteesList: [ZegoUIKitUser] = []
                inviteesList.removeAll()
                let user: ZegoUIKitUser = ZegoUIKitUser.init((self.bookingResultModel?.userId ?? ""), (self.bookingResultModel?.userName ?? ""))
                inviteesList.append(user)
                self.videoBtn.inviteeList = inviteesList
                self.audioBtn.inviteeList = inviteesList
            }else{
                var inviteesList: [ZegoUIKitUser] = []
                inviteesList.removeAll()
                let user: ZegoUIKitUser = ZegoUIKitUser.init((self.bookingResultModel?.doctorId ?? ""), (self.bookingResultModel?.doctorname ?? ""))
                inviteesList.append(user)
                self.videoBtn.inviteeList = inviteesList
                self.audioBtn.inviteeList = inviteesList
            }
            self.clientlogin = self.bookingResultModel?.ownuser_connectycube_userlogin ?? ""
            print("clientlogin ===== \(self.clientlogin)")
            self.clientpassword = self.bookingResultModel?.ownuser_connectycube_password ?? ""
            self.clientconnecty_Id = self.bookingResultModel?.ownuser_connectycube_userid ?? ""
            self.clientemail = UserDefaultModule.shared.getLoginData().email ?? ""
            
            
            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor"{
                
                UserDefaultModule.shared.setconnectyLogin(login: self.lawyerlogin, password: self.lawyerpassword, Id: self.lawyerconnecty_Id, email: self.lawyeremail)
                
                let user = User()
                
                let id = UserDefaultModule.shared.getconnectyLoginData().user_id
                let convertint_Id = UInt(id)
                
                user.id = convertint_Id ?? 0
                user.email = UserDefaultModule.shared.getconnectyLoginData().email
                user.login = UserDefaultModule.shared.getconnectyLoginData().login
                user.fullName = UserDefaultModule.shared.getLoginData().firstName ?? ""
                user.password = UserDefaultModule.shared.getconnectyLoginData().password
                
                Profile.currentProfile = user
                
                if Profile.currentProfile != nil {
                    
                    CallsApp.connect()
                }
                
                
            }else{
                UserDefaultModule.shared.setconnectyLogin(login: self.clientlogin, password: self.clientpassword, Id: self.clientconnecty_Id, email: self.clientemail)
                
                let user = User()
                
                let id = UserDefaultModule.shared.getconnectyLoginData().user_id
                let convertint_Id = UInt(id)
                
                user.id = convertint_Id ?? 0
                user.email = UserDefaultModule.shared.getconnectyLoginData().email
                user.login = UserDefaultModule.shared.getconnectyLoginData().login
                user.fullName = UserDefaultModule.shared.getLoginData().firstName ?? ""
                user.password = UserDefaultModule.shared.getconnectyLoginData().password
                
                Profile.currentProfile = user
                print(Profile.currentProfile)
                
                if Profile.currentProfile != nil {
                    
                    CallsApp.connect()
                }
                
            }
            //self.client_id = self.bookingResultModel?.userId ?? ""
            self.client_id = self.bookingResultModel?.client_id ?? ""
            
            //                self.getbooking_status = self.bookingResultModel?.getbooking_status ?? ""
            //                self.complete_status = self.bookingResultModel?.complete_status ?? ""
            
            
            self.loadUserData()
        }
            //            Utility.shared.stopAnimation(viewController: self)
        }) { (failure) in
            //            Utility.shared.stopAnimation(viewController: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if !self.prescriptionView.isHidden{
            self.prescriptionView.isHidden = true
        }else{
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                if isForCall {
                    if UserDefaultModule.shared.getLoginData().type == "user"{
                        let pageObj = UserTabbarController()
                        self.appDelegate.setInitialViewController(initialView: pageObj)
                    }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                        let pageObj = DCTabbarViewController()
                        self.appDelegate.setInitialViewController(initialView: pageObj)
                    }else{
                        let pageObj = DoctorTabViewController()
                        self.appDelegate.setInitialViewController(initialView: pageObj)

                    }
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else if isLeft == 1{
                
            }
            else if isLeft == 2{
                
            }
            }
        }
    }
    @objc func updatetime() {
        var timestamp = NSDate().timeIntervalSince1970
        if Int(timestamp)  >= self.showtime && (bookingResultModel?.status.lowercased() ?? "") == "pending"{
            self.declineButton.isHidden = false
//            self.loadUserData()
            print("check4")
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    @objc func updatetime1() {
        
        var timestamp = NSDate().timeIntervalSince1970
      
        print("scheeehe",self.scheduletime)
        print("scheeehe",timestamp)
        print("scheeehe",bookingResultModel?.status)
        
        if Int(timestamp)  >= self.scheduletime {
            
            print("rescheduled rescheduled")
            self.declineButton.isHidden = true
            self.acceptButton.isHidden = true
//            self.loadUserData()
           
            self.timer?.invalidate()
            self.timer = nil
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.doctorNameLabel.numberOfLines = 0
        self.declineButton.isHidden = true
        self.acceptButton.isHidden = true
        self.chatButton.isHidden = true
        self.prescriptionButton.isHidden = true
        self.prescriptionBtnView.isHidden = true
        self.timeView.isHidden = true
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
           // self.StackViewBottom.constant = 270
        }else if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.StackViewBottom.constant = 250
            self.HeaderPatientNameStackView.isHidden = true
        }
        else{
            self.StackViewBottom.constant = 100
            self.firstStackView.isHidden = true
        }
        self.RescheduleView.isHidden = true
        if UserDefaultModule.shared.getAppTheme() == "dark"{
                  self.prescriptionView.backgroundColor = UIColor.black.withAlphaComponent(0.90)
              }else{
                  self.prescriptionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
              }
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "details") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.prescriptionSelectorView.layer.cornerRadius = 10
        self.doneButton.layer.cornerRadius = 5
        self.prescriptionView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.videoButton.cornerViewRadius()
        self.prescriptionView.isHidden = true
        self.handwrittingButton.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, title: "handwriting")
        self.onlineButton.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, title: "online_or_offline")
        self.doneButton.config(color: UIColor(named: "white"), font: fontsemi16, align: .center, title: "done")
        self.prescriptionTitleTextView.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .center, text: "prescription_heading")
        self.doctorImageView.contentMode = .scaleAspectFill
        self.doctorImageView.cornerViewRadius()
        self.HeaderPatientNameTittleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "new_patient_name")
        self.HeaderPatientNameLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.doctorNameLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
        self.specialityLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.ratingCountLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.bookingDateTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_date")
        self.bookingDateLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bookingstatusTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_status")
        self.bookingstatusLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.statusTxt.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bookingReasonTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_reason")
        self.bookingReasonLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.reasonTxt.config(color: UIColor(named: "red"), font: regular14, align: .right, text: "")
        
        self.bookingTimeTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_time")
        self.bookingTimeLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.policyTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "cancellation")
        self.policyLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "accept")
        self.RescheduleBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "reschedule")
        self.chatButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "chat")
        self.prescriptionButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .right, title: "prescription")
        self.chatButton.cornerMiniumRadius()
        self.chatButton.backgroundColor = UIColor(named: "AppColor")
        self.acceptButton.cornerMiniumRadius()
        self.acceptButton.backgroundColor = UIColor(named: "AppColor")
        self.declineButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "decline")
        self.declineButton.cornerMiniumRadius()
        self.declineButton.backgroundColor = UIColor(named: "BorderColor")
        self.payButton.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, title: "pay")
        self.payButton.cornerMiniumRadius()
        self.payButton.backgroundColor = UIColor(named: "AppColor")
        self.payButton.isHidden = true
        self.videoVisitButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "video_visit")
        self.videoVisitButton.cornerMiniumRadius()
        self.videoVisitButton.backgroundColor = UIColor(named: "AppColor")
        self.videoVisitButton.isHidden = true
        self.videoBtn.isHidden = true
        self.videoButton.cornerViewRadius()
        self.audioVisitButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "audio_visit")
        self.audioVisitButton.cornerMiniumRadius()
        self.audioVisitButton.backgroundColor = UIColor(named: "AppColor")
        self.audioVisitButton.isHidden = true
        self.audioBtn.isHidden = true
        self.priceTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "fees")
        self.priceLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.siteTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "sitecharges")
        self.siteLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.taxTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "new_tax")
        self.taxLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.totalTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "total")
        self.totalLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.paymentTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "payment")
        self.paymentStatusLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.resudleTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "resudle_time")
        self.feedbackTittlelbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "feedback")
        self.feedbackLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.resudleLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.prescriptionBtnView.backgroundColor = UIColor(named: "AppColor")
        self.prescriptionBtnView.cornerViewMiniumRadius()
       // if bookingResultModel?.status == "accepted"{
            self.statusCheckTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "status")
      //  }

        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                self.TopStackView.isHidden = false
                self.doctorNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
                self.doctorNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
                self.doctorEmailTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "email")
                self.doctorEmailLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.emailTxtView.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
                self.doctorgenderTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "patient_gender")
                self.doctorgenderLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.addressTxt.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        
                self.doctorQualificationTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "qualification")
                self.doctorQualificationLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
                self.doctorMobileTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "mobile_no")
                self.doctorMobileLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
                self.doctordetailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "doctor_details")
                self.patientdeailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "patient_details")
            self.patientPhnTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "patient_phonebumber")
            self.patientPhnLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctoremailStackView.isHidden = true
            self.doctorMobileStackView.isHidden = true
        }else if UserDefaultModule.shared.getLoginData().type == "doctor" {
            self.TopStackView.isHidden = false
            self.doctorQualificationStackView.isHidden = true
            self.doctorNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
            self.doctorNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorEmailTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "email")
            self.doctorEmailLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.emailTxtView.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorMobileTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "mobile_no")
            self.doctorMobileLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorgenderTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "host_address")
            self.doctorgenderLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.addressTxt.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            
//            self.genderStackView.isHidden = true
            self.doctordetailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "dc_details")
            self.patientdeailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "patient_details")
            self.statusCHeckLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        }
        self.patientdeailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "patient_details")
        self.patientNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
        self.patientNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
        self.patientAgeTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "age")
        self.patientAgeLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
        self.patientgenderTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "patient_gender")
        self.patientgenderLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientweightTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "weight")
        self.patientweightLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientillnessTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "issue_complaint")
        self.patientillnessLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.heightTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "height")
        self.heightbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bpTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "bp")
        self.bpLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bprsTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "grps")
        self.bprsLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        
        //Right NavigationButtons
                self.videoBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.videoBtn.tintColor = UIColor(named: "whitecolor")
                self.videoBtn.setImage(#imageLiteral(resourceName: "new_videocall"), for: UIControl.State.normal)
                self.videoBtn.imageView?.tintColor = UIColor(named: "White")
                self.videoBtn.tag = 0
                self.videoBtn.delegate = self
                self.videoBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
                self.videoBtn.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
                
                self.audioBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                self.audioBtn.setImage(#imageLiteral(resourceName: "new_call"), for: UIControl.State.normal)
                self.audioBtn.tag = 1
                self.audioBtn.delegate = self
        //        button1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.audioBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
                self.audioBtn.imageView?.tintColor = UIColor(named: "White")
                self.audioBtn.addTarget(self, action: #selector(self.rightBarButtonAct1(_:)), for: .touchUpInside)
        let stackview = UIStackView.init(arrangedSubviews: [self.videoBtn,self.audioBtn,self.videooffBtn,self.audiooffBtn])
                stackview.distribution = .fillEqually
                stackview.axis = .horizontal
                stackview.alignment = .center
                stackview.spacing = 10
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
     
    //    self.loadUserData()
        self.loadData()
    }
    func loadUserData() {
        self.wholeStackView.isHidden = true
        
        
        
        
        if self.bookingResultModel != nil {
            Utility.shared.stopAnimation(viewController: self)
            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() != "doctor" {
                if (bookingResultModel?.slotBookingtype.lowercased() ?? "") == "videovisit" {
                    self.videoButton.isHidden = false
                }
                else {
                    self.videoButton.isHidden = true
                }
            }
            else {
                self.videoButton.isHidden = true
            }
            
            self.wholeStackView.isHidden = false
            if self.bookingResultModel?.reschedule_time != "" {
                self.resudleStatckView.isHidden = false
            }
            if self.bookingResultModel?.patientstatus != "" {
                self.feedbackStackView.isHidden = false
            }
            if (UserDefaultModule.shared.getLoginData().type ?? "") == "user" {
                

                if bookingResultModel?.status == "pending" {
                    self.bookingstatusLbl.text =  "Waiting for doctor's response"
                    self.statusTxt.text =  "Waiting for doctor's response"
                } else {
                    self.bookingstatusLbl.text = bookingResultModel?.status ?? ""
                    self.statusTxt.text = bookingResultModel?.status ?? ""
                }

                self.doctorNameLabel.text = "Dr.\(bookingResultModel?.userName ?? "")"
            } else if (UserDefaultModule.shared.getLoginData().type ?? "") == "digitalclinic"{
                if bookingResultModel?.status == "pending" {
                    self.bookingstatusLbl.text =  "Waiting for doctor's response"
                    self.statusTxt.text =  "Waiting for doctor's response"
                } else {
                    self.bookingstatusLbl.text = bookingResultModel?.status ?? ""
                    self.statusTxt.text =  bookingResultModel?.status ?? ""
                }

                self.doctorNameLabel.text = "Dr.\(bookingResultModel?.userName ?? "")"
//                self.heightStackView.isHidden = true
//                self.BpstackView.isHidden = true
//                self.bprsStackView.isHidden = true
            }
            else {
                self.doctorNameLabel.text = bookingResultModel?.userName ?? ""
                self.statusTxt.text =  bookingResultModel?.status ?? ""
            }
            
            self.specialityLabel.text = bookingResultModel?.speciality ?? ""
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                self.locationLabel.text = bookingResultModel?.location ?? ""
            }else{
                self.locationLabel.text = bookingResultModel?.doctor_location ?? ""
            }
//            self.payButton.setTitle("\(getLanguage["pay"] ?? "") \(self.bookingResultModel?.currency ?? "")\(self.bookingResultModel?.grandTotal ?? "0")", for: .normal)
            self.payButton.setTitle("\(getLanguage["new_pay"] ?? "")", for: .normal)

            self.doctorImageView.sd_setImage(with: URL(string: (bookingResultModel?.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
            self.doctorImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileAct)))
            let bookingDate = Date(timeIntervalSince1970: Double(self.bookingResultModel?.bookingDate ?? 0))
            self.bookingDateLabel.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\((self.bookingResultModel?.utcappstart ?? "0"))", dateFormat: "MMM dd,yyyy"))
            self.bookingTimeLabel.text = bookingResultModel?.time ?? ""
          ///  self.bookingstatusLbl.text = bookingResultModel?.status ?? ""
            self.feedbackLbl.text = bookingResultModel?.patientstatus ?? ""
            self.resudleLbl.text = bookingResultModel?.reschedule_time ?? ""
            let reason: [String] = bookingResultModel?.bookingReason.map({$0.name}) ?? [String]()
            self.bookingReasonLabel.text = reason.joined(separator: ", ")
            self.reasonTxt.text = reason.joined(separator: ", ")
            self.priceLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.consultFees ?? "0")"
            self.siteLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.sitefees ?? "")"
            self.taxLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.tax ?? "")"
            self.totalLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.grandTotal ?? "0")"
            self.policyLabel.text = bookingResultModel?.content
            self.paymentStatusLabel.text = (getLanguage[(bookingResultModel?.orderstatus ?? "")] ?? (bookingResultModel?.orderstatus ?? "")).capitalized
            self.HeaderPatientNameLabel.text = UserDefaultModule.shared.getLoginData().firstName ?? ""
            self.payButton.isHidden = true
            
            
            
            // DC Details
          if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
              
              self.scheduletime = (Int(bookingResultModel?.utcappstart ?? "0") ?? 0)
                         print("scheduletime",self.scheduletime)
                  self.doctorNameLbl.text = "\(bookingResultModel?.doctorname ?? "")"
                  self.doctorgenderLbl.text = "\(bookingResultModel?.doctorgender ?? "")"
              self.addressTxt.text = "\(bookingResultModel?.doctorgender ?? "")"
          
                  self.doctorEmailLbl.text = "\(bookingResultModel?.doctoremail ?? "")"
              self.emailTxtView.text = "\(bookingResultModel?.doctoremail ?? "")"
                  self.doctorMobileLbl.text = "\(bookingResultModel?.doctormobilenumber ?? "")"
                  self.doctorQualificationLbl.text = "\(bookingResultModel?.doctorqualification ?? "")"
                  
                  self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                  self.patientweightLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                  self.patientillnessLbl.text = "\(bookingResultModel?.patientillness ?? "")"
                  self.patientAgeLbl.text = "\(bookingResultModel?.patientage ?? "")"
                  self.patientgenderLbl.text = "\(bookingResultModel?.patientgender ?? "")"
                  self.patientPhnLbl.text = "\(bookingResultModel?.patient_phonenumber ?? "")"
                  self.heightbl.text = "\(bookingResultModel?.patient_height ?? "")"
                  self.bpLabel.text = "\(bookingResultModel?.patient_bp ?? "")"
                  self.bprsLbl.text = "\(bookingResultModel?.patient_bprs ?? "")"
              if bookingResultModel?.patient_height ?? "" == "" && bookingResultModel?.patient_bp ?? "" == "" && bookingResultModel?.patient_bprs ?? "" == "" && bookingResultModel?.patientillness ?? "" == "" && bookingResultModel?.patientweight ?? "" == "" {
                  self.heightStackView.isHidden = true
                  self.patientWeightStackView.isHidden = true
                  self.BpstackView.isHidden = true
                  self.bprsStackView.isHidden = true
                  self.patientillnessStackView.isHidden = true
                  self.StackViewBottom.constant = 300
              }else{
                  if bookingResultModel?.patient_height ?? "" == "" {
                      self.heightStackView.isHidden = true
                  }else{
                      self.heightStackView.isHidden = false
                      self.StackViewBottom.constant = 400
                  }
                  if bookingResultModel?.patient_bp ?? "" == "" {
                      self.BpstackView.isHidden = true
                  }else{
                      self.BpstackView.isHidden = false
                      self.StackViewBottom.constant = 450
                  }
                  if bookingResultModel?.patient_bprs ?? "" == "" {
                      self.bprsStackView.isHidden = true
                  }else{
                      self.bprsStackView.isHidden = false
                      self.StackViewBottom.constant = 500
                  }
                  if bookingResultModel?.patientillness ?? "" == "" {
                      self.patientillnessStackView.isHidden = true
                  }else{
                      self.StackViewBottom.constant = 550
                      self.patientillnessStackView.isHidden = false
                  }
                  if bookingResultModel?.patientweight ?? "" == "" {
                      self.patientWeightStackView.isHidden = true
                  }else{
                      self.patientWeightStackView.isHidden = false
                  }
              }
              if self.bookingResultModel?.patientillness.count ?? 0 >= 100{
                  self.StackViewBottom.constant = 810
              }
              else if self.bookingResultModel?.patientillness.count ?? 0 >= 50{
                  self.StackViewBottom.constant = 620
              }else{
                  self.StackViewBottom.constant = 100
              }
                 
                  self.statuscheckView.isHidden = true
                  self.statusCHeckLbl.isHidden = true
                  self.statusCheckTittleLbl.isHidden = true
            }
            else if UserDefaultModule.shared.getLoginData().type == "doctor"{
                self.patientPhnStackView.isHidden = true
                if bookingResultModel?.status == "accepted"{
                    self.statusCHeckLbl.text = "\(bookingResultModel?.status ?? "")"
                    self.RescheduleView.isHidden = true
                }else{
                    self.statuscheckView.isHidden = true
                    self.statusCHeckLbl.isHidden = true
                    self.statusCheckTittleLbl.isHidden = true
                    self.RescheduleView.isHidden = true
                }
                if "\(bookingResultModel?.dcname ?? "")" != "" {
                    self.firstStackView.isHidden = false
                    self.firstStackViewTop.constant = 10
                    self.StackViewBottom.constant = 600
                    self.nameHeight.constant = 45
                    self.genderHeight.constant = 45
                    self.patientgenderLbl.isHidden = false
                    self.patientgenderView.isHidden = false
                    self.patientgenderTittleLbl.isHidden = false
                    self.patientillnessView.isHidden = false
                    self.patientillnessLbl.isHidden = false
                    self.patientillnessTittleLbl.isHidden = false
                    self.doctordetailsLbl.isHidden = false
                    self.patientweightLbl.isHidden = false
                    self.patientweightView.isHidden = false
                    self.patientweightTittleLbl.isHidden = false
                    self.doctorNameLbl.text = "\(bookingResultModel?.dcname ?? "")"
                    self.doctorEmailLbl.text = "\(bookingResultModel?.dcemail ?? "")"
                    self.emailTxtView.text = "\(bookingResultModel?.dcemail ?? "")"
                    self.doctorMobileLbl.text = "\(bookingResultModel?.dcmobilenumber ?? "")"
                    self.doctorgenderLbl.text = "\(bookingResultModel?.dcaddress ?? "")"
                    self.addressTxt.text = "\(bookingResultModel?.dcaddress ?? "")"
                    self.patientweightLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                    self.patientillnessLbl.text = "\(bookingResultModel?.patientillness ?? "")"
                    self.patientgenderLbl.text = "\(bookingResultModel?.patientgender ?? "")"
                    self.patientNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
                    self.patientNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
                    self.patientAgeTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "age")
                    self.patientAgeLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
                    self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                    self.patientAgeLbl.text = "\(bookingResultModel?.patientage ?? "")"
                    self.heightbl.text = "\(bookingResultModel?.patient_height ?? "")"
                    self.bpLabel.text = "\(bookingResultModel?.patient_bp ?? "")"
                    self.bprsLbl.text = "\(bookingResultModel?.patient_bprs ?? "")"
                    if bookingResultModel?.patient_height ?? "" == "" && bookingResultModel?.patient_bp ?? "" == "" && bookingResultModel?.patient_bprs ?? "" == "" && bookingResultModel?.patientillness ?? "" == "" && bookingResultModel?.patientweight ?? "" == ""{
                        self.heightStackView.isHidden = true
                        self.BpstackView.isHidden = true
                        self.bprsStackView.isHidden = true
                        self.patientillnessStackView.isHidden = true
                        self.patientWeightStackView.isHidden = true
                        self.StackViewBottom.constant = 300
                    }else{
                        if bookingResultModel?.patient_height ?? "" == "" {
                            self.heightStackView.isHidden = true
                        }else{
                            self.heightStackView.isHidden = false
                            self.StackViewBottom.constant = 400
                        }
                        if bookingResultModel?.patient_bp ?? "" == "" {
                            self.BpstackView.isHidden = true
                        }else{
                            self.BpstackView.isHidden = false
                            self.StackViewBottom.constant = 450
                        }
                        if bookingResultModel?.patient_bprs ?? "" == "" {
                            self.bprsStackView.isHidden = true
                        }else{
                            self.bprsStackView.isHidden = false
                            self.StackViewBottom.constant = 500
                        }
                        if bookingResultModel?.patientillness ?? "" == "" {
                            self.patientillnessStackView.isHidden = true
                        }else{
                            self.StackViewBottom.constant = 550
                            self.patientillnessStackView.isHidden = false
                        }
                        if bookingResultModel?.patientweight ?? "" == "" {
                            self.patientWeightStackView.isHidden = true
                        }else{
                            self.patientWeightStackView.isHidden = false
                        }
                    }
                }else{
                    self.patientNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
                    self.patientNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
                    self.patientAgeTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "age")
                    self.patientAgeLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text:"")
                    self.patientAgeLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                    self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                    
                    self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                    self.patientAgeLbl.text = "\(bookingResultModel?.patientage ?? "")"
                    self.patientweightLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                    self.patientillnessLbl.text = "\(bookingResultModel?.patientillness ?? "")"
                    self.heightbl.text = "\(bookingResultModel?.patient_height ?? "")"
                    self.bpLabel.text = "\(bookingResultModel?.patient_bp ?? "")"
                    self.bprsLbl.text = "\(bookingResultModel?.patient_bprs ?? "")"
                    self.patientgenderLbl.text = "\(bookingResultModel?.patientgender ?? "")"
         //           self.patientgenderLbl.isHidden = true
                    self.patientgenderLbl.isHidden = false
                    self.patientgenderView.isHidden = false
                    self.patientgenderTittleLbl.isHidden = false
//                    self.patientgenderTittleLbl.isHidden = true
          //          self.genderStackView.isHidden = true
                    self.firstStackViewTop.constant = -300
                    self.StackViewBottom.constant = 310

                    self.doctordetailsLbl.isHidden = true
                    self.firstStackView.isHidden = true
                    if bookingResultModel?.patient_height ?? "" == "" && bookingResultModel?.patient_bp ?? "" == "" && bookingResultModel?.patient_bprs ?? "" == "" && bookingResultModel?.patientillness ?? "" == "" && bookingResultModel?.patientweight ?? "" == "" {
                        self.heightStackView.isHidden = true
                        self.patientWeightStackView.isHidden = true
                        self.BpstackView.isHidden = true
                        self.bprsStackView.isHidden = true
                        self.patientillnessStackView.isHidden = true
                        self.StackViewBottom.constant = 50
                    }else{
                        if bookingResultModel?.patient_height ?? "" == "" {
                            self.heightStackView.isHidden = true
                        }else{
                            self.heightStackView.isHidden = false
                            self.StackViewBottom.constant = 75
                        }
                        if bookingResultModel?.patient_bp ?? "" == "" {
                            self.BpstackView.isHidden = true
                        }else{
                            self.BpstackView.isHidden = false
                            self.StackViewBottom.constant = 100
                        }
                        if bookingResultModel?.patient_bprs ?? "" == "" {
                            self.bprsStackView.isHidden = true
                        }else{
                            self.bprsStackView.isHidden = false
                            self.StackViewBottom.constant = 150
                        }
                        if bookingResultModel?.patientillness ?? "" == "" {
                            self.patientillnessStackView.isHidden = true
                        }else{
                            self.StackViewBottom.constant = 300
                            self.patientillnessStackView.isHidden = false
                        }
                        if bookingResultModel?.patientweight ?? "" == "" {
                            self.patientWeightStackView.isHidden = true
                        }else{
                            self.patientWeightStackView.isHidden = false
                        }
                    }
                }
            } else {
                self.scheduletime = (Int(bookingResultModel?.utcappstart ?? "0") ?? 0)
                print("scheduletime",self.scheduletime)
                self.firstStackViewTop.constant = -350
                self.patientgenderStackView.isHidden = false
                self.patientPhnStackView.isHidden = true
                self.doctordetailsLbl.isHidden = true
                self.patientAgeLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                self.patientgenderLbl.text = "\(bookingResultModel?.patientgender ?? "")"
                self.patientNameLbl.text = "\(bookingResultModel?.patientname ?? "")"
                self.patientAgeLbl.text = "\(bookingResultModel?.patientage ?? "")"
                self.patientweightLbl.text = "\(bookingResultModel?.patientweight ?? "")"
                self.patientillnessLbl.text = "\(bookingResultModel?.patientillness ?? "")"
                self.heightbl.text = "\(bookingResultModel?.patient_height ?? "")"
                self.bpLabel.text = "\(bookingResultModel?.patient_bp ?? "")"
                self.bprsLbl.text = "\(bookingResultModel?.patient_bprs ?? "")"
                if bookingResultModel?.patient_height ?? "" == "" && bookingResultModel?.patient_bp ?? "" == "" && bookingResultModel?.patient_bprs ?? "" == "" && bookingResultModel?.patientillness ?? "" == "" && bookingResultModel?.patientweight ?? "" == "" {
                    self.heightStackView.isHidden = true
                    self.patientWeightStackView.isHidden = true
                    self.BpstackView.isHidden = true
                    self.bprsStackView.isHidden = true
                    self.patientillnessStackView.isHidden = true
                    self.patientPhnStackView.isHidden = true
                    self.StackViewBottom.constant = -350
                }else{
                    if bookingResultModel?.patient_height ?? "" == "" {
                        self.heightStackView.isHidden = true
                    }else{
                        self.heightStackView.isHidden = false
                        self.StackViewBottom.constant = 75
                    }
                    if bookingResultModel?.patient_bp ?? "" == "" {
                        self.BpstackView.isHidden = true
                    }else{
                        self.BpstackView.isHidden = false
                        self.StackViewBottom.constant = 100
                    }
                    if bookingResultModel?.patient_bprs ?? "" == "" {
                        self.bprsStackView.isHidden = true
                    }else{
                        self.bprsStackView.isHidden = false
                        self.StackViewBottom.constant = 150
                    }
                    if bookingResultModel?.patientillness ?? "" == "" {
                        self.patientillnessStackView.isHidden = true
                    }else{
                        self.StackViewBottom.constant = 300
                        self.patientillnessStackView.isHidden = false
                    }
                    if bookingResultModel?.patientweight ?? "" == "" {
                        self.patientWeightStackView.isHidden = true
                    }else{
                        self.patientWeightStackView.isHidden = false
                    }
                }
                
                // Check if current date in reached check in date
//                let datetime = bookingResultModel?.time ?? "0"
//                let toArray = datetime.components(separatedBy: ":")
//                let timeZone = TimeZone(identifier: bookingResultModel?.timezone ?? "") ?? TimeZone.current
//                let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
//                let bookingDate = Date(timeIntervalSince1970: Double(bookingResultModel?.bookingDate ?? 0))
//
//                var calendar = Calendar.current
//                if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
//                    print("Current Date \(currentDate)")
//                    print("toDate Date \(toDate)")
//                    if currentDate >= toDate {
//                        self.acceptButton.isHidden = true
//                        self.declineButton.isHidden = true
//
//                    }
//                }
            }
            let timeZone = TimeZone(identifier: (bookingResultModel?.timezone ?? "0")) ?? TimeZone.current
            let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
            print("TIMEZONETEST:\(timeZone)")
            let calendar = Calendar.current
            if bookingResultModel?.reschedule_time == "" {
                self.resudleStatckView.isHidden = true
            }
            if bookingResultModel?.patientstatus == "" {
                self.feedbackStackView.isHidden = true
            }
//            calendar.timeZone = timeZone

            if type.lowercased() == "doctor" {
                self.declineButton.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, title: "decline")
            }
            else {
                self.declineButton.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, title: "cancel")
            }
            print("")
            if (bookingResultModel?.type ?? "") == "current" {
                self.acceptButton.isHidden = true
//                self.prescriptionButton.isHidden = true
                // self.prescriptionBtnView.isHidden = true
                if bookingResultModel?.status == "pending"{
                    self.declineButton.isHidden = true
                    self.acceptButton.isHidden = true
                    self.chatButton.isHidden = true
                    self.showtime = (bookingResultModel?.createdDate ?? 0)+900
                }else{
                    self.declineButton.isHidden = false
                }
                if (bookingResultModel?.status.lowercased() ?? "") == "accepted" {
                    if (bookingResultModel?.paytoken ?? "") == "" && bookingResultModel?.bookingType.lowercased() == "request" {
                        self.declineButton.isHidden = false
                        self.RescheduleView.isHidden = true
                        self.videoVisitButton.isHidden = true
                        self.videoBtn.isHidden = true
                        self.audioVisitButton.isHidden = true
                        self.audioBtn.isHidden = true
                        if type.lowercased() != "doctor" {
                            let datetime = bookingResultModel?.time ?? "0"
                            let toArray = datetime.components(separatedBy: ":")
                            let timeZone = TimeZone(identifier: bookingResultModel?.timezone ?? "") ?? TimeZone.current
                            let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
                            print("TIMEZONETEST:\(timeZone)")
                            let bookingDate = Date(timeIntervalSince1970: Double(bookingResultModel?.slot_endtime ?? "")!)

                            var calendar = Calendar.current
                            if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
                                print("Current Date \(currentDate)")
                                print("toDate Date \(toDate)")
                                if currentDate >= toDate {
                                    self.acceptButton.isHidden = true
                                    self.declineButton.isHidden = true
                                    self.payButton.isHidden = false
                                }else{
                                    self.payButton.isHidden = false
                                }
                            }
//                            self.payButton.isHidden = false
                        }
                        else {
                            self.declineButton.isHidden = true
                        }
                    }
                    else {
                        if bookingResultModel?.orderstatus.lowercased() == "paid"{
                        if (bookingResultModel?.slotBookingtype.lowercased() ?? "") == "videovisit" {
                            self.RescheduleView.isHidden = true
                            self.videoVisitButton.alpha = 0.5
                            self.audioVisitButton.alpha = 0.5
                            self.videoVisitButton.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioVisitButton.isHidden = true
                            self.audioBtn.isHidden = true
                            if type.lowercased() == "doctor"{
                                self.chatButton.isHidden = false
                                let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
                                if (toArray.count) > 1 {
                                    var mins = (Int(toArray.last ?? "0") ?? 0)
                                    var hours = (Int(toArray.first ?? "0") ?? 0)
                                    
                                    // if mins < 5 {
                                    if mins < 30{
                                        let min = 30 - mins
                                        mins = 60-min
                                        print("MINS1:\(mins)")
                                    }
                                    else {
                                        mins = mins-30
                                        //                                        mins = mins-5
                                        print("MINS2:\(mins)")
                                    }
                                    
                                    if mins == 60 {
                                        //                                              mins = 55
                                        mins = 30
                                        print("MINS3:\(mins)")
                                        if hours == 0 {
                                            hours = 23
                                            print("Hours:\(hours)")
                                        }
                                        else {
                                            hours = hours-1
                                            print("Hours:\(hours)")
                                        }
                                    }else if mins > 30{
                                        if hours == 0 {
                                            hours = 23
                                            print("Hours:\(hours)")
                                        }
                                        else {
                                            hours = hours-1
                                            print("Hours:\(hours)")
                                        }
                                    }
                                    if let toDate = calendar.date(bySettingHour: hours, minute: mins, second: 0, of: bookingDate) {
                                        print("TODATE:\(toDate)")
                                        print("CURRENTDATE:\(currentDate)")
                                        if currentDate >= toDate {
                                            self.videoVisitButton.alpha = 1
                                            self.videoVisitButton.isHidden = false
                                            self.videoBtn.isHidden = false
                                            self.audioVisitButton.alpha = 1
                                            self.audioVisitButton.isHidden = false
                                            self.audioBtn.isHidden = false
                                            self.audiooffBtn.isHidden = true
                                            self.videooffBtn.isHidden = true
                                        }
                                        else{
                                            self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                                            self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct3(_:)), for: .touchUpInside)
                                            self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                                            self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                                            print("IF")
                                            self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                                            self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct5(_:)), for: .touchUpInside)
                                            self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                                            self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                                            self.audiooffBtn.isHidden = false
                                            self.videooffBtn.isHidden = false
                                        }
                                    }
                                }
                            }else{
                                self.chatButton.isHidden = false
                                var timestamp = NSDate().timeIntervalSince1970
                                if (Int(timestamp) < self.slotStartTime){
                                    print("IFCONDITION")
                                    self.videoBtn.isHidden = true
                                    self.audioBtn.isHidden = true
                                    self.audiooffBtn.isHidden = false
                                    self.videooffBtn.isHidden = false
                                    self.prescriptionButton.isHidden = true
                                    self.prescriptionBtnView.isHidden = true
                                    self.timeView.isHidden = false
                                    self.timeButton.titleLabel?.numberOfLines = 2
                                    self.timeButton.isUserInteractionEnabled = false
                                    self.timeButton.config(color: UIColor(named: "AppColor"), font: regular14, align: .left
                                                           , title: "")
                                    self.prescriptionBtnView.backgroundColor = .clear
                                    self.timeButton.setTitle("Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.bookingResultModel?.utcappstart ?? "")", dateFormat: "dd MMM yy HH:mm")))", for: .normal)
    
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
                                    self.videoBtn.isHidden = false
                                    self.audioBtn.isHidden = false
                                    self.audiooffBtn.isHidden = true
                                    self.videooffBtn.isHidden = true
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
                                    self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct3(_:)), for: .touchUpInside)
                                    self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                                    self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                                    
                                    self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                                    self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct5(_:)), for: .touchUpInside)
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
                        }
                        self.declineButton.isHidden = false
                    }
                }
                    if type.lowercased() != "doctor"{
                        if bookingResultModel?.bookingType.lowercased() == "request" {
                            self.declineButton.isHidden = true
                        }
                        else {
                            self.declineButton.isHidden = false
                        }
                    }else {
                        if bookingResultModel?.bookingType.lowercased() == "request" {
                            self.declineButton.isHidden = true
                        }
                        else {
                            self.declineButton.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, title: "cancel")
                            self.declineButton.isHidden = false
                        }
                    }
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "cancelled" || (bookingResultModel?.status.lowercased() ?? "") == "refunded"{
                    self.declineButton.isHidden = true
                    self.videoVisitButton.isHidden = true
                    self.videoBtn.isHidden = true
                    self.audioVisitButton.isHidden = true
                    self.audioBtn.isHidden = true
                    self.payButton.isHidden = true
                    self.chatButton.isHidden = true
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "declined" {
                    self.videoVisitButton.isHidden = true
                    self.videoBtn.isHidden = true
                    self.chatButton.isHidden = true
                    self.audioVisitButton.isHidden = true
                    self.audioBtn.isHidden = true
                    self.payButton.isHidden = true
                    self.declineButton.isHidden = true
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "pending"{
                    self.resudleStatckView.isHidden = true
                    self.feedbackStackView.isHidden = true
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        self.RescheduleView.isHidden = false
                        self.acceptButton.isHidden = false
                        self.declineButton.isHidden = false
                        
                        // Check if current date in reached check in date
                        let datetime = bookingResultModel?.time ?? "0"
                        let toArray = datetime.components(separatedBy: ":")
                        let timeZone = TimeZone(identifier: bookingResultModel?.timezone ?? "") ?? TimeZone.current
                        let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
                        let bookingDate = Date(timeIntervalSince1970: Double(bookingResultModel?.bookingDate ?? 0))

                        var calendar = Calendar.current
                        if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
                            print("Current Date \(currentDate)")
                            print("toDate Date \(toDate)")
                            if currentDate >= toDate {
                                self.acceptButton.isHidden = false
                                self.declineButton.isHidden = false
                                
                            }
                        }
                    }else{
                        self.RescheduleView.isHidden = true
                    }
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "rescheduled"{
                    self.resudleStatckView.isHidden = false
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        self.acceptButton.isHidden = true
                        self.declineButton.isHidden = true
                        self.chatButton.isHidden = true
                    }else {
                        self.confrimpage = "1"
                        self.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "confrim")
                        self.declineButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "cancel")
                        self.declineButton.isHidden = false
                        self.acceptButton.isHidden = false
                        self.chatButton.isHidden = true
                        
                        
                        // Check if current date in reached check in date
                        let datetime = bookingResultModel?.time ?? "0"
                        let toArray = datetime.components(separatedBy: ":")
                        let timeZone = TimeZone(identifier: bookingResultModel?.timezone ?? "") ?? TimeZone.current
                        let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
                        let bookingDate = Date(timeIntervalSince1970: Double(bookingResultModel?.slot_endtime ?? "")!)

                        var calendar = Calendar.current
                        if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
                            print("Current Date \(currentDate)")
                            print("toDate Date \(toDate)")
                            if currentDate >= toDate {
                                self.acceptButton.isHidden = false
                                self.declineButton.isHidden = false
                                self.payButton.isHidden = true
                            }
                        }
                        
                    }
                }
                else if (bookingResultModel?.status) == "Confirmed"{
                    self.resudleStatckView.isHidden = false
                    self.RescheduleView.isHidden = true
                    self.acceptButton.isHidden = true
                    self.declineButton.isHidden = true
                    self.chatButton.isHidden = false
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        self.payButton.isHidden = true
                        if bookingResultModel?.orderstatus == "paid"{
                            self.videoVisitButton.isHidden = false
                            self.videoBtn.isHidden = false
                            self.audioVisitButton.isHidden = false
                            self.audioBtn.isHidden = false
                            self.chatButton.isHidden = false
                        }else{
                            self.videoVisitButton.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioVisitButton.isHidden = true
                            self.audioBtn.isHidden = true
                            self.chatButton.isHidden = false
                        }
                    }else{
                        if bookingResultModel?.orderstatus == "paid"{
                            self.payButton.isHidden = true
                            self.videoVisitButton.isHidden = false
                            self.videoBtn.isHidden = false
                            self.audioVisitButton.isHidden = false
                            self.audioBtn.isHidden = false
                            self.chatButton.isHidden = false
                        }else{
                            self.payButton.isHidden = false
                            self.chatButton.isHidden = false
                        }
                    }
                }
                else  {
                    self.resudleStatckView.isHidden = true
                    self.feedbackStackView.isHidden = true
                    self.RescheduleView.isHidden = true
                    self.payButton.isHidden = true
                    self.videoVisitButton.isHidden = true
                    self.videoBtn.isHidden = true
                    self.audioVisitButton.isHidden = true
                    self.audioBtn.isHidden = true
                }
            }
            else {
                if self.bookingResultModel?.orderstatus.lowercased() == "paid"{
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        if self.bookingResultModel?.patientstatus == "" {
                            self.acceptButton.isHidden = true
                            self.completepage = "1"
                            self.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "completed")
                        }else{
                            self.acceptButton.isHidden = true
                        }
                    }else{
                        self.acceptButton.isHidden = true
                    }
                     //   self.prescriptionButton.isHidden = false
                    // self.prescriptionBtnView.isHidden = false
                    if UserDefaultModule.shared.getLoginData().type != "doctor"{
                        self.videoBtn.isHidden = true
                        self.audioBtn.isHidden = true
                    }
                }else{
                    self.acceptButton.isHidden = true
                    self.prescriptionButton.isHidden = true
                    self.prescriptionBtnView.isHidden = true
                    self.chatButton.isHidden = true
                    self.audiooffBtn.isHidden = true
                    self.videooffBtn.isHidden = true
                }
                
                self.declineButton.isHidden = true
                //let end_day = 600 //It is for 10 mins for testing purpose
                let end_day = 604800 //It is the seconds of 7 days
                let end_date = Int((bookingResultModel?.bookingDate)! + end_day)
                let current_Date = Int(Date().timeIntervalSince1970)
                print("end date ",end_date)
                print("Current date ",current_Date)
                if current_Date <= end_date{
                    if UserDefaultModule.shared.getLoginData().type == "doctor"{
                        if self.bookingResultModel?.orderstatus.lowercased() == "paid"{
                            self.videoVisitButton.alpha = 1
                            self.videoVisitButton.isHidden = false
                            self.videoBtn.isHidden = false
                            self.audioVisitButton.alpha = 1
                            self.audioVisitButton.isHidden = false
                            self.audioBtn.isHidden = false
                            self.chatButton.isHidden = false
                            self.audiooffBtn.isHidden = true
                            self.videooffBtn.isHidden = true
                        }else{
                            self.videoVisitButton.isHidden = true
                            self.videoBtn.isHidden = true
                            self.audioVisitButton.isHidden = true
                            self.audioBtn.isHidden = true
                            self.audiooffBtn.isHidden = true
                            self.videooffBtn.isHidden = true
                            self.chatButton.isHidden = true
                            self.audiooffBtn.isHidden = true
                            self.videooffBtn.isHidden = true
                        }
                    }else{
                        if self.bookingResultModel?.status.lowercased() == "expired" || self.bookingResultModel?.status.lowercased() == "cancelled" || self.bookingResultModel?.status.lowercased() == "refunded" || self.bookingResultModel?.status.lowercased() == "declined"{
                            self.chatButton.isHidden = true
                            self.audioVisitButton.isHidden = true
                            self.audioBtn.isHidden = true
                            self.videoVisitButton.isHidden = true
                            self.videoBtn.isHidden = true
                            self.videooffBtn.isHidden = true
                            self.audiooffBtn.isHidden = true
                        }else {
                            self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                            self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                            self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                            self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                            
                            self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                            self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                            self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                            self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                            self.chatButton.isHidden = false
                            if bookingResultModel?.orderstatus != "paid"{
                                self.videooffBtn.isHidden = true
                                self.audiooffBtn.isHidden = true
                                self.chatButton.isHidden = true
                            }
                            self.audioVisitButton.isHidden = true
                            self.audioBtn.isHidden = true
                            self.videoVisitButton.isHidden = true
                            self.videoBtn.isHidden = true
                        }
                    }
                }else{
                    self.videoVisitButton.isHidden = true
                    self.audioVisitButton.isHidden = true
                    self.audioBtn.isHidden = true
                    self.videoBtn.isHidden = true
                    self.audiooffBtn.isHidden = false
                    self.videooffBtn.isHidden = false
                    if self.bookingResultModel?.orderstatus.lowercased() == "paid"{
                        self.prescriptionButton.isHidden = false
                        self.prescriptionBtnView.isHidden = false
                        self.prescription_type = "true"
                    }
                    
                    self.videooffBtn.setImage(#imageLiteral(resourceName: "new_videocalloff"), for: UIControl.State.normal)
                    self.videooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                    self.videooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    self.videooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                    
                    self.audiooffBtn.setImage(#imageLiteral(resourceName: "new_calloff"), for: UIControl.State.normal)
                    self.audiooffBtn.addTarget(self, action: #selector(self.rightBarButtonAct4(_:)), for: .touchUpInside)
                    self.audiooffBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    self.audiooffBtn.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
                    self.chatButton.isHidden = true
                }
            }
            // Check if current date in reached check in date
            let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
            if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
                print("Current Date \(currentDate)")
                print("toDate Date \(toDate)")
                if currentDate >= toDate {
            //        self.payButton.isHidden = true
                    //self.acceptButton.isHidden = true
            //        self.declineButton.isHidden = true
     //               self.RescheduleView.isHidden = true
                   // self.chatButton.isHidden = false
                }
            }
      //      self.chatButton.isHidden = false
     //       self.prescriptionButton.isHidden = true
            // self.prescriptionBtnView.isHidden = true
            if (bookingResultModel?.status.lowercased() ?? "") == "accepted" || (bookingResultModel?.status.lowercased() ?? "") == "completed" || (bookingResultModel?.status.lowercased() ?? "") == "paid"{
                if (bookingResultModel?.paytoken ?? "") == "" && bookingResultModel?.bookingType.lowercased() == "request" {
                    self.prescriptionButton.isHidden = true
                    self.prescriptionBtnView.isHidden = true
                }
                else {
                    let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
                    var hours = (Int(toArray.first ?? "0") ?? 0)
                    var mins = (Int(toArray.last ?? "0") ?? 0)
                    if mins < 30 {
                        mins = 60-mins
                    }
                    else {
                        mins = mins-30
                    }
                    if mins == 60 {
                        mins = 30
                        if hours == 0 {
                            hours = 23
                        }
                        else {
                            hours = hours-1
                        }
                    }
                    if let toDate = calendar.date(bySettingHour: hours, minute: mins, second: 0, of: bookingDate) {
                        if currentDate >= toDate {
                      //      self.prescriptionButton.isHidden = false
                        // self.prescriptionBtnView.isHidden = false
                        }
                    }
                }
            }
        }
        else {
            self.wholeStackView.isHidden = true
        }
    }
    @objc func rightBarButtonAct(_ sender: UIButton) {
        var userIDString = ""
             var username = ""
        self.callType = "video"
             self.prescriptionButtonhide = "1"
        self.viewModel.callinitate(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", type: self.callType, onSuccess: { (success) in
                     if UserDefaultModule.shared.getLoginData().type == "doctor"{
                         userIDString = self.bookingResultModel?.userId ?? ""
                         if self.bookingResultModel?.dcname == "" {
                             username = self.bookingResultModel?.userName ?? ""
                         }else{
                             username = self.bookingResultModel?.dcname ?? ""
                         }
                     }else{
                         userIDString = self.bookingResultModel?.doctorId ?? ""
                         username = "\(self.bookingResultModel?.doctorname ?? "")"
                     }
                     print("USERID:\(userIDString)")
                     let userIDList = userIDString.components(separatedBy: ",")
                     var inviteesList: [ZegoUIKitUser] = []
                     for userID in userIDList {
                         let userName: String = String(format: "%@", username)
                         if userID == "" {
                             print("THIS ISSUE")
                             continue
                         }
                         let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
                         inviteesList.append(user)
                     }
                     self.videoBtn.inviteeList = inviteesList
                     self.prescriptionButton.isHidden = false
                     self.prescriptionBtnView.isHidden = false
             }) { (failure) in
                 Utility.shared.stopAnimation(viewController: self)
             }
        
    /*
            if sender.tag == 0{
                if Profile.currentProfile != nil {

                    CallsApp.connect()
                }
                if self.testing == "connect"
                {
                    if sender.alpha == 1{
                        Utility.shared.startAnimation(viewController: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.shared.stopAnimation(viewController: self)
                        self.attemptCall(with: .video)
                        }
                            
                    }
                }
            }else{
                if Profile.currentProfile != nil {

                    CallsApp.connect()
                }
                if self.testing == "connect"
                {
                    if sender.alpha == 1{
                        Utility.shared.startAnimation(viewController: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.shared.stopAnimation(viewController: self)
                        self.attemptCall(with: .audio)
                        }
                    }
                }
            }
        */
        }
    @objc func rightBarButtonAct1(_ sender: UIButton) {
        var userIDString = ""
               var username = ""
               self.prescriptionButtonhide = "1"
        self.callType = "audio"
        self.viewModel.callinitate(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", type: self.callType, onSuccess: { (success) in
               if UserDefaultModule.shared.getLoginData().type == "doctor"{
                   userIDString = self.bookingResultModel?.userId ?? ""
                   if self.bookingResultModel?.dcname == "" {
                       username = self.bookingResultModel?.userName ?? ""
                   }else{
                       username = self.bookingResultModel?.dcname ?? ""
                   }
               }else{
                   userIDString = self.bookingResultModel?.doctorId ?? ""
                   username = self.bookingResultModel?.doctorname ?? ""
               }
               print("USERID:\(userIDString)")
               let userIDList = userIDString.components(separatedBy: ",")
               var inviteesList: [ZegoUIKitUser] = []
               for userID in userIDList {
                   let userName: String = String(format: "%@", username)
                   if userID == "" {
                       print("THIS ISSUE")
                       continue
                   }
                   let user: ZegoUIKitUser = ZegoUIKitUser.init(userID, userName)
                   inviteesList.append(user)
               }
               self.audioBtn.inviteeList = inviteesList
               self.prescriptionButton.isHidden = false
            self.prescriptionBtnView.isHidden = false
               }) { (failure) in
                   Utility.shared.stopAnimation(viewController: self)
               }
        
    /*
            if sender.tag == 0{
                if Profile.currentProfile != nil {

                    CallsApp.connect()
                }
                if self.testing == "connect"
                {
                    if sender.alpha == 1{
                        Utility.shared.startAnimation(viewController: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.shared.stopAnimation(viewController: self)
                        self.attemptCall(with: .video)
                        }
                            
                    }
                }
            }else{
                if Profile.currentProfile != nil {

                    CallsApp.connect()
                }
                if self.testing == "connect"
                {
                    if sender.alpha == 1{
                        Utility.shared.startAnimation(viewController: self)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        Utility.shared.stopAnimation(viewController: self)
                        self.attemptCall(with: .audio)
                        }
                    }
                }
            }
        */
        }
    @objc func rightBarButtonAct3(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["Payment was done and “Your video consultation will start  on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.doctorBookingStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.doctorBookingStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }else{
            self.view.makeToast(getLanguage["Payment was done and “Your video consultation will start  on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.bookingResultModel?.utcappstart ?? "")", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your video consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.bookingResultModel?.utcappstart ?? "")", dateFormat: "dd MMM yy HH:mm")))")
        }
    }
    @objc func rightBarButtonAct4(_ sender: UIButton) {
        self.view.makeToast(getLanguage["your appointment time slot is over, please request doctor to call if needed"] ?? "your appointment time slot is over, please request doctor to call if needed")
    }
    @objc func rightBarButtonAct5(_ sender: UIButton){
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["Payment was done and “Your Audio consultation will start  on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.doctorBookingStartTime)", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.doctorBookingStartTime)", dateFormat: "dd MMM yy HH:mm")))")
        }else{
            self.view.makeToast(getLanguage["Payment was done and “Your Audio consultation will start  on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.bookingResultModel?.utcappstart ?? "")", dateFormat: "dd MMM yy HH:mm")))"] ?? "Payment was done and “Your Audio consultation will start on \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(self.bookingResultModel?.utcappstart ?? "")", dateFormat: "dd MMM yy HH:mm")))")
        }
    }
    func changeToSystemTimeZone(_ date: Date, from: TimeZone, to: TimeZone = TimeZone.current) -> Date {
        let sourceOffset = from.secondsFromGMT(for: date)
        let destinationOffset = to.secondsFromGMT(for: date)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
        return Date(timeInterval: timeInterval, since: date)
    }
    @IBAction func RescheduleBtnAct(_ sender: Any) {
        let pageObj = BookingCalendarViewController()
        pageObj.type = "request"
        pageObj.booking_type = "videovisit"
        pageObj.redoctorID = self.bookingResultModel?.doctorId ?? ""
        pageObj.sendType = "redoctor"
        pageObj.res = "1"
        pageObj.bookingID = self.bookingResultModel?.bookingId ?? ""
        pageObj.resechudle_date = self.bookingResultModel?.bookingDate ?? 0
        self.navigationController?.pushViewController(pageObj, animated: true)
       
    }
    @objc func profileAct() {
        if (UserDefaultModule.shared.getLoginData().type) != "doctor" {
            let pageObj = DoctorDetailsViewController()
            pageObj.doctorID = (self.bookingResultModel?.doctorId ?? "")
            pageObj.type = (self.bookingResultModel?.speciality ?? "")
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    @objc func videoCall(){
        
    }
    @objc func audioCall(){
        
    }
    func configCheckBox(){
        self.checkBoxView.line = .thin
        self.checkBoxView1.line = .thin
        self.checkBoxView.bgColorSelected  = AppRed
        self.checkBoxView1.bgColorSelected = AppRed
//        self.checkBoxView.bgColor          = .white
//        self.checkBoxView1.bgColor         = .white
//        self.checkBoxView.color            = .white
//        self.checkBoxView1.color           = .white
        self.checkBoxView.borderWidth      = 1.5
        self.checkBoxView.cornerRadius     = 2
        self.checkBoxView1.borderWidth      = 1.5
        self.checkBoxView1.cornerRadius     = 2
        self.checkBoxView.borderColor      = AppRed
        self.checkBoxView1.borderColor      = AppRed
        checkBoxView.checkboxValueChangedBlock = {
            isOn in
            if isOn == true{
                self.checkBoxView1.setOn(false, animated: true)
                self.prescriptiontype = "handwritting"
            }else{
                self.prescriptiontype = ""
            }
            print("Custom checkbox is \(isOn ? "ON" : "OFF")")
        }
        checkBoxView1.checkboxValueChangedBlock = {
            isOn in
            if isOn == true{
                self.checkBoxView.setOn(false, animated: true)
                self.prescriptiontype = "online"
            }else{
                self.prescriptiontype = ""
            }
            print("Custom checkbox1 is \(isOn ? "ON" : "OFF")")
        }
    }
    @IBAction func chatButtonAct(_ sender: UIButton) {
        if isFromChat {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let pageObj = ChatViewController()
            pageObj.isFromBooking = true
            pageObj.id = (self.bookingResultModel?.bookingId ?? "")
            pageObj.userName = (self.bookingResultModel?.userName ?? "")
            pageObj.receiverImage = (self.bookingResultModel?.userImage ?? "")
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    @IBAction func doneButtonAct(_ sender: UIButton) {
        if self.prescriptiontype == "online"{
            let pageObj = PrescriptionViewController()
            pageObj.viewFrom = "online"
            pageObj.booking_id = self.bookingResultModel?.bookingId ?? ""
            self.navigationController?.pushViewController(pageObj, animated: true)
            self.prescriptionView.isHidden = true
        }else if self.prescriptiontype == "handwritting"{
            let pageObj = PrescriptionViewController()
            pageObj.viewFrom = "handwriting"
            pageObj.doctorName = UserDefaultModule.shared.getLoginData().firstName ?? ""
            pageObj.doctorqualification = self.bookingResultModel?.doctorqualification ?? ""
         //   pageObj.speciality = self.bookingResultModel?.speciality ?? ""
            pageObj.doctorregno = self.bookingResultModel?.doctorregister ?? ""
            pageObj.booking_id = self.bookingResultModel?.bookingId ?? ""
            pageObj.patientGender = self.bookingResultModel?.patientgender ?? ""
            var bookingDate = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\((self.bookingResultModel?.bookingDate ?? 0))", dateFormat: "MMM dd,yyyy"))
            pageObj.bookingDate = bookingDate
            pageObj.slotTime = self.bookingResultModel?.time ?? ""
            pageObj.speciality = self.bookingResultModel?.doctor_speciality ?? ""
         pageObj.patientName = self.bookingResultModel?.userName ?? ""
                pageObj.patientAge = self.bookingResultModel?.patientage ?? ""
                pageObj.patientWeight = self.bookingResultModel?.patientweight ?? ""
            self.navigationController?.pushViewController(pageObj, animated: true)
            self.prescriptionView.isHidden = true
        }else{
            self.prescriptionView.isHidden = true
        }
    }
    @IBAction func handwrittingButtonAct(_ sender: UIButton) {
        if !checkBoxView.isOn{
        self.checkBoxView.setOn(true, animated: true)
        self.checkBoxView1.setOn(false, animated: true)
        self.prescriptiontype = "handwritting"
        }else{
            self.checkBoxView.setOn(false, animated: true)
            self.prescriptiontype = ""
        }
    }
    @IBAction func onlineButtonAct(_ sender: UIButton) {
        if !checkBoxView1.isOn{
        self.checkBoxView.setOn(false, animated: true)
        self.checkBoxView1.setOn(true, animated: true)
        self.prescriptiontype = "online"
    }else{
        self.checkBoxView.setOn(false, animated: true)
        self.prescriptiontype = ""
    }
    }
    @IBAction func acceptButtonAct(_ sender: UIButton) {
        if self.completepage == "1"{
//            let pageObj = compleReviewViewController()
//            pageObj.booking_id = self.bookingResultModel?.bookingId ?? ""
//            pageObj.status = self.bookingResultModel?.status ?? ""
//            pageObj.doctorName = UserDefaultModule.shared.getLoginData().firstName ?? ""
//            if self.bookingResultModel?.patientname == "" {
//                pageObj.patientName = self.bookingResultModel?.userName ?? ""
//                pageObj.patientGender = UserDefaultModule.shared.getLoginData().gender ?? ""
//            }else{
//                pageObj.patientName = self.bookingResultModel?.patientname ?? ""
//                pageObj.patientGender = self.bookingResultModel?.patientgender ?? ""
//            }
//            pageObj.patientAge = self.bookingResultModel?.patientage ?? ""
//            pageObj.modalPresentationStyle = .overCurrentContext
//            self.present(pageObj, animated: true)
        }else{
            if UserDefaultModule.shared.getLoginData().type != "doctor" {
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.reschudlebooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: "Reschedule", booking_id: (self.bookingResultModel?.bookingId ?? ""), status: "Accepted", onSuccess: { (success) in
                    Utility.shared.stopAnimation(viewController: self)
                    let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                    if success {
                        alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                    }
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                        if success {
                            self.bookingResultModel?.status = "accepted"
                            self.loadUserData()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
           /*
                self.viewModel.CancelBooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: self.type, booking_id: (self.bookingResultModel?.bookingId ?? ""), status: "confrim", onSuccess: { (success) in
                    Utility.shared.stopAnimation(viewController: self)
                    let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                    if success {
                        alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                    }
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                        if success {
                            self.bookingResultModel?.status = "accepted"
                            self.loadUserData()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
                */
            }else{
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.CancelBooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: self.type, booking_id: (self.bookingResultModel?.bookingId ?? ""), status: "accepted", onSuccess: { (success) in
                    Utility.shared.stopAnimation(viewController: self)
                    let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                    if success {
                        alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                    }
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                        if success {
                            self.bookingResultModel?.status = "accepted"
                            self.loadUserData()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }) { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
        }
    }
    
    @IBAction func payButtonAct(_ sender: UIButton) {
        let pageObj = PaymentViewController()
        let doctorDetails = DoctorResultModel(averageRating: (self.bookingResultModel?.rating ?? ""), bookingType: (self.bookingResultModel?.bookingType ?? ""), doctorId: (self.bookingResultModel?.doctorId ?? ""), doctorImage: (self.bookingResultModel?.userImage ?? ""), consultFees: (self.bookingResultModel?.consultFees ?? ""), slotBookingtype: (self.bookingResultModel?.slotBookingtype ?? ""))
        pageObj.doctorData = doctorDetails
        pageObj.bookingSlotModel = BookingSlotResultModel(consultFees: (self.bookingResultModel?.consultFees ?? ""), currency: (self.bookingResultModel?.currency ?? ""), grandTotal: (self.bookingResultModel?.grandTotal ?? ""), sitefees: (self.bookingResultModel?.sitefees ?? ""), tax: (self.bookingResultModel?.tax ?? ""), currencycode: (self.bookingResultModel?.tax ?? ""), price: (self.bookingResultModel?.price ?? ""), convertedcurrencycode: (self.bookingResultModel?.convertedcurrencycode ?? ""))
        pageObj.stripeKey = (self.bookingResultModel?.stripePublishkey ?? "")
        pageObj.doctor_id = (self.bookingResultModel?.doctorId ?? "")
        pageObj.booking_id = (self.bookingResultModel?.bookingId ?? "")
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    func attemptCall(with type: CallConferenceType) {
    
        //here start code flow
       // oppoennets

        //let someString = "5801837" //mailto:notify@mailinator.com iphone6 oppent doctor oda opponent
        
       // let someString = "5801596" //mailto:goolawyer@mailinator.com iphone7+   user oda opponent
        
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor"{
            self.somestring = self.bookingResultModel?.ownuser_connectycube_userid ?? ""  //opponent of doctor
            print("somestring ======= \(somestring)")
        }else{
            self.somestring = self.bookingResultModel?.connectycube_userid ?? ""  //opponent of user
        }
            if let myInteger = Int(self.somestring)
            {
                self.myNumber = NSNumber(value:myInteger)
                print(myNumber)
            }
            else
            {
                print("'\(self.somestring)' did not convert to an Int")
            }
            
            var opponentIDs: [NSNumber] = []
            opponentIDs.append(self.myNumber)
            
            if let session = CallClient.instance().createNewSession(withOpponents: opponentIDs, with: type) as CallSession?
            {
                self.session = session
                self.callUUID = UUID()
                
                CallKitAdapter.shared.startCall(with: opponentIDs as! [Int], session: session, uuid: self.callUUID!)
                
                /*
                  //old
                let payload =
                [
                    "message" : String(format: "%@ is calling you.", Profile.currentProfile!.fullName!),
                    "ios_voip" : "1",
                    kVOIPEvent : "1",
                    
                ]
                */
                
                /*
                 //sample
                let event = Event()
                event.notificationType = .push
                event.usersIDs = opponentIDs
                event.type = .oneShot

                var pushParameters = [String : String]()
         
                pushParameters["message"] = "Bitcoin trends"
                pushParameters["ios_badge"] = "2"
                pushParameters["ios_sound"] = "app_sound.wav"

                // custom params
                pushParameters["thread_likes"] = "24"
                pushParameters["thread_id"] = "678923"

                if let jsonData = try? JSONSerialization.data(withJSONObject: pushParameters,
                                                            options: .prettyPrinted) {
                  let jsonString = String(bytes: jsonData,
                                          encoding: String.Encoding.utf8)

                  event.message = jsonString

                  Request.createEvent(event, successBlock: {(events) in

                  }, errorBlock: {(error) in

                  })
                }
        */
        /*
                let data = try! JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
                let message = String(data: data, encoding: String.Encoding.utf8)
                let event = Event()

                event.notificationType = .push
                event.usersIDs = opponentIDs
                event.type = .oneShot
                event.message = message

                Request.createEvent(event, successBlock: { (event) in
                    NSLog("Send voip push - Success")
                }) { (error) in
                    NSLog("Send voip push - Error")
                    print("Send voip push error:\(error.localizedDescription)")
                }
            */
                
                let callVC =  CallViewController1()
                if type == .audio{
                    callVC.call_type = "audio"
                }else{
                    callVC.call_type = "video"
                }

                callVC.userName = self.bookingResultModel?.userName ?? ""
                callVC.receiverId =  self.bookingResultModel?.userId ?? ""
                callVC.user_img = self.bookingResultModel?.userImage ?? ""
                callVC.userType = self.type.lowercased()
                callVC.chatData = self.bookingResultModel
                callVC.session = self.session
                callVC.callUUID = self.callUUID
                self.appDelegate.callUUID = self.callUUID
                self.appDelegate.session = self.session
                callVC.modalPresentationStyle = .fullScreen
                self.appDelegate.window?.rootViewController?.present(callVC, animated: true, completion: nil)

                    //self.performSegue(withIdentifier: Segues.callSceneID, sender: self.callUUID)
                  
       
                
            }
            else
            {
                print("not working")
            }
            
            
            
            
        }
    
    @IBAction func videoVisitButtonAct(_ sender: UIButton) {
        if self.testing == "connect"
        {
            if sender.alpha == 1{
                Utility.shared.startAnimation(viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                Utility.shared.stopAnimation(viewController: self)
                self.attemptCall(with: .video)
                }
                    
            }
        }
        else
        {
            /*
            if sender.alpha == 1 {
                let pageobj = CallViewController()
                if type.lowercased() != "doctor" {
                    pageobj.call_type = "request"
                    pageobj.receiverId =  (self.bookingResultModel?.doctorId ?? "")
                    pageobj.userType = type.lowercased()
                    pageobj.chatData = self.bookingResultModel
                    pageobj.senderFlag = true
                    pageobj.modalPresentationStyle = .fullScreen
                }
                else {
                    pageobj.call_type = "call"
                    pageobj.receiverId =  self.bookingResultModel?.userId ?? ""
                    pageobj.userType = type.lowercased()
                    //            pageobj.random_id = random_id
                    pageobj.chatData = self.bookingResultModel
                    Utility.shared.startAnimation(viewController: self)
                    
                }
                let callModel = CallViewModel()
                callModel.checkChat(sender_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), chat_id: self.booking_id) { (success) in
                    
                    if (callModel.statusModel?.status ?? false) && (callModel.statusModel?.call_status ?? "") == "create"{
                        pageobj.senderFlag = true
                    }
                    else {
                        pageobj.senderFlag = false
                        pageobj.viewType = "2"
                    }
                    pageobj.room_id = (callModel.statusModel?.room_id ?? "")
                    pageobj.modalPresentationStyle = .fullScreen
                    if (callModel.statusModel?.status ?? false) {
                        self.appDelegate.window?.rootViewController?.present(pageobj, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: getLanguage[(callModel.statusModel?.message ?? "")] ?? (callModel.statusModel?.message ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    Utility.shared.stopAnimation(viewController: self)
                } onFailure: { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: getLanguage["Your Video Call timing is not matched with your booking time. kindly wait  till  your booked timing slot."] ?? "Your Video Call timing is not matched with your booking time. kindly wait  till  your booked timing slot.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                }))
                self.present(alert, animated: true, completion: nil)
            }*/
        }
    }
    
    @IBAction func audioVisitButtonAct(_ sender: UIButton) {
        if self.testing == "connect"
        {
            if sender.alpha == 1{
                Utility.shared.startAnimation(viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                Utility.shared.stopAnimation(viewController: self)
                self.attemptCall(with: .audio)
                }
                    
            }
        }
        else
        {
            /*
            if sender.alpha == 1 {
                let pageobj = CallViewController()
                if type.lowercased() != "doctor" {
                    pageobj.call_type = "request"
                    pageobj.receiverId =  (self.bookingResultModel?.doctorId ?? "")
                    pageobj.userType = type.lowercased()
                    pageobj.chatData = self.bookingResultModel
                    pageobj.senderFlag = true
                    pageobj.modalPresentationStyle = .fullScreen
                }
                else {
                    pageobj.call_type = "call"
                    pageobj.receiverId =  self.bookingResultModel?.userId ?? ""
                    pageobj.userType = type.lowercased()
                    //            pageobj.random_id = random_id
                    pageobj.chatData = self.bookingResultModel
                    Utility.shared.startAnimation(viewController: self)
                    
                }
                let callModel = CallViewModel()
                callModel.checkChat(sender_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), chat_id: self.booking_id) { (success) in
                    
                    if (callModel.statusModel?.status ?? false) && (callModel.statusModel?.call_status ?? "") == "create"{
                        pageobj.senderFlag = true
                    }
                    else {
                        pageobj.senderFlag = false
                        pageobj.viewType = "2"
                    }
                    pageobj.room_id = (callModel.statusModel?.room_id ?? "")
                    pageobj.modalPresentationStyle = .fullScreen
                    if (callModel.statusModel?.status ?? false) {
                        self.appDelegate.window?.rootViewController?.present(pageobj, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: getLanguage[(callModel.statusModel?.message ?? "")] ?? (callModel.statusModel?.message ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    Utility.shared.stopAnimation(viewController: self)
                } onFailure: { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            else {
                let alert = UIAlertController(title: nil, message: getLanguage["Your Video Call timing is not matched with your booking time. kindly wait  till  your booked timing slot."] ?? "Your Video Call timing is not matched with your booking time. kindly wait  till  your booked timing slot.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                }))
                self.present(alert, animated: true, completion: nil)
            }*/
        }
    }
    
    @IBAction func declineButtonAct(_ sender: UIButton) {
        Utility.shared.startAnimation(viewController: self)
        if UserDefaultModule.shared.getLoginData().type != "doctor"{
            self.viewModel.reschudlebooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: "Reschedule", booking_id: (self.bookingResultModel?.bookingId ?? ""), status: "Rejected", onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                if success {
                    alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                }
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                    if success {
                        self.bookingResultModel?.status = "cancelled"
                        self.loadUserData()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }else{
            var cancelStatus = "declined"
//            if getLanguage[(sender.currentTitle ?? "")] == getLanguage["decline"]  {
//                cancelStatus = "declined"
//            }
            self.viewModel.CancelBooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: self.type, booking_id: (self.bookingResultModel?.bookingId ?? ""), status: cancelStatus, onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                if success {
                    alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                }
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                    if success {
                        self.bookingResultModel?.status = "declined"
                        self.loadUserData()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
    }
    @IBAction func prescriptionButtonAct(_ sender: UIButton) {
        let pageObj = ViewPrescriptionController()
                pageObj.type = self.type
                pageObj.booking_id = self.booking_id
                pageObj.prescriptionAdd = self.prescription_type
                self.navigationController?.pushViewController(pageObj, animated: true)
//        if self.type == "doctor"{
//            self.prescriptionView.isHidden = false
//        }else{
//            let pageObj = PrescriptionViewController()
//            if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
//                pageObj.patientName = self.bookingResultModel?.patientname ?? ""
//                pageObj.patientGender = self.bookingResultModel?.patientgender ?? ""
//            }else{
//                pageObj.patientName = UserDefaultModule.shared.getLoginData().firstName ?? ""
//                pageObj.patientGender = UserDefaultModule.shared.getLoginData().gender ?? ""
//            }
//            pageObj.patientAge = self.bookingResultModel?.patientage ?? ""
//            pageObj.patientWeight = self.bookingResultModel?.patientweight ?? ""
//            pageObj.slotTime = self.bookingResultModel?.time ?? ""
//            pageObj.booking_id = self.bookingResultModel?.bookingId ?? ""
//            var bookingDate = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\((self.bookingResultModel?.bookingDate ?? 0))", dateFormat: "MMM dd,yyyy"))
//            pageObj.bookingDate = bookingDate
//            pageObj.doctorName = self.bookingResultModel?.doctorname ?? ""
//            pageObj.doctorqualification = self.bookingResultModel?.doctorqualification ?? ""
//            pageObj.speciality = self.bookingResultModel?.doctor_speciality ?? ""
//            pageObj.doctorregno = self.bookingResultModel?.doctorregister ?? ""
//            self.navigationController?.pushViewController(pageObj, animated: true)
//        }
    }
}

extension BookingDetailsViewController: ZegoUIKitPrebuiltCallInvitationServiceDelegate, UITextFieldDelegate, ZegoSendCallInvitationButtonDelegate{
    
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
      //      config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
      //      }
        } else {
//            if data.invitees?.count ?? 0 > 1 {
//                let config = ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//                return config
//            } else {
                let config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            config.topMenuBarConfig.isVisible = true
   //         config.topMenuBarConfig.buttons = [.minimizingButton]
                return config
          //  }
        }
    }

    func onIncomingCallDeclineButtonPressed() {
        print("CORRECT!!!")
        self.viewModel.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }
    func onIncomingCallAcceptButtonPressed() {

    }
    func onOutgoingCallCancelButtonPressed() {
        print("CORRECT")
        self.viewModel.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }

    func onIncomingCallReceived(_ callID: String, caller: ZegoCallUser, callType: ZegoCallType, callees: [ZegoCallUser]?) {
        
    }
    func onIncomingCallCanceled(_ callID: String, caller: ZegoCallUser) {
        print("CORRECT!")
        self.viewModel.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
    }
    func onOutgoingCallAccepted(_ callID: String, callee: ZegoCallUser) {

    }
    
    func onOutgoingCallCutButtonPressed() {
        self.viewModel.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
            
        }) { (failure) in
            
        }
        print("Suriya cut btn tapped")
    }
    func onOutgoingCallRejectedCauseBusy(_ callID: String, callee: ZegoCallUser) {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.view.makeToast(getLanguage["\(self.bookingResultModel?.userName ?? "") on call with another doctor, please try again later"] ?? "\(self.bookingResultModel?.userName ?? "") on call with another doctor, please try again later")
        }else{
            self.view.makeToast(getLanguage["\(self.bookingResultModel?.doctorname ?? "") on call with another patient,please try again later"] ?? "\(self.bookingResultModel?.doctorname ?? "") on call with another patient,please try again later")
        }
        self.viewModel.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
        
        }) { (failure) in
            
        }
        
    }
    func onOutgoingCallDeclined(_ callID: String, callee: ZegoCallUser) {
//        self.viewModel.callend(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
//
//        }) { (failure) in
//
//        }
    }
    func onIncomingCallTimeout(_ callID: String,  caller: ZegoCallUser){
        self.viewModel.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
        
        }) { (failure) in
            
        }
    }
    func onOutgoingCallTimeout(_ callID: String, callees: [ZegoCallUser]) {
        self.viewModel.missedcall(sender_id: UserDefaultModule.shared.getLoginData().userId ?? "", receiver_id: self.bookingResultModel?.userId ?? "", call_id: self.bookingResultModel?.bookingId ?? "", onSuccess: { (success) in
        
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

