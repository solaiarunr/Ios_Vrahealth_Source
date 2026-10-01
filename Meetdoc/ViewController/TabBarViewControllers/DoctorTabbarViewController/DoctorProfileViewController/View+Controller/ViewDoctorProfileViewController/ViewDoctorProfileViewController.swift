 //
 //  ViewDoctorProfileViewController.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 16/10/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import UIKit
 import Photos
 import PhotosUI
 import FirebaseUI
 import PhoneNumberKit

class ViewDoctorProfileViewController: UIViewController,select_hospitalName {
    func addHospitalName(_ hospitalName: String) {
        
    }
    
    func passLocation(_ location: String) {
        
    }
    
     
    @IBOutlet weak var basicStackView: UIStackView!
     @IBOutlet weak var basicTitleLabel: UILabel!
     @IBOutlet weak var nameStackView: UIStackView!
     @IBOutlet weak var nameTitleLabel: UILabel!
     @IBOutlet weak var nameTextField: UITextView!
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
     @IBOutlet weak var qualificationStackView: UIStackView!
     @IBOutlet weak var qualificationTitleLabel: UILabel!
     @IBOutlet weak var qualificationTextField: UITextField!
     @IBOutlet weak var phoneNumberView: UIView!
     @IBOutlet weak var phoneNumberTitleLabel: UILabel!
     @IBOutlet weak var phoneNumberTextField: UITextField!
     @IBOutlet weak var phoneNumberVerifyStackView: UIStackView!
     @IBOutlet weak var phoneNumberVerifyImageView: UIImageView!
     @IBOutlet weak var phoneNumberVerifyLabel: UILabel!
    
     @IBOutlet weak var aboutDetailsStackView: UIStackView!
     @IBOutlet weak var aboutTitleLabel: UILabel!
     @IBOutlet weak var languageView: UIView!
     @IBOutlet weak var languageTitleLabel: UILabel!
     @IBOutlet weak var languageTextField: UITextField!
     @IBOutlet weak var RegisterNoStackView: UIStackView!
     @IBOutlet weak var registerNoTitleLabel: UILabel!
     @IBOutlet weak var registerNoTextField: UITextField!
     @IBOutlet weak var certificateUploadView: UIView!
     @IBOutlet weak var certificateTitleLabel: UILabel!
     @IBOutlet weak var certificateCountLabel: UILabel!
     @IBOutlet weak var portfolioView: UIView!
     @IBOutlet weak var portfolioTitleLabel: UILabel!
     @IBOutlet weak var portfolioCountLabel: UILabel!
     @IBOutlet weak var specialitiesView: UIView!
     @IBOutlet weak var specialitiesTitleLabel: UILabel!
     @IBOutlet weak var specialitiesTextField: UITextField!
    
    
     @IBOutlet weak var skillTextField: UITextField!
     @IBOutlet weak var skillTitleLabel: UILabel!
     @IBOutlet weak var skilStackView: UIStackView!
     @IBOutlet weak var bioStackView: UIStackView!
     @IBOutlet weak var bioTitleLabel: UILabel!
     @IBOutlet weak var bioTextView: UITextView!
     @IBOutlet weak var doctorAccountDetail: UIStackView!
     @IBOutlet weak var accountDetailTextview: UITextView!
     @IBOutlet weak var accountDetailView: UIView!
     @IBOutlet weak var accountDetailLabel: UILabel!
     @IBOutlet weak var hospitalStackView: UIStackView!
     @IBOutlet weak var hospitalTitleLabel: UILabel!
     @IBOutlet weak var hospitalTextField: UITextField!
     @IBOutlet weak var locationStackView: UIStackView!
     @IBOutlet weak var locationTitleLabel: UILabel!
     @IBOutlet weak var locationTextField: UITextField!
     @IBOutlet weak var saveButton: UIButton!
     @IBOutlet weak var instituteStackView: UIStackView!
     @IBOutlet weak var instituteLabel: UILabel!
     @IBOutlet weak var instituteTextField: UITextField!
     var viewModel = ProfileViewModel()
     var doctorProfileData: DoctorProfileResultModel?
     
     var imagePicker = UIImagePickerController()
     var imageModel: ImageModel?
     let child = SpinnerViewController()
    
