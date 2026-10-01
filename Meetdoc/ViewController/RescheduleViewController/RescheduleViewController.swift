//
//  RescheduleViewController.swift
//  Meetdoc
//
//  Created by HTS-MAC on 24/02/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class RescheduleViewController: UIViewController {
    @IBOutlet weak var TopStackView: UIStackView!
    @IBOutlet weak var StackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var prescriptionButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var siteTitleLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxTitleLabel: UILabel!
    @IBOutlet weak var videoVisitButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var bookingDateTitleLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingTimeLabel: UILabel!
    @IBOutlet weak var bookingTimeTitleLabel: UILabel!
    @IBOutlet weak var bookingReasonTitleLabel: UILabel!
    @IBOutlet weak var paymentStatusTittleLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var bookingReasonLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var doctordetailsLbl: UILabel!
    @IBOutlet weak var patientdeailsLbl: UILabel!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var doctorNameView: UIView!
    @IBOutlet weak var doctorNameTittleLbl: UILabel!
    @IBOutlet weak var doctorEmailTittleLbl: UILabel!
    @IBOutlet weak var doctorEmailLbl: UILabel!
    @IBOutlet weak var doctorEmailView: UIView!
    @IBOutlet weak var doctorgenderTittleLbl: UILabel!
    @IBOutlet weak var doctorgenderLbl: UILabel!
    @IBOutlet weak var doctorgenderView: UIView!
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
    
    var viewModel = BookingHistoryViewModel()
    var viewModel1 = DoctorViewModel()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    func configUI() {
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                  self.StackViewBottom.constant = 270
        }else if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.StackViewBottom.constant = 710
        }
        else{
            // self.StackViewBottom.constant = 15
            self.detailsView.isHidden = true
        }
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "details") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.doctorImageView.contentMode = .scaleAspectFill
        self.doctorImageView.cornerViewRadius()
        self.doctorNameLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.bookingDateTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_date")
        self.bookingDateLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bookingReasonTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_reason")
        self.bookingReasonLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.bookingTimeTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "booking_time")
        self.bookingTimeLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "accept")
        self.prescriptionButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .right, title: "prescription")
        self.acceptButton.cornerMiniumRadius()
        self.acceptButton.backgroundColor = UIColor(named: "AppColor")
        self.declineButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "decline")
        self.declineButton.cornerMiniumRadius()
        self.declineButton.backgroundColor = UIColor(named: "BorderColor")
        self.videoVisitButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "video_visit")
        self.videoVisitButton.cornerMiniumRadius()
        self.videoVisitButton.backgroundColor = UIColor(named: "AppColor")
        self.videoVisitButton.isHidden = true
        self.priceTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "fees")
        self.priceLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.siteTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "sitecharges")
        self.siteLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.taxTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "new_tax")
        self.taxLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.totalTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "total")
        self.totalLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.paymentStatusTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "res_time")
        self.paymentStatusLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            self.doctorNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
            self.doctorNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorEmailTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "email")
            self.doctorEmailLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorgenderTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "patient_gender")
            self.doctorgenderLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorQualificationTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "qualification")
            self.doctorQualificationLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctorMobileTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "mobile_no")
            self.doctorMobileLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
            self.doctordetailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "doctor_details")
            self.patientdeailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "patient_details")
        }else{
            self.StackViewBottom.constant = 15
        }
        self.patientNameTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "name")
        self.patientdeailsLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "patient_details")
        self.patientNameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientAgeTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "age")
        self.patientAgeLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientgenderTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "patient_gender")
        self.patientgenderLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientweightTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "weight")
        self.patientweightLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        self.patientillnessTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "issue_complaint")
        self.patientillnessLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .right, text: "")
        //        self.loadUserData()
                self.loadData()
    }
    func loadData() {
        print("DOCTORID:\((self.bookingResultModel?.doctorId ?? ""))")
        //        Utility.shared.startAnimation(viewController: self)
        self.viewModel.viewBookingDetails(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: "digitalclinic", booking_id: self.booking_id, booking_schedule: "new", onSuccess: { (success) in
            if self.viewModel.historyModel?.result.count ?? 0 > 0 {
                self.bookingResultModel = self.viewModel.historyModel?.result.first
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
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadUserData() {
        if self.bookingResultModel != nil {
            Utility.shared.stopAnimation(viewController: self)
            if (UserDefaultModule.shared.getLoginData().type ?? "") == "user" {
                self.doctorNameLabel.text = "Dr.\(bookingResultModel?.userName ?? "")"
            }
            else {
                self.doctorNameLabel.text = bookingResultModel?.userName ?? ""
            }
            
            self.locationLabel.text = bookingResultModel?.location ?? ""

            self.doctorImageView.sd_setImage(with: URL(string: (bookingResultModel?.userImage ?? "")), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
            let bookingDate = Date(timeIntervalSince1970: Double(self.bookingResultModel?.bookingDate ?? 0))
            self.bookingDateLabel.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\((self.bookingResultModel?.bookingDate ?? 0))", dateFormat: "MMM dd,yyyy"))
            self.bookingTimeLabel.text = bookingResultModel?.time ?? ""
            let reason: [String] = bookingResultModel?.bookingReason.map({$0.name}) ?? [String]()
            self.bookingReasonLabel.text = reason.joined(separator: ", ")
            self.priceLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.consultFees ?? "0")"
            self.siteLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.sitefees ?? "")"
            self.taxLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.tax ?? "")"
            self.totalLabel.text = "\(bookingResultModel?.currency ?? "")\(bookingResultModel?.grandTotal ?? "0")"
            
            let timeZone = TimeZone(identifier: (bookingResultModel?.timezone ?? "0")) ?? TimeZone.current
            let calendar = Calendar.current
//            calendar.timeZone = timeZone

                self.declineButton.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, title: "cancel")
            if (bookingResultModel?.type ?? "") == "current" {
                self.acceptButton.isHidden = true
                self.declineButton.isHidden = false
                
                if (bookingResultModel?.status.lowercased() ?? "") == "accepted" {
                    if (bookingResultModel?.paytoken ?? "") == "" && bookingResultModel?.bookingType.lowercased() == "request" {
                        self.declineButton.isHidden = false
                        self.videoVisitButton.isHidden = true
                    }
                    else {
                        if (bookingResultModel?.slotBookingtype.lowercased() ?? "") == "videovisit" {
                            self.videoVisitButton.alpha = 0.5
                            self.videoVisitButton.isHidden = false
                            let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
                            if (toArray.count) > 1 {
                                var mins = (Int(toArray.last ?? "0") ?? 0)
                                var hours = (Int(toArray.first ?? "0") ?? 0)

                                if mins < 5 {
                                    mins = 60-mins
                                }
                                else {
                                    mins = mins-5
                                }

                                if mins == 60 {
                                    mins = 55
                                    if hours == 0 {
                                        hours = 23
                                    }
                                    else {
                                        hours = hours-1
                                    }
                                }
                                
                                if let toDate = calendar.date(bySettingHour: hours, minute: mins, second: 0, of: bookingDate) {
                                }
                            }
                        }
                        self.declineButton.isHidden = false
                    }
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "cancelled" || (bookingResultModel?.status.lowercased() ?? "") == "refunded"{
                    self.declineButton.isHidden = true
                    self.videoVisitButton.isHidden = true
                }
                else if (bookingResultModel?.status.lowercased() ?? "") == "declined" {
                    self.videoVisitButton.isHidden = true
                    self.declineButton.isHidden = true
                }
                else  {
                    self.videoVisitButton.isHidden = true
                    
                        self.acceptButton.isHidden = false
                        self.declineButton.isHidden = false
                }
            }
            else {
                self.acceptButton.isHidden = true
                self.declineButton.isHidden = true
            }
            // Check if current date in reached check in date
            let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
            if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
            }
            self.prescriptionButton.isHidden = true
            if (bookingResultModel?.status.lowercased() ?? "") == "accepted" || (bookingResultModel?.status.lowercased() ?? "") == "completed" || (bookingResultModel?.status.lowercased() ?? "") == "paid"{
                if (bookingResultModel?.paytoken ?? "") == "" && bookingResultModel?.bookingType.lowercased() == "request" {
                    self.prescriptionButton.isHidden = true
                }
                else {
                    let toArray = (bookingResultModel?.time ?? "").components(separatedBy: ":")
                    var hours = (Int(toArray.first ?? "0") ?? 0)
                    var mins = (Int(toArray.last ?? "0") ?? 0)
                    if mins < 5 {
                        mins = 60-mins
                    }
                    else {
                        mins = mins-5
                    }
                    if mins == 60 {
                        mins = 55
                        if hours == 0 {
                            hours = 23
                        }
                        else {
                            hours = hours-1
                        }
                    }
                    if let toDate = calendar.date(bySettingHour: hours, minute: mins, second: 0, of: bookingDate) {
                        }
                    }
                }
            }
        }
    
    
    @IBAction func confrimBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
    }

}
