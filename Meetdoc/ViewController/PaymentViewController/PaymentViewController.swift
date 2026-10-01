//
//  PaymentViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 26/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Stripe
import Razorpay

class PaymentViewController: UIViewController, RazorpayProtocol {
    @IBOutlet weak var payImageView: UIImageView!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var secureCodeTextField: UITextField!
    @IBOutlet weak var secureCodeLabel: UILabel!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var cardTextField: UITextField!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var siteFeeTitleLabel: UILabel!
    @IBOutlet weak var siteFeeLabel: UILabel!
    @IBOutlet weak var taxTitleLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    var stripeKey = ""
    var doctorData: DoctorResultModel?
    var illnessID = ""
    var slotTime = ""
    var slotEndTime = ""
    var bookingSlotModel: BookingSlotResultModel?
    var selectedDate: Int?
    var viewModel = DoctorViewModel()
    var viewModel1 = ProfileViewModel()
    var token = ""
    var bookingType = ""
    var doctor_id = ""
    var booking_id = ""
    var order_id = ""
    var slotBookingType = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromBooking = false
    var stripe_currency = ["BIF","CLP","DJF","GNF","JPY","KMF","KRW","MGA","PYG","RWF","UGX","VND","VUV","XAF","XOF","XPF"];
    var stripeModel = StripeDataModel()
    var razorpayModel = RazorpayDataModel()
    var paymentModel = paymentVerifyModel()
    var razorpay: RazorpayCheckout!
    var userProfileModel = UserLoginResultModel()
    var secret = ""
    var razorpayID = ""
    var paymentSignature = ""
    var name = String()
    var number = String()
    var email = String()
    var image = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.loadUserData()
        self.configUI()
        self.view.addSubview(indicatorView)
        STPAPIClient.shared.publishableKey = stripeKey
        razorpay = RazorpayCheckout.initWithKey(self.razorpayID, andDelegateWithData: self)
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["payment"] ?? "payment", fColor: "White", fontName: fontRegular16, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        
        self.cardNumberLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "card_number")
        self.cardTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "0000 0000 0000 0000", Font: fontRegular16, setBorder: true)
        self.expireDateLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "expiry_date")
        self.expireDateTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "MM/YY", Font: fontRegular16, setBorder: true)
        self.secureCodeLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "secure_code")
        self.secureCodeTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "CVV", Font: fontRegular16, setBorder: true)
        self.paymentButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "pay")
        self.paymentButton.cornerMiniumRadius()
        self.paymentButton.backgroundColor = UIColor(named: "AppColor")
        self.paymentButton.setTitle("\(getLanguage["pay"] ?? "") \(self.bookingSlotModel?.currency ?? "")\(self.bookingSlotModel?.grandTotal ?? "0")", for: .normal)

        self.priceTitleLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "fees")
        self.priceLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .right, text: "")
        self.priceLabel.text = "\(self.bookingSlotModel?.currency ?? "")\(self.bookingSlotModel?.consultFees ?? "0")"
        self.siteFeeTitleLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "sitecharges")
        self.siteFeeLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .right, text: "")
        self.siteFeeLabel.text = "\(self.bookingSlotModel?.currency ?? "")\(self.bookingSlotModel?.sitefees ?? "")"
        self.taxTitleLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "new_tax")
        self.taxTitleLabel.numberOfLines = 2;
        self.taxLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .right, text: "")
        self.taxLabel.text = "\(self.bookingSlotModel?.currency ?? "")\(self.bookingSlotModel?.tax ?? "")"
        self.totalTitleLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "total")
        self.totalLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .right, text: "")
        self.totalLabel.text = "\(self.bookingSlotModel?.currency ?? "")\(self.bookingSlotModel?.grandTotal ?? "0")"
