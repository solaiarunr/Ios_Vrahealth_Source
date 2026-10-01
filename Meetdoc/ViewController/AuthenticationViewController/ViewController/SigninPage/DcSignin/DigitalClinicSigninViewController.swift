//
//  DigitalClinicSigninViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 13/09/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit
import ValidationComponents
import AuthenticationServices
import SwiftyJSON
import PhoneNumberKit
import FirebaseUI
import ConnectyCube
import ConnectyCubeCalls

class DigitalClinicSigninViewController: UIViewController {
    
    
    
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var signInLbl: UILabel!
    @IBOutlet weak var signInLbl1: UILabel!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var dontHaveAccLbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var doctorSigninButton: UIButton!
    @IBOutlet weak var patientSigninButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var phoneNumberLogin: UIButton!
    
    @IBOutlet weak var signupBtnView: UIView!
    @IBOutlet weak var doctorSigninView: UIView!
    @IBOutlet weak var doctorSigninLbl1: UILabel!
    @IBOutlet weak var doctorSigninLbl2: UILabel!
    @IBOutlet weak var patientSigninView: UIView!
    @IBOutlet weak var patientSigninLbl1: UILabel!
    
    @IBOutlet weak var patientSigninLbl2: UILabel!
    var predicate = EmailValidationPredicate()
    let child = SpinnerViewController()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel = AuthenticationViewModel()
    var isFromList = false
    var currency_code = ""
    let authUI = FUIAuth.defaultAuthUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        self.doctorButton.config(color: UIColor(named: "AppColor"), font: fontsemi16, align: .right, title: "Doc_Sign")
        self.skipButton.config(color: UIColor(named: "AppColor"), font: fontsemi16, align: .right, title: "home")
        
        self.titleLbl.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_to_meetDoc")
        self.titleLbl.text = self.titleLbl.text?.replacingOccurrences(of: " ", with: "\n")
        if UserDefaultModule.shared.getAppLanguage().capitalized == "French" {
            self.titleLbl.numberOfLines = 2
        }
        self.signInLbl.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "digital")
        self.signInLbl1.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "clinic")
        self.emailTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "emailaddress", Font: fontRegular16, setBorder: true)
        self.passwordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "password", Font: fontRegular16, setBorder: true)
        self.forgotPasswordButton.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .right, title: "forgotpasswrd")
