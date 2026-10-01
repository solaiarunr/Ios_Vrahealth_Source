//
//  UploadImageViewController.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit
import PhotosUI



protocol imageuploadDelegate {
    func imageAct(_ image: [UIImage])
}
class UploadImageViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var imageCV: UICollectionView!
    
    
    var delegate: imageuploadDelegate?
    
    let imagePicker = UIImagePickerController()
    var imgType = String()
    var imagearray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.configUI()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    func configUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "upload_image") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.headerLbl.config(color: UIColor(named: "appblackcolor"), font: fontRegular16, align: .left, text: "attach_the_file_below")
       
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.saveBtn.backgroundColor = (UIColor(named: "AppColor") ?? .white)
        self.saveBtn.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "save")
        self.saveBtn.viewRadius(radius: 5)
        self.imagePicker.delegate = self
        
        self.imageCV.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        self.imageCV.delegate = self
        self.imageCV.dataSource = self
        self.imageCV.reloadData()
        
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
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        if self.imagearray.count != 0 {
            self.delegate?.imageAct(self.imagearray)
            self.navigationController?.popViewController(animated: true)
            
            
        }else {
            
            let alert = UIAlertController(title: nil, message: getLanguage["please upload the image"] ?? "please upload the image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func imageUploadBtntapped(_ sender: Any) {
        if self.imagearray.count >= 20 {
            let alert = UIAlertController(title: nil, message: getLanguage["cant upload more than 20 image"] ?? "cant upload more than 20 image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: getLanguage["take_photo"] ?? "take_photo", style: .default, handler: { _ in
                self.chooseFromCamera()
            }))
            alert.addAction(UIAlertAction(title: getLanguage["choose_photo"] ?? "choose_photo", style: .default, handler: { _ in
                let photos = PHPhotoLibrary.authorizationStatus()
                   
                        PHPhotoLibrary.requestAuthorization({status in
                            if status == .authorized{
                                self.chooseFromGallery()
                            } else {
                                
                            }
                        })
                    }))
            alert.addAction(UIAlertAction.init(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func chooseFromGallery(){
        if #available(iOS 14, *) {
            DispatchQueue.main.async {
                var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                config.filter = .images
                config.selectionLimit = 1
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                picker.modalPresentationStyle = .overFullScreen
                self.present(picker, animated: true, completion: nil)
            }
           
        } else {
            // Fallback on earlier version
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .overFullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func chooseFromCamera(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            self.moveToCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.moveToCamera()
                } else {
                    //access denied
                    DispatchQueue.main.async {
                        self.cameraPermissionAlert()
                    }
                }
            })
        }
    }
    
    func moveToCamera(){
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .overFullScreen
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    func cameraPermissionAlert()  {
        DispatchQueue.main.async {
            let otherAlert = UIAlertController(title: nil, message: getLanguage["camera_permission"], preferredStyle: UIAlertController.Style.alert)
            let dismiss = UIAlertAction(title: getLanguage["cancel"], style: UIAlertAction.Style.cancel, handler: nil)
            otherAlert.addAction(dismiss)
            let setting = UIAlertAction(title: getLanguage["setting"], style: UIAlertAction.Style.default, handler:self.goSetting(alert:))
            otherAlert.addAction(setting)
            UIApplication.shared.keyWindow?.rootViewController!.present(otherAlert, animated: true, completion: nil)
        }
    }
    func goSetting(alert: UIAlertAction){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    

}
extension UploadImageViewController: PHPickerViewControllerDelegate,UIImagePickerControllerDelegate {
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    //            imgType
                
                
                 self.imgType = ".png"
                    if let url = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.imageURL.rawValue)] as? URL {
                     self.imgType = url.pathExtension
                 }
                                    
                picker.dismiss(animated: true, completion: nil)
                if let img = image.fixedOrientation(){
                    self.imagearray.append(img)
                    self.imageCV.reloadData()
                }else{
                    self.imagearray.append(image)
                    self.imageCV.reloadData()
                }
                
            }
            
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        picker.dismiss(animated:true) {
            guard let result = results.first else { return }
            if let ident = result.assetIdentifier {
                let result1 = PHAsset.fetchAssets(withLocalIdentifiers: [ident], options: nil)
                if result1.firstObject != nil {
                    let provider = result.itemProvider
                    if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { (image, error) in

                            self.imgType = ".png"

                            DispatchQueue.main.async {
                                if let image = image as? UIImage {
                                    if let img = image.fixedOrientation(){
                                        self.imagearray.append(img)
                                        self.imageCV.reloadData()
                                    }else{
                                        self.imagearray.append(image)
                                        self.imageCV.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    
                }
            }
            else {
                print("Error Error Error Error")
            }
        }
        
    }
    
}
extension UploadImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagearray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.loadimage(image: self.imagearray[indexPath.row])
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(self.ButtonAct(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func ButtonAct(_ sender: UIButton) {
        self.imagearray.remove(at: sender.tag)
        self.imageCV.reloadData()
    }
    
   
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.imageCV.frame.width - 32) / 4, height: 100)
    }
}


