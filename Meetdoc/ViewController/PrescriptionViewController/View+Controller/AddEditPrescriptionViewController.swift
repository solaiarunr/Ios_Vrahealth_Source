//
//  AddEditPrescriptionViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import DropDown

protocol medicineDelegate {
    func medicineAct(_ model: [medicineListModel])
}

class AddEditPrescriptionViewController: UIViewController {

    @IBOutlet weak var prescriptionlistTabelView: UITableView!
    @IBOutlet weak var frequencyImageView: UIImageView!
    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet weak var directionView: UIView!
    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var componentTextField: UITextField!
    @IBOutlet weak var drugStrengthTitleLabel: UILabel!
    @IBOutlet weak var drugStrengthTextField: UITextField!
    @IBOutlet weak var frequencyTitleLabel: UILabel!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var routeTitleLabel: UILabel!
    @IBOutlet weak var routeTextField: UITextField!
    @IBOutlet weak var directionTitleLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var insructionTitleLabel: UILabel!
    @IBOutlet weak var instructionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    var prescriptionResultModel = PrescriptionResultModel()
    var viewModel = PrescriptionViewModel()
    var valArray = [PrescriptionDetailsModel]()
    var key = ""
    var offset = 0
    var bookingID = ""
    var drug_name = ""
    var drug_strength = ""
    var prescriptionListArray = [String]()
    var totalarray = [String]()
    var listModel = [medicineListModel]()
    var editlistModel : medicineListModel?
    var delegate: medicineDelegate?
    var viewtype = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView1)
        self.prescriptionlistTabelView.isHidden = true
//        self.dataModel()
        //self.componentTextField.addTarget(self, action: #selector(self.filter), for: .editingChanged)
