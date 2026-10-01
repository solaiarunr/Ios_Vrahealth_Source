//
//  DetailsfillViewController.swift
//  Meetdoc
//
//  Created by HTS-MAC on 23/05/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
protocol BookingStatusDelegate {
    func responsesuccess()
}

class DetailsfillViewController: UIViewController {
    
    
    @IBOutlet weak var femalebtnname: UIButton!
    @IBOutlet weak var malebtnname: UIButton!
    @IBOutlet weak var malebtn: UIButton!
    
    @IBOutlet weak var femalebtn: UIButton!
    @IBOutlet weak var backwholeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var bookBtnView: UIView!
    @IBOutlet weak var closeBtnView: UIView!
    @IBOutlet weak var nameStackview: UIStackView!
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var sickStackView: UIStackView!
    @IBOutlet weak var nameTittleLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTittleLbl: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTittleLbl: UILabel!
//    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTittleLbl: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sickTittleLbl: UILabel!
    @IBOutlet weak var sickTextView: UITextView!
    @IBOutlet weak var mobileStackView: UIStackView!
    @IBOutlet weak var mobileTittleLbl: UILabel!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var heightTittleLbl: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var grpsStackView: UIStackView!
    @IBOutlet weak var grpsTittlelbl: UILabel!
    @IBOutlet weak var grpsTextField: UITextField!
    @IBOutlet weak var bpStackView: UIStackView!
    @IBOutlet weak var bpTittleLbl: UILabel!
    @IBOutlet weak var bpTextField: UITextField!
    
    @IBOutlet weak var nameTextFieldView: UIView!
    @IBOutlet weak var ageTextFieldView: UIView!
    @IBOutlet weak var weightTextFieldView: UIView!
    @IBOutlet weak var heightTextFieldView: UIView!
    @IBOutlet weak var grpTextFieldView: UIView!
    @IBOutlet weak var bpTextFieldView: UIView!
    @IBOutlet weak var mobileTextFieldView: UIView!
    
    @IBOutlet weak var MainStackView: UIView!
    
    var doctorData: DoctorResultModel?
    var illnessID =  [String]()
    var selectedDate: Int?
    var booking_type = ""
    var viewModel = DoctorViewModel()
    var selectedSlot: BookingSlotSubModel?
    var sendType = String()
    var bookingID = String()
    var doctor_id = String()
    var doctoravailable = String()
    var currency = String()
    var grand_total = String()
    var doctor_fees = String()
    var tax = String()
    var sitefees = String()
    var price = String()
    var currencycode = String()
    var convertedcurrencycode = String()
    var paymentprice = String()
    var usercurrencyrate = String()
    var doctorcurrencyrate = String()
    var cancelpercentage = String()
    var docbookType = String()
    var time = String()
    var endTime = String()
    var delegate : BookingStatusDelegate?
    
    
    @IBOutlet weak var sickview: UIView!
    
    @IBOutlet weak var genderview: UIView!
    var genders = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.hideView.isHidden = true
        print("viewmodel check",viewModel)
        
        
        if UserDefaultModule.shared.getAppTheme() == "dark"{
            self.mainView.backgroundColor = .black
            self.backwholeView.backgroundColor = .black.withAlphaComponent(0.90)
            self.genderview.backgroundColor = .clear
            self.nameTextField.textColor = .white
            self.ageTextField.textColor = .white
            self.sickTextView.backgroundColor = .gray.withAlphaComponent(0.2)
//            self.sickview.backgroundColor = .black
            self.sickTextView.textColor = .white
            self.nameTextFieldView.styleTextField()
            self.ageTextFieldView.styleTextField()
            self.weightTextFieldView.styleTextField()
            self.sickview.styleTextField()
            self.heightTextFieldView.styleTextField()
            self.grpTextFieldView.styleTextField()
            self.bpTextFieldView.styleTextField()
            self.mobileTextFieldView.styleTextField()
            
        }else{
         //   self.nameTextField.styleTextField()
            self.nameTextFieldView.styleTextField()
         //   self.ageTextField.styleTextField()
            self.ageTextFieldView.styleTextField()
         //   self.weightTextField.styleTextField()
            self.weightTextFieldView.styleTextField()
    //        self.genderTextField.styleTextField()
        //   self.sickTextView.styleTextField()
            self.sickview.styleTextField()
//            self.weightTextField.styleTextField()
//            self.heightTextField.styleTextField()
            self.heightTextFieldView.styleTextField()
//            self.grpsTextField.styleTextField()
            self.grpTextFieldView.styleTextField()
            self.bpTextFieldView.styleTextField()
            self.mobileTextFieldView.styleTextField()
//            self.bpTextField.styleTextField()
//            self.mobileTextField.styleTextField()
            self.mainView.backgroundColor = .white
        }
        // Do any additional setup after loading the view.
    }
    func configUI(){
        self.backwholeView.backgroundColor = .black.withAlphaComponent(0.6)
        
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            self.mainViewHeight.constant = 900
        }else{
            self.mainViewHeight.constant = 800
            self.mobileStackView.isHidden = true
        }
