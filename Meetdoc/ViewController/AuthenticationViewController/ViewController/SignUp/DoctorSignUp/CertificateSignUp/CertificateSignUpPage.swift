 
 //
 //  CertificateSignUpPage.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 23/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import UIKit
 import  Photos
 import PhotosUI
 import MobileCoreServices
 import AuthenticationServices
 import ValidationComponents
 import Alamofire
 import SwiftyJSON
 import GoogleMaps
 import CoreTelephony
 import ConnectyCube
 import ConnectyCubeCalls
 
 class CertificateSignUpPage: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UIDocumentPickerDelegate, UINavigationControllerDelegate, Select_Specialities, select_hospitalName, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var bioShadowView: UIView!
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var portfolioUploadView: UIView!
    @IBOutlet weak var certificateUploadView: UIView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hospitalTextField: UITextField!
    @IBOutlet weak var specialitiesTextField: UITextField!
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var regNoTxt: UITextField!
    @IBOutlet weak var certUploadBtn: UIButton!
    @IBOutlet weak var imageUploadTxt: UITextField!
    @IBOutlet weak var certificateUploadTxt: UITextField!
    
    @IBOutlet weak var imageUploadCollection: UICollectionView!
    @IBOutlet weak var hospitalLocationTxt: UITextField!
    @IBOutlet weak var bioDescriTextView: UITextView!
    @IBOutlet weak var skillsTxt: UITextField!
    @IBOutlet weak var imageUploadBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    let language : NSDictionary = Utility().language()
    let child = SpinnerViewController()
    var doctorDetailDict = NSMutableDictionary()
    var imagePicker = UIImagePickerController()
    var docuFor = String()
    var listArray = NSMutableArray()
    var viewType = String()
    var institue_Name = String()
    var delegate = UIApplication.shared.delegate as! AppDelegate
    var photosInTheCellNow : [UIImage] = []
    
    var arrayOfButtons: [UIButton] = []
    
    var imageModel = [ImageResultModel]()
    var portfolioModel = [ImageResultModel]()
    var getSpecialities = [LanguageModel]()
    var isCertificateUpload = false
    var selectedHospital: HospitalResultModel?
    var selectedLocation: LocationModel?
    
    var userData = DoctorSignupModel()
    var viewModel = AuthenticationViewModel()
    var country = ""
    var currency_code = String()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.imagePicker.delegate = self
        self.configUI()
        imageUploadCollection.isHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    func configUI() {
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.titleLabel.numberOfLines = 2
        }
        self.tableView.register(UINib(nibName: "UploadCertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadCertificateTableViewCell")
        self.imageUploadCollection.register(UINib(nibName: "ImageUploadCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageUploadCollectionCell")
        self.imageUploadCollection.isScrollEnabled = true
        self.titleLabel.config(color: UIColor(named: "AppColor"), font: titleFont, align: .left, text: "welcome_doctor")
        self.titleLabel.text = self.titleLabel.text?.replacingOccurrences(of: " ", with: "\n")
        self.aboutLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "about_details")
        self.languageTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "language_label", Font: fontRegular16, setBorder: true)
        self.regNoTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "register_number1", Font: fontRegular16, setBorder: true)
        self.certificateUploadTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "certifiction_upload", Font: fontRegular16, setBorder: true)
        self.imageUploadTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "portfolio_upload", Font: fontRegular16, setBorder: true)
        self.specialitiesTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "specialities", Font: fontRegular16, setBorder: true)
        self.skillsTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "new_skills", Font: fontRegular16, setBorder: true)
        self.hospitalTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "hospital_name", Font: fontRegular16, setBorder: true)
        self.hospitalLocationTxt.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "hospital_location", Font: fontRegular16, setBorder: true)
        self.bioDescriTextView.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "", setBorder: false)
        self.bioDescriTextView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 0, right: 8)
        
        self.descTitleLabel.config(color: UIColor(named: "BorderColor"), font: fontRegular16, align: .left, text: "bio_desc")
        self.continueBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "sign_up")
        self.languageTextField.styleTextField1()
        self.regNoTxt.styleTextField1()
        self.specialitiesTextField.styleTextField1()
        self.skillsTxt.styleTextField1()
        self.hospitalTextField.styleTextField1()
        self.hospitalLocationTxt.styleTextField1()
        self.certificateUploadTxt.styleTextField1()
        self.imageUploadTxt.styleTextField1()
        self.imageUploadCollection.isPagingEnabled = false
       
        bioDescriTextView.layer.cornerRadius = 5
        bioDescriTextView.linkTextAttributes = [.underlineStyle: 0]
        bioDescriTextView.layer.borderColor = UIColor.clear.cgColor
        bioShadowView.layer.borderColor = UIColor.clear.cgColor