//        self.prescriptionListArray = ["1","2","3","4","5","6","7","8","9","1234555555","2222222222","21234444","333333333"]
        self.configUI()
    //    self.addLoadMore()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (getLanguage["medicine"] ?? "medicine"), fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.componentTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "component_name")
        self.componentTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.drugStrengthTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "drug_strength")
        self.drugStrengthTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.frequencyTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "frequency")
        self.frequencyTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "choose_anyone", Font: regularFont)
        self.frequencyTextField.attributedPlaceholder = NSAttributedString(string: (getLanguage["choose_anyone"] ?? "choose_anyone"), attributes: [NSAttributedString.Key.foregroundColor: (UIColor(named: "TitleColor") ?? .white)])
        self.durationTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "duration")
        self.durationTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.routeTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "route")
        self.routeTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "", Font: regularFont)
        self.directionTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "direction")
        self.directionLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "choose_direction")
        self.insructionTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, text: "instructions")
        self.instructionTextView.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
        self.saveButton.config(color: UIColor(named: "White"), font: regularFont, align: .center, title: "save")
        self.directionImageView.image = #imageLiteral(resourceName: "next").imageFlippedForRightToLeftLayoutDirection()
        self.frequencyImageView.image = #imageLiteral(resourceName: "next").imageFlippedForRightToLeftLayoutDirection()
        self.prescriptionlistTabelView.register(UINib(nibName: "prescriptionListTableViewCell", bundle: nil), forCellReuseIdentifier: "prescriptionListTableViewCell")
        self.directionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionViewAct)))
        self.saveButton.cornerMiniumRadius()
        self.loadPrescriptionData()
        self.prescriptionlistTabelView.delegate = self
        self.prescriptionlistTabelView.dataSource = self
        self.componentTitleLabel.halfTextColorChange(fullText: Utility().language().value(forKey: "component_name") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.frequencyTitleLabel.halfTextColorChange(fullText: Utility().language().value(forKey: "frequency") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.durationTitleLabel.halfTextColorChange(fullText: Utility().language().value(forKey: "duration") as? String ?? "", changeText: Utility().language().value(forKey: "*") as? String ?? "")
        self.offset = 0
        
        if self.viewtype == "edit"{
            self.componentTextField.text = self.editlistModel?.name
            self.frequencyTextField.text = self.editlistModel?.frequency
            self.durationTextField.text = self.editlistModel?.duration
            self.routeTextField.text = self.editlistModel?.route
            
            var localizeArray = [String]()
            for val in self.editlistModel!.direction {
                localizeArray.append(val)
                print("localizeArray \(localizeArray)")
            }
            if localizeArray.count > 0 {
                self.directionLabel.text = localizeArray.joined(separator: ", ")
            }
            self.prescriptionResultModel.direction = self.editlistModel!.direction
            self.instructionTextView.text = self.editlistModel?.investigation
            
        }
    }
    @objc func directionViewAct() {
        self.view.endEditing(true)
        let pageObj = DirectionViewController()
        if self.prescriptionResultModel.direction.count > 0 {
            pageObj.selectedArray = self.prescriptionResultModel.direction
        }
        pageObj.delegate = self
        pageObj.titlestring = "direction"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func loadPrescriptionData() {
        if self.componentTextField.isEditing == true{
            self.prescriptionlistTabelView.isHidden = false
        }else{
            self.prescriptionlistTabelView.isHidden = true
        }
        self.componentTextField.text = self.prescriptionResultModel.medicineName
        self.drugStrengthTextField.text = self.prescriptionResultModel.drugStrength
        self.frequencyTextField.text = getLanguage[self.prescriptionResultModel.frequency.lowercased()] ?? self.prescriptionResultModel.frequency
        self.durationTextField.text = self.prescriptionResultModel.duration
        self.routeTextField.text = self.prescriptionResultModel.route
        var localizeArray = [String]()
        for val in self.prescriptionResultModel.direction {
            localizeArray.append(getLanguage[val.lowercased()] ?? val)
        }
        if localizeArray.count > 0 {
            self.directionLabel.text = localizeArray.joined(separator: ", ")
        }
        
        self.instructionTextView.text = self.prescriptionResultModel.instruction
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
    func dataModel(offset: Int){
    //    Utility.shared.startAnimation1(viewController: self)
        self.viewModel.prescriptioList(user_id: UserDefaultModule.shared.getLoginData().userId,offset:"\(self.offset)", limit:"35", key:self.key, onSuccess: { (success) in
            if self.offset == 0 {
                self.prescriptionListArray.removeAll()
            }
            for i in self.viewModel.prescriptionDataModel!.results{
//                self.prescriptionListArray.append("\(i.dosage ?? "")-\(i.medicine_name ?? "")")
                self.prescriptionListArray.append("\(i.medicine_name ?? "")-\(i.dosage ?? "")")
            }
            Utility.shared.stopAnimation1(viewController: self)
            print("CONNECT:\(self.prescriptionListArray)")
         
//            self.totalarray.append(contentsOf: self.prescriptionListArray)
            print("SUCCESS")
            self.prescriptionlistTabelView.isHidden = false
            self.prescriptionlistTabelView.reloadData()
            if self.prescriptionListArray.count == 0 || self.componentTextField.text == ""{
                self.prescriptionlistTabelView.isHidden = true
            }
        }, onFailure: {_ in
            Utility.shared.stopAnimation(viewController: self)
            print("FAILURE")
        })
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    @objc func filter(){
        if !self.componentTextField.text!.isEmpty{
            self.prescriptionlistTabelView.isHidden = false
                let filtered = self.totalarray.filter { ((($0 as? String)as! String).lowercased().starts(with: self.componentTextField.text!.lowercased()))}
            self.prescriptionListArray.removeAll()
            self.prescriptionListArray.append(contentsOf: filtered)
            if self.prescriptionListArray.count == 0 {
                self.prescriptionListArray.removeAll()
                self.prescriptionlistTabelView.isHidden = true
                print("not visible")
            }else {
                print("visible")
                self.prescriptionlistTabelView.reloadData()
                self.prescriptionlistTabelView.isHidden = false
                
            }
            
        }else{
            self.prescriptionListArray.removeAll()
            print("not visible123")
            self.prescriptionlistTabelView.isHidden = true
//            self.prescriptionListArray.removeAll()
//            self.prescriptionListArray.append(contentsOf: self.totalarray as! [String])
//            self.prescriptionlistTabelView.reloadData()
            
        }
    }
                                                     
    @IBAction func saveButtonAct(_ sender: UIButton) {
        if self.componentTextField.text == "" || self.durationTextField.text == "" || self.frequencyTextField.text == "" {
            let alert = UIAlertController(title: nil, message: getLanguage["fill_fields"] ?? "fill_fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }

        else {
                let requestDict = NSMutableDictionary()
//                requestDict.setValue(self.componentTextField.text!, forKey: "name")
            requestDict.setValue(self.drug_name, forKey: "name")
            requestDict.setValue(self.drug_strength, forKey: "medicine_strength")
                requestDict.setValue(self.listModel.count, forKey: "id")
//                requestDict.setValue(self.prescriptionResultModel.frequency, forKey: "frequency")
                requestDict.setValue(self.frequencyTextField.text!, forKey: "frequency")
                requestDict.setValue(self.durationTextField.text!, forKey: "duration")
                requestDict.setValue(self.routeTextField.text!, forKey: "route")
                requestDict.setValue(self.prescriptionResultModel.direction, forKey: "direction")
            let newString = self.instructionTextView.text.replacingOccurrences(of: "\n", with: "<br>")
            requestDict.setValue(newString, forKey: "investigation")
  //              requestDict.setValue(self.instructionTextView.text!, forKey: "investigation")
                
                var arrayOfDict = [[String: Any]]()
                          // Create a dictionary and add it to the array.
                let dict1: [String: Any] = requestDict as! [String : Any]
                arrayOfDict.append(dict1)
                
                          
                          
                let str = try! Utility.shared.toJSON(array: arrayOfDict)
                self.listModel += Utility.shared.convertSendModel(from: str) ?? [medicineListModel]()
                self.delegate?.medicineAct(self.listModel)
            print("LISTMODEL:\(self.listModel.count)")
                self.navigationController?.popViewController(animated: true)
            }
            
            
            


        }
   
}
extension AddEditPrescriptionViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  textField == frequencyTextField {
            DispatchQueue.main.async {
                self.view.endEditing(true)
                let pageObj = DirectionViewController()
                if textField.text != "" {
                    pageObj.selectedArray = [self.prescriptionResultModel.frequency]
                }
                pageObj.isFrequency = true
                pageObj.delegate = self
                pageObj.titlestring = "frequency_title"
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.containsEmoji {
            return false
        }
        if textField == componentTextField {
            let maxLength = 250
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            self.componentTextField.text = currentString as String
            self.key = newString as String
            self.dataModel(offset: 0)
            
            return newString.length <= maxLength
        }
        
        if textField == drugStrengthTextField || textField == durationTextField || textField == routeTextField {
            let maxLength = 250
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
        
        if textView == instructionTextView{
            let maxLength = 500
            let currentString: NSString = (textView.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
extension AddEditPrescriptionViewController: DirectionDelegate {
    func directionAct(_ selectionDirection: [String], isFrequency: Bool) {
        if isFrequency {
            self.frequencyTextField.text = getLanguage[selectionDirection.first ?? ""] ?? selectionDirection.first
            self.prescriptionResultModel.frequency = (selectionDirection.first ?? "")
        }
        else {
            var localizeArray = [String]()
            for val in selectionDirection {
                localizeArray.append(getLanguage[val] ?? val)
            }
            self.directionLabel.text = localizeArray.joined(separator: ", ")
            self.prescriptionResultModel.direction = selectionDirection
        }
        
    }
}
extension AddEditPrescriptionViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prescriptionListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prescriptionlistTabelView.dequeueReusableCell(withIdentifier: "prescriptionListTableViewCell")as! prescriptionListTableViewCell
        if indexPath.row  <= self.prescriptionListArray.count - 1 {
            cell.prescriptionTittle.text = self.prescriptionListArray[indexPath.row]as? String ?? ""
        }
        if indexPath.row == (self.prescriptionListArray.count - 1) && self.prescriptionListArray.count >= 25 {
            self.offset = self.prescriptionListArray.count
            self.dataModel(offset: self.offset)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row  <= self.prescriptionListArray.count - 1 {
            self.componentTextField.text = self.prescriptionListArray[indexPath.row]as? String ?? ""
            let value = self.componentTextField.text!
            print("Value:\(value)")
            let components = value.components(separatedBy: "-")
            if components.count != 0 {
                self.drug_name = components[0]
                self.drug_strength = components[1]
            }
            print("Drug_name:\(self.drug_name)")
            print("drug_strength:\(self.drug_strength)")
            self.prescriptionlistTabelView.isHidden = true
        }
    }
    
}

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String ) {
            let strNumber: NSString = fullText as NSString
            let range = (strNumber).range(of: changeText)
            let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
            self.attributedText = attribute
        }
}