//        self.shadowView.elevationEffect()
        self.loadData()
    }
    
    @IBAction func paymentAct(_ sender: UIButton) {
        //card parameters
        let paymentSheet: PaymentSheet?
        let currencyCode = (self.bookingSlotModel?.convertedcurrencycode ?? "")
        self.order_id = razorpayModel.order_id
        var desc = String(format: "%.2f", Double(self.bookingSlotModel?.grandTotal ?? "0") ?? 0)
        
        if stripe_currency.contains(currencyCode) {
            desc = String(format: "%.0f", Double(self.bookingSlotModel?.grandTotal ?? "0") ?? 0)
        }
        print("descdesc \(desc)")
        Utility.shared.startAnimation(viewController: self)
//        self.viewModel.getStripeDetails(amount: desc, currency: currencyCode, user_id: "\((UserDefaultModule().getCurrentUserID()!))") { (success) in
//            self.stripeModel = self.viewModel.stripeModel ?? StripeDataModel()
//            if success {
//                var configuration = PaymentSheet.Configuration()
//                configuration.merchantDisplayName = "Example, Inc."
//                configuration.customer = .init(id: self.stripeModel.customer, ephemeralKeySecret: self.stripeModel.ephemeralKey)
//                paymentSheet = PaymentSheet(paymentIntentClientSecret: self.stripeModel.paymentIntent, configuration: configuration)
//                DispatchQueue.main.async {
//                    paymentSheet?.present(from: self) { paymentResult in
//                        // MARK: Handle the payment result
//                        switch paymentResult {
//                        case .completed:
//                            print("Your order is confirmed")
//                            let token = self.stripeModel.paymentIntent.components(separatedBy: "_secret_")
//                            self.token = (token.first ?? "")
//                            self.payAct()
//                        case .canceled:
//                            print("Canceled!")
//                            Utility().stopAnimation(viewController: self)
//                        case .failed(let error):
//                            Utility().stopAnimation(viewController: self)
//                            print("Payment failed: \n\(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//            else {
//                let alert = UIAlertController(title: nil, message: Utility().language().value(forKey: "amount_too_small") as? String ?? "", preferredStyle: UIAlertController.Style.alert)
//                //settings
//                alert.addAction(UIAlertAction(title: Utility().language().value(forKey: "OK") as? String ?? "", style: .default, handler: { action in
//                    Utility().stopAnimation(viewController: self)
//                }))
//                self.navigationController?.present(alert, animated: true, completion: nil)
//            }
//        }onFailure: { (failure) in
//            Utility().stopAnimation(viewController: self)
//        }
        
        self.viewModel.createorderid(amount: desc, currency: currencyCode, booking_id: booking_id){ [self] (success) in
                self.razorpayModel = self.viewModel.razorpayModel ?? RazorpayDataModel()
                self.loadUserData()
                let options: [String:Any] = [
                              "amount" : desc,
                              "currency": currencyCode,
                              "order_id" : razorpayModel.order_id,
//                              "description": "payment description",
                              "description": "",
                              "name": self.name,
                              "image": self.image,
                              "prefill": [
                                "contact": self.number,
                                "email": self.email
                              ],
                              "theme": [
                                    "color": "#1aaaaf"
                                ]
                          ]
                Utility().stopAnimation(viewController: self)
        DispatchQueue.main.async { [self] in
                razorpay?.open(options)
            }
        } onFailure: { (failure) in
                        Utility().stopAnimation(viewController: self)
                   }
        
//        if self.cardTextField.text == "" {
//            self.view.makeToast(getLanguage["enter_card_number"] ?? "")
//        }
//        else if self.expireDateTextField.text == "" {
//            self.view.makeToast(getLanguage["Expiry_date_error"] ?? "")
//        }
//        else if (self.expireDateTextField.text?.count ?? 0) != 5 && !(self.expireDateTextField.text?.contains("/") ?? true){
//            self.view.makeToast(getLanguage["Expiry_date_error"] ?? "")
//        }
//        else if self.secureCodeTextField.text == "" {
//            self.view.makeToast(getLanguage["secure_code_error"] ?? "")
//        }
//        else {
//            STPAPIClient.shared().publishableKey = stripeKey
//            StripeAPI.defaultPublishableKey = stripeKey
//            let card = STPCardParams()
//            card.number = self.cardTextField.text!
//            let expiryParameters = expireDateTextField.text?.components(separatedBy: "/")
//            card.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
//            card.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
//            card.cvc = self.secureCodeTextField.text!
//            //converting into token
//            _ = STPAPIClient()
//            STPAPIClient.shared().createToken(withCard: card) { (token, error) in
//                if error == nil {
//                    print("\(token!)")
//                    self.token = token?.stripeID ?? ""
//                    self.payAct()
//                    
//                } else {
//                    let alert = UIAlertController(title: getLanguage["failed"] ?? "", message: error?.localizedDescription ?? "", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    print("Failed")
//                }
//            }
//        }
    }
    func loadData() {
        Utility.shared.startAnimation(viewController: self)
        self.viewModel1.loadProfileData(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            if success {
                self.loadUserData()
            }
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func loadUserData() {
        if let userData = self.viewModel1.userProfileModel?.result{
            self.name = userData.firstName + " \(userData.lastName ?? "")"
            self.number = userData.phoneNumber
            self.email = userData.email
            self.image = userData.userImage
            self.razorpayID = userData.razorpayID
            self.secret = userData.razorpaySecret
        }
    }
    func payAct() {
        if isFromBooking {
            self.viewModel.bookAppointment(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), doctor_id: "\(self.doctorData?.doctorId ?? "")", paytoken: token, illness_id: self.illnessID, date: selectedDate ?? 0, time: self.slotTime, slot_bookingtype: slotBookingType, booking_type: self.bookingType, currency: "\(self.bookingSlotModel?.currency ?? "")", grand_total: (self.bookingSlotModel?.grandTotal ?? "0"), endTime: slotEndTime,doctor_fees: "\(self.bookingSlotModel?.consultFees ?? "0")",tax: "\(self.bookingSlotModel?.tax ?? "0")",sitefees: "\(self.bookingSlotModel?.sitefees ?? "0")",price: (self.bookingSlotModel?.price ?? "0"),currencycode: (self.bookingSlotModel?.currencycode ?? ""),convertedcurrencycode: (self.bookingSlotModel?.convertedcurrencycode ?? ""), paymentprice: (self.bookingSlotModel?.paymentprice ?? ""), usercurrencyrate: "\(self.bookingSlotModel?.usercurrencyrate ?? "")",doctorcurrencyrate: "\(self.bookingSlotModel?.doctorcurrencyrate ?? "")", cancelpercentage: "\(self.bookingSlotModel?.cancelpercentage ?? "")",type: "", patient_name: "", patient_age: "", patient_gender: "", patient_weight: "", patient_illness: "", appointment: "new", dc_name: "", booking_id: "", patient_phone: "",patient_height: "",patient_bp: "",patient_bprs: "", onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                if success {
                    let pageObj = BookingStatusViewController()
                    pageObj.bookingType = "pay"
                    pageObj.requestType = self.slotBookingType
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
                else {
                    let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
        else {
            self.viewModel.paymentAct(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), doctor_id: self.doctor_id, paytoken: token, booking_id: booking_id, onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                    if success {
                        if UserDefaultModule.shared.getLoginData().type == "user"{
                            let pageObj = UserTabbarController()
                            pageObj.selectedIndex = 2
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                            let pageObj = DCTabbarViewController()
                            pageObj.selectedIndex = 2
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }else{
                            let pageObj = DoctorTabViewController()
                            pageObj.selectedIndex = 2
                            self.appDelegate.setInitialViewController(initialView: pageObj)
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
    }
    
    func verifypayment(payment_id: String, payment_signature: String){
        print("paid")
        Utility.shared.startAnimation(viewController: self)
        self.razorpayModel = self.viewModel.razorpayModel ?? RazorpayDataModel()
        self.viewModel.payment(booking_id: self.booking_id, order_id: razorpayModel.order_id, payment_id: payment_id, payment_signature: payment_signature, onSuccess: { (success) in
            if success{
                Utility.shared.stopAnimation(viewController: self)
//                let alert = UIAlertController(title: "Paid", message: "\(self.paymentModel.message ?? "")", preferredStyle: .alert)
                let alert = UIAlertController(title: "Paid", message: "Payment successfully", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: {(UIAlertAction) in
                    if UserDefaultModule.shared.getLoginData().type == "user"{
                        let pageObj = UserTabbarController()
                        pageObj.selectedIndex = 2
                        self.appDelegate.setInitialViewController(initialView: pageObj)
                    }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
                        let pageObj = DCTabbarViewController()
                        pageObj.selectedIndex = 2
                        self.appDelegate.setInitialViewController(initialView: pageObj)
                    }else{
                        let pageObj = DoctorTabViewController()
                        pageObj.selectedIndex = 2
                        self.appDelegate.setInitialViewController(initialView: pageObj)
                    }
                })
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
            }
        }, onFailure: {(error) in
            Utility.shared.stopAnimation(viewController: self)
            let alert = UIAlertController(title: "Error", message: ("Payment Error"), preferredStyle: .alert)
               let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alert.addAction(action)
               self.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func expireTextFieldEditingAct(_ sender: UITextField) {
        
    }
    
}
extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //no dots allowed
        if string == "." {
            return false
        }
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if textField == cardTextField {
                if updatedText.count > 16 {
                    return false
                }
            } else if textField == secureCodeTextField {
                
                if updatedText.count > 3 {
                    return false
                }
            } else if textField == expireDateTextField {
                if string != "" && !updatedText.contains("/"){
                    if (updatedText.count) == 2 {
                        textField.text = "\(updatedText)/"
                        return false
                    }
                    else if (updatedText.count) == 3 {
                        textField.text = "\(textField.text!)/\(string)"
                        return false
                    }
                 }
                if updatedText.count > 5 {
                    return false
                }
            }
        }
        return true
    }
}
extension PaymentViewController: RazorpayPaymentCompletionProtocolWithData{
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        Utility.shared.stopAnimation(viewController: self)
                       let alert = UIAlertController(title: "Error", message: "\(code)\n\(str)", preferredStyle: .alert)
                       let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        print("ERROR123:\(str)")
                       alert.addAction(action)
                       self.present(alert, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        Utility.shared.stopAnimation(viewController: self)
                    print("success: ", payment_id)
                    self.paymentSignature = response?["razorpay_signature"] as! String
                    self.token = payment_id
                    verifypayment(payment_id: payment_id, payment_signature: paymentSignature)
    }
    
    
}
