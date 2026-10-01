//
//  DocumentUploadViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 19/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import  Photos
import PhotosUI
import MobileCoreServices
import Alamofire
import WebKit
import QuickLook

protocol uploadDelegate {
    func updateDocumentData(_ isCertificateUpload: Bool, imageArray: [ImageResultModel])
}

class DocumentUploadViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    
    var imageModel = [ImageResultModel]()
    var isCertificateView = false
    var imagePicker = UIImagePickerController()
    let child = SpinnerViewController()
    var delegate: uploadDelegate?
    var fileFormat = ["JPEG", "jpeg", "PNG", "png", "gif", "GIF", "JPG", "jpg"]
    let previewController = QLPreviewController()
    var previewItems: [PreviewItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        if self.isCertificateView {
            self.titleLabel.config(color: UIColor(named: "TitleColor"), font: tableHeaderFont, align: .left, text: "certifiction_upload")
        }
        else {
            self.titleLabel.config(color: UIColor(named: "TitleColor"), font: tableHeaderFont, align: .left, text: "portfolio upload")
        }
        self.fileLabel.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .center, text: "file_upload")
        self.applyBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "save")
        self.tableView.register(UINib(nibName: "UploadCertificateTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadCertificateTableViewCell")
        self.collectionView.register(UINib(nibName: "ImageUploadCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageUploadCollectionCell")
        self.imagePicker.delegate = self
        self.shadowView.elevationEffect()
        self.tableView.reloadData()
        self.webView.navigationDelegate = self
        self.webView.isHidden = true
        // Certificate Upload Gesture
        self.shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.uploadAct(_:))))
        if self.isCertificateView {
            self.tableView.isHidden = false
        }
        else {
            self.tableView.isHidden = true
        }
    }
    @objc func uploadAct(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "", message: (getLanguage["Choose a source"] ?? ""), preferredStyle: .actionSheet)
        if self.isCertificateView {
            alertController.addAction(UIAlertAction(title: (getLanguage["file"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
                self.picDocument()
            }))
        }
        else {
            alertController.addAction(UIAlertAction(title: (getLanguage["camera"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
                self.imagePicker.sourceType = .camera
//                self.navigationC
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
             }))
        }
        alertController.addAction(UIAlertAction(title: (getLanguage["gallery"] ?? ""), style: .default, handler: { (action:UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if (self.isCertificateView && self.imageModel.count >= 5) || (!self.isCertificateView && self.imageModel.count >= 10){
            var message = "Can't upload more than 10 certificates"
            if (self.isCertificateView && self.imageModel.count >= 5) {
                message = "cant upload more than 5 image"
            }
            let errorAlert = UIAlertController(title: nil, message: (getLanguage[message] ?? message), preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? "OK"), style: .cancel, handler: { (alertAction) in
            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
        else {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        self.delegate?.updateDocumentData(isCertificateView, imageArray: self.imageModel)
        self.navigationController?.popViewController(animated: true)
     }
    
    //MARK: pic document from docment drobox icloud
    func picDocument()  {
        let types: NSArray = NSArray.init(objects: kUTTypePDF,kUTTypeJPEG)
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as! [String], in: .import)
        documentPicker.view.semanticContentAttribute = .forceLeftToRight
        for subview in documentPicker.view.subviews {
            subview.semanticContentAttribute = .forceLeftToRight
        }
        documentPicker.delegate = self
//        documentPicker.modalPresentationStyle = .formSheet
        self.navigationController?.present(documentPicker, animated: true, completion: nil)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                if !self.webView.isHidden {
                    self.webView.isHidden = true
                }
                else{
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
    override func updateViewConstraints() {
        if tableView.contentSize.height < (self.view.frame.height - 280) {
            tableViewHeightConst.constant = tableView.contentSize.height + 10
            self.tableView.isScrollEnabled = false
        }
        else {
            tableViewHeightConst.constant = (self.view.frame.height - 280)
            self.tableView.isScrollEnabled = true
        }
        super.updateViewConstraints()
    }
}
extension DocumentUploadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isCertificateView ? self.imageModel.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadCertificateTableViewCell") as! UploadCertificateTableViewCell
        cell.selectionStyle = .none
        cell.docNameLabel.text = self.imageModel[indexPath.row].name
        cell.cancelButton.imageView?.tintColor = UIColor(named: "TitleColor")
        if self.imageModel[indexPath.row].isNew == true {
            cell.cancelButton.setImage(#imageLiteral(resourceName: "close_icon"), for: .normal)
        }
        else {
            cell.cancelButton.setImage(#imageLiteral(resourceName: "uploadCertificate"), for: .normal)
        }
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(self.certificateCancelAct(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Hii
         var img_url = self.imageModel[indexPath.row].image ?? ""
        if !img_url.contains("http") {
            img_url = "\(webURL)\(img_url)"
        }
        if let url = URL(string: img_url) {
            let fileExtension = url.pathExtension
//            let filePath = url.lastPathComponent
            if fileFormat.contains(fileExtension) {
                let pageObj = FullImageViewController()
                pageObj.imageModel = self.imageModel
                pageObj.selectedIndex = indexPath.row
                pageObj.isFromCertificate = true
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                Utility.shared.startAnimation(viewController: self)
                self.webView.isHidden = false
                self.webView.load(URLRequest(url: url))
//                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    documentsURL.appendPathComponent(filePath)
//                    return (documentsURL, [.removePreviousFile])
//                }
//                Alamofire.download(url, to: destination).responseJSON { (response) in
//                    if response.result.isSuccess, let imagePath = response.destinationURL {
//                        var imageURL = imagePath
//                        imageURL.hasHiddenExtension = true
//                        let previewItem = PreviewItem()
//                        previewItem.previewItemURL = imageURL
//                        self.previewItems.append(previewItem)
//                        DispatchQueue.main.async {
//                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                            self.previewController.delegate = self
//                            self.previewController.dataSource = self
//                            self.previewController.currentPreviewItemIndex = 0
//                            self.present(self.previewController, animated: true)
//                         }
//                        Utility.shared.stopAnimation(viewController: self)
//                    }
//                    else {
//                        self.webView.isHidden = false
//                        self.webView.load(URLRequest(url: url))
//                    }
//                }
            }
        }
        
    }
    @objc func certificateCancelAct(_ sender: UIButton) {
        if self.imageModel.count > sender.tag {
            if self.imageModel[sender.tag].isNew {
                self.imageModel.remove(at: sender.tag)
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.updateViewConstraints()
                }
            }
            else {
                self.tableView(self.tableView, didSelectRowAt: IndexPath(row: sender.tag, section: 0))
            }
        }

    }
}
extension DocumentUploadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !isCertificateView ? self.imageModel.count : 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUploadCollectionCell", for: indexPath) as! ImageUploadCollectionCell
        if !(self.imageModel[indexPath.row].image ?? "").contains(webURL) {
            cell.imageViewUpload.sd_setImage(with: URL(string: "\(webURL)\(self.imageModel[indexPath.row].image ?? "")")) { (image, error, cache, url) in
                if error != nil {
                    cell.imageViewUpload.image = #imageLiteral(resourceName: "sheeticon")
                }
            }
        }
        else {
            cell.imageViewUpload.sd_setImage(with: URL(string: (self.imageModel[indexPath.row].image ?? ""))) { (image, error, cache, url) in
                if error != nil {
                    cell.imageViewUpload.image = #imageLiteral(resourceName: "sheeticon")
                }
            }
        }
        cell.imageViewUpload.contentMode = .scaleAspectFill
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(self.cancelButtonAct(_:)), for: .touchUpInside)
        return cell
    }
    @objc func cancelButtonAct(_ sender: UIButton) {
        if self.imageModel.count > sender.tag {
            self.imageModel.remove(at: sender.tag)
            self.collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageObj = FullImageViewController()
        pageObj.imageModel = self.imageModel
        pageObj.selectedIndex = indexPath.row
        pageObj.isFromCertificate = true
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height, height: self.collectionView.frame.height)
    }
}
extension DocumentUploadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIDocumentPickerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            let imageData = pickedImage.jpegData(compressionQuality: 0)! as Data // (pickedImage.resized(toWidth: 960, isOpaque: true) ?? pickedImage)
            self.createSpinnerView(self.child)
            var certificateType = "portfolio"
            if self.isCertificateView {
                certificateType = "doctor_certificates"
            }

            ParsingFunction().uploadDoc(fileData: imageData, uploaddoctype: ".jpeg", fileName: "profilepic.jpeg", type: certificateType, user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                if imageModel.status {
                    imageModel.result.isNew = true
                    self.imageModel.append(imageModel.result)
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
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
                DispatchQueue.main.async {
                    self.updateViewConstraints()
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK: Document picker delegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // you get from the urls parameter the urls from the files selected
        if urls.count > 0 {
            do {
                let fileData = try Data(contentsOf: urls[0])
                let fileName = urls[0].lastPathComponent
                self.createSpinnerView(self.child)
                ParsingFunction().uploadDoc(fileData: fileData, uploaddoctype: urls[0].pathExtension, fileName: fileName, type: "doctor_certificates", user_id: UserDefaultModule.shared.getLoginData().userId, onSuccess: { (imageModel) in
                    if imageModel.status {
                        imageModel.result.isNew = true
                        self.imageModel.append(imageModel.result)
                        self.tableView.reloadData()
//                        self.collectionView.reloadData()
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
                }) { (failure) in
                    self.removeSpinnerView(self.child)
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    //MARK: Upload document function
    func uploadDocument(fileData:Data,fileType:String,fileName:String)  {
        //   let uploadObj = UploadServices()
        
    }
}
extension DocumentUploadViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.shared.stopAnimation(viewController: self)
    }
}
extension DocumentUploadViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItems.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        previewItems[index]
    }
    
    
}
extension URL {
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
class PreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