//        self.nextBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "sign_in")
        self.dontHaveAccLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "dont' have an account")
        self.signUpBtn.config(color: UIColor(named: "White"), font: fontsemi16, align: .left, title: "sign_up_Dc")
        self.phoneNumberLogin.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "login_with_mobile")
        self.doctorSigninLbl1.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, text: "new_doctor")
        self.doctorSigninLbl2.config(color: UIColor(named: "White"), font: fontRegular10, align: .center, text: "here")
        self.patientSigninLbl1.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, text: "new_user1")
        self.patientSigninLbl2.config(color: UIColor(named: "White"), font: fontRegular10, align: .center, text: "here")
        self.emailTxt.layer.borderColor = UIColor.clear.cgColor
        self.passwordTxt.layer.borderColor = UIColor.clear.cgColor
        self.emailTxt.styleTextField()
        self.passwordTxt.styleTextField()
    //    self.doctorSigninButton.cornerMiniumRadius()
        self.doctorSigninView.cornerViewMiniumRadius()
     //   self.patientSigninButton.cornerMiniumRadius()
        self.patientSigninView.cornerViewMiniumRadius()
        self.signupBtnView.cornerViewMiniumRadius()
        // MARK: Addon Mobile Number Login
        self.phoneNumberLogin.isHidden = false
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        self.authUI?.providers = providers
        self.authUI?.delegate = self
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // self.shadowView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 1 {
                let pageObj = ForgotPasswordPage()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func phoneNumberLoginTap(_ sender: Any) {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
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
    
    @IBAction func loginBtnTapped(_ sender: Any)
    {
            if ((emailTxt.text == "") || (passwordTxt.text == "")){
                let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
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
            else if passwordTxt.text?.count ?? 0 < 6 {
                let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "createPasswordDesc") as? String ?? "createPasswordDesc"), preferredStyle: .alert)
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
            else{
                self.view.endEditing(true)
                self.createSpinnerView(self.child)
                self.viewModel.loginData(email: self.emailTxt.text!, password: self.passwordTxt.text!, type: "digitalclinic", onSuccess: { (success) in
                    self.removeSpinnerView(self.child)
                    if self.viewModel.loginModel?.status ?? false {
                        if self.viewModel.loginModel?.result.type  == "digitalclinic"{
                            UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                            UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                            if self.viewModel.loginModel?.result.connecty_userId ?? "" != ""{
                            //connectycube
                            let connecty_userlogin = self.viewModel.loginModel?.result.connecty_userlogin ?? ""
                            let connecty_password = self.viewModel.loginModel?.result.connecty_password ?? ""
                            let connecty_userId = self.viewModel.loginModel?.result.connecty_userId ?? ""
                            let connecty_email = UserDefaultModule.shared.getLoginData().email ?? ""
        
                            UserDefaultModule.shared.setconnectyLogin(login: connecty_userlogin, password: connecty_password, Id: connecty_userId, email: connecty_email)
                                
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
                            }

                            self.delegate.languageAndCurrency()
                            Utility.shared.registerPushServices()
                        }
                        else if self.viewModel.loginModel?.result.type  == "doctor"{
                            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_already") as? String ?? "Enter valid Email"), preferredStyle: .alert)
                            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if self.viewModel.loginModel?.result.type  == "user"{
                            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_already") as? String ?? "Enter valid Email"), preferredStyle: .alert)
                            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else {
                        if self.viewModel.loginModel?.message  == "Please wait, Once admin approved the account you can login"{
                            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "admin_approve") as? String ?? "Enter valid Email"), preferredStyle: .alert)
                            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        else {
                            let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }) { (failure) in
                    self.removeSpinnerView(self.child)
                }
            }
        }
    
    @IBAction func skipButtonAct(_ sender: UIButton) {
        if isFromList {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            self.delegate.setInitialViewController(initialView: UserTabbarController())
        }
    }
    
    //MARK: Set Default currencycode using mobile number
    func getCurrencyCode(for regionID: String) -> String {
        let locales = Locale.availableIdentifiers
        for identifier in locales {
            let locale = Locale(identifier: identifier)
            guard let countryCode = locale.regionCode else {
                continue
            }
            if countryCode == regionID {
                if let currencyCode = locale.currencyCode {
                    print("Currency code for region ID \(regionID): \(currencyCode)")
                    return currencyCode
                }
            }
        }
        print("Currency code not found for the region ID: \(regionID)")
        return ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if ((emailTxt.text?.containsEmoji) != nil){
            return false
        }
        if self.predicate.evaluate(with: "\(self.emailTxt.text!)"){
            self.view.endEditing(true)
            textField.resignFirstResponder()
            return true
        }else if(self.emailTxt.text == "" && self.passwordTxt.text == ""){
            self.view.endEditing(true)
            return true
        }else{
            textField.resignFirstResponder()
            return true
        }
    }
    
    @IBAction func showBtnTapped(_ sender: UIButton) {
        self.passwordTxt.isSecureTextEntry = !self.passwordTxt.isSecureTextEntry
        sender.imageView?.tintColor = self.passwordTxt.isSecureTextEntry == true ? UIColor(named: "SubTitleColor") : UIColor(named: "AppColor")
    }
    @IBAction func forgotPasswordBtn(_ sender: UIButton) {
        let pageObj = ForgotPasswordPage()
        pageObj.isFromUserSignUp = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func doctorSignInBtn(_ sender: UIButton) {
        let pageObj = DoctorSignInPage()
      //  pageObj.isFromUserSignin = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func SignUpTapped(_ sender: UIButton) {
        let pageObj = DigitalClinicSignupViewController()
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func patientSigninTapped(_ sender: UIButton) {
        let pageObj = UserSigninViewController()
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
extension DigitalClinicSigninViewController: FUIAuthDelegate {
  func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
      print(error?.localizedDescription ?? "")
      if error == nil {
          print(authDataResult?.user.phoneNumber ?? "")
          let phoneNumberKit = PhoneNumberKit()
          do {
              let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
              //                 self.phoneNumberTextField.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
              self.createSpinnerView(self.child)
              self.currency_code = self.getCurrencyCode(for: phoneNumbers.regionID!)
              self.viewModel.MobileLogin(mobilenumber: "\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)", type: "digitalclinic", currency_code: self.currency_code) { (success) in
                  self.removeSpinnerView(self.child)
                  if self.viewModel.loginModel?.status ?? false {
                      if self.viewModel.loginModel?.result.type  == "digitalclinic"{
                          if self.viewModel.loginModel?.result.emailVerified  == true{
                              UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                              UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                              Utility.shared.registerPushServices()
                              if self.viewModel.loginModel?.result.connecty_userId ?? "" != ""{
                              //connectycube
                              let connecty_userlogin = self.viewModel.loginModel?.result.connecty_userlogin ?? ""
                              let connecty_password = self.viewModel.loginModel?.result.connecty_password ?? ""
                              let connecty_userId = self.viewModel.loginModel?.result.connecty_userId ?? ""
                              let connecty_email = UserDefaultModule.shared.getLoginData().email ?? ""
          
                              UserDefaultModule.shared.setconnectyLogin(login: connecty_userlogin, password: connecty_password, Id: connecty_userId, email: connecty_email)
                                  
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
                              }

                              self.delegate.languageAndCurrency()
                              self.delegate.setAppLanguage(DCTabbarViewController())
                          }
                          else if self.viewModel.loginModel?.result.emailVerified  == false{
                              let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_verify") as? String ?? "Please verify your Email address"), preferredStyle: .alert)
                              let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default) { (UIAlertAction) in
                              }
                              let action1 = UIAlertAction(title: getLanguage["verify_email"] ?? "verify_email", style: .default) { (UIAlertAction) in
                                  self.createSpinnerView(self.child)
                                  let viewModel = SettingViewModel()
                                  Utility.shared.startAnimation(viewController: self)
                                  viewModel.EmailVerification(user_id: (self.viewModel.loginModel?.result.userId ?? ""), onSuccess: { (success) in
                                      Utility.shared.stopAnimation(viewController: self)
                                      self.view.makeToast(getLanguage[(viewModel.settingData?.result ?? "")] ?? (viewModel.settingData?.result ?? ""))
                                      print(success)
                                      self.removeSpinnerView(self.child)
                                  }) { (failure) in
                                      self.removeSpinnerView(self.child)
                                      Utility.shared.stopAnimation(viewController: self)
                                      print(failure)
                                  }
                              }
                              alert.addAction(action)
                              alert.addAction(action1)
                              self.present(alert, animated: true, completion: nil)
                          }
                          else {
                              let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                              let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                              alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                              self.present(alertController, animated: true, completion: nil)
                          }
                      }
                      else if self.viewModel.loginModel?.result.type  == "user"{
                          let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_already") as? String ?? "Enter valid Email"), preferredStyle: .alert)
                          let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                          }
                          alert.addAction(action)
                          self.present(alert, animated: true, completion: nil)
                      }
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
          catch {
              print("Generic parser error")
          }
      }
      else {
      }
  }
  func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
      print(error?.localizedDescription ?? "")
  }
}
