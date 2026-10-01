 //
 //  SignInPage.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 18/06/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //

 import UIKit
 import ValidationComponents
 import FBSDKCoreKit
 import FacebookLogin
 import FacebookCore
 import GoogleSignIn
 import AuthenticationServices
 import SwiftyJSON
 import FirebaseUI
 import PhoneNumberKit
import ConnectyCube
import ConnectyCubeCalls


 class UserSigninViewController: UIViewController
{
     @IBOutlet weak var termsBtn: UIButton!
     @IBOutlet weak var termsLbl: UILabel!
     
     @IBOutlet weak var orLabel: UILabel!
     @IBOutlet weak var forgotPasswordButton: UIButton!
     @IBOutlet weak var doctorsigninButton: UIButton!
     @IBOutlet weak var digitalclinicsigninButton: UIButton!
     @IBOutlet weak var passwordTxt: UITextField!
     @IBOutlet weak var emailTxt: UITextField!
     //    @IBOutlet weak var nextBtn: UIButton!
     @IBOutlet weak var showBtn: UIButton!
     @IBOutlet weak var titleLbl: UILabel!
     @IBOutlet weak var signInLbl: UILabel!
     @IBOutlet weak var orLbl: UILabel!
     @IBOutlet weak var dontHaveAccLbl: UILabel!
     @IBOutlet weak var signUpBtn: UIButton!
     @IBOutlet weak var appleButton: UIButton!
     @IBOutlet weak var mobileLoginButton: UIButton!
     @IBOutlet weak var skipButton: UIButton!
     @IBOutlet weak var signupBtnView: UIView!
     @IBOutlet weak var digitalclinicsigninView: UIView!
     @IBOutlet weak var digitalclinicsigninLbl: UILabel!
     @IBOutlet weak var comehereLbl: UILabel!
     
     @IBOutlet weak var doctorsigninView: UIView!
     
     @IBOutlet weak var doctorsigninLbl: UILabel!
     @IBOutlet weak var comehereLbl1: UILabel!
     
     @IBOutlet weak var signupLbl1: UILabel!
     
     @IBOutlet weak var signupLbl2: UILabel!
     var predicate = EmailValidationPredicate()
     let child = SpinnerViewController()
     var delegate = UIApplication.shared.delegate as! AppDelegate
     var viewModel = AuthenticationViewModel()
     var currency_code = ""
     // FUIMobileNumber Login
     let authUI = FUIAuth.defaultAuthUI()
     var isFromList = false
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.configUI()
         
     }
     func configUI() {
         self.orLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .center, text: "or")
         // self.doctorButton.config(color: UIColor(named: "AppColor"), font: fontsemi16, align: .right, title: "Doc_Sign")
         self.doctorsigninButton.cornerMiniumRadius()
      //   self.digitalclinicsigninButton.cornerMiniumRadius()
         self.digitalclinicsigninView.cornerViewMiniumRadius()
         self.doctorsigninView.cornerViewMiniumRadius()
//         self.signupBtnView.cornerViewMiniumRadius()
         self.signupBtnView.cornerViewRadius()
         self.skipButton.config(color: UIColor(named: "AppColor"), font: fontsemi16, align: .right, title: "home")
         
         self.titleLbl.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_to_meetDoc")
         self.titleLbl.text = self.titleLbl.text?.replacingOccurrences(of: " ", with: "\n")
         if UserDefaultModule.shared.getAppLanguage().capitalized == "French" {
             self.titleLbl.numberOfLines = 2
         }
         self.mobileLoginButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "login_with_mobile")
         self.signInLbl.config(color: UIColor(named: "AppColor"), font: new_titleFont, align: .left, text: "new_user")
         self.digitalclinicsigninLbl.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, text: "new_dcname")
         self.comehereLbl.config(color: UIColor(named: "White"), font: fontRegular10, align: .center, text: "here")
         self.doctorsigninLbl.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, text: "new_doctor")
         self.comehereLbl1.config(color: UIColor(named: "White"), font: fontRegular10, align: .center, text: "here")
         self.signupLbl1.config(color: UIColor(named: "White"), font: fontRegular15, align: .center, text: "new_patient")
         self.signupLbl2.config(color: UIColor(named: "White"), font: fontRegular12, align: .center, text: "new_signup")
         self.emailTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "emailaddress", Font: fontRegular16, setBorder: true)
         self.passwordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "password", Font: fontRegular16, setBorder: true)
         self.forgotPasswordButton.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .right, title: "forgotpasswrd")
         //        self.nextBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "sign_in")
         self.dontHaveAccLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "dont' have an account")
