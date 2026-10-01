//
//  DigitalClinicSignupViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 07/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit
import FirebaseUI
import PhoneNumberKit
import ValidationComponents
import AVFoundation
import ConnectyCube
import ConnectyCubeCalls

class DigitalClinicSignupViewController: UIViewController, FUIAuthDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var phoneNumbertextField: UITextField!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var welcomeUserLbl: UILabel!
    @IBOutlet weak var signUpLbl: UILabel!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var alreadyAccLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var mobileLoginButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var plusimage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var profileimageLbl: UILabel!
    @IBOutlet weak var addressShadowView: UIView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var userLbl1: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var maleTextButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleTextButton: UIButton!
    @IBOutlet weak var plusicon: UIImageView!
    
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var termsLbl: UILabel!
    
    // FUIMobileNumber Login
    let authUI = FUIAuth.defaultAuthUI()
    var isLogin = false
    let child = SpinnerViewController()
    var predicate = EmailValidationPredicate()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var image = String()
    var signUpType = String()
    let language : NSDictionary = Utility().language()
    var imagePicker = UIImagePickerController()
    var viewModel = AuthenticationViewModel()
    var dcResultdata = DCLoginResultModel()
    var DcDetailDict = NSMutableDictionary()
    var dcModel: DCLoginModel?
    var currency_code = String()
    var isMale: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        addressTextView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        if let currencyCode = Locale.current.currencyCode {
//            self.currency_code = currencyCode
//            print("Currency code of current",currencyCode)
//        } else {
//            print("Currency code not found")
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func configUI(){
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
//        self.plusView.isHidden = false
        self.plusicon.isHidden = false
        self.welcomeUserLbl.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_user")
        self.addressTitleLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "enter_address")
        self.userLbl.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "digital")
        self.userLbl1.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "clinic")
        self.welcomeUserLbl.text = self.welcomeUserLbl.text?.replacingOccurrences(of: " ", with: "\n")
        self.signUpLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "dc_signup")
        self.descriptionLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "description")
        self.profileimageLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "profile")
        self.fullNameTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "full_name", Font: fontRegular16, setBorder: true)
        self.lastNameTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "lastname", Font: fontRegular16, setBorder: true)
        self.phoneNumbertextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "verifiy_phoneno", Font: fontRegular16, setBorder: true)

        self.emailTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "emailaddress", Font: fontRegular16, setBorder: true)
        self.passwordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "password", Font: fontRegular16, setBorder: true)
        self.confirmPasswordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "confirm_password", Font: fontRegular16, setBorder: true)
        self.signUpBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "sign_up")
        self.alreadyAccLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "already have an account")
        self.signInBtn.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .left, title: "sign_in")
        self.mobileLoginButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "login_with_mobile")
//        self.plusView.isHidden = false
//        self.plusView.backgroundColor = UIColor.white
//        self.plusimage.image = UIImage(named: "plus")
        self.profileImage.image = UIImage(named: "plus_sign")
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
        self.profileImage.isUserInteractionEnabled = true
//        self.plusimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
//        self.plusView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
        self.fullNameTxt.styleTextField()
        self.lastNameTxt.styleTextField()
        self.emailTxt.styleTextField()
        self.passwordTxt.styleTextField()
        self.confirmPasswordTxt.styleTextField()
        self.phoneNumbertextField.styleTextField()
        self.profileImage.styleTextField()