//        if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
//            self.nameTextField.text = UserDefaultModule.shared.getLoginData().firstName
//        }
        //self.componentTitleLabel.halfTextColorChange(fullText: Utility().language().value(forKey: "component_name") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
     //   self.nameTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "patient_name")
        self.nameTittleLbl.halfTextColorChange(fullText: Utility().language().value(forKey: "patient_name") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.nameTittleLbl.font = fontSemi14
        self.ageTittleLbl.halfTextColorChange(fullText: Utility().language().value(forKey: "detailsfill_age") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.ageTittleLbl.font = fontSemi14
        self.genderTittleLbl.halfTextColorChange(fullText: Utility().language().value(forKey: "patient_gender") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.genderTittleLbl.font = fontSemi14
        self.mobileTittleLbl.halfTextColorChange(fullText: Utility().language().value(forKey: "mobile_no") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.mobileTittleLbl.font = fontSemi14
        
   //     self.ageTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "detailsfill_age")
   //     self.genderTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "patient_gender")
        self.weightTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "detailsfill_Weight")
        self.heightTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "detailsfill_Height")
        self.bpTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "detailsfill_BP")
        self.grpsTittlelbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "detailsfill_GRBS")
        self.sickTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "issue_complaint")
        self.headingLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .center, text: "patient_details")
  //      self.mobileTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "mobile_no")
    }
    override func viewDidLayoutSubviews() {
        self.mainView.cornerViewMiniumRadius()
        self.closeBtnView.cornerViewRadius()
        self.bookBtnView.cornerViewMiniumRadius()
        self.MainStackView.cornerViewMaxRadius()
    }
    
    
    
    @IBAction func malecheck(_ sender: Any) {
        
        self.genders = "male"
        malebtnname.titleLabel?.textColor = UIColor(named: "primary")
        self.malebtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.femalebtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
       femalebtnname.titleLabel?.textColor = .gray
}
    
    
    
    
    @IBAction func femalecheck(_ sender: Any) {
        self.genders = "female"
        self.femalebtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.malebtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        femalebtnname.titleLabel?.textColor = UIColor(named: "primary")
        malebtnname.titleLabel?.textColor = .gray
      
        
    }
    
    
    
    @IBAction func malebtnact(_ sender: Any) {
    }
    
    
    
    
    
    
    @IBAction func femalebtnact(_ sender: Any) {
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func bookBtnTapped(_ sender: Any) {
        print("Text:\(UserDefaultModule.shared.getLoginData().type)")
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            if self.ageTextField.text == "" || self.nameTextField.text == "" || self.mobileTextField.text == ""  || self.genders == ""{
                self.view.makeToast(getLanguage["fill_fields"] ?? "")
            }else{
                self.hideView.isHidden = false
                self.loaderView.startAnimating()
         //       if (self.viewModel.bookingSlotModel?.doctorStatus ?? false) {
                let timezoneOffset =  TimeZone.current.secondsFromGMT()
                let localDate = Int(Double(self.selectedDate ?? 0) + Double(timezoneOffset))
                    if (doctoravailable) == "request" {
                        self.viewModel.bookAppointment(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: "\(self.doctor_id)", paytoken: "", illness_id: Utility.shared.jsonString(from: illnessID), date: self.selectedDate ?? 0, time: self.time, slot_bookingtype: booking_type, booking_type: "\(self.docbookType)", currency: "\(self.currency)", grand_total: "\(self.grand_total)", endTime: self.endTime, doctor_fees: "\(self.doctor_fees)", tax: "\(self.tax)", sitefees: "\(self.sitefees)", price: "\(self.price)", currencycode: "\(self.currencycode)", convertedcurrencycode: "\(self.convertedcurrencycode)", paymentprice: "\(self.paymentprice)", usercurrencyrate: "\(self.usercurrencyrate)", doctorcurrencyrate: "\(self.doctorcurrencyrate)", cancelpercentage: "\(self.cancelpercentage)", type: UserDefaultModule.shared.getLoginData().type, patient_name: "\(self.nameTextField.text ?? "")", patient_age: "\(self.ageTextField.text ?? "")", patient_gender: "\(self.genders)", patient_weight: "\(self.weightTextField.text ?? "")", patient_illness: "\(self.sickTextView.text ?? "")", appointment: "new", dc_name: UserDefaultModule.shared.getLoginData().firstName,booking_id: "", patient_phone: "\(self.mobileTextField.text ?? "")",patient_height: "\(self.heightTextField.text ?? "")",patient_bp: "\(self.bpTextField.text ?? "")",patient_bprs: "\(grpsTextField.text ?? "")",onSuccess: { (success) in
                        if success {
                            let date = Date()
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            let minutes = calendar.component(.minute, from: date)
                            UserDefaults.standard.set(minutes, forKey: "currentmin")
                            UserDefaults.standard.set(hour, forKey: "currenthour")
                            let pageObj = BookingStatusViewController()
                            pageObj.bookingType = "request"
                            pageObj.requestType = self.booking_type
                            self.navigationController?.pushViewController(pageObj, animated: true)
                            self.dismiss(animated: true)
                            
                            self.delegate?.responsesuccess()
                        }
                        else {
                            let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.hideView.isHidden = true
                            self.loaderView.stopAnimating()
                        }
                    }) { (failure) in
                                                self.hideView.isHidden = true
                                                self.loaderView.stopAnimating()
                    }
                }else {
                                        self.hideView.isHidden = false
                                        self.loaderView.startAnimating()
                    let profileModel = ProfileViewModel()
                    profileModel.loadProfileData(userid: UserDefaultModule.shared.getLoginData().userId) { (success) in
                
                        if (profileModel.userProfileModel?.result.emailVerified ?? false) && (profileModel.userProfileModel?.result.phoneVerified ?? false) && (profileModel.userProfileModel?.status ?? false)
                        {
                            if self.sendType != "redoctor"{
                                let pageObj = PaymentViewController()
                                pageObj.isFromBooking = true
                                pageObj.doctorData = self.doctorData
                                pageObj.slotBookingType = self.booking_type
                                pageObj.illnessID = Utility.shared.jsonString(from: self.illnessID)
                                pageObj.bookingType = "\(self.doctorData?.bookingType ?? "")"
                                pageObj.slotTime = (self.selectedSlot?.startTime ?? "")
                                pageObj.slotEndTime = (self.selectedSlot?.endTime ?? "")
                                pageObj.selectedDate = self.selectedDate
                                pageObj.bookingSlotModel = self.viewModel.bookingSlotModel?.result
                                pageObj.stripeKey = self.viewModel.bookingSlotModel?.result.stripePublishkey ?? ""
                                self.dismiss(animated: true)
                                self.navigationController?.pushViewController(pageObj, animated: true)
                            }else{
                                let pageObj = RescheduleViewController()
                                self.navigationController?.pushViewController(pageObj, animated: true)
                                pageObj.type = "request"
                                pageObj.booking_id = self.bookingID
                            }
                        }
                        else {
                            let alert = UIAlertController(title: nil, message: getLanguage["Please verify your account by registered email id"] ?? "Please verify your account by registered email id", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.hideView.isHidden = true
                            self.loaderView.stopAnimating()
                        }
                    } onFailure: { (failure) in
                        self.hideView.isHidden = false
                        self.loaderView.startAnimating()
                    }
                }
            }
        }else{
            if self.ageTextField.text == "" || self.nameTextField.text == "" || self.genders == ""{
                self.view.makeToast(getLanguage["fill_fields"] ?? "")
                
            }else {
                self.hideView.isHidden = false
                let timezoneOffset =  TimeZone.current.secondsFromGMT()
                let localDate = Int(Double(self.selectedDate ?? 0) + Double(timezoneOffset))
                self.loaderView.startAnimating()
                if (doctoravailable) == "request" {
                    self.viewModel.bookAppointment(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: "\(self.doctor_id)", paytoken: "", illness_id: Utility.shared.jsonString(from: illnessID), date: self.selectedDate ?? 0, time: self.time, slot_bookingtype: booking_type, booking_type: "\(self.docbookType)", currency: "\(self.currency)", grand_total: "\(self.grand_total)", endTime: self.endTime, doctor_fees: "\(self.doctor_fees)", tax: "\(self.tax)", sitefees: "\(self.sitefees)", price: "\(self.price)", currencycode: "\(self.currencycode)", convertedcurrencycode: "\(self.convertedcurrencycode)", paymentprice: "\(self.paymentprice)", usercurrencyrate: "\(self.usercurrencyrate)", doctorcurrencyrate: "\(self.doctorcurrencyrate)", cancelpercentage: "\(self.cancelpercentage)", type: "user", patient_name: "\(self.nameTextField.text ?? "")", patient_age: "\(self.ageTextField.text ?? "")", patient_gender: "\(self.genders)", patient_weight: "\(self.weightTextField.text ?? "")", patient_illness: "\(self.sickTextView.text ?? "")", appointment: "new", dc_name: UserDefaultModule.shared.getLoginData().firstName,booking_id: "", patient_phone: "",patient_height: "\(self.heightTextField.text ?? "")",patient_bp: "\(self.bpTextField.text ?? "")",patient_bprs: "\(grpsTextField.text ?? "")",onSuccess: { (success) in
                    if success {
//                                let pageObj = BookingStatusViewController()
//                                pageObj.bookingType = "request"
//                                pageObj.requestType = self.booking_type
//                                self.navigationController?.pushViewController(pageObj, animated: true)
                        self.dismiss(animated: true)
                        
                        self.delegate?.responsesuccess()
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }) { (failure) in
                    //                        self.hideView.isHidden = true
                    //                        self.loaderView.stopAnimating()
                }
            }else {
                //                    self.hideView.isHidden = false
                //                    self.loaderView.startAnimating()
                let profileModel = ProfileViewModel()
                profileModel.loadProfileData(userid: UserDefaultModule.shared.getLoginData().userId) { (success) in
            
                    if (profileModel.userProfileModel?.result.emailVerified ?? false) && (profileModel.userProfileModel?.result.phoneVerified ?? false) && (profileModel.userProfileModel?.status ?? false)
                    {
                        if self.sendType != "redoctor"{
                            let pageObj = PaymentViewController()
                            pageObj.isFromBooking = true
                            pageObj.doctorData = self.doctorData
                            pageObj.slotBookingType = self.booking_type
                            pageObj.illnessID = Utility.shared.jsonString(from: self.illnessID)
                            pageObj.bookingType = "\(self.doctorData?.bookingType ?? "")"
                            pageObj.slotTime = (self.selectedSlot?.startTime ?? "")
                            pageObj.slotEndTime = (self.selectedSlot?.endTime ?? "")
                            pageObj.selectedDate = self.selectedDate
                            pageObj.bookingSlotModel = self.viewModel.bookingSlotModel?.result
                            pageObj.stripeKey = self.viewModel.bookingSlotModel?.result.stripePublishkey ?? ""
                            self.dismiss(animated: true)
                            self.navigationController?.pushViewController(pageObj, animated: true)
                        }else{
                            let pageObj = RescheduleViewController()
                            self.navigationController?.pushViewController(pageObj, animated: true)
                            pageObj.type = "request"
                            pageObj.booking_id = self.bookingID
                        }
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: getLanguage["Please verify your account by registered email id"] ?? "Please verify your account by registered email id", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                } onFailure: { (failure) in

                }
            }
            }
        }
        
    }
}

