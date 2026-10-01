//
//  ViewPrescriptionController.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 03/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit
import WebKit

class ViewPrescriptionController: UIViewController {
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var noResultStackView: UIStackView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var openType = ""
    var type = ""
    var booking_id = ""
    var viewModel = ViewPrescriptionViewModel()
    var prescriptionListModel = [ViewPrescriptionResultModel]()
    var fileUrl = ""
    var prescriptionAdd = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.configUI()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.collectionView.register(UINib(nibName: "ViewImageCell", bundle: nil), forCellWithReuseIdentifier: "ViewImageCell")
        
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
        self.webView.navigationDelegate = self
        self.webView.isHidden = true
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "view_prescription") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.customRightBarButtonView2(title:  "", fColor: "white", fontName: fontRegular16, imageName: "download_icon", isLeft: false, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.addBtn.backgroundColor = (UIColor(named: "AppColor") ?? .white)
        self.addBtn.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "add_Prescription")
        self.addBtn.viewRadius(radius: 5)
        if self.type == "doctor" {
            if self.prescriptionAdd == "true"{
                self.bottomView.isHidden = true
            }else{
                self.bottomView.isHidden = false
            }
        }else {
            self.bottomView.isHidden = true
        }
        self.updateNoResultUI()
        self.loadData()
        
    }
    
    func updateNoResultUI() {
        self.noResultStackView.isHidden = true
        self.noResultLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular16, align: .center, text: "no_prescription")
    }
    
    func loadData() {
            Utility.shared.startAnimation(viewController: self)
            self.noResultStackView.isHidden = true
            self.viewModel.getviewPrescriptionList(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), booking_id: self.booking_id, type: self.type) { (success) in
                if ((self.viewModel.prescriptionListModel?.result.count ?? 0) == 0) {
                    self.noResultStackView.isHidden = false
                }
                else {
                    self.prescriptionListModel.removeAll()
                    self.prescriptionListModel += (self.viewModel.prescriptionListModel?.result)!
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                }
                Utility.shared.stopAnimation(viewController: self)
                
                
            } onFailure: { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
       
    }
    
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        
        if self.openType == "document" {
            if let isLeft = notification.userInfo?["isLeft"] as? Int {
                print(isLeft)
                if isLeft == 0 {
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.webView.isHidden = true
                        self.openType = ""
                        self.navigationController?.customRightBarButtonView2(title:  "", fColor: "white", fontName: fontRegular16, imageName: "download_icon", isLeft: false, vc: self, transparantView: false)
                    })
                }else {
                    let url = URL(string: self.fileUrl)
                    ViewPrescriptionController.loadFileAsync(url: url!) { (path, error) in
                    DispatchQueue.main.async {
                        print("PDF File downloaded to : \(path!)")
                        let alert = UIAlertController(title: nil, message: "download the file successfully", preferredStyle: UIAlertController.Style.alert)
                        
                        
                        
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil))
                        
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                }
            }
            
        } else {
            if let isLeft = notification.userInfo?["isLeft"] as? Int {
                print(isLeft)
                if isLeft == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let pageObj = AddPrescriptionViewController()
        pageObj.booking_id = self.booking_id
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    
    
        
    }
    


extension ViewPrescriptionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prescriptionListModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewImageCell", for: indexPath) as! ViewImageCell
        cell.nameLbl.text = "\(Utility().language().value(forKey: "prescription") as? String ?? "")" + " " + "\(indexPath.row + 1)"
        cell.loaddata(model: self.prescriptionListModel[indexPath.row])
        cell.imageBtn.tag = indexPath.row
        cell.imageBtn.addTarget(self, action: #selector(self.ButtonAct(_:)), for: .touchUpInside)
        cell.digitalBtn.tag = indexPath.row
        cell.digitalBtn.addTarget(self, action: #selector(self.digitalButtonAct(_:)), for: .touchUpInside)
        return cell
    }
    @objc func ButtonAct(_ sender: UIButton) {
        self.openType = "document"
        var URLString = ""
        var thePrescriptionmodel = self.prescriptionListModel[sender.tag]
        
        if thePrescriptionmodel.digital_prescription_url == "" && thePrescriptionmodel.image_precription_url != "" {
            URLString = self.prescriptionListModel[sender.tag].image_precription_url
        }else if thePrescriptionmodel.digital_prescription_url != "" && thePrescriptionmodel.image_precription_url == "" {
            URLString = self.prescriptionListModel[sender.tag].digital_prescription_url
        }else if thePrescriptionmodel.digital_prescription_url != "" && thePrescriptionmodel.image_precription_url != "" {
            URLString = self.prescriptionListModel[sender.tag].image_precription_url
        }
        
//        if self.prescriptionListModel[sender.tag].image_precription_url == "" {
//            URLString = self.prescriptionListModel[sender.tag].digital_prescription_url
//        }else if self.prescriptionListModel[sender.tag].digital_prescription_url == ""{
//            URLString = self.prescriptionListModel[sender.tag].image_precription_url
//        }else {
//            URLString = self.prescriptionListModel[sender.tag].image_precription_url
//        }
        
        if let url = URL(string: URLString) {
            let fileExtension = url.pathExtension
        
        Utility.shared.startAnimation(viewController: self)
        self.webView.isHidden = false
        self.fileUrl = URLString
        self.webView.load(URLRequest(url: url))
            if self.type != "doctor" {
                self.navigationController?.customRightBarButtonView(title:  "", fColor: "White", fontName: fontRegular16, imageName: "download_icon", isLeft: false, vc: self, transparantView: false)
            }
        }
    }
    
    @objc func digitalButtonAct(_ sender: UIButton) {
        self.openType = "document"
       
        if let url = URL(string: self.prescriptionListModel[sender.tag].digital_prescription_url) {
            let fileExtension = url.pathExtension
            
            Utility.shared.startAnimation(viewController: self)
            self.webView.isHidden = false
            self.fileUrl = self.prescriptionListModel[sender.tag].digital_prescription_url
            self.webView.load(URLRequest(url: url))
            
            if self.type != "doctor" {
                
                self.navigationController?.customRightBarButtonView(title:  "", fColor: "White", fontName: fontRegular16, imageName: "download_icon", isLeft: false, vc: self, transparantView: false)
            
        }
    }


                    
        }
  

static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
{
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var n = Int.random(in: 1...1000)
    let destinationUrl = documentsUrl.appendingPathComponent("\(url.lastPathComponent)\(n).pdf")

    if FileManager().fileExists(atPath: destinationUrl.path)
    {
        
        print("File already exists [\(destinationUrl.path)]")
        completion(destinationUrl.path, nil)
    }
    else
    {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler:
        {
            data, response, error in
            if error == nil
            {
                if let response = response as? HTTPURLResponse
                {
                    if response.statusCode == 200
                    {
                        if let data = data
                        {
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                            {
                                completion(destinationUrl.path, error)
                                
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                        else
                        {
                            completion(destinationUrl.path, error)
                        }
                    }
                }
            }
            else
            {
                completion(destinationUrl.path, error)
            }
        })
        task.resume()
    }
}
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 280)
    }
}

extension ViewPrescriptionController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.shared.stopAnimation(viewController: self)
    }
}
