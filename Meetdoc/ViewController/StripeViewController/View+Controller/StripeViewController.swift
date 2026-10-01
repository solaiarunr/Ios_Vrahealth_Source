//
//  StripeViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation

class StripeViewController: UIViewController {
        
    @IBOutlet weak var hostCountryButton2: UIButton!
    @IBOutlet weak var hostErrorStackView: UIStackView!
    @IBOutlet weak var hostErrorTitleLabel: UILabel!
    @IBOutlet weak var hostErrorDescLabel: UILabel!
    @IBOutlet weak var hostErrorDataLabel: UILabel!
    @IBOutlet weak var hostDocErrorLabel: UILabel!
    
    @IBOutlet weak var payoutStackView: UIStackView!
    @IBOutlet weak var routingStackView: UIStackView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateStackView: UIStackView!
    @IBOutlet weak var postalStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var accNoRoutingNoStackView: UIStackView!
    @IBOutlet weak var accStatusStackView: UIStackView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var HostCountryStackView: UIStackView!
    @IBOutlet weak var hostCountryButton: UIButton!
    @IBOutlet weak var hostCountryTitileLabel: UILabel!
    @IBOutlet weak var hostCountryContentLabel: UILabel!
    @IBOutlet weak var stackViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var hostInfoStackView: UIStackView!
    @IBOutlet weak var hostInfoTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var hostInfoContentLabel: UILabel!
    @IBOutlet weak var accTypeTitleLabel: UILabel!
    @IBOutlet weak var accTypeLabel: UILabel!
    @IBOutlet weak var mailTitleLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    @IBOutlet weak var hostAccStackView: UIStackView!
    @IBOutlet weak var hostAccTitleLabel: UILabel!
    @IBOutlet weak var accNoTextField: UITextField!
    @IBOutlet weak var routingNoTextField: UITextField!
    
    @IBOutlet weak var ssnNumberTextField: UITextField!
    @IBOutlet weak var ssnNumberStackView: UIStackView!
    @IBOutlet weak var personalIDTextField: UITextField!
    @IBOutlet weak var personalIDStackView: UIStackView!
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var ibanStackView: UIStackView!
    @IBOutlet weak var hostAddressStackView: UIStackView!
    @IBOutlet weak var hostAddressTitleLabel: UILabel!
    @IBOutlet weak var hostAddressContentLabel: UILabel!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var line2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var accStatusLabel: UILabel!
    @IBOutlet weak var accStatusTitleLAbel: UILabel!
    @IBOutlet weak var payoutStatusLabel: UILabel!
    @IBOutlet weak var payoutStatusTitleLabel: UILabel!
    
    @IBOutlet weak var payoutScheduleLabel: UILabel!
    @IBOutlet weak var payoutScheduleTitleLabel: UILabel!
    @IBOutlet var stackViewCollection: [UIStackView]!
    @IBOutlet weak var phoneNumberDescLabel: UILabel!
    @IBOutlet weak var accNoDescLabel: UILabel!
    @IBOutlet weak var routingNoDescLabel: UILabel!
    @IBOutlet weak var ibanNoDescLabel: UILabel!
    @IBOutlet weak var personalIdDescLabel: UILabel!
    @IBOutlet weak var ssnDescLabel: UILabel!
    
    var euroCountries = ["EUR", "CHF", "DKK", "NOK", "SEK", "CZK", "PLN"]
    var stateCountries = ["AU", "US", "CA"]
    var loginData = [UserLoginResultModel]()
    var stripeData: StripeClass?
    var stripeCountryDict: StripeCountryDetails?
    var stripeCountryArray: StripeCountryDetailsModel?

