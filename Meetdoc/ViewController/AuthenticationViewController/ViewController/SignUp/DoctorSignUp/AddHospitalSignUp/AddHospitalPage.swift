 //
 //  AddHospitalPage.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 24/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import UIKit
 import GoogleMaps
 import GooglePlaces
 import SwiftyJSON
 import Alamofire

 protocol getHospitalData {
     func selectedHospital(_ hospitalData: AddHospitalResultModel)
 }

 class AddHospitalPage: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
     @IBOutlet weak var collectionView: UICollectionView!
     @IBOutlet weak var uploadTextField: UITextField!
     @IBOutlet weak var uploadButton: UIButton!
     @IBOutlet weak var logoView: UIView!
     @IBOutlet weak var insuranceTextField: UITextField!
     @IBOutlet weak var specialitiesTextField: UITextField!
     @IBOutlet weak var locationTextField: UITextField!
     @IBOutlet weak var addHospScrollView: UIScrollView!
     @IBOutlet weak var backBtn: UIButton!
     
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var addHospLabel: UILabel!
     
     @IBOutlet weak var hospitalDescTextField: UITextField!
     @IBOutlet weak var hospitalNameTxt: UITextField!
     
     @IBOutlet weak var doneBtn: UIButton!
     var delegate: getHospitalData?
     var imagePicker = UIImagePickerController()
     
     var imageModel = [ImageResultModel]()
     let child = SpinnerViewController()
     var getSpecialities = [LanguageModel]()
     var selectedInsurance = [InsuranceResultModel]()
     var viewModel = AuthenticationViewModel()
     var selectedLocation: LocationModel?
     var lat = ""
     var long = ""

     override func viewDidLoad() {
         super.viewDidLoad()
         self.configUI()
     }
     func configUI() {
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
         }
          self.collectionView.register(UINib(nibName: "ImageUploadCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageUploadCollectionCell")

         self.titleLabel.config(color: UIColor(named: "TitleColor"), font: titleFont, align: .left, text: "welcome_doctor")
         self.titleLabel.text = self.titleLabel.text?.replacingOccurrences(of: " ", with: "\n")
         self.addHospLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "add_hospital")
         self.hospitalNameTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "hospital_name", Font: fontRegular16, setBorder: true)
         self.hospitalDescTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "type_hospital_desc", Font: fontRegular16, setBorder: true)
         self.locationTextField.config(color: UIColor(named: "location"), align: .left, placeHolder: "location", Font: fontRegular16, setBorder: true)
         self.specialitiesTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "specialities", Font: fontRegular16, setBorder: true)
         self.insuranceTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "select_insurance", Font: fontRegular16, setBorder: true)
         self.uploadTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "hospital_logo_upload", Font: fontRegular16, setBorder: true)
         self.doneBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "done")
         
         self.locationTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getLocationData)))
         self.specialitiesTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getspecialitiesData)))
         self.insuranceTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getInsuranceData)))
        
        self.hospitalNameTxt.styleTextField()
        self.hospitalDescTextField.styleTextField()
        self.insuranceTextField.styleTextField()
        self.specialitiesTextField.styleTextField()
        self.locationTextField.styleTextField()
        self.uploadTextField.styleTextField()
        self.logoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct)))
         self.insuranceTextField.isHidden = true
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    @objc func uploadAct() {
        if self.imageModel.count < 1 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 1 image"] ?? ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
     override func viewWillAppear(_ animated: Bool) {
         if Profile.currentProfile != nil {
             CallsApp.connect()
         }

        self.navigationController?.setNavigationBarHidden(true, animated: true)
         super.viewWillAppear(animated)
         self.customUI()
     }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
     func customUI(){
         navigationController?.navigationBar.barTintColor = AppRed
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
         self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
         self.navigationController?.navigationBar.barStyle = .default
         
     }
     
     @objc override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
     }
     @IBAction func backBtnTapped(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
     }
     @IBAction func uploadLogoBtnTapped(_ sender: UIButton) {
         if self.imageModel.count < 1 {
             if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                 self.imagePicker.delegate = self
                 self.imagePicker.sourceType = .photoLibrary
                 self.imagePicker.allowsEditing = false
                 self.imagePicker.modalPresentationStyle = .fullScreen
                 self.present(self.imagePicker, animated: true, completion: nil)
             }
         }
         else {
             let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 1 image"] ?? ""), preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            let imageData = (pickedImage.resized(toWidth: 960, isOpaque: true) ?? pickedImage).jpegData(compressionQuality: 0)! as Data
            self.createSpinnerView(self.child)
            
            ParsingFunction().uploadDoc(fileData: imageData, uploaddoctype: ".jpeg", fileName: "profilepic.jpeg", type: "hospital", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                if imageModel.status {
                    self.imageModel.append(imageModel.result)
                    self.collectionView.isHidden = false
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                else {
                    var message = (getLanguage["failed_upload_image"] ?? "")
                    if imageModel.message == "Image doesnot allowed by moderator." {
                        message = (getLanguage[imageModel.message] ?? imageModel.message)
                    }
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.removeSpinnerView(self.child)
            })
            { failure in
                self.removeSpinnerView(self.child)
                let alert = UIAlertController(title: nil, message: (getLanguage["failed_upload_image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
     @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
         if let error = error {
             // we got back an error!
             let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default))
             present(ac, animated: true)
         } else {
             let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default))
             present(ac, animated: true)
         }
     }
     
     
     @objc func getLocationData(_ sender: UITapGestureRecognizer? = nil) {
         locationTextField.resignFirstResponder()
 //        let pageObj = GMSAutocompleteViewController()
 //        pageObj.delegate = self
 //        pageObj.modalPresentationStyle = .fullScreen
 //        present(pageObj, animated: true, completion: nil)
         let pageObj = HospitalLocationPage()
         pageObj.isFromHospital = true
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     
     @objc func getspecialitiesData(_ sender: UITapGestureRecognizer? = nil) {
         let pageObj = SpecialitiesViewController()
         pageObj.selectedArray = self.getSpecialities
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     
     @objc func getInsuranceData(_ sender: UITapGestureRecognizer? = nil) {
         let pageObj = SelectInsurancePage()
         pageObj.selectedArray = self.selectedInsurance
         pageObj.delegate = self
         self.navigationController?.pushViewController(pageObj, animated: true)
     }
     
     @IBAction func doneBtnTapped(_ sender: Any) {
         
         if ((hospitalNameTxt.text == "") || (hospitalDescTextField.text == "") || (locationTextField.text == "") || (specialitiesTextField.text == "")){
             let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
             let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
             }
             alert.addAction(action)
             self.present(alert, animated: true, completion: nil)
         }
         if (self.imageModel.count == 0){
                      let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "failed_upload_image") as? String ?? ""), preferredStyle: .alert)
                      let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                      }
                      alert.addAction(action)
                      self.present(alert, animated: true, completion: nil)
         
                  }else {
                      let sArray: [String] = getSpecialities.map({"\($0.id ?? 0)"})
                      let sArray1: [String] = selectedInsurance.map({"\($0.id ?? 0)"})
                      self.view.endEditing(true)
                      Utility.shared.startAnimation(viewController: self)
                      self.viewModel.AddHospital(hospital_name: self.hospitalNameTxt.text!, description: self.hospitalDescTextField.text!, location: self.locationTextField.text!, latitude: self.lat, longitude: self.long, speciality_id: Utility.shared.jsonString(from: sArray), insurance_id: Utility.shared.jsonString(from: sArray1), hospital_logo: (self.imageModel.first?.name ?? ""), onSuccess: {
                          (success) in
                          if success {
                              if let hospital = self.viewModel.addHospitalModel?.result {
                                  self.delegate?.selectedHospital(hospital)
                                  
                              }
                              self.navigationController?.popViewController(animated: true)
                          }
                          Utility.shared.stopAnimation(viewController: self)
                      }) { (failure) in
                          Utility.shared.stopAnimation(viewController: self)
                      }
                  }
     }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
 }
 extension AddHospitalPage: Select_Specialities{
     func addSpecialities(_ specialities: [LanguageModel]) {
         getSpecialities = specialities
         if getSpecialities.count > 0 {
             let sArray: [String] = getSpecialities.map({$0.name ?? ""})
             self.specialitiesTextField.text = sArray.joined(separator: ", ")
         }
     }
     func addInsurance(_ Insurance: String){
     }
 }
 extension getHospitalData{
     func getHospitalName(_ hospital_Name: String){
         
     }
     
 }
 extension AddHospitalPage: GMSAutocompleteViewControllerDelegate {
     
     func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
         locationTextField.text = place.name
         self.dismiss(animated: true, completion: nil)
     }
     func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
         // Handle the error
         print("Error: ", error.localizedDescription)
     }
     func wasCancelled(_ viewController: GMSAutocompleteViewController) {
         // Dismiss when the user canceled the action
         dismiss(animated: true, completion: nil)
     }
     
 }
 extension AddHospitalPage : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.imageModel.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUploadCollectionCell", for: indexPath) as! ImageUploadCollectionCell
        var imgURL = (self.imageModel[indexPath.row].image ?? "")
        if !(self.imageModel[indexPath.row].image ?? "").contains(webURL) {
            imgURL = "\(webURL)\(self.imageModel[indexPath.row].image ?? "")"
        }
         cell.imageViewUpload.sd_setImage(with: URL(string: imgURL), completed: nil)
         cell.imageViewUpload.contentMode = .scaleAspectFill
         cell.closeBtn.tag = indexPath.row
         cell.closeBtn.addTarget(self, action: #selector(self.cancelButtonAct(_:)), for: .touchUpInside)
         return cell
     }
     @objc func cancelButtonAct(_ sender: UIButton) {
         if self.imageModel.count > sender.tag {
             self.imageModel.remove(at: sender.tag)
             self.collectionView.reloadData()
             if self.imageModel.count == 0 {
                 self.collectionView.isHidden = true
             }
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: self.collectionView.frame.height, height: self.collectionView.frame.height)
     }

 }
 extension AddHospitalPage: Select_Insurance, select_Location {
     func locationData(_ location: LocationModel) {
         
     }
     
     func locationDetails(_ location: String, lat: String, long: String, countryCode: String) {
         self.locationTextField.text = location
         self.lat = lat
         self.long = long
     }
     
     func selectedInsurance(_ insuranceArray: [InsuranceResultModel]) {
         self.selectedInsurance = insuranceArray
         if self.selectedInsurance.count > 0 {
             let sArray: [String] = self.selectedInsurance.map({$0.name ?? ""})
             self.insuranceTextField.text = sArray.joined(separator: ", ")
         }
     }
 }