//         self.signUpBtn.config(color: UIColor(named: "White"), font: fontsemi16, align: .left, title: "sign_up_user")
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
         self.emailTxt.styleTextField()
         self.passwordTxt.styleTextField()
         self.emailTxt.layer.borderColor = UIColor.clear.cgColor
         self.passwordTxt.layer.borderColor = UIColor.clear.cgColor
         //        self.emailTxt.styleTextField()
         //        self.passwordTxt.styleTextField()
         // MARK: Addon Mobile Number Login
         self.mobileLoginButton.isHidden = false
         let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
         ]
         self.authUI?.providers = providers
         self.authUI?.delegate = self
         self.termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(termsLabelAct(gesture:))))
               self.termsLbl.isUserInteractionEnabled = true
               self.termsLbl.attributedText = mutableAttributedString
     }
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         navigationController?.setNavigationBarHidden(true, animated: animated)
         if let currencyCode = Locale.current.currencyCode {
             self.currency_code = currencyCode
             print("Currency code of current",currencyCode)
         } else {
             print("Currency code not found")
         }
         // self.shadowView()
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         navigationController?.setNavigationBarHidden(false, animated: animated)
     }
     
     func getFBUserData() {
         if((AccessToken.current) != nil){
             self.createSpinnerView(self.child)
             print("enter into the getFBUserData function")
             
             GraphRequest(graphPath: "me", parameters: ["fields": "id,name,first_name,last_name,email,birthday,gender,location,hometown,about,likes,work,education,picture,photos"]).start(completionHandler: { (connection, result, error) -> Void in
                 if (error == nil), let result = result as? [String: Any], let _ = result["email"] as? String {
                     print("FaceBook Details \(result)")
                     let resJson = JSON(result)
                     if resJson["email"].stringValue == "" {
                         let message = getLanguage["email_not_found"] ?? "email_not_found"
                         let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                         alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                         self.present(alertController, animated: true, completion: nil)
                     }
                     else {
                         self.viewModel.SocialLogin(first_name: resJson["first_name"].stringValue, last_name: resJson["last_name"].stringValue, email: resJson["email"].stringValue, id: resJson["id"].stringValue, type: "facebook", gender: resJson["gender"].stringValue, language: UserDefaultModule().getAppLanguage(), image_url: resJson["picture","data","url"].stringValue, onSuccess: { (success) in
                             self.removeSpinnerView(self.child)
                             if self.viewModel.loginModel?.status ?? false {
                                 
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
                             else {
                                 let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                                 let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                 alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                                 self.present(alertController, animated: true, completion: nil)
                             }
                         }) { (failure) in
                             self.removeSpinnerView(self.child)
                         }
                     }
                 }
             })
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
     
     @IBAction func skipButtonAct(_ sender: UIButton) {
         if isFromList {
             self.dismiss(animated: true, completion: nil)
         }
         else {
             self.delegate.setInitialViewController(initialView: UserTabbarController())
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
             self.viewModel.loginData(email: self.emailTxt.text!, password: self.passwordTxt.text!, type: "user", onSuccess: { (success) in
                 self.removeSpinnerView(self.child)
                 if self.viewModel.loginModel?.status ?? false {
                     if self.viewModel.loginModel?.result.type  == "user"{
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
                 }
                 else {
                     if self.viewModel.loginModel?.message  == "Please wait, Once admin approved the account you can login"{
                         let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "email_already") as? String ?? "Enter valid Email"), preferredStyle: .alert)
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
     func getCurrencyCode1(for regionID: String) -> String {
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
      // pageObj.isFromUserSignin = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
     @IBAction func digitalclinicSignInBtn(_ sender: Any) {
         let pageObj = DigitalClinicSigninViewController()
         //pageObj.isFromList = true
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     
    @IBAction func fbLogin(_ sender: UIButton) {
        if let accessToken = AccessToken.current{
            print("accessToken: \(accessToken)")
            self.getFBUserData()
        }
        else{
            print("Empty")
            let completion = {(result:LoginResult) in
                print("result\(result)")
                switch result {
                case .success(let grantedPermissions, let declinedPermissions, let AccessToken):
                    print("grantedPermission: \(grantedPermissions), declinedPermission: \(declinedPermissions), AccessToken: \(AccessToken)")
                    print("check:\(declinedPermissions.description)")
                    if (declinedPermissions.contains("email"))
                    {
                        print("correct \(declinedPermissions.description)")
                        DispatchQueue.main.async {
                            let loginManager = LoginManager()
                            loginManager.logOut()
                        }
                    }else{
                        self.getFBUserData()
                    }
                default:
                    self.getFBUserData()
                }
            }
            let loginManagerobj = LoginManager()
            loginManagerobj.logIn(permissions: [.publicProfile, .email], viewController: self, completion: completion)
        }
    }
    @IBAction func mobileLoginButtonAct(_ sender: UIButton) {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    @IBAction func appleLoginButtonAct(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            
            authorizationController.delegate = self
            
            authorizationController.presentationContextProvider = self
            
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func googleLogin(_ sender: UIButton) {
        //        GIDSignIn.sharedInstance().delegate = self
        //        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        GIDSignIn.sharedInstance().signIn()
                let signInConfig = GIDConfiguration.init(clientID: GOOGLE_CLIENT_KEY)
                GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                    self.createSpinnerView(self.child)

                            guard error == nil else {
                                self.removeSpinnerView(self.child)
                                Utility.shared.stopAnimation(viewController: self)
                                return
                            }
                            guard let user = user else {
                                self.removeSpinnerView(self.child)
                                Utility.shared.stopAnimation(viewController: self)
                                return
                            }

                            if (error == nil)
                            {
                                self.viewModel.SocialLogin(first_name: user.profile?.givenName ?? "", last_name: user.profile?.familyName ?? "", email: user.profile?.email ?? "", id: user.userID ?? "", type: "google", gender: "", language: UserDefaultModule().getAppLanguage(), image_url: user.profile?.imageURL(withDimension: 100)?.absoluteString ?? "", onSuccess: { (success) in
                                    self.removeSpinnerView(self.child)
                                    if self.viewModel.loginModel?.status ?? false {
                                        let userModel = UserLoginResultModel(email: self.viewModel.loginModel?.result.email ?? "", emailVerified: true, firstName: self.viewModel.loginModel?.result.firstName ?? "", gender: self.viewModel.loginModel?.result.gender ?? "", lastName: self.viewModel.loginModel?.result.lastName ?? "",phoneNumber: "\(self.viewModel.loginModel?.result.phoneNumber ?? "")", phoneVerified: false, referalUrl: self.viewModel.loginModel?.result.referalUrl ?? "", type: "user", userId: self.viewModel.loginModel?.result.userId ?? "", userImage: self.viewModel.loginModel?.result.userImage ?? "", message: "", dateOfBirth: "", qualification: self.viewModel.loginModel?.result.qualification ?? "")
                                        UserDefaultModule.shared.setUserLoginData(userModel)
//                                        UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                                        UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                                        self.delegate.languageAndCurrency()
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
                                    }
                                    else {
                                       let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                                       let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                       alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                                       self.present(alertController, animated: true, completion: nil)
                                   }
                                }) { (failure) in
                                    self.removeSpinnerView(self.child)
                                }
                            }else{
                               self.removeSpinnerView(self.child)
                                print(error?.localizedDescription ?? "")
                            }

                            // If sign in succeeded, display the app's main content View.
                        }

            }
    @IBAction func SignUpTapped(_ sender: UIButton) {
        let pageObj = UserSignupViewController()
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
 }
// extension UserSigninViewController: GIDSignInDelegate {
//     func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        self.createSpinnerView(self.child)
//         if (error == nil)
//         {
//            self.viewModel.SocialLogin(first_name: user.profile.givenName ?? "", last_name: user.profile.familyName ?? "", email: user.profile.email ?? "", id: user.userID ?? "", type: "google", gender: "", language: UserDefaultModule().getAppLanguage(), image_url: user.profile.imageURL(withDimension: 100)?.absoluteString ?? "", onSuccess: { (success) in
//                 self.removeSpinnerView(self.child)
//                 if self.viewModel.loginModel?.status ?? false {
//                     UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
//                     UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
//                     self.delegate.languageAndCurrency()
//                     Utility.shared.registerPushServices()
//                 }
//                 else {
//                    let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
//                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
//                    self.present(alertController, animated: true, completion: nil)
//                }
//             }) { (failure) in
//                 self.removeSpinnerView(self.child)
//             }
//         }else{
//            self.removeSpinnerView(self.child)
//             print(error.localizedDescription)
//         }
//     }
//
// }
 extension UserSigninViewController: UITextFieldDelegate {
     
 }
 @available(iOS 13.0, *)
 extension UserSigninViewController: ASAuthorizationControllerDelegate {

      // ASAuthorizationControllerDelegate function for authorization failed
     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

         print(error.localizedDescription)

     }

        // ASAuthorizationControllerDelegate function for successful authorization

     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
         
         if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
             
             // Create an account as per your requirement
             
             let appleId = appleIDCredential.user
             let appleUserEmail = appleIDCredential.email
             var userData = UserDefaultModule.shared.getAppleLoginData()
             if appleUserEmail != "" && appleUserEmail != nil{
                 userData.email = appleUserEmail ?? ""
                 userData.first_name = appleIDCredential.fullName?.givenName ?? ""
                 userData.last_name = appleIDCredential.fullName?.familyName ?? ""
                 userData.user_id = appleId
                UserDefaultModule.shared.setAppleLogin(fName: userData.first_name, lName: userData.last_name, Id: userData.user_id, email: userData.email)
             }
             else {
                 userData.user_id = appleId
             }
            self.createSpinnerView(self.child)
            self.viewModel.SocialLogin(first_name: userData.first_name, last_name: userData.last_name, email: userData.email, id: userData.user_id , type: "apple", gender: "", language: UserDefaultModule().getAppLanguage(), image_url: "", onSuccess: { (success) in
                 self.removeSpinnerView(self.child)
                 if self.viewModel.loginModel?.status ?? false {
                     let userModel = UserLoginResultModel(email: self.viewModel.loginModel?.result.email ?? "", emailVerified: true, firstName: self.viewModel.loginModel?.result.firstName ?? "", gender: self.viewModel.loginModel?.result.gender ?? "", lastName: self.viewModel.loginModel?.result.lastName ?? "",phoneNumber: "\(self.viewModel.loginModel?.result.phoneNumber ?? "")", phoneVerified: false, referalUrl: self.viewModel.loginModel?.result.referalUrl ?? "", type: "user", userId: self.viewModel.loginModel?.result.userId ?? "", userImage: self.viewModel.loginModel?.result.userImage ?? "", message: "", dateOfBirth: "", qualification: self.viewModel.loginModel?.result.qualification ?? "")
                     UserDefaultModule.shared.setUserLoginData(userModel)
//                     UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                     UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                     self.delegate.languageAndCurrency()
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
                     

                 }
                 else {
                    let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
             }) { (failure) in
                 self.removeSpinnerView(self.child)
             }
         }
         else if let passwordCredential = authorization.credential as? ASPasswordCredential {
             
             let appleUsername = passwordCredential.user
             print(appleUsername)
             
             let applePassword = passwordCredential.password
             print(applePassword)
             //Write your code
         }
         
     }

 }

 @available(iOS 13.0, *)
 extension UserSigninViewController: ASAuthorizationControllerPresentationContextProviding {

     //For present window

     func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
         return self.view.window!
     }

 }
 extension UserSigninViewController: FUIAuthDelegate {
     func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
         print(error?.localizedDescription ?? "")
         if error == nil {
             print(authDataResult?.user.phoneNumber ?? "")
             let phoneNumberKit = PhoneNumberKit()
             do {
                 let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
                self.createSpinnerView(self.child)
                 self.currency_code = self.getCurrencyCode1(for: phoneNumbers.regionID!)
//                 self.phoneNumberTextField.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
                 self.viewModel.MobileLogin(mobilenumber: "\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)", type: "user", currency_code: self.currency_code) { (success) in
                    self.removeSpinnerView(self.child)
                    if self.viewModel.loginModel?.status ?? false {
                        UserDefaultModule.shared.setUserLoginData(self.viewModel.loginModel?.result)
                        UserDefaults.standard.set("\(self.viewModel.loginModel?.result.userId ?? "0")", forKey: "user_id")
                        self.delegate.languageAndCurrency()
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
             catch let error as NSError {
                print(error)
            }
         }
         else {
         }
     }
     func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {
         print(error?.localizedDescription ?? "")
     }
 }