    var selectedCountry: StripeCountry?
    var birthDate = ["birth_day":"","birth_month":"","birth_year":""]
    var isFromProfile = true
    var viewModel = StripeViewModel()
    let datePickerView = UIDatePicker()
    var isFromList = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let imagePicker = UIImagePickerController()
    let child = SpinnerViewController()
    var docType = ""
    var docDict = ["idfrontfile":"", "idbackfile":"", "addrfrontfile":"", "addrbackfile":""]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginData = [UserDefaultModule.shared.getLoginData()]
        self.hostCountryButton2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hostButtonAct)))
        self.configUI()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "White", fontName: fontRegular18, imageName: "close_x", isLeft: true, vc: self, transparantView: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadData() {
        Utility().startAnimation(viewController: self)
        CallParsingFunction().getStripeDetails(user_id: (self.loginData.first?.userId ?? ""), onSuccess: { (response) in
            let resJson = JSON(response)
            print(response)
            let stripeData = StripeClass.init(fromJson: resJson)
            self.stripeData = stripeData
            self.loadStripeCountryDetails()

            if self.stripeData?.status ?? false {
                if self.isFromProfile {
                    self.isFromProfile = false
                    self.selectedCountry = self.stripeData?.result.selectedCountry
                }
                self.loadUI()
            }
            Utility().stopAnimation(viewController: self)
         }) { (error) in
            Utility().stopAnimation(viewController: self)
        }
    }
    func loadStripeCountryDetails() {
        let url = Bundle.main.url(forResource: "CountryDetailsJson", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
//            let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
            self.stripeCountryArray = StripeCountryDetailsModel.init(fromJson: JSON(jsonData))
            if let stripeDict = stripeCountryArray?.country.filter({$0.countryCode == self.stripeData?.result.countryCode ?? ""}).first {
                self.stripeCountryDict = stripeDict
            }
            
        }
        catch {
            print(error)
        }
    }
    func loadUI() {
        self.loadCurrencyDetails()
        self.firstNameTextField.text = self.stripeData?.result.firstName
        self.lastNameTextField.text = self.stripeData?.result.lastName
        self.birthDateTextField.text = self.stripeData?.result.dateOfBirth
        self.phoneNumberTextField.text = self.stripeData?.result.phone
        self.accTypeLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "individual")
        self.mailLabel.text = self.stripeData?.result.email
        self.accNoTextField.text = self.stripeData?.result.accountNo
        self.ibanTextField.text = self.stripeData?.result.accountNo
            
        self.routingNoTextField.text = self.stripeData?.result.routingNo
        self.streetTextField.text = self.stripeData?.result.addressLineOne
        self.line2TextField.text = self.stripeData?.result.addressLineTwo
        self.cityTextField.text = self.stripeData?.result.city
        self.stateTextField.text = self.stripeData?.result.state
        self.postalCodeTextField.text = self.stripeData?.result.zipcode
        self.accStatusLabel.text =  getLanguage[(self.stripeData?.result.accountStatus ?? "").lowercased()] ?? (self.stripeData?.result.accountStatus ?? "")
        self.payoutStatusLabel.text = getLanguage[(self.stripeData?.result.payoutStatus ?? "").lowercased()] ?? (self.stripeData?.result.payoutStatus ?? "")
        if self.stripeData?.result.payoutSchedule != "" {
            self.payoutScheduleLabel.text = self.stripeData?.result.payoutSchedule
            self.payoutStackView.isHidden = false
        }
        else {
            self.payoutStackView.isHidden = true
        }
        self.personalIDTextField.text = self.stripeData?.result.personalIdNo
        self.ssnNumberTextField.text = self.stripeData?.result.ssnNo
        self.convertDateToDay()
        self.tableView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeightConst.constant = self.tableView.contentSize.height
    }
    func hideShowTextFieldStack(_ sender: UITextField) {
        let stackView = self.stackViewCollection.filter({$0.tag == sender.tag})
        if sender.text == "" {
            stackView.first?.isHidden = true
        }
        else {
            stackView.first?.isHidden = false
        }
    }
    func hideShowLabelStack(_ sender: UILabel) {
        let stackView = self.stackViewCollection.filter({$0.tag == sender.tag})
        if sender.text == "" {
            stackView.first?.isHidden = true
        }
        else {
            stackView.first?.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)
    }
    @IBAction func hostCountryButtonAct(_ sender: UIButton) {
//        let pageObj = StripeCountryViewController()
//        pageObj.selectedCountry = self.selectedCountry
//        pageObj.stripeData = self.stripeData
//        pageObj.delegate = self
//        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func hostButtonAct() {
        let pageObj = StripeCountryViewController()
        pageObj.selectedCountry = self.selectedCountry
        pageObj.stripeData = self.stripeData
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    @IBAction func submitButtonAct(_ sender: UIButton) {
        self.view.endEditing(true)
        let isValid = checkHostDetails()
        let stripeVal = convertToJSON()

        if isValid.0 && stripeVal.1{
            Utility().startAnimation(viewController: self)
            var accNo = ""
            if (self.hostAccStackView.isHidden == false && self.accNoRoutingNoStackView.isHidden == false) {
                accNo = self.accNoTextField.text!
            }
            else {
                accNo = self.ibanTextField.text!
            }
            self.viewModel.addHostAccount(user_id: (self.loginData.first?.userId ?? ""), country_code: self.selectedCountry?.countryCode ?? "", country_name: self.selectedCountry?.countryName ?? "", currency_code: self.selectedCountry?.currencyCode ?? "", first_name: self.firstNameTextField.text!, last_name: self.lastNameTextField.text!, phone: self.phoneNumberTextField.text!, account_no: accNo, routing_no: self.routingNoTextField.text!, personal_id_no: self.personalIDTextField.text!, ssn_no: self.ssnNumberTextField.text!, address_line_one: self.streetTextField.text!, address_line_two: self.line2TextField.text!, city: self.cityTextField.text!, state: self.stateTextField.text!, zipcode: self.postalCodeTextField.text!, birth_day: self.birthDate["birth_day"] ?? "", birth_month: self.birthDate["birth_month"] ?? "", birth_year: self.birthDate["birth_year"] ?? "", email: self.mailLabel.text!,stripe_proof:stripeVal.0, onSuccess: { (success) in
                print(success)
                if self.viewModel.settingData?.status ?? false {
                    let alert = UIAlertController(title: (Utility().language().value(forKey: "stripe_host_account") as? String ?? "stripe_host_account"), message: (getLanguage[(self.viewModel.settingData?.result ?? "")] ?? (self.viewModel.settingData?.result ?? "")), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.view.makeToast(Utility().language().value(forKey: "\(self.viewModel.settingData?.result ?? "")") as? String ?? (self.viewModel.settingData?.result ?? ""))
                }
                Utility().stopAnimation(viewController: self)
            }) { (failure) in
                self.view.makeToast(Utility().language().value(forKey: "enter_valid_details") as? String ?? "enter_valid_details")
                Utility().stopAnimation(viewController: self)
            }
        }
        else {
            self.view.makeToast(isValid.1)
        }
        
    }
    func convertToJSON() -> (String, Bool) {
         if self.docDict["idfrontfile"] != "" && self.docDict["idbackfile"] != "" && self.docDict["addrfrontfile"] != "" && self.docDict["addrbackfile"] != "" {
            var dict = [[String: String]]()
            for key in self.docDict.keys {
                let cal: [String: String] = ["doctype":key, "image": "\(self.docDict[key] ?? "")"]
                dict.append(cal)
            }
            let data = try! JSONSerialization.data(withJSONObject: dict, options:.prettyPrinted)
            let jsonStr  = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            print(jsonStr ?? "")
            return (jsonStr ?? "", true)
        }
        return ("", true)
    }
    func checkHostDetails() -> (Bool, String) {
        var isValid = true
        var err = ""
        if self.selectedCountry?.countryName == "" {
            isValid = false
            err =  ChangeToLanguage("select_host_country")
        }
        else if self.firstNameTextField.text == "" {
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.firstNameTextField.placeholder ?? "")"
        }
        else if (self.firstNameTextField.text?.count ?? 0) < 3 {
            isValid = false
            err = "\(ChangeToLanguage("first_name_err"))"
        }
        else if self.lastNameTextField.text == "" {
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.lastNameTextField.placeholder ?? "")"
        }
        else if (self.lastNameTextField.text?.count ?? 0) < 3 {
            isValid = false
            err = "\(ChangeToLanguage("last_name_err"))"
        }
        else if birthDateTextField.text == "" {
            isValid = false
            err = "\(ChangeToLanguage("please_select")) \(self.birthDateTextField.placeholder ?? "")"
        }
        else if phoneNumberTextField.text == ""{
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.phoneNumberTextField.placeholder ?? "")"
        }
        else if (self.hostAccStackView.isHidden == false && self.accNoRoutingNoStackView.isHidden == false && self.accNoTextField.text == ""){
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.accNoTextField.placeholder ?? "")"
        }
        else if (self.hostAccStackView.isHidden == false && self.accNoRoutingNoStackView.isHidden == false && self.routingNoTextField.text == "" && self.routingStackView.isHidden == false){
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.routingNoTextField.placeholder ?? "")"
        }
        else if (self.hostAccStackView.isHidden == false && self.ibanStackView.isHidden == false && self.ibanTextField.text == ""){
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.ibanTextField.placeholder ?? "")"
        }
        else if (self.hostAccStackView.isHidden == false && self.personalIDStackView.isHidden == false && self.personalIDTextField.text == ""){
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.personalIDTextField.placeholder ?? "")"
        }
        else if (self.hostAccStackView.isHidden == false && self.ssnNumberStackView.isHidden == false && self.ssnNumberTextField.text == ""){
            isValid = false
            err = "\(ChangeToLanguage("please_enter")) \(self.ssnNumberTextField.placeholder ?? "")"
        }
        else if self.hostAddressStackView.isHidden == false {
            if (self.streetTextField.text == "") {
                isValid = false
                err = "\(ChangeToLanguage("please_enter")) \(self.streetTextField.placeholder ?? "")"
            }
            else if (self.cityStackView.isHidden == false && self.cityTextField.text == ""){
                isValid = false
                err = "\(ChangeToLanguage("please_enter")) \(self.cityTextField.placeholder ?? "")"
            }
            else if (self.stateStackView.isHidden == false && self.stateTextField.text == ""){
                isValid = false
                err = "\(ChangeToLanguage("please_enter")) \(self.stateTextField.placeholder ?? "")"
            }
            else if (self.postalStackView.isHidden == false && self.postalCodeTextField.text == ""){
                isValid = false
                err = "\(ChangeToLanguage("please_enter")) \(self.postalCodeTextField.placeholder ?? "")"
            }
        }
        return (isValid, err)
    }
    func ChangeToLanguage(_ val: String) -> String {
        return Utility().language().value(forKey: val) as? String ?? val
    }
}
extension StripeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StripeProofHeaderTableViewCell") as! StripeProofHeaderTableViewCell
        cell.loadData(index: section)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StripeProofTableViewCell") as! StripeProofTableViewCell
        cell.loadData(index: indexPath.section, docDict: self.docDict, documentstatus: self.stripeData?.result.documentstatus ?? "")
        
        cell.doc2ProofView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectDocTypeAct(_:))))
        cell.Doc1ProofView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectDocTypeAct(_:))))
        return cell
    }
    func moveToCamera() {
        DispatchQueue.main.async {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }
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
    @objc func selectDocTypeAct(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        if tag == 0 {
            self.docType = "idfrontfile"
        }
        else if tag == 1 {
            self.docType = "idbackfile"
        }
        else if tag == 2 {
            self.docType = "addrfrontfile"
        }
        else {
            self.docType = "addrbackfile"
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: (Utility().language().value(forKey: "camera") as? String ?? ""), style: .default) { (action) in
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
        let gallery = UIAlertAction(title: (Utility().language().value(forKey: "gallery") as? String ?? ""), style: .default)
        {
            (action) in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.navigationController?.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title:(Utility().language().value(forKey: "cancel") as? String ?? ""), style: .cancel)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
extension StripeViewController {
    func configUI() {
        self.hostDocErrorLabel.isHidden = true
        self.imagePicker.delegate = self
        self.stateTextField.delegate = self
        self.view.addSubview(indicatorView)
        self.hostInfoStackView.isHidden = true
        self.hostAccStackView.isHidden = true
        self.hostAddressStackView.isHidden = true
        self.tableView.isHidden = true
        self.submitButton.isHidden = true

        self.submitButton.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "submit")
        self.submitButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.submitButton.layer.cornerRadius = 3
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.viewGestureAct)))
        
        // update Label Text
        self.hostErrorTitleLabel.config(color: UIColor(named: "red") ?? .white, font: tableHeaderFont, align: .left, text: "stripe_requirement")
        self.hostErrorDescLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "stripe_desc")
        self.hostErrorDataLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "")

        // Host Country
        self.hostCountryTitileLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: tableHeaderFont, align: .left, text: "host_country")
        self.hostCountryContentLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "stripe_privacy")
        self.hostCountryButton.config(color: UIColor(named: "AppColor") ?? .white, font: fontRegular16, align: .left, title: "select_host_country")
        self.hostInfoTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: tableHeaderFont, align: .left, text: "host_information")
        self.firstNameTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "firstname", Font: regularFont, setBorder: true)
        self.lastNameTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "lastname", Font: regularFont, setBorder: true)
        self.birthDateTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "lastname", Font: regularFont, setBorder: true)
        self.birthDateTextField.placeholder = (Utility().language().value(forKey: "birth_date") as? String ?? "") + (Utility().language().value(forKey: "stripe_host_age_limit") as? String ?? "")
        self.phoneNumberTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "phoneno", Font: regularFont, setBorder: true)
        self.hostInfoContentLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "host_country")
        
        self.hostInfoContentLabel.text = (Utility().language().value(forKey: "stripe_ph_no_alert1") as? String ?? "") + " \(self.selectedCountry?.countryName ?? "") " + (Utility().language().value(forKey: "stripe_ph_no_alert2") as? String ?? "")
        self.accTypeTitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "account_type")
        self.accTypeLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "individual")
        self.mailTitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "email")
        self.mailLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: self.loginData[0].email)
        
        self.personalIdDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "personal_id_desc")
        self.routingNoDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.accNoDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.ssnDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text:"ssn_no_desc")
        self.ibanNoDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")

        // Host Account
        self.hostAccTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: tableHeaderFont, align: .left, text: "host_account")
        self.accNoTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "account_number", Font: regularFont, setBorder: true)
        self.routingNoTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "routing_number", Font: regularFont, setBorder: true)
        self.personalIDTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "personal_id_number", Font: regularFont, setBorder: true)
        self.ssnNumberTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "ssn_number_last_four_digit", Font: regularFont, setBorder: true)
        self.ibanTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "iban_europe", Font: regularFont, setBorder: true)
        self.accStatusTitleLAbel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "account_status")
        self.accStatusLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "account_status")
        self.payoutStatusTitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "payout_status")
        self.payoutStatusLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "payout_status")
        self.payoutScheduleTitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "payout_schedule")
        self.payoutScheduleLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "payout_schedule")

        // Host Address
        self.hostAddressTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: tableHeaderFont, align: .left, text: "host_address")
        self.hostAddressContentLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "host_country")
        self.hostAddressContentLabel.text = (Utility().language().value(forKey: "stripe_address_alert1") as? String ?? "") + " - \(self.selectedCountry?.countryName ?? "") " + (Utility().language().value(forKey: "stripe_address_alert2") as? String ?? "")
        self.streetTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "street_line1", Font: regularFont, setBorder: true)
        self.line2TextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "line_2", Font: regularFont, setBorder: true)
        self.cityTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "city", Font: regularFont, setBorder: true)
        self.stateTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "state", Font: regularFont, setBorder: true)
        self.postalCodeTextField.config(color: UIColor(named: "SubTitleColor") ?? .white, align: .left, placeHolder: "postal_code", Font: regularFont, setBorder: true)
        self.countryTitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "country")
        self.countryLabel.config(color: UIColor(named: "AppColor") ?? .white, font: regular14, align: .left, text: "country")

        self.datePickerView.datePickerMode = .date
        self.datePickerView.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        let toolBar = UIToolbar().ToolbarPikerSelect(mySelect: #selector(self.dismissPicker))
        self.birthDateTextField.inputAccessoryView = toolBar
        self.birthDateTextField.inputView = self.datePickerView
        self.datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        self.tableView.register(UINib(nibName: "StripeProofTableViewCell", bundle: nil), forCellReuseIdentifier: "StripeProofTableViewCell")
        self.tableView.register(UINib(nibName: "StripeProofHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "StripeProofHeaderTableViewCell")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 50
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension

    }
    @objc func dismissPicker()
    {
        self.view.endEditing(true)
    }
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.birthDateTextField.text = dateFormatter.string(from: sender.date)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            self.birthDate["birth_day"] = "\(day)"
            self.birthDate["birth_month"] = "\(month)"
            self.birthDate["birth_year"] = "\(year)"
        }
    }
    func convertDateToDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: self.stripeData?.result.dateOfBirth ?? "") ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let day = components.day, let month = components.month, let year = components.year {
            self.birthDate["birth_day"] = "\(day)"
            self.birthDate["birth_month"] = "\(month)"
            self.birthDate["birth_year"] = "\(year)"
        }
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.stackViewBottomConst.constant = 20 + keyboardFrame.height
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        print(self.stackViewBottomConst.constant)
        self.viewDidLayoutSubviews()
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.stackViewBottomConst.constant = 15
        print(self.stackViewBottomConst.constant)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @objc func viewGestureAct() {
        self.view.endEditing(true)
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
}

