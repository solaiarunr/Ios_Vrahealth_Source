 //
 //  ProfilePage.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 02/06/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //
 
 import UIKit
 import GoogleMaps
 import GooglePlaces
 import Photos
 import PhotosUI
 import PhoneNumberKit
 import FirebaseUI
 import SDWebImage
 import CoreTelephony

 protocol userData {
    func addUserName(name: String, lastName : String, userImage: UIImage)
 }
 class ProfilePage: UIViewController  {
    
    @IBOutlet weak var phoneverifyLabel: UILabel!
    @IBOutlet weak var phoneVerifyImageView: UIImageView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var basicStackView: UIStackView!
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextView!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var maleStackView: UIStackView!
    @IBOutlet weak var maleCheckButton: UIButton!
    @IBOutlet weak var maleTitleButton: UIButton!
    @IBOutlet weak var femaleStackView: UIStackView!
    @IBOutlet weak var femaleCheckButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailVerifyStackView: UIStackView!
    @IBOutlet weak var emailVerifyImageView: UIImageView!
    @IBOutlet weak var emailVerifyLabel: UILabel!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
     @IBOutlet weak var addressStackView: UIStackView!
     
     @IBOutlet weak var addressTittleLbl: UILabel!
     
     @IBOutlet weak var addressTextField: UITextView!
     @IBOutlet weak var lastnameStackView: UIStackView!
     @IBOutlet weak var lastNameView: UIView!
     
    var viewModel = ProfileViewModel()
    var userProfileData: UserLoginResultModel?
    
    var imagePicker = UIImagePickerController()
    var imageModel: ImageModel?
    let child = SpinnerViewController()
    var delegate: userData?
    
    // FUIMobileNumber Login
    let authUI = FUIAuth.defaultAuthUI()
    
    var lat = ""
    var long = ""
    var countryCode = ""
    var currency_code = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.checkReachability()
        customUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        //        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["edit_profile"] ?? "edit_profile", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func customUI() {
        self.view.addSubview(indicatorView)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["edit_profile"] ?? "edit_profile", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.nameTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "firstname")
        self.nameTextField.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
        self.lastNameTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "lastname")
        self.lastNameTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.addressTittleLbl.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "address")
        self.addressTextField.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
        if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
            self.addressTittleLbl.isHidden = true
            self.addressTextField.isHidden = true
        }
        if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            self.nameTextField.isUserInteractionEnabled = false
            self.lastNameTextField.isUserInteractionEnabled = false
            self.maleTitleButton.isUserInteractionEnabled = false
            self.maleCheckButton.isUserInteractionEnabled = false
            self.femaleButton.isUserInteractionEnabled = false
            self.femaleCheckButton.isUserInteractionEnabled = false
            self.nameTextField.isEditable = false
            self.nameTextField.isScrollEnabled = true
        }else{
            self.nameTextField.isUserInteractionEnabled = true
            self.lastNameTextField.isUserInteractionEnabled = true
            self.maleTitleButton.isUserInteractionEnabled = true
            self.maleCheckButton.isUserInteractionEnabled = true
            self.femaleButton.isUserInteractionEnabled = true
            self.femaleCheckButton.isUserInteractionEnabled = true
        }
        self.profileImageView.cornerViewRadius()
        self.genderTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "gender")
        self.maleTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "male")
        self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.femaleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "female")
        self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emailTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "emailaddress")
        self.emailTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.emailTextField.isUserInteractionEnabled = false
        self.emailVerifyImageView.image = nil
        self.emailVerifyLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
        self.phoneNumberTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "phoneno")
        self.phoneNumberTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.phoneNumberTextField.isUserInteractionEnabled = false
        self.locationTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "location")
        self.locationTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.locationTextField.isUserInteractionEnabled = false
       self.saveButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "save")
        
        // Gesture for profile Image
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageGestureAct)))
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.contentMode = .scaleAspectFill
        self.imagePicker.delegate = self
        // Gesture for Mobile Number
        if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
            self.phoneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.PhoneNumberViewAct(_:))))
        }
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        self.authUI?.providers = providers
        self.authUI?.delegate = self
        self.verifyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.verifyAct(_:))))
        self.locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationAct(_:))))
        self.locationTextField.isUserInteractionEnabled = false
