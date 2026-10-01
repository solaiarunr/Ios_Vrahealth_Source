//
//  AddPrescriptionViewController.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 07/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class AddPrescriptionViewController: UIViewController {
    
    
    
    
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var uplaodimageLbl: UILabel!
    @IBOutlet weak var uploaddigitalprescriptionLbl: UILabel!
    @IBOutlet weak var uplaodimageView: UIImageView!
    @IBOutlet weak var digitalimageView: UIImageView!
    
    var imagearray = [UIImage]()
    var files : filesModel?
    var listmodel = [medicineListModel]()
    var booking_id = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.view.addSubview(indicatorView)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "add_Prescription") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
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
        
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.submitBtn.backgroundColor = (UIColor(named: "TextCustomColor") ?? .white)
        self.submitBtn.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "send_patient")
        self.submitBtn.viewRadius(radius: 5)
        self.uplaodimageLbl.config(color: UIColor(named: "appblackcolor"), font: fontSemi14, align: .left, text: "upload_image")
        self.uploaddigitalprescriptionLbl.config(color: UIColor(named: "appblackcolor"), font: fontSemi14, align: .left, text: "digital_prescription")
        self.submitBtn.isUserInteractionEnabled = false
        
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
    
    @IBAction func uploadimageBtnTapped(_ sender: Any) {
        let pageObj = UploadImageViewController()
        pageObj.delegate = self
        pageObj.imagearray = self.imagearray
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func submitBtntapped(_ sender: Any) {
//        if imagearray.count == 0 && self.files == nil {
//            let alert = UIAlertController(title: nil, message: getLanguage["fill_fields"] ?? "fill_fields", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
//                
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }else {
        
        Utility.shared.startAnimation(viewController: self)
            let encodedData = try! JSONEncoder().encode(self.files)
                let jsonString = String(data: encodedData,
                                        encoding: .utf8)
            let newString = (jsonString! as NSString).replacingOccurrences(of: "\\", with: "")
            print("varientstring: \(String(describing: newString))")
            let requestDict = NSMutableDictionary()
            requestDict.setValue(UserDefaultModule.shared.getLoginData().userId, forKey: "user_id")
            requestDict.setValue("doctor", forKey: "type")
            requestDict.setValue(Utility.shared.getLanguageCode(), forKey: "language")
            requestDict.setValue(self.booking_id, forKey: "booking_id")
        if self.files != nil {
            requestDict.setValue(newString, forKey: "files")
        }else {
            requestDict.setValue("", forKey: "files")
        }
            
            print("request Data \(requestDict)")
        var jpegdata = [Data]()
        print("JPEGDATA:\(jpegdata)")
        if self.imagearray.count != 0 {
            if self.imagearray.count != 0 {
                for i in 0...self.imagearray.count - 1 {
                    jpegdata.append(self.imagearray[i].jpegData(compressionQuality: 0.1)!)
                }
            }
        }
            
            ParsingFunction().uploadprescription(fileData: jpegdata, uploaddoctype: ".jpeg",params: requestDict as! [String : Any], onSuccess: { (PrescriptionModel) in
               if PrescriptionModel.status == "true" {
                   Utility.shared.stopAnimation(viewController: self)
                   let alert = UIAlertController(title: nil, message: getLanguage["add_prescription_successfully"] ?? "add_prescription_successfully", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                       let pageObj = compleReviewViewController()
                       pageObj.booking_id = self.booking_id
                       pageObj.status = ""
                       pageObj.delegate = self
                       pageObj.modalPresentationStyle = .overCurrentContext
                       self.present(pageObj, animated: true)
                   }))
                   self.present(alert, animated: true, completion: nil)
               }
               else {
                   Utility.shared.stopAnimation(viewController: self)
               }

           })
           { failure in
               Utility.shared.stopAnimation(viewController: self)
               let alert = UIAlertController(title: nil, message: (getLanguage["failed_upload_image"] ?? ""), preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
        //}
    }
    
    
    
    
    @IBAction func digitalimageBtnTapped(_ sender: Any) {
        let pageObj = DigitalPrescriptionViewController()
        pageObj.delegate = self
        pageObj.files = self.files
        pageObj.listModel = self.listmodel
        self.navigationController?.pushViewController(pageObj, animated: true)
    }

   
    

}

extension AddPrescriptionViewController: imageuploadDelegate {
    func imageAct(_ image: [UIImage]) {
        self.imagearray = image
        self.uplaodimageView.image = UIImage(named: "image_active")
        if imagearray.count != 0 {
            self.submitBtn.isUserInteractionEnabled = true
            self.submitBtn.backgroundColor = (UIColor(named: "primary") ?? .white)
        }
    }
}

extension AddPrescriptionViewController: filesDelegate {
    func fileAct(_ files: filesModel?, list: [medicineListModel]) {
        print("files:\(files) list:\(list)")
        

        self.listmodel = list
        self.files = files
        self.files?.medicine_details = list
        let encodedData = try! JSONEncoder().encode(self.files)
            let jsonString = String(data: encodedData,
                                    encoding: .utf8)
        let newString = (jsonString! as NSString).replacingOccurrences(of: "\\", with: "")
        print("varientstring1234: \(String(describing: newString))")
        self.digitalimageView.image = UIImage(named: "digital_active")
        if self.files != nil {
            self.submitBtn.isUserInteractionEnabled = true
            self.submitBtn.backgroundColor = (UIColor(named: "primary") ?? .white)
        }
    }
}

extension AddPrescriptionViewController: dismissDelegate {
    
    func dismissAct() {
        self.navigationController?.popViewController(animated: true)
    }
}