extension StripeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == stateTextField {
            if (self.selectedCountry?.countryCode ?? "") == "CA" {
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= 2
            }
        }
        
        return true
    }
    
    
}
extension StripeViewController: StripeCountryDelegate {
    func selectedCountry(country: StripeCountry?) {
        self.selectedCountry = country
        if let stripeDict = stripeCountryArray?.country.filter({$0.countryCode == self.selectedCountry?.countryCode ?? ""}).first {
            self.stripeCountryDict = stripeDict
        }
        self.loadCurrencyDetails()
    }
    func loadCurrencyDetails() {
        self.hostAddressContentLabel.text = (Utility().language().value(forKey: "stripe_address_alert1") as? String ?? "") + " - \(self.selectedCountry?.countryName ?? "") " + (Utility().language().value(forKey: "stripe_address_alert2") as? String ?? "")
        let countryDetails = (Utility().language().value(forKey: "stripe_ph_no_alert1") as? String ?? "") + " \(self.selectedCountry?.countryName ?? "") " + (Utility().language().value(forKey: "stripe_ph_no_alert2") as? String ?? "")
        let countryDetails1 = (self.stripeCountryDict?.mobileCode ?? "") + " \((Utility().language().value(forKey: "stripe_ph_no_alert3") as? String ?? ""))" + "\u{200E}\(self.stripeCountryDict?.mobileNo ?? "")"
        let countryDetails2 = " \((Utility().language().value(forKey: "instead_of") as? String ?? ""))" + "\u{200E}\(self.stripeCountryDict?.mobileFormat ?? "")"
        self.hostInfoContentLabel.text = countryDetails + countryDetails1 + countryDetails2
        self.routingNoDescLabel.text = "\((Utility().language().value(forKey: "routing_no_desc") as? String ?? "")) \(self.stripeCountryDict?.routingNo ?? "")"
        self.accNoDescLabel.text = "\((Utility().language().value(forKey: "stripe_acc_no_desc") as? String ?? "")) \(self.stripeCountryDict?.accNo ?? "")"
        self.ibanNoDescLabel.text = "\((Utility().language().value(forKey: "iban_desc") as? String ?? "")) \(self.stripeCountryDict?.accNo ?? "")"
        if self.selectedCountry?.countryName != "" {
            self.hostCountryButton.setTitle((Utility().language().value(forKey: "host_country") as? String ?? "") + " " + (self.selectedCountry?.countryName ?? ""), for: .normal)
            self.countryLabel.text = self.selectedCountry?.countryName ?? ""
            
            self.hostInfoStackView.isHidden = false
            self.hostAccStackView.isHidden = false
            self.hostAddressStackView.isHidden = false
            self.tableView.isHidden = false
            self.submitButton.isHidden = false
            self.accStatusStackView.isHidden = true
            
            if let countryVal = self.selectedCountry {
                // Update Host Account StackView
                self.accNoRoutingNoStackView.isHidden = true
                self.ibanStackView.isHidden = true
                self.personalIDStackView.isHidden = true
                self.ssnNumberStackView.isHidden = true

                if self.euroCountries.contains(where: {$0 == countryVal.currencyCode}) {
                    self.ibanStackView.isHidden = false
                    self.stateStackView.isHidden = true
                }
                else {
                    self.stateStackView.isHidden = false
                    self.accNoRoutingNoStackView.isHidden = false
                    
                    if countryVal.countryCode == "US" {
                        self.personalIDStackView.isHidden = false
                        self.ssnNumberStackView.isHidden = false
                    }
                    else if countryVal.countryCode == "CA" || countryVal.countryCode == "HK" || countryVal.countryCode == "SG" || countryVal.countryCode == "MY" {
                        self.personalIDStackView.isHidden = false
                        self.ssnNumberStackView.isHidden = true
                    }
                }
                if countryVal.countryCode == "NZ" {
                    self.routingStackView.isHidden = true
                }
                else {
                    self.routingStackView.isHidden = false
                }

                // Update Host Address Layout
                self.postalStackView.isHidden = false
                self.cityStackView.isHidden = false
                self.stateStackView.isHidden = true
                
//                if countryVal.countryCode == "AT" {
//                    self.hostAddressStackView.isHidden = true
//                }
//                else
                if countryVal.countryCode == "GB" {
                    self.routingNoTextField.placeholder = Utility().language().value(forKey: "sort_code") as? String
                    self.routingNoDescLabel.text = "\((Utility().language().value(forKey: "sort_no_desc") as? String ?? "")) \(self.stripeCountryDict?.routingNo ?? "")"
                }
                if countryVal.countryCode == "SG" {
                    self.cityStackView.isHidden = true
                }
                else if countryVal.countryCode == "HK" {
                    self.postalStackView.isHidden = true
                }
                else if countryVal.countryCode == "IE" {
                    self.postalStackView.isHidden = true
                    self.stateStackView.isHidden = false
                }
                else if self.stateCountries.contains(where: {$0 == countryVal.countryCode}) {
                    self.stateStackView.isHidden = false
                    if countryVal.countryCode == "CA" {
                        self.stateTextField.placeholder = Utility().language().value(forKey: "canada_state") as? String
                    }
                }
            }
            if self.stripeData?.result.accountStatus != nil &&  self.stripeData?.result.accountStatus != "" {
                self.hostCountryButton.isHidden = true
                self.accStatusStackView.isHidden = false
                self.hostErrorStackView.isHidden = true
                if self.stripeData?.result.accountStatus == "Verified" {
                    self.hostCountryButton.isHidden = false
                    self.hideView.isHidden = false
                    self.submitButton.isHidden = true
                }
                else if self.stripeData?.result.accountStatus == "Pending" {
                    if self.stripeData?.result.stripe_pending != "" {
                        self.hostCountryButton.isHidden = false
                        self.hostErrorStackView.isHidden = false
                        self.hostErrorDataLabel.text = self.stripeData?.result.stripe_pending
                    }
                    if (self.stripeData?.result.stripe_doc_reason.count ?? 0) > 0 {
                        self.hostDocErrorLabel.isHidden = false
                        self.hostDocErrorLabel.text = (self.stripeData?.result.stripe_doc_reason.joined(separator: "\n") ?? "")
                    }
                    else {
                        self.hostDocErrorLabel.isHidden = true
                    }
                    self.hideView.isHidden = true
                    self.submitButton.isHidden = false

                }
                else {
                    self.hideView.isHidden = true
                    self.submitButton.isHidden = false
                }
            }
            else {
                self.submitButton.isHidden = false
                self.hideView.isHidden = true
            }
        }
        else {
            self.hostCountryButton.setTitle((Utility().language().value(forKey: "select_host_country") as? String ?? ""), for: .normal)
            self.hostInfoStackView.isHidden = true
            self.tableView.isHidden = true
            self.hostAccStackView.isHidden = true
            self.hostAddressStackView.isHidden = true
            self.countryLabel.text = self.stripeData?.result.countryName ?? ""
            self.submitButton.isHidden = true
            self.hideView.isHidden = true
        }
        
    }
}
extension StripeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.image = pickedImage
            let imageData = pickedImage.jpegData(compressionQuality: 0)! as Data
            self.createSpinnerView(child)
            UploadServices().uploadStripePic(profileimage: imageData, doctype: self.docType, user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), type: "stripe") { (response) in
                print(response)
                if (response["status"] as? String ?? "") == "false" {
                    self.removeSpinnerView(self.child)
                }
                else {
                    self.removeSpinnerView(self.child)
                    let res = response["result"] as! Dictionary<String, String>
                    let imageName = (res["name"] ?? "")
                    self.docDict[self.docType] = imageName
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.viewWillLayoutSubviews()
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
