 //
 //  DoctorSignUpPage.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 22/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import UIKit
 import ValidationComponents
 import FirebaseUI
 import PhoneNumberKit
 import AVFoundation
 import Alamofire
 
 class DoctorSignUpPage: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var profileTextField: UITextField!
    @IBOutlet weak var doctorProfileStackView: UIStackView!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var femaleTextBtn: UIButton!
    @IBOutlet weak var maleTextBtn: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var qualificationTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instituteTxt: UITextField!
     
     @IBOutlet weak var termsLbl: UILabel!
     @IBOutlet weak var termsBtn: UIButton!
     
     let language : NSDictionary = Utility().language()
    var predicate = EmailValidationPredicate()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    let child = SpinnerViewController()
    let authUI = FUIAuth.defaultAuthUI()
    var isMale: Bool!
    var userData = DoctorSignupModel()
    var viewModel = AuthenticationViewModel()
    var imagePicker = UIImagePickerController()
    var currency_code = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicatorView)
//        if let currencyCode = Locale.current.currencyCode {
//            self.currency_code = currencyCode
//            print("Currency code of current",currencyCode)
//        } else {
//            print("Currency code not found")
//        }
        self.configUI()
    }
    func configUI(){
        
        self.titleLabel.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_doctor")
        titleLabel.text = self.titleLabel.text?.replacingOccurrences(of: " ", with: "\n")
        self.profileTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "choose_profile_image", Font: fontRegular16, setBorder: true)
        
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
//        self.titleLabel.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_doctor")
        titleLabel.text = self.titleLabel.text?.replacingOccurrences(of: " ", with: "\n")
        self.signUpLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "sign_join")
        self.nameTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "full_name", Font: fontRegular16, setBorder: true)
        self.emailTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "emailaddress", Font: fontRegular16, setBorder: true)
        self.passwordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "password", Font: fontRegular16, setBorder: true)
        self.confirmPasswordTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "confirm_password", Font: fontRegular16, setBorder: true)
        self.qualificationTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "qualification", Font: fontRegular16, setBorder: true)
        self.instituteTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "Institute", Font: fontRegular16, setBorder: true)
        self.phoneNumberTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "phoneno", Font: fontRegular16, setBorder: true)
        self.continueBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "continue")
        self.maleTextBtn.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .center, title: "male")
        self.femaleTextBtn.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .center, title: "female")
        self.genderLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "gender")
        self.imagePicker.delegate = self
        let phoneGesture = UITapGestureRecognizer(target: self, action: #selector(self.privateDetailsViewGesture))
        self.phoneNumberTxt.addGestureRecognizer(phoneGesture)
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        self.authUI?.providers = providers
        self.authUI?.delegate = self
        self.view.endEditing(true)
        
        maleBtn.addTarget(self, action: #selector(maleBtnTapped), for: .touchUpInside)
        maleTextBtn.addTarget(self, action: #selector(maleBtnTapped), for: .touchUpInside)
        femaleBtn.addTarget(self, action: #selector(femaleBtnTapped), for: .touchUpInside)
        femaleTextBtn.addTarget(self, action: #selector(femaleBtnTapped), for: .touchUpInside)
        
        self.nameTxt.styleTextField()
        self.emailTxt.styleTextField()
        self.passwordTxt.styleTextField()
        self.confirmPasswordTxt.styleTextField()
        self.qualificationTxt.styleTextField()
        self.instituteTxt.styleTextField()
        self.phoneNumberTxt.styleTextField()
        self.profileView.styleTextField()
        self.profileTextField.styleTextField()
        self.profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
        self.uploadButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
        self.profileImageView.cornerViewMiniumRadius()
        self.profileImageView.contentMode = .scaleAspectFill
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
    @objc func uploadAct() {
        let actionSheet = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? "gallery"), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: (getLanguage["camera"] ?? ""), style: .default, handler: { (action) in
           if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
               //already authorized
               self.imagePicker.sourceType = .camera
               self.navigationController?.present(self.imagePicker, animated: true, completion: nil)

//                self.moveToCamera()
           } else {
               AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                   if granted {
                       //access allowed
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = .camera
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
        
        actionSheet.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.imagePicker.allowsEditing = false
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(actionSheet, animated: true, completion: nil)
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
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func maleBtnTapped(_ button: UIButton?) {
        isMale = true
        maleBtn.setImage(UIImage(named: "radio_Sel"), for: .normal)
        maleTextBtn.setTitleColor(UIColor(named: "AppColor") ?? .white, for: .normal)
        femaleBtn.setImage(UIImage(named: "radio_UnSel"), for: .normal)
        femaleTextBtn.setTitleColor(AppSecondaryColor, for: .normal)
    }
    @objc func femaleBtnTapped(_ button: UIButton?) {
        isMale = false
        femaleBtn.setImage(UIImage(named: "radio_Sel"), for: .normal)
        femaleTextBtn.setTitleColor(AppRed, for: .normal)
        maleBtn.setImage(UIImage(named: "radio_UnSel.png"), for: .normal)
        maleTextBtn.setTitleColor(AppSecondaryColor, for: .normal)
    }
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    @IBAction func passwordShownBtn(_ sender: UIButton) {
        self.passwordTxt.isSecureTextEntry = !self.passwordTxt.isSecureTextEntry
        sender.imageView?.tintColor = self.passwordTxt.isSecureTextEntry == true ? UIColor(named: "SubTitleColor") : UIColor(named: "AppColor")
    }
    @IBAction func confirmPassShowBtn(_ sender: UIButton) {
        self.confirmPasswordTxt.isSecureTextEntry = !(self.confirmPasswordTxt.isSecureTextEntry)
        sender.imageView?.tintColor = self.confirmPasswordTxt.isSecureTextEntry == true ? UIColor(named: "SubTitleColor") : UIColor(named: "AppColor")
    }
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
        
        if ((nameTxt.text == "") || (emailTxt.text == "") || (passwordTxt.text == "") ||
            (confirmPasswordTxt.text == "") || (qualificationTxt.text == "") || (instituteTxt.text == "") || (!(passwordTxt.text == confirmPasswordTxt.text))) || (self.phoneNumberTxt.text == "") || passwordTxt.text?.count ?? 0 < 6 || !self.predicate.evaluate(with: "\(self.emailTxt.text!)") || self.userData.userImage == ""{
            if (nameTxt.text == "") || (emailTxt.text == "") {
                alert.message = Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"
            }
            else if !self.predicate.evaluate(with: "\(self.emailTxt.text!)") {
                alert.message = Utility().language().value(forKey: "email_error") as? String ?? "email_error"
            }
            else if (passwordTxt.text == "") {
                alert.message = Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"
            }
            
            else if  (self.nameTxt.text?.count ?? 0 > 30){
                alert.message = Utility().language().value(forKey: "first_name_err") as? String ?? "first_name_err"
            }
            else if passwordTxt.text?.count ?? 0 < 6 || passwordTxt.text?.count ?? 0 > 12 {
                alert.message = Utility().language().value(forKey: "createPasswordDesc") as? String ?? "createPasswordDesc"
            }
            else if (!(passwordTxt.text == confirmPasswordTxt.text)){
                alert.message = Utility().language().value(forKey: "password_mismatch") as? String ?? "password_mismatch"
            }
            else if (qualificationTxt.text == ""){
                alert.message = Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"
            }
            else if  ((self.qualificationTxt.text?.count)! < 3 || (self.qualificationTxt.text?.count)! > 50){
                alert.message = Utility().language().value(forKey: "qualification_error") as? String ?? "qualification_error"
            }
            else if (instituteTxt.text == ""){
                alert.message = Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"
            }
            /*
            else if ((self.instituteTxt.text?.count)! < 3 || (self.instituteTxt.text?.count)! > 50){
                alert.message = Utility().language().value(forKey: "qualification_error") as? String ?? "qualification_error"
            }
            */
            else if (self.phoneNumberTxt.text == "") {
                alert.message = Utility().language().value(forKey: "please_choose_phone_number") as? String ?? "please_choose_phone_number"
            }
            
            else if self.isMale == nil {
                alert.message = Utility().language().value(forKey: "select_gender") as? String ?? "select_gender"
            }
            else if self.userData.userImage == "" {
                alert.message = Utility().language().value(forKey: "choose_profile_image") as? String ?? "choose_profile_image"
            }
            let action = UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if self.isMale == nil {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "select_gender") as? String ?? "select_gender"), preferredStyle: .alert)
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
            Utility.shared.startAnimation(viewController: self)
            let group = DispatchGroup()
            group.enter()
            var isValidEmail = false
            var isValidMobile = false
            var errorMessge = ""
            self.viewModel.emailValidate(inputvalue: self.emailTxt.text!, type: "email",currency_code: self.currency_code, onSuccess: { (success) in
                isValidEmail = self.viewModel.loginModel?.status ?? false
                errorMessge = !isValidEmail ? getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "") : errorMessge
                group.leave()
            }, onFailure: { (failure) in
                isValidEmail = true
                group.leave()
            })
            group.enter()
            self.viewModel.emailValidate(inputvalue: self.phoneNumberTxt.text!, type: "Phone number", currency_code: self.currency_code) { (success) in
                isValidMobile = self.viewModel.loginModel?.status ?? false
                errorMessge = !isValidMobile ? getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "") : errorMessge
                group.leave()
            } onFailure: { (failure) in
                isValidMobile = true
                group.leave()
            }
            
            group.notify(queue: .main) {
                Utility.shared.stopAnimation(viewController: self)
                if isValidMobile && isValidEmail {
                    let PageObj = CertificateSignUpPage()
                    self.userData.firstName = self.nameTxt.text!
                    self.userData.email = self.emailTxt.text!
                    self.userData.phoneNumber = self.phoneNumberTxt.text!
                    self.userData.gender = self.isMale == true ? "male" : "female"
                    self.userData.qualification = self.qualificationTxt.text!
                    self.userData.institute = self.instituteTxt.text!
                    self.userData.password = self.passwordTxt.text!
                    PageObj.userData = self.userData
                    PageObj.currency_code = self.currency_code
                    print("CURRENCYCODE1:\(self.currency_code)")
                    self.navigationController?.pushViewController(PageObj, animated: true)
                }
                else {
                    var message = errorMessge
                    if !isValidMobile && !isValidEmail {
                        message = getLanguage["email phone number already exist"] ?? "email phone number already exist"
                    }
                    else if !isValidMobile {
                        message = getLanguage["phone_number_already_exsist"] ?? "phone_number_already_exsist"
                    }
                    
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { [self] (UIAlertAction) in
                        if !isValidEmail {
                            self.emailTxt.text = ""
                        }
                        else {
                            self.phoneNumberTxt.text = ""
                        }
                    }
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }

        }
    }
    @objc func privateDetailsViewGesture(_ sender: UITapGestureRecognizer? = nil) {
        if (sender?.view) != nil {
            phoneNumberTxt.resignFirstResponder()
            let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
            phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        if textField == self.nameTxt{
            if textField.text?.count ?? 0 > 29 && string != ""{
                return false
            }else{
                return true
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        if self.predicate.evaluate(with: "\(self.emailTxt.text!)"){
            // self.view.endEditing(true)
            textField.resignFirstResponder()
            return true
        }
        else{
            textField.resignFirstResponder()
            return true
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
 extension DoctorSignUpPage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            print(authDataResult?.user.phoneNumber ?? "")
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
                self.phoneNumberTxt.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
                //MARK: Set Default Currency code using mobile number
                self.getCurrencyCode(for: phoneNumbers.regionID ?? "")
                print("CURRENCYCODE:\(self.currency_code)")
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
 extension DoctorSignUpPage: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func moveToCamera()   {
        self.imagePicker.allowsEditing = false
         self.imagePicker.modalPresentationStyle = .fullScreen
        self.imagePicker.sourceType = .camera
        self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        guard let fileUrl = info[.originalImage]  as? UIImage else { return }
        let fileData = (fileUrl.resized(toWidth: 960, isOpaque: true) ?? fileUrl).jpegData(compressionQuality: 0)! as Data
        let fileName = "profilepic.jpeg"
        self.createSpinnerView(self.child)
        ParsingFunction().uploadDoc(fileData: fileData, uploaddoctype: "jpeg", fileName: fileName, type: "doctors", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
            if imageModel.status {
                self.profileImageView.isHidden = false
                self.profileImageView.image = fileUrl
                self.userData.userImage = imageModel.result.name
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