//        self.lastnameStackView.isHidden = true
//        self.lastNameView.isHidden = true
        self.loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func locationAct(_ sender: UITapGestureRecognizer) {
        let pageObj = HospitalLocationPage()
        pageObj.isFromHospital = true
        pageObj.isFromPatientProfile = true
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func verifyAct(_ sender: UITapGestureRecognizer) {
        if !(self.userProfileData?.emailVerified ?? false) {
            let viewModel = SettingViewModel()
            Utility.shared.startAnimation(viewController: self)
            viewModel.EmailVerification(user_id: "\(UserDefaultModule.shared.getLoginData().userId ?? "")", onSuccess: { (success) in
                Utility.shared.stopAnimation(viewController: self)
                self.view.makeToast(viewModel.settingData?.result ?? "")
                print(success)
            }) { (failure) in
                Utility.shared.stopAnimation(viewController: self)
                print(failure)
            }
        }
    }
    @objc func PhoneNumberViewAct(_ sender: UITapGestureRecognizer) {
        let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }
    func loadData() {
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.loadProfileData(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            if success {
                self.loadUserData()
            }
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func loadUserData() {
        if let userData = self.viewModel.userProfileModel?.result {
            self.userProfileData = userData
            self.nameTextField.text = userData.firstName
            self.lastNameTextField.text = userData.lastName
            if userData.gender == "male" {
                self.genderButtonAct(self.maleCheckButton)
            }
            else if userData.gender == "female" {
                self.genderButtonAct(self.femaleCheckButton)
            }
            self.emailTextField.text = userData.email
            if (self.userProfileData?.emailVerified ?? false) {
                self.emailVerifyImageView.image = #imageLiteral(resourceName: "verified")
                self.emailVerifyLabel.text = getLanguage["verify"] ?? "verified"
            }
            else {
                self.emailVerifyImageView.image = #imageLiteral(resourceName: "cancel_rounded")
                self.emailVerifyLabel.text = getLanguage["resend_verification_mail"] ?? "resend_verification_mail"
            }
            if (self.userProfileData?.phoneNumber ?? "") != "" {
                self.phoneNumberTextField.text = "+\(self.userProfileData?.phoneNumber ?? "")"
                self.phoneVerifyImageView.image = #imageLiteral(resourceName: "verified")
                self.phoneverifyLabel.text = getLanguage["verify"] ?? "verified"
            }
            else {
                self.phoneVerifyImageView.image = #imageLiteral(resourceName: "cancel_rounded")
                self.phoneverifyLabel.text = getLanguage["unverify"] ?? "unverify"

            }
            self.locationTextField.text = userData.location
            self.addressTextField.text = userData.address
            self.currency_code = userData.currency_code
            self.profileImageView.sd_setImage(with: URL(string: userData.userImage), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
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
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        Utility.shared.stopAnimation(viewController: self)
        if let error = error {
            self.countryCode = (Locale.current.regionCode ?? "IN")
            print("Unable to Forward Geocode Address (\(error))")
        } else {
            var location: CLLocation?

            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }

            if location != nil {
                self.countryCode = placemarks?.first?.isoCountryCode ?? (Locale.current.regionCode ?? "IN")
            } else {
                self.countryCode = (Locale.current.regionCode ?? "IN")
            }
        }
    }
    @IBAction func complete(_ sender: Any) {
        let alertContorller = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        alertContorller.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
        if self.nameTextField.text == "" || self.phoneNumberTextField.text == "" ||  self.emailTextField.text == "" || self.locationTextField.text == "" {
            alertContorller.message = getLanguage["fill_fields"] ?? ""
            self.present(alertContorller, animated: true, completion: nil)
        }
        /*
        else if  ((self.nameTextField.text?.count)! < 3 || (self.nameTextField.text?.count)! > 30){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "first_name_err") as? String ?? "first_name_err"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if  ((self.lastNameTextField.text?.count)! < 3 || (self.lastNameTextField.text?.count)! > 30){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "last_name_err") as? String ?? "last_name_err"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        */
        else if  (self.userProfileData?.gender ?? "") == ""{
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "select_gender") as? String ?? "select_gender"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.saveUserProfileData(userid: "\(UserDefaultModule.shared.getLoginData().userId ?? "")", first_name: self.nameTextField.text!, gender: (self.userProfileData?.gender ?? ""), phone_number: self.phoneNumberTextField.text!, location: self.locationTextField.text!, latitude: self.lat, longitude: self.long, last_name: self.lastNameTextField.text!, countryCode: self.countryCode, address: self.addressTextField.text, currency_code: self.currency_code) { (success) in
                    Utility.shared.stopAnimation(viewController: self)
                    let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    if (message == getLanguage["Mobile number already registered in doctor account"] ?? "Mobile number already registered in doctor account") || (message == getLanguage["Mobile number already registered in patient account"] ?? "Mobile number already registered in patient account") {
                        self.phoneNumberTextField.text = "+\(self.userProfileData?.phoneNumber ?? "")"
                    }
                    alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (action:UIAlertAction) in
                        self.delegate?.addUserName(name: self.nameTextField.text!, lastName: self.lastNameTextField.text!, userImage: self.profileImageView.image!)
                        if success {
                            isProfileUpdate = true
                            self.navigationController?.popViewController(animated: true)
                        }
                    }))
                    //                alertController.addAc
                    self.present(alertController, animated: true, completion: nil)
                    
                } onFailure: { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }else{
                Utility.shared.startAnimation(viewController: self)
                self.viewModel.saveUserProfileData(userid: "\(UserDefaultModule.shared.getLoginData().userId ?? "")", first_name: self.nameTextField.text!, gender: (self.userProfileData?.gender ?? ""), phone_number: self.phoneNumberTextField.text!, location: self.locationTextField.text!, latitude: self.lat, longitude: self.long, last_name: self.lastNameTextField.text!, countryCode: self.countryCode, address: self.addressTextField.text, currency_code: "") { (success) in
                    Utility.shared.stopAnimation(viewController: self)
                    let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    if (message == getLanguage["Mobile number already registered in doctor account"] ?? "Mobile number already registered in doctor account") || (message == getLanguage["Mobile number already registered in patient account"] ?? "Mobile number already registered in patient account") {
                        self.phoneNumberTextField.text = "+\(self.userProfileData?.phoneNumber ?? "")"
                    }
                    alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (action:UIAlertAction) in
                        self.delegate?.addUserName(name: self.nameTextField.text!, lastName: self.lastNameTextField.text!, userImage: self.profileImageView.image!)
                        if success {
                            isProfileUpdate = true
                            self.navigationController?.popViewController(animated: true)
                        }
                    }))
                    //                alertController.addAc
                    self.present(alertController, animated: true, completion: nil)
                    
                } onFailure: { (failure) in
                    Utility.shared.stopAnimation(viewController: self)
                }
            }
            
        }
    }
    //set lable height depends an String value
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize
    {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    @IBAction func genderButtonAct(_ sender: UIButton) {
        self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.maleTitleButton.setTitleColor((UIColor(named: "secondary_text") ?? UIColor.white), for: .normal)
        self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.femaleButton.setTitleColor((UIColor(named: "secondary_text") ?? UIColor.white), for: .normal)
        
        if sender == maleCheckButton || sender == maleTitleButton {
            self.userProfileData?.gender = "male"
            self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
            self.maleTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
        }
        else {
            self.userProfileData?.gender = "female"
            self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
            self.femaleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
        }
    }
    
    @objc func imageGestureAct() {
        let actionSheet = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? "gallery"), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: (getLanguage["camera"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.imagePicker.allowsEditing = false
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.present(actionSheet, animated: true, completion: nil)
    }
    @objc func privateDetailsViewGesture(_ sender: UITapGestureRecognizer? = nil) {
        if (sender?.view) != nil {
            phoneNumberTextField.resignFirstResponder()
            let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
            phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
        }
    }
 }
 extension ProfilePage: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            print(authDataResult?.user.phoneNumber ?? "")
            let phoneNumberKit = PhoneNumberKit()
            do {
                let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
                self.phoneNumberTextField.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
                //MARK: Set Default Currency code using mobile number
                self.getCurrencyCode(for: phoneNumbers.regionID ?? "")
                print("CURRENCYCODE:\(self.getCurrencyCode(for: phoneNumbers.regionID ?? ""))")
//                self.countryCode = ""
                self.phoneVerifyImageView.image = #imageLiteral(resourceName: "verified")
                self.phoneverifyLabel.text = getLanguage["verify"] ?? "verified"
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
 extension ProfilePage: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        do {
            let fileData = (fileUrl.resized(toWidth: 960, isOpaque: true) ?? fileUrl).jpegData(compressionQuality: 0)! as Data
            let fileName = "profilepic.jpeg"
            self.createSpinnerView(self.child)
            ParsingFunction().uploadDoc(fileData: fileData, uploaddoctype: "jpeg", fileName: fileName, type: "users", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
//                self.profileImageView.sd_setImage(with: URL(string: "\(webURL)\(imageModel.result.image ?? "")"), completed: nil)
                if imageModel.status {
                    self.profileImageView.image = fileUrl
                    self.userProfileData?.userImage = imageModel.result.name
                    var param = Parameters()
                    param["user_id"] = (UserDefaultModule().getCurrentUserID() as? String ?? "")
                    param["user_image"] = imageModel.result.name
                    CallParsingFunction().editProfileImageData(param: param, onSuccess: { (response) in
                        print(response)
                        self.removeSpinnerView(self.child)
                    }) { (error) in
                        self.removeSpinnerView(self.child)
                    }
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
        }
        catch {
            print("Unable to load data: \(error)")
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
 extension ProfilePage: UITextFieldDelegate {
    @objc func getLocationData(_ sender: UITapGestureRecognizer? = nil) {
        self.locationTextField.resignFirstResponder()
        let pageObj = HospitalLocationPage()
        pageObj.isFromHospital = true
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
 }
 extension ProfilePage: select_Location {
    func locationData(_ location: LocationModel) {
    }
    func locationDetails(_ location: String, lat: String, long: String, countryCode: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        self.locationTextField.text = location
        self.lat = lat
        self.long = long
    }
 }
 
 extension userData {
    
    func addUserName (name: String, lastName: String, userImage: UIImage){
        
    }
 }
 
 
 
 