//        bioShadowView.layer.cornerRadius = 5
//        bioShadowView.clipsToBounds = false
//        bioShadowView.layer.shadowOpacity = 0.3
//        bioShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.barStyle = .default
        let specialGesture = UITapGestureRecognizer(target: self, action: #selector(self.getSpecialitiesData))
        self.specialitiesTextField.addGestureRecognizer(specialGesture)
        let languageGesture = UITapGestureRecognizer(target: self, action: #selector(self.getLanguageData))
        self.languageTextField.addGestureRecognizer(languageGesture)
        self.languageTextField.resignFirstResponder()
        let hospitalGesture = UITapGestureRecognizer(target: self, action: #selector(self.getHospitalData))
        self.hospitalTextField.addGestureRecognizer(hospitalGesture)
        
        // CertificateView
        self.certificateUploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAct(_:))))
        self.certificateUploadView.tag = 0
        self.portfolioUploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAct(_:))))
        self.portfolioUploadView.tag = 1
        
    }
    @objc func imageViewAct(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        if tag == 0 {
            self.certificateUploadTapped(certUploadBtn)
        }
        else {
            self.imageUploadTapped(imageUploadBtn)
        }
    }
    override func updateViewConstraints() {
        tableViewHeightConst.constant = tableView.contentSize.height
        if tableViewHeightConst.constant == 0 {
            self.tableView.isHidden = true
        }
        else {
            self.tableView.isHidden = false
        }
        super.updateViewConstraints()
    }
    @objc override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backBtnTappd(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func certificateUploadTapped(_ sender: UIButton)  {
        self.isCertificateUpload = true
        self.showDocumentPickerMenu(type: "1")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x != 0 {
//            scrollView.contentOffset.x = 0
//        }
    }
    
    func showDocumentPickerMenu(type:String) {
        let alertController = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: (getLanguage["file"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.picDocument()
        }))
        
        alertController.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.picPhoto()
        }))
        
        alertController.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? ""), style: .cancel, handler: nil))
        if isCertificateUpload{
            regNoTxt.resignFirstResponder()
             if self.imageModel.count < 5 {
                regNoTxt.resignFirstResponder()
                 self.present(alertController, animated: true, completion: nil)
             }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 5 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            if self.portfolioModel.count < 10{
            self.present(alertController, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 10 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
         }
       
     }
    
    //MARK: pick photo from library
    func picPhoto()  {
        if isCertificateUpload{
            regNoTxt.resignFirstResponder()
             if self.imageModel.count < 5 {
             imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 5 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            if self.portfolioModel.count < 10 {
           imagePicker.delegate = self
           imagePicker.allowsEditing = false
           imagePicker.sourceType = .photoLibrary
           imagePicker.modalPresentationStyle = .fullScreen
           self.navigationController?.present(imagePicker, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 10 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: pic document from docment drobox icloud
    func picDocument()  {
        let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeJPEG)
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.view.semanticContentAttribute = .forceRightToLeft
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.navigationController?.present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: Document picker delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        if urls.count > 0 {
            do {
                let fileData = try Data(contentsOf: urls[0])

                let fileName = urls[0].lastPathComponent
                self.createSpinnerView(self.child)
                uploadDoc(fileData: fileData, uploaddocfor: self.docuFor, uploaddoctype: urls[0].pathExtension, fileName: fileName, type: "doctor_certificates", onSuccess: {response in
                    print(response)
                    let res = JSON(response)
                    let certificateRes = ImageModel.init(fromJson: res)
                    if certificateRes.status {
                        if self.isCertificateUpload {
                            self.imageModel.append(certificateRes.result)
                            self.tableViewHeightConst.constant = 45
                            self.tableView.reloadData()
                            DispatchQueue.main.async {
                                self.updateViewConstraints()
                            }
                        }
                        else {
                            self.portfolioModel.append(certificateRes.result)
                            self.imageUploadCollection.isHidden = false
                            self.imageUploadCollection.reloadData()
                        }
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: (getLanguage["image_size"] ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.removeSpinnerView(self.child)
                }, onFailure: { failure in
                    self.removeSpinnerView(self.child)
                    let alert = UIAlertController(title: nil, message: (getLanguage["failed_upload_image"] ?? ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    //MARK: Upload document function
    func uploadDocument(fileData:Data,fileType:String,fileName:String)  {
        //   let uploadObj = UploadServices()
        
    }
    
    public func uploadDoc(fileData:Data,uploaddocfor:String,uploaddoctype:String,fileName:String, type: String, onSuccess success: @escaping (NSDictionary) -> Void, onFailure failure: @escaping (String) -> Void) {
        let BaseUrl = URL(string: ImageURL)
        print("BASE URL : \(ImageURL)")
        var parameters = ["user_id":UserDefaultModule.shared.getLoginData().userId,"type":type,"sitename":webURL] as [String : Any]
        
        if UserDefaultModule().getCurrentUserID() != nil {
            parameters["user_id"] = (UserDefaultModule().getCurrentUserID() as? String ?? "")
        }
        
        print("REQUEST : \(parameters)")
        print("data\(fileData)")
        var mime_type = String()
        if uploaddoctype == ".jpeg" {
            mime_type = "image/jpeg"
        }
        else if type == "audio" {
            mime_type = uploaddoctype
        }
        else{
            mime_type = "application/pdf"
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(fileData, withName: "images", fileName:fileName, mimeType: mime_type)
            for (key, value) in parameters {
                multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        }, to:BaseUrl!,method:.post)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    print("RESPONSE \(response)")
                    if JSON != nil {
                        success(JSON!)
                    }
                    else {
                        failure("failed")
                    }
                }
            case .failure(let error):
                print("FAILURE RESPONSE: \(error.localizedDescription)")
                if error._code == NSURLErrorTimedOut{
                    
                }else if error._code == NSURLErrorNotConnectedToInternet{
                }else{
                }
                failure(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func imageUploadTapped(_ sender: UIButton) {
        self.isCertificateUpload = false
        
        let actionSheet = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? "gallery"), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
             self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: (getLanguage["camera"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.modalPresentationStyle = .fullScreen
        if isCertificateUpload{
            regNoTxt.resignFirstResponder()
             if self.imageModel.count < 5 {
                self.present(actionSheet, animated: true, completion: nil)
             }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 5 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            if self.portfolioModel.count < 10 {
             self.present(actionSheet, animated: true, completion: nil)
            }else {
                    let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 10 image"] ?? ""), preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                   self.present(alert, animated: true, completion: nil)
             }
         }
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
         if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            let imageData = (pickedImage.resized(toWidth: 960, isOpaque: true) ?? pickedImage).jpegData(compressionQuality: 0)! as Data
            self.createSpinnerView(self.child)
            var certificateType = "portfolio"
            var picName = "portfolio.jpeg"
            if self.isCertificateUpload {
                certificateType = "doctor_certificates"
                picName = "doctorcertificate.jpeg"
            }
            
             ParsingFunction().uploadDoc(fileData: imageData, uploaddoctype: ".jpeg", fileName: picName, type: certificateType, user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                if imageModel.status {
                    if self.isCertificateUpload {
                        self.imageModel.append(imageModel.result)
                        self.tableViewHeightConst.constant = 45
                        self.tableView.reloadData()
                        DispatchQueue.main.async {
                            self.updateViewConstraints()
                        }
                    }
                    else {
                        self.portfolioModel.append(imageModel.result)
                        self.imageUploadCollection.isHidden = false
                        self.imageUploadCollection.reloadData()
                    }
                }
                else {
                    self.removeSpinnerView(self.child)
                    var message = (getLanguage["image_size"] ?? "")
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
     
    var photosURLArr = [String]()
    func uploadImage(_ image: UIImage) {
        if let img = image.fixedOrientation() {
            let imageData = img.jpegData(compressionQuality: 0.5)! as Data
            Utility().startAnimation(viewController: self)
            self.imageUploadCollection.reloadData()
            Utility().stopAnimation(viewController: self)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.portfolioModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUploadCollectionCell", for: indexPath) as! ImageUploadCollectionCell
        var imgURL = (self.portfolioModel[indexPath.row].image ?? "")
        if !(self.portfolioModel[indexPath.row].image ?? "").contains(webURL) {
            imgURL = "\(webURL)\(self.portfolioModel[indexPath.row].image ?? "")"
        }
        cell.imageViewUpload.sd_setImage(with: URL(string: imgURL), completed: nil)
        cell.imageViewUpload.contentMode = .scaleAspectFill
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(self.cancelButtonAct(_:)), for: .touchUpInside)
        return cell
    }
    @objc func cancelButtonAct(_ sender: UIButton) {
        if self.portfolioModel.count > sender.tag {
            self.portfolioModel.remove(at: sender.tag)
            self.imageUploadCollection.reloadData()
            if self.portfolioModel.count == 0 {
                self.imageUploadCollection.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.imageUploadCollection.frame.height, height: self.imageUploadCollection.frame.height)
    }
    @objc func getLanguageData(_ sender: UITapGestureRecognizer? = nil) {
        let pageObj = LanguageViewController()
        if userData.doctorLanguage.count != 0 {
            pageObj.selectedArray = userData.doctorLanguage
        }
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func getSpecialitiesData(_ sender: UITapGestureRecognizer? = nil) {
        let pageObj = SpecialitiesViewController()
        pageObj.selectedArray = self.getSpecialities
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func getHospitalData(_ sender: UITapGestureRecognizer? = nil) {
        let pageObj = HospitalSignUpPage()
         pageObj.selectedHospital = self.selectedHospital
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton)  {
        if ((languageTextField.text == "") || (regNoTxt.text == "") || (specialitiesTextField.text == "") || (skillsTxt.text == "") || (bioDescriTextView.text == "") || (hospitalTextField.text == "") || (hospitalLocationTxt.text == "")){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if  ((self.regNoTxt.text?.count)! < 3 || (self.regNoTxt.text?.count)! > 30){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "registerNo_err") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if   ((self.skillsTxt.text?.count)! < 5 || (self.skillsTxt.text?.count)! > 170){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "skill_err") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else if  ((self.bioDescriTextView.text?.count)! < 5 || (self.bioDescriTextView.text?.count)! > 500){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "bio_desc_err") as? String ?? "email_error"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let parsingObj = CallParsingFunction()
            self.createSpinnerView(self.child)
            var certificateArray = [String]()
            for val in self.imageModel {
                certificateArray.append(val.name)
            }
            var portfolioArray = [String]()
            for val in self.portfolioModel {
                portfolioArray.append(val.name)
            }
            let sArray: [String] = getSpecialities.map({"\($0.id ?? 0)"})
            if sArray.count > 0 {
                self.userData.specialitiesId = sArray.joined(separator: ", ")
            }
            
            let lan: [String] = self.userData.doctorLanguage.map({("\($0.id ?? 0)")})
            let languageArray = lan
            self.view.endEditing(true)
            parsingObj.doctorsignUp(full_name: self.userData.firstName, email: self.userData.email, gender: self.userData.gender, password: userData.password, qualification: self.userData.qualification, location_id: "\(self.selectedLocation?.id ?? 0)", speciality_id: Utility.shared.jsonString(from: sArray), doctor_language: Utility.shared.jsonString(from: languageArray), register_number: self.regNoTxt.text!, certification_upload: Utility.shared.jsonString(from: certificateArray), portfolio_images: Utility.shared.jsonString(from: portfolioArray), skills: self.skillsTxt.text!, language: Utility.shared.getLanguageCode(), country: (self.country == "" ? (Locale.current.regionCode ?? "IN") : self.country), phone_number: self.userData.phoneNumber, hospital_id: "\(self.selectedHospital?.id ?? 0)", bio_description: self.bioDescriTextView.text!, profileImage: (self.userData.userImage ?? ""),type:"doctor",currency_code: self.currency_code, institute_name: "\(self.userData.institute ?? "")", onSuccess: {
                response in
                print(response)
                self.doctorDetailDict.addEntries(from: response as! [AnyHashable : Any])
                self.removeSpinnerView(self.child)
                let alert = UIAlertController(title: "SignUp", message: getLanguage[(self.doctorDetailDict.object(forKey: "message") as? String ?? "")] ?? (self.doctorDetailDict.object(forKey: "message") as? String ?? ""), preferredStyle: .alert)
                let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                    if(self.doctorDetailDict.object(forKey: "status") as! String == "true")
                    {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.setInitialViewController(initialView: DoctorSignInPage())
                    }else{
                    }
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                
            }, onFailure: {errorResponse in
                self.removeSpinnerView(self.child)
                Utility().stopAnimation(viewController: self)
                print(errorResponse ?? "Error")
            })
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.containsEmoji {
            return false
        }
        if textField == skillsTxt{
            let maxLength = 170
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.containsEmoji{
            return false
        }
        
        if textView == bioDescriTextView {
            let maxLength = 500
            let currentString: NSString = (textView.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let inte: Int = Int(CInt(textField.text!)!)
        
        if textField == regNoTxt{
            if inte < 30 && inte > 3 {
                return false
            }
        }
        return true
        
    }
    //     func textViewDidBeginEditing(_ textView: UITextView) {
    //         textView.text = ""
    //     }
 }
 extension CertificateSignUpPage: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if bioDescriTextView.text == "" {
            self.descTitleLabel.isHidden = false
        }
        else {
            self.descTitleLabel.isHidden = true
        }
    }
 }
 extension CertificateSignUpPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        self.tableView.isHidden = false
        return self.imageModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadCertificateTableViewCell") as! UploadCertificateTableViewCell
        cell.docNameLabel.text = self.imageModel[indexPath.row].name
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(self.certificateCancelAct(_:)), for: .touchUpInside)
        return cell
    }
    @objc func certificateCancelAct(_ sender: UIButton) {
        if self.imageModel.count > sender.tag {
            self.imageModel.remove(at: sender.tag)
        }
        self.tableView.reloadData()
        DispatchQueue.main.async {
            self.updateViewConstraints()
        }
    }
 }
 extension CertificateSignUpPage: Select_Language{
    func addLanguage(_ language: [LanguageModel]){
        userData.doctorLanguage = language
        let dArray: [String] = language.map({($0.lname ?? "")})
        self.languageTextField.text = dArray.joined(separator: ", ")
    }
    func addSpecialities(_ specialities: [LanguageModel]) {
        getSpecialities = specialities
        if getSpecialities.count > 0 {
            let sArray: [String] = getSpecialities.map({$0.name ?? ""})
            self.specialitiesTextField.text = sArray.joined(separator: ", ")
        }
        else {
            self.specialitiesTextField.text = ""
        }
    }
    
    func addHospitalDetails(_ hospital: HospitalResultModel, location: LocationModel) {
//        country
        self.selectedHospital = hospital
        self.selectedLocation = location
        Utility.shared.startAnimation(viewController: self)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.selectedLocation?.location ?? "") { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        self.hospitalTextField.text = hospital.name
        self.hospitalLocationTxt.text = location.location
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
    func addHospitalName(_ hospitalName: String){
        //        self.getHospitalName = hospitalName
        //        self.hospitalTextField.text = self.getHospitalName
    }
    func passLocation(_ location: String){
        //        self.getHospitalLocation = location
        //        hospitalLocationTxt.text = getHospitalLocation
    }
    func getLocId (_ getLocationId : String){
        //        self.locationId = getLocationId
    }
 }
 