    var selectedHospital: HospitalResultModel?
    var selectedLocation: LocationModel?
    var country = ""
    var hospital_id = ""
    var location_id = ""

     // FUIMobileNumber Login
     let authUI = FUIAuth.defaultAuthUI()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         self.customUI()
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
    override func viewDidAppear(_ animated: Bool) {
    }
     override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

          NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
     }
     func customUI() {
         self.view.addSubview(indicatorView)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
          self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["edit_profile"] ?? "edit_profile", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
         self.basicTitleLabel.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .left, text: "basic_info")
         self.nameTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "name")
         self.nameTextField.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
         self.nameTextField.isUserInteractionEnabled = false
         self.profileImageView.cornerViewRadius()
         self.genderTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "gender")
         self.maleTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "male")
         self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
         self.maleCheckButton.isUserInteractionEnabled = false
         self.maleTitleButton.isUserInteractionEnabled = false
         self.femaleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "female")
         self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
         self.femaleCheckButton.isUserInteractionEnabled = false
         self.femaleButton.isUserInteractionEnabled = false
         self.emailTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "emailaddress")
         self.emailTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.emailTextField.isUserInteractionEnabled = false
         self.emailVerifyImageView.image = nil
         self.emailVerifyLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
         self.qualificationTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "qualification")
         self.instituteLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "new_Institute")
         self.qualificationTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.qualificationTextField.isUserInteractionEnabled = false
         self.instituteTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.instituteTextField.isUserInteractionEnabled = false
         self.phoneNumberTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "phoneno")
         self.phoneNumberTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.phoneNumberTextField.isUserInteractionEnabled = false
         self.phoneNumberVerifyImageView.image = nil
         self.phoneNumberVerifyLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
         self.aboutTitleLabel.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .left, text: "about_details")
         self.languageTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "language_label")
         self.languageTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.languageTextField.isUserInteractionEnabled = false
         self.registerNoTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "register_number1")
         self.registerNoTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.registerNoTextField.isUserInteractionEnabled = false
         self.certificateTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "certifiction_upload")
         self.certificateCountLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "")
         self.portfolioTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "portfolio_upload")
         self.portfolioCountLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "")
         self.specialitiesTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "specialities")
         self.specialitiesTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.specialitiesTextField.isUserInteractionEnabled = false
         self.skillTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "new_skills")
         self.skillTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.bioTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "about_doctor")
         self.bioTextView.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
         self.bioTextView.textContainerInset = UIEdgeInsets.zero
         self.bioTextView.textContainer.lineFragmentPadding = 0
        self.accountDetailLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "doctor_account_details")
        self.accountDetailTextview.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
        self.accountDetailTextview.textContainerInset = UIEdgeInsets.zero
        self.accountDetailTextview.textContainer.lineFragmentPadding = 0
         
         self.hospitalTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "hospital")
         self.hospitalTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.hospitalTextField.isUserInteractionEnabled = true
         self.locationTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "location")
         self.locationTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
         self.locationTextField.isUserInteractionEnabled = true
         self.saveButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "save")
         
         
         // Gesture for profile Image
         self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageGestureAct)))
         self.profileImageView.isUserInteractionEnabled = true
         self.profileImageView.contentMode = .scaleAspectFill
         self.imagePicker.delegate = self
         // Gesture for Mobile Number
//         self.phoneNumberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.PhoneNumberViewAct(_:))))
         let providers: [FUIAuthProvider] = [
             FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
         ]
         self.authUI?.providers = providers
         self.authUI?.delegate = self
         // Gesture for Language View
         self.languageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.languageViewAct(_:))))
         // Gesture for SpecialitiesView
