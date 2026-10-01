//
//  DigitalPrescriptionViewController.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

protocol filesDelegate {
    func fileAct(_ files: filesModel?, list:[medicineListModel])
}

class DigitalPrescriptionViewController: UIViewController, medicineDelegate {
   
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var symptomstextField: UITextField!
    @IBOutlet weak var provisionaldignosistextField: UITextField!
    @IBOutlet weak var clinicaldetailstextField: UITextField!
    @IBOutlet weak var investigationtextField: UITextField!
    @IBOutlet weak var symptomsLbl: UILabel!
    @IBOutlet weak var provisionaldignosisLbl: UILabel!
    @IBOutlet weak var clinicaldetailsLbl: UILabel!
    @IBOutlet weak var investigationLbl: UILabel!
    @IBOutlet weak var addmedicineLbl: UILabel!
    @IBOutlet weak var medicineHeight: NSLayoutConstraint!
    @IBOutlet weak var medicineTV: UITableView!
    
    @IBOutlet weak var additional_instructionsLbl: UILabel!
 //   @IBOutlet weak var additional_instructionsTextField: UITextField!
    
    @IBOutlet weak var additional_instructionsTextView: UITextView!
    var listModel = [medicineListModel]()
    var files : filesModel?
    var delegate: filesDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.additional_instructionsTextView.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "")
        self.symptomstextField.text = self.files?.symptoms ?? ""
        self.provisionaldignosistextField.text = self.files?.provisional_diagnosis ?? ""
        self.clinicaldetailstextField.text = self.files?.clinical_details ?? ""
        self.investigationtextField.text = self.files?.instruction ?? ""
//        self.additional_instructionsTextField.text = self.files?.additional_instructions ?? ""
        self.additional_instructionsTextView.text = self.files?.additional_instructions ?? ""
        self.medicineHeight.constant = CGFloat(self.listModel.count * 50)
        self.medicineTV.delegate = self
        self.medicineTV.dataSource = self
        self.medicineTV.reloadData()
        print("self.listModel.count \(self.listModel.count)")
        
        
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
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "digital_prescription") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        self.bottomView.layer.borderWidth = 0.5
        self.bottomView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.submitBtn.backgroundColor = (UIColor(named: "AppColor") ?? .white)
        self.submitBtn.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "submit")
        self.submitBtn.viewRadius(radius: 5)
        self.symptomsLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "symptoms")
        self.additional_instructionsLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "additional_instructions")
        self.provisionaldignosisLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "provisional_diagonsis")
        self.clinicaldetailsLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "clinical_details")
        self.investigationLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "investigations")
        self.symptomstextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: fontRegular16, setBorder: false)
        self.provisionaldignosistextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: fontRegular16, setBorder: false)
        self.clinicaldetailstextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: fontRegular16, setBorder: false)
        self.investigationtextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: fontRegular16, setBorder: false)
//        self.additional_instructionsTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: fontRegular16, setBorder: false)
        self.additional_instructionsTextView.textContainerInset = UIEdgeInsets.zero
        self.additional_instructionsTextView.textContainer.lineFragmentPadding = 0
        self.addmedicineLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "add_medicine")
        self.medicineTV.register(UINib(nibName: "MedicineCell", bundle: nil), forCellReuseIdentifier: "MedicineCell")
        
        self.provisionaldignosisLbl.halfTextColorChange(fullText: Utility().language().value(forKey: "provisional_diagonsis") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        
        
                
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
    
    
    @IBAction func addmedicineBtntapped(_ sender: Any) {
        let pageObj = AddEditPrescriptionViewController()
        pageObj.delegate = self
        pageObj.listModel = self.listModel
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    func medicineAct(_ model: [medicineListModel]) {
        self.listModel = model
        self.medicineHeight.constant = CGFloat(self.listModel.count * 50)
        self.medicineTV.delegate = self
        self.medicineTV.dataSource = self
        self.medicineTV.reloadData()
    }
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.provisionaldignosistextField.text == "" /*|| self.listModel.count == 0 MARK: Add medician mandatory*/ {
            let alert = UIAlertController(title: nil, message: getLanguage["fill_fields"] ?? "fill_fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }else {
            
           
            let requestDict = NSMutableDictionary()
            requestDict.setValue(self.symptomstextField.text!, forKey: "symptoms")
            requestDict.setValue(self.provisionaldignosistextField.text!, forKey: "provisional_diagnosis")
            requestDict.setValue(self.clinicaldetailstextField.text!, forKey: "clinical_details")
            requestDict.setValue(self.investigationtextField.text!, forKey: "instruction")
//          requestDict.setValue(self.additional_instructionsTextField.text!, forKey: "additional_instructions")
            let newString = self.additional_instructionsTextView.text.replacingOccurrences(of: "\n", with: "<br>")
            requestDict.setValue(newString, forKey: "additional_instructions")
    
            
            
            print("final data : \(requestDict)")
            let dict1: [String: Any] = requestDict as! [String : Any]
            
            do {
               let jsonData = try JSONSerialization.data(withJSONObject: dict1, options: JSONSerialization.WritingOptions()) as NSData
                let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                print("json string = \(jsonString)")
                self.files = Utility.shared.convertSendModel1(from: jsonString)
                self.delegate?.fileAct(self.files!, list: self.listModel)
                self.navigationController?.popViewController(animated: true)
            } catch _ {
                print ("JSON Failure")
            }
        }
       
                  
        
        
    }
    

    
}

extension DigitalPrescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineCell
        cell.nameLbl.text = "\(Utility().language().value(forKey: "medicine") as? String ?? "")" + " " + "\(indexPath.row + 1)"
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(self.editAct(_:)), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteAct(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteAct(_ sender: UIButton) {
        self.listModel.remove(at: sender.tag)
        self.medicineTV.reloadData()
    }
    
    @objc func editAct(_ sender: UIButton) {
        let pageObj = AddEditPrescriptionViewController()
        pageObj.delegate = self
        pageObj.viewtype = "edit"
        pageObj.editlistModel = self.listModel[sender.tag]
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    
}