//        self.plusView.styleTextField()
        self.imagePicker.delegate = self
        // MARK: Addon Mobile Number Login
        self.mobileLoginButton.isHidden = true
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        self.authUI?.providers = providers
        self.authUI?.delegate = self
        let phoneGesture = UITapGestureRecognizer(target: self, action: #selector(self.privateDetailsViewGesture))
        self.phoneNumbertextField.addGestureRecognizer(phoneGesture)
        self.phoneNumbertextField.isHidden = false
        
        self.addressTextView.layer.cornerRadius = 5
        self.addressTextView.linkTextAttributes = [.underlineStyle: 0]
        self.addressTextView.isScrollEnabled = true
        self.addressShadowView.layer.cornerRadius = 5
        self.addressShadowView.clipsToBounds = false
        self.addressShadowView.layer.shadowOpacity = 0.3
        self.addressShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        maleButton.addTarget(self, action: #selector(maleBtnTapped), for: .touchUpInside)
        maleTextButton.addTarget(self, action: #selector(maleBtnTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleBtnTapped), for: .touchUpInside)
        femaleTextButton.addTarget(self, action: #selector(femaleBtnTapped), for: .touchUpInside)
        self.termsLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")

        let mainString = Utility.shared.language().value(forKey: "by continuing, agree our Terms of use & Privacy policy") ?? "by continuing, agree our Terms of use & Privacy policy"
        let subString = Utility.shared.language().value(forKey: "Privacy policy") ?? "Privacy policy"
        let range = (mainString as! NSString).range(of: subString as! String)
        let mutableAttributedString = NSMutableAttributedString(string: mainString as! String, attributes: [NSAttributedString.Key.font: regular14!])
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "AppColor")!, range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: fontSemi14!, range: range)
        let subString1 = Utility.shared.language().value(forKey: "Terms of use") as? String ?? "Terms of use"
        let range1 = (mainString as! NSString).range(of: subString1)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "AppColor")!, range: range1)
        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: fontSemi14!, range: range1)
        self.termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(termsLabelAct(gesture:))))
        self.termsLbl.isUserInteractionEnabled = true
        self.termsLbl.attributedText = mutableAttributedString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.addressTitleLbl.isHidden = true
        if text.containsEmoji{
            return false
        }
        
        if textView == addressTextView {
            let maxLength = 500
            let currentString: NSString = (textView.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        if self.predicate.evaluate(with: "\(self.emailTxt.text!)"){
            // self.view.endEditing(true)
            textField.resignFirstResponder()
            return true
        }else if(self.emailTxt.text == "" && self.passwordTxt.text == ""){
            //self.view.endEditing(true)
            return true
        }
        //         else if (textField == firstNameTxt  && textField == lastNameTxt){
        //       let inte: Int = Int(CInt(textField.text!)!)
        
        //            if inte < 30 && inte > 3 {
        //               return true
        //           }
        //        }
        else{
            textField.resignFirstResponder()
            return true
        }
    }
    
    @objc func privateDetailsViewGesture(_ sender: UITapGestureRecognizer? = nil) {
        if (sender?.view) != nil {
            isLogin = false
            phoneNumbertextField.resignFirstResponder()
            let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
            phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
        }
    }
    @IBAction func termsLabelAct(gesture: UITapGestureRecognizer) {
        let termsRange = (self.termsLbl.text! as NSString).range(of: (Utility.shared.language().value(forKey: "Terms of use") as? String ?? "Terms of use"))
        let policyRange = (self.termsLbl.text! as NSString).range(of: (Utility.shared.language().value(forKey: "Privacy policy") as? String ?? "Privacy policy"))
        let pageObj = TermsAndCoditionPage()
        if gesture.didTapAttributedTextInLabel(label: self.termsLbl, inRange: termsRange) {
            pageObj.titleString = getLanguage["terms"] ?? "terms"
            pageObj.termsString = (delegate.adminData?.result.termsConditions.mainContent ?? "") + (delegate.adminData?.result.termsConditions.subContent ?? "")
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if gesture.didTapAttributedTextInLabel(label: self.termsLbl, inRange: policyRange) {
            print("Working")
            pageObj.titleString = getLanguage["Privacy policy"] ?? "Privacy policy"

            pageObj.termsString = (self.delegate.adminData?.result.newprivacyPolicy.mainContent ?? "") + (self.delegate.adminData?.result.newprivacyPolicy .subContent ?? "")
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    @IBAction func termsButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            self.termsBtn.tag = 1
            self.termsBtn.setImage(UIImage(named: "CheckBox"), for: .normal)
        }
        else {
            self.termsBtn.tag = 0
            self.termsBtn.setImage(UIImage(named: "CheckBox_withoutTick"), for: .normal)
        }
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        self.passwordTxt.isSecureTextEntry = !self.passwordTxt.isSecureTextEntry
        sender.imageView?.tintColor = self.passwordTxt.isSecureTextEntry == true ? UIColor(named: "SubTitleColor") : UIColor(named: "AppColor")
    }
    
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        self.confirmPasswordTxt.isSecureTextEntry = !self.confirmPasswordTxt.isSecureTextEntry
        sender.imageView?.tintColor = self.confirmPasswordTxt.isSecureTextEntry == true ? UIColor(named: "SubTitleColor") : UIColor(named: "AppColor")
        
    }
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signupBtnTapped(_ sender: UIButton) {
        if ((fullNameTxt.text == "") || (addressTextView.text == "") || (emailTxt.text == "") ||
            (passwordTxt.text == "") || (confirmPasswordTxt.text == "")){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if  (self.fullNameTxt.text?.count ?? 0 > 30){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "first_name_err") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        /*
        else if  ((self.lastNameTxt.text?.count)! < 3 || (self.lastNameTxt.text?.count)! > 30){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "first_name_err") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        */
        else if self.isMale == nil {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "select_gender") as? String ?? "select_gender"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if !self.predicate.evaluate(with: "\(self.emailTxt.text!)") {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_error") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if passwordTxt.text?.count ?? 0 < 6 || passwordTxt.text?.count ?? 0 > 12 {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "createPasswordDesc") as? String ?? "createPasswordDesc"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if (!(passwordTxt.text == confirmPasswordTxt.text)){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "password_mismatch") as? String ?? "password_mismatch"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if (self.phoneNumbertextField.text == "") {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "please_choose_phone_number") as? String ?? "please_choose_phone_number"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if self.termsBtn.tag == 0 {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "Accept our terms & Conditions") as? String ?? "Accept our terms & Conditions"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
//        else if  ((self.addressTextView.text?.count)! < 5 || (self.addressTextView.text?.count)! > 500){
//            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "address_error") as? String ?? "address_error"), preferredStyle: .alert)
//            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
//            }
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//        }
        else{
            self.view.endEditing(true)
            self.createSpinnerView(self.child)
//            self.viewModel.SignUpData(first_name: self.firstNameTxt.text!, last_name: self.lastNameTxt.text!, email: self.emailTxt.text!, password: self.passwordTxt.text!, phoneNumber: self.phoneNumbertextField.text!, onSuccess: { (success) in
            self.viewModel.DcSignUpData(full_name: self.fullNameTxt.text!, last_name: self.lastNameTxt.text ?? "", email: self.emailTxt.text!, password: self.passwordTxt.text!, phoneNumber: self.phoneNumbertextField.text!, address: self.addressTextView.text!, profile_img: self.dcResultdata.userImage!,type:"digitalclinic",currency_code: self.currency_code, gender: self.isMale == true ? "male" : "female", onsuccess: { (response) in
                print(response)
                self.removeSpinnerView(self.child)
                self.dcModel = response
                let alert = UIAlertController(title: "SignUp", message: getLanguage[(self.dcModel!.message ?? "")] ?? ((self.dcModel!.message) ?? ""), preferredStyle: .alert)
                let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                    if self.dcModel!.status == true
                    {
//                        self.delegate.languageAndCurrency()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.setInitialViewController(initialView: DigitalClinicSigninViewController())
                    }else{
                    }
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }) { (failure) in
                self.removeSpinnerView(self.child)
            }
        }
    }
    
    
    @objc func uploadAct() {
        let actionSheet = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? "gallery"), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.plusicon.isHidden = true
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: (getLanguage["camera"] ?? "camera"), style: .default, handler: { (action) in
           if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
               //already authorized
               self.imagePicker.sourceType = .camera
               self.plusicon.isHidden = true
               self.navigationController?.present(self.imagePicker, animated: true, completion: nil)

//                self.moveToCamera()
           } else {
               AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                   if granted {
                       //access allowed
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = .camera
                        self.plusicon.isHidden = true
                        self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
                    }
                       //                        self.moveToCamera()
                   } else {
                       //access denied
                       DispatchQueue.main.async {
                           self.cameraPermissionAlert()
                       }
                   }
               })
           }
       }))
        self.plusicon.isHidden = false
        actionSheet.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.imagePicker.allowsEditing = false
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(actionSheet, animated: true, completion: nil)
    }
    func cameraPermissionAlert() {
        let alert = UIAlertController(
            title: "",
            message: Utility().language().value(forKey: "camera_permission") as? String ?? "",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: Utility().language().value(forKey: "cancel") as? String ?? "", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: Utility().language().value(forKey: "setting") as? String ?? "", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    @objc func maleBtnTapped(_ button: UIButton?) {
        isMale = true
        maleButton.setImage(UIImage(named: "radio_Sel"), for: .normal)
        maleTextButton.setTitleColor(UIColor(named: "AppColor") ?? .white, for: .normal)
        femaleButton.setImage(UIImage(named: "radio_UnSel"), for: .normal)
        femaleTextButton.setTitleColor(AppSecondaryColor, for: .normal)
    }
    @objc func femaleBtnTapped(_ button: UIButton?) {
        isMale = false
        femaleButton.setImage(UIImage(named: "radio_Sel"), for: .normal)
        femaleTextButton.setTitleColor(AppRed, for: .normal)
        maleButton.setImage(UIImage(named: "radio_UnSel.png"), for: .normal)
        maleTextButton.setTitleColor(AppSecondaryColor, for: .normal)
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            print(authDataResult?.user.phoneNumber ?? "")
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
                if self.isLogin {
                    self.createSpinnerView(self.child)
                    self.viewModel.MobileLogin(mobilenumber: "\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)", type: "user", currency_code: self.currency_code) { (success) in
                        self.removeSpinnerView(self.child)
                        if self.viewModel.loginModel?.status ?? false {
                            UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                            UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                            self.delegate.languageAndCurrency()
                            Utility.shared.registerPushServices()
                        }
                        else {
                            let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } onFailure: { (failure) in
                        self.removeSpinnerView(self.child)
                    }
                }
                else {
                    self.phoneNumbertextField.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
                    //MARK: Set Default Currency code using mobile number
                    self.getCurrencyCode(for: phoneNumbers.regionID ?? "")
                    print("CURRENCYCODE:\(self.getCurrencyCode(for: phoneNumbers.regionID ?? ""))")
                }
            }
            catch {
                print("Generic parser error")
            }
        }
        else {
        }
    }
    //MARK: Set Default currencycode using mobile number
    func getCurrencyCode(for regionID: String) {
        let locales = Locale.availableIdentifiers
        for identifier in locales {
            let locale = Locale(identifier: identifier)
            guard let countryCode = locale.regionCode else {
                continue
            }
            if countryCode == regionID {
                if let currencyCode = locale.currencyCode {
                    self.currency_code = currencyCode
                    print("Currency code for region ID \(regionID): \(currencyCode)")
                    return
                }
            }
        }
        print("Currency code not found for the region ID: \(regionID)")
    }
}
extension DigitalClinicSignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let fileUrl = info[.originalImage]  as? UIImage else { return }
        let fileData = (fileUrl.resized(toWidth: 960, isOpaque: true) ?? fileUrl).jpegData(compressionQuality: 0)! as Data
        let fileName = "profilepic.jpeg"
        self.createSpinnerView(self.child)
        ParsingFunction().uploadDoc(fileData: fileData, uploaddoctype: "jpeg", fileName: fileName, type: "users", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
            if imageModel.status {
                self.profileImage.image = fileUrl
                self.dcResultdata.userImage = imageModel.result.name
                self.removeSpinnerView(self.child)
            }
            else {
                self.removeSpinnerView(self.child)
                let alert = UIAlertController(title: nil, message: (getLanguage[imageModel.message] ?? imageModel.message), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        {
            (failure) in
            self.removeSpinnerView(self.child)
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        self.dismiss(animated: true, completion: nil)
    }
    
 
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
     }
}
extension DigitalClinicSignupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == getLanguage["enter_address"] ?? "enter_address" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = getLanguage["enter_address"] ?? "enter_address"
            textView.textColor = UIColor.lightGray
        }
    }
}