//         self.specialitiesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.specialityViewAct(_:))))
         // Gesture for certificateView
         self.certificateUploadView.tag = 0
         self.certificateUploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.certificateViewAct(_:))))
         self.portfolioView.tag = 1
         self.portfolioView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.certificateViewAct(_:))))
         let hospitalGesture = UITapGestureRecognizer(target: self, action: #selector(self.getHospitalData))
                  self.hospitalTextField.addGestureRecognizer(hospitalGesture)
         self.loadData()
     }
     @objc func getHospitalData(_ sender: UITapGestureRecognizer? = nil) {
              let pageObj = HospitalSignUpPage()
              pageObj.selectedHospital = self.selectedHospital
              pageObj.delegate = self
              self.navigationController?.pushViewController(pageObj, animated: true)
          }
     private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
              // Update View
              Utility.shared.stopAnimation(viewController: self)
              if let error = error {
                  print("Unable to Forward Geocode Address (\(error))")
              } else {
                  var location: CLLocation?

                  if let placemarks = placemarks, placemarks.count > 0 {
                      location = placemarks.first?.location
                  }

                  if location != nil {
                      self.country = placemarks?.first?.isoCountryCode ?? ""
                  } else {
                  }
              }
          }
          
          
          func addHospitalDetails(_ hospital: HospitalResultModel, location: LocationModel) {
      //        country
              self.selectedHospital = hospital
              self.hospital_id = "\(hospital.id ?? 0)"
              self.selectedLocation = location
              self.location_id = "\(location.id ?? 0)"
              Utility.shared.startAnimation(viewController: self)
              let geocoder = CLGeocoder()
              geocoder.geocodeAddressString(self.selectedLocation?.location ?? "") { (placemarks, error) in
                  self.processResponse(withPlacemarks: placemarks, error: error)
              }
              self.hospitalTextField.text = hospital.name
              self.locationTextField.text = location.location
          }
     @objc func barButtonAction(_ notification: Notification) {
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
     func loadData() {
         Utility.shared.startAnimation(viewController: self)
         self.viewModel.loadDoctorProfileData(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
             Utility.shared.stopAnimation(viewController: self)
             if success {
                 self.loadDoctorData()
             }
         }) { (failure) in
             Utility.shared.stopAnimation(viewController: self)
         }
     }
     func loadDoctorData() {
         if let doctorData = self.viewModel.profileModel?.result {
             self.doctorProfileData = doctorData
             self.nameTextField.text = doctorData.fullName
             if doctorData.gender == "male" {
                 self.genderButtonAct(self.maleCheckButton)
             }
             else {
                 self.genderButtonAct(self.femaleCheckButton)
             }
             self.emailTextField.text = doctorData.email
             self.emailVerifyImageView.image = #imageLiteral(resourceName: "verified")
             self.emailVerifyLabel.text = getLanguage["verify"] ?? "verified"
             self.qualificationTextField.text = doctorData.qualification
             self.instituteTextField.text = doctorData.institute
             self.phoneNumberTextField.text = "+\(doctorData.phoneNumber ?? 0)"
             self.phoneNumberVerifyImageView.image = #imageLiteral(resourceName: "verified")
             self.phoneNumberVerifyLabel.text = getLanguage["verify"] ?? "verified"
            self.languageTextField.text = doctorData.languages.count > 1 ? doctorData.languages.map({$0.lname ?? ""}).joined(separator: ", ") : (doctorData.languages.first?.lname ?? "")
             self.registerNoTextField.text = doctorData.registerNumber
             self.certificateCountLabel.text = "\(doctorData.certificationUpload.count)"
             self.portfolioCountLabel.text = "\(doctorData.portfolioImages.count)"
             self.specialitiesTextField.text = doctorData.speciality.count > 1 ? doctorData.speciality.map({$0.name ?? ""}).joined(separator: ", ") : (doctorData.speciality.first?.name ?? "")
             self.skillTextField.text = doctorData.skills
             self.bioTextView.text = doctorData.bioDescription
             self.accountDetailTextview.text = doctorData.bankdetails
             self.hospitalTextField.text = doctorData.hospitalName
             self.locationTextField.text = doctorData.location
             self.hospital_id = doctorData.hospitalId
             self.location_id = doctorData.location_id
             self.profileImageView.sd_setImage(with: URL(string: doctorData.userImage), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
         }
     }
     @IBAction func genderButtonAct(_ sender: UIButton) {
         self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
         self.maleTitleButton.setTitleColor((UIColor(named: "secondary_text") ?? UIColor.white), for: .normal)
         self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
         self.femaleButton.setTitleColor((UIColor(named: "secondary_text") ?? UIColor.white), for: .normal)

         if sender == maleCheckButton || sender == maleTitleButton {
             self.doctorProfileData?.gender = "male"
             self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
             self.maleTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
         }
         else {
             self.doctorProfileData?.gender = "female"
             self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
             self.femaleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
          }
     }
     
    @IBAction func saveButtonAct(_ sender: UIButton) {
        let alertContorller = UIAlertController(title: nil, message: "", preferredStyle: .alert)
               alertContorller.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
               if self.nameTextField.text == "" || self.phoneNumberTextField.text == "" || self.qualificationTextField.text == "" || self.languageTextField.text == "" || self.registerNoTextField.text == "" || self.specialitiesTextField.text == "" || self.skillTextField.text == "" || self.bioTextView.text == "" || self.hospitalTextField.text == "" || self.locationTextField.text == "" {
                   alertContorller.message = getLanguage["fill_fields"] ?? ""
                   self.present(alertContorller, animated: true, completion: nil)
               }
               else if  ((self.registerNoTextField.text?.count)! < 3 || (self.registerNoTextField.text?.count)! > 30){
                   let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "registerNo_err") as? String ?? "email_error"), preferredStyle: .alert)
                   let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
               }
               else if   ((self.skillTextField.text?.count)! < 5 || (self.skillTextField.text?.count)! > 170){
                   let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "skill_err") as? String ?? "email_error"), preferredStyle: .alert)
                   let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
               }
               else if  ((self.bioTextView.text?.count)! < 5 || (self.bioTextView.text?.count)! > 500){
                   let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "bio_desc_err") as? String ?? "email_error"), preferredStyle: .alert)
                   let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
               }
        /*
               else if  ((self.nameTextField.text?.count)! < 3 || (self.nameTextField.text?.count)! > 30){
                   let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "first_name_err") as? String ?? "first_name_err"), preferredStyle: .alert)
                   let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
               }
        */
               else if  ((self.qualificationTextField.text?.count)! < 3 || (self.qualificationTextField.text?.count)! > 50){
                   let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "qualification_error") as? String ?? "qualification_error"), preferredStyle: .alert)
                   let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
               }
               else {
                   var certificateArray = [String]()
                   for val in (self.doctorProfileData?.certificationUpload ?? [ImageResultModel]()) {
                       certificateArray.append(val.name)
                   }
                   var portfolioArray = [String]()
                   for val in (self.doctorProfileData?.portfolioImages ?? [ImageResultModel]()) {
                       portfolioArray.append(val.name)
                   }
                   let sArray: [String] = self.doctorProfileData?.speciality.map({"\($0.id ?? 0)"}) ?? [String]()
       //            let languageString = self.languageTextField.text!
                   let languageArray = self.doctorProfileData?.languages.map({"\($0.id ?? 0)"}) ?? [String]()
                   Utility.shared.startAnimation(viewController: self)
                   self.viewModel.saveProfileData(userid: self.doctorProfileData?.userId ?? "", full_name: self.nameTextField.text!, gender: (self.doctorProfileData?.gender ?? ""), phone_number: self.phoneNumberTextField.text!, qualification: self.qualificationTextField.text!, doctor_language: Utility.shared.jsonString(from: languageArray), certification_upload: Utility.shared.jsonString(from: certificateArray), portfolio_images: Utility.shared.jsonString(from: portfolioArray), speciality_id: Utility.shared.jsonString(from: sArray), skills: self.skillTextField.text!, bio_description: self.bioTextView.text!, banking_details: self.accountDetailTextview.text!,location_id: self.location_id,hospital_id: self.hospital_id,country: (self.country == "" ? (Locale.current.regionCode ?? "IN") : self.country), institute_name: self.instituteTextField.text!, onSuccess: { (success) in
                       Utility.shared.stopAnimation(viewController: self)
                       let message = getLanguage[(self.viewModel.loginModel?.message ?? "")] ?? (self.viewModel.loginModel?.message ?? "")
                       let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                       if (message == getLanguage["Mobile number already registered in doctor account"] ?? "Mobile number already registered in doctor account") || (message == getLanguage["Mobile number already registered in patient account"] ?? "Mobile number already registered in patient account") {
                           self.phoneNumberTextField.text = "+\(self.viewModel.profileModel?.result.phoneNumber ?? 0)"
       //                    self.phoneNumberVerifyStackView.isHidden = true
                       }
                       alertController.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (action:UIAlertAction) in
                           if success {
                               self.navigationController?.popViewController(animated: true)
                           }
                       }))
                       //                alertController.addAc
                       self.present(alertController, animated: true, completion: nil)
                       
                   }) { (failure) in
                       Utility.shared.stopAnimation(viewController: self)
                   }
               }
    }
     @objc func imageGestureAct() {
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
    
     @objc func PhoneNumberViewAct(_ sender: UITapGestureRecognizer) {
         let phoneProvider = FUIAuth.defaultAuthUI()?.providers.first as! FUIPhoneAuth
         phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
     }
     @objc func languageViewAct(_ sender: UITapGestureRecognizer) {
         let pageObj = LanguageViewController()
         pageObj.selectedArray = self.doctorProfileData?.languages ?? [LanguageModel]()
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     @objc func specialityViewAct(_ sender: UITapGestureRecognizer) {
         let pageObj = SpecialitiesViewController()
         pageObj.selectedArray = self.doctorProfileData?.speciality  ?? [LanguageModel]()
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     @objc func certificateViewAct(_ sender: UITapGestureRecognizer) {
         let pageObj = DocumentUploadViewController()
         if (sender.view?.tag ?? 0) == 0 { // Upload Certificate
             pageObj.imageModel = self.doctorProfileData?.certificationUpload ?? [ImageResultModel]()
             pageObj.isCertificateView = true
         }
         else { // Upload Portfolio Certificates
             pageObj.imageModel = self.doctorProfileData?.portfolioImages ?? [ImageResultModel]()
             pageObj.isCertificateView = false
         }
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
 }
 extension ViewDoctorProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.containsEmoji {
            return false
        }
        return true
    }
 }
 extension ViewDoctorProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
                self.profileImageView.image = fileUrl
                self.doctorProfileData?.userImage = imageModel.result.name
                var param = Parameters()
                param["user_id"] = (UserDefaultModule().getCurrentUserID() as? String ?? "")
                param["user_image"] = imageModel.result.name
                CallParsingFunction().editProfileImageData(param: param, onSuccess: { (response) in
                    print(response)
                    self.removeSpinnerView(self.child)
                }) { (error) in
    //                let alert = UIAler
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.dismiss(animated: true, completion: nil)
    }
    
 
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
     }
 }
 extension ViewDoctorProfileViewController: FUIAuthDelegate {
     func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
         print(error?.localizedDescription ?? "")
         if error == nil {
             print(authDataResult?.user.phoneNumber ?? "")
             let phoneNumberKit = PhoneNumberKit()
             do {
                 let phoneNumbers = try phoneNumberKit.parse(authDataResult?.user.phoneNumber ?? "",ignoreType: true)
                 self.phoneNumberTextField.text = "+\(phoneNumbers.countryCode)\(phoneNumbers.nationalNumber)"
                self.phoneNumberVerifyStackView.isHidden = false
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
 extension ViewDoctorProfileViewController: Select_Language, Select_Specialities, uploadDelegate { // Get Selected Language & Specialities
    func addLanguage(_ language: [LanguageModel]){
        self.doctorProfileData?.languages = language
        let dArray: [String] = language.map({($0.lname ?? "")})
        self.languageTextField.text = dArray.joined(separator: ", ")
    }
     func addSpecialities(_ specialities: [LanguageModel]) {
         self.doctorProfileData?.speciality = specialities
         let sArray: [String] = specialities.map({$0.name ?? ""})
         self.specialitiesTextField.text = sArray.joined(separator: ", ")
     }
     func updateDocumentData(_ isCertificateUpload: Bool, imageArray: [ImageResultModel])
     {
         if isCertificateUpload {
             self.doctorProfileData?.certificationUpload = imageArray
         }
         else {
             self.doctorProfileData?.portfolioImages = imageArray
         }
         self.certificateCountLabel.text = "\(self.doctorProfileData?.certificationUpload.count ?? 0)"
         self.portfolioCountLabel.text = "\(self.doctorProfileData?.portfolioImages.count ?? 0)"
     }
 }

