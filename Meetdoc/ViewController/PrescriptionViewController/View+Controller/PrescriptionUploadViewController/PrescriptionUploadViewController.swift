//
//  PrescriptionUploadViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 01/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import Alamofire
import MobileCoreServices
import ValidationComponents
import SwiftyJSON

class PrescriptionUploadViewController: UIViewController, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveBgView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prescriptionUploadButton: UIButton!
    @IBOutlet weak var prescriptionUploadText: UITextField!
    @IBOutlet weak var prescriptionUploadView: UIView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isPrescriptionUpload = false
    var imageModel = [ImageResultModel]()
    var imagePicker = UIImagePickerController()
    var certificateType = ""
    var picName = ""
    var bookingID = ""
    let child = SpinnerViewController()
    var docuFor = String()
    var imageArray : [String]=[String]()
    var imageName = ""
    var viewModel = PrescriptionViewModel()
    var prescriptionResultModel = PrescriptionResultModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "doctot_handwritting") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.saveBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "save")
        self.prescriptionUploadText.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "prescription_upload", Font: fontRegular16, setBorder: true)
        self.prescriptionUploadText.styleTextField()
        self.prescriptionUploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAct(_:))))
        self.tableView.register(UINib(nibName: "UploadPrescriptionCell", bundle: nil), forCellReuseIdentifier: "UploadPrescriptionCell")
        self.saveBgView.layer.shadowColor = UIColor.gray.cgColor
        self.saveBgView.layer.shadowRadius = 0.2
        self.saveBgView.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.saveBgView.layer.shadowOpacity = 0.2
        self.saveBgView.alpha = 0.9
        self.saveBgView.layer.masksToBounds = false
    }
        
    override func updateViewConstraints() {
        self.tableViewHeightConst.constant = self.tableView.contentSize.height
        if self.tableViewHeightConst.constant == 0 {
            self.tableView.isHidden = true
        }
        else {
            self.tableView.isHidden = false
        }
        super.updateViewConstraints()
    }
    @objc func imageViewAct(_ sender: UITapGestureRecognizer) {
            self.prescriptionUploadButtonAct(prescriptionUploadButton)
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
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    
    
    @IBAction func prescriptionUploadButtonAct(_ sender: UIButton) {
        self.isPrescriptionUpload = true
        self.showDocumentPickerMenu()
    }
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
        if self.imageArray.count == 0{
            let alert = UIAlertController(title: nil, message: getLanguage["no_image"] ?? "no_image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (UIAlertAction) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.viewModel.AddPrescription(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), booking_id: self.bookingID, medicine_name: "", drug_strength: "", frequency: "", duration: "", route: "", direction: "", instruction: "", prescription_id: self.prescriptionResultModel.id,type: "handwritten",prescription_image:"\(self.imageArray)" ) { (success) in
                Utility.shared.stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: (getLanguage[(self.viewModel.addPrescriptionModel?.message ?? "")] ?? (self.viewModel.addPrescriptionModel?.message ?? "")), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                    let status = self.viewModel.addPrescriptionModel?.status ?? ""
    //                if  status == "true"{
    //                    self.navigationController?.popViewController(animated: true)
    //                }
                    
                }))
                self.present(alert, animated: true, completion: nil)
            } onFailure: { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
    }
    
    func showDocumentPickerMenu() {
        let alertController = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: (getLanguage["camera"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.picCamera()
        }))
        
//        alertController.addAction(UIAlertAction(title: (getLanguage["file"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
//            self.picDocument()
//        }))
        
        alertController.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.picPhoto()
        }))
        
        alertController.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? ""), style: .cancel, handler: nil))
             if self.imageModel.count < 10 {
                 self.present(alertController, animated: true, completion: nil)
             }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 10 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
     }
    func picCamera(){
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .camera
        self.imagePicker.modalPresentationStyle = .fullScreen
        self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func picDocument()  {
        let types: NSArray = NSArray.init(objects: kUTTypeJPEG)
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.view.semanticContentAttribute = .forceRightToLeft
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.navigationController?.present(documentPicker, animated: true, completion: nil)
    }
    func picPhoto()  {
      if self.imageModel.count < 10 {
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: nil, message: (getLanguage["cant upload more than 10 image"] ?? ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            if let img = pickedImage.fixedOrientation(){
                let imageData = (img.resized(toWidth: 960, isOpaque: true) ?? pickedImage).jpegData(compressionQuality: 0)! as Data
                self.createSpinnerView(self.child)
                certificateType = "prescription"
                picName = "Prescription.jpeg"
                
                ParsingFunction().uploadDoc(fileData: imageData, uploaddoctype: ".jpeg", fileName: picName, type: certificateType, user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                    if imageModel.status {
                        self.imageModel.append(imageModel.result)
                        self.imageArray.append(imageModel.result.name)
                        self.tableViewHeightConst.constant = 45
                        self.tableView.reloadData()
                        DispatchQueue.main.async {
                            self.updateViewConstraints()
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
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        if urls.count > 0 {
            do {
                let fileData = try Data(contentsOf: urls[0])

                let fileName = urls[0].lastPathComponent
                self.createSpinnerView(self.child)
                uploadDoc(fileData: fileData, uploaddocfor: self.docuFor, uploaddoctype: urls[0].pathExtension, fileName: fileName, type: "prescription", onSuccess: {response in
                    print(response)
                    let res = JSON(response)
                    let certificateRes = ImageModel.init(fromJson: res)
                    if certificateRes.status {
                        if self.isPrescriptionUpload {
                            self.imageModel.append(certificateRes.result)
                            self.tableViewHeightConst.constant = 45
                            self.tableView.reloadData()
                            DispatchQueue.main.async {
                                self.updateViewConstraints()
                            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PrescriptionUploadViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //        self.tableView.isHidden = false
       return self.imageModel.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "UploadPrescriptionCell") as! UploadPrescriptionCell
       cell.PrescriptionNameLabel.text = self.imageModel[indexPath.row].name
       cell.cancelButton.tag = indexPath.row
       cell.cancelButton.addTarget(self, action: #selector(self.certificateCancelAct(_:)), for: .touchUpInside)
       return cell
   }
   @objc func certificateCancelAct(_ sender: UIButton) {
       if self.imageModel.count > sender.tag {
           self.imageModel.remove(at: sender.tag)
           self.imageArray.remove(at: sender.tag)
       }
       self.tableView.reloadData()
       DispatchQueue.main.async {
           self.updateViewConstraints()
       }
   }
}
