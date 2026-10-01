 //
 //  ForgotPasswordPage.swift
 //  Meetdoc
 //
 //  Created by HTS-SERVICETEAM on 22/01/19.
 //  Copyright © 2019 BTMani. All rights reserved.
 //

 import UIKit
 import ValidationComponents

 class ForgotPasswordPage: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleDescLbl: UILabel!
    @IBOutlet weak var emailAdrsTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    let child = SpinnerViewController()
    var prediction = EmailValidationPredicate()
    let language : NSDictionary = Utility().language()
    var signUpType = ""
    var predicate = EmailValidationPredicate()
    var viewModel = AuthenticationViewModel()
    var isFromUserSignUp = false
    var isFromDoctorSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        // Do any additional setup after loading the view.
        self.emailAdrsTextField.delegate = self
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            backBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        self.titleLbl.config(color: UIColor(named: "TitleColor"), font: titleFont, align: .left, text: "forgotYourPasswrd")
        if UserDefaultModule.shared.getAppLanguage().capitalized == "French" {
            self.titleLbl.numberOfLines = 2
            self.titleLbl.text = self.titleLbl.text?.replacingOccurrences(of: " ", with: "\n")
        }
        self.titleDescLbl.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "forgotPageDesc")
        self.emailAdrsTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "emailaddress", Font: fontRegular16, setBorder: true)
        self.nextBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "send")
        self.emailAdrsTextField.styleTextField()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if isFromUserSignUp{
            self.signUpType = "users"
        }
        else if isFromDoctorSignUp {
            self.signUpType = "doctors"
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.prediction.evaluate(with: "\(self.emailAdrsTextField.text!)"){
            self.view.endEditing(true)
            self.emailAdrsTextField.resignFirstResponder()
            return true
        }else{
            self.emailAdrsTextField.resignFirstResponder()
            return true
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
        if emailAdrsTextField.text == "" || !self.predicate.evaluate(with: "\(self.emailAdrsTextField.text!)") {
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
            if emailAdrsTextField.text == "" {
                
            }
            else {
                alert.message = (Utility().language().value(forKey: "email_error") as? String ?? "email_error")
            }
            let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.createSpinnerView(self.child)
            self.viewModel.forgotData(email: self.emailAdrsTextField.text!, type: self.signUpType, onSuccess: { (success) in
                self.removeSpinnerView(self.child)
                let alert = UIAlertController(title: nil, message: getLanguage[self.viewModel.loginModel?.message ?? ""] ?? self.viewModel.loginModel?.message ?? "", preferredStyle: .alert)
                
                let action = UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel) { (UIAlertAction) in
                    if self.viewModel.loginModel?.status ?? false {
                        let pagenaviObj = UserSigninViewController()
                        self.navigationController?.pushViewController(pagenaviObj, animated: true)
                    }
                    else {
                        self.emailAdrsTextField.text = ""
                        self.emailAdrsTextField.becomeFirstResponder()
                    }
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }) { (failure) in
                self.removeSpinnerView(self.child)
            }
        }
    }
 }

