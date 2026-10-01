//
//  PatientDetailViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 07/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class PatientDetailViewController: UIViewController {

    @IBOutlet weak var formLbl: UILabel!
    @IBOutlet weak var patientName: UITextField!
    @IBOutlet weak var patientAge: UITextField!
    @IBOutlet weak var patientGender: UITextField!
    @IBOutlet weak var patientWeight: UITextField!
    @IBOutlet weak var issueLbl: UILabel!
    @IBOutlet weak var issueShadowView: UIView!
    @IBOutlet weak var issueTextField: UITextView!
    @IBOutlet weak var issueTitleLbl: UILabel!
    @IBOutlet weak var bookbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["patient_details"] ?? "patient_details", fColor: "White", fontName: fontRegular16, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.patientName.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: getLanguage["name"] ?? "name", Font: fontRegular16, setBorder: true)
        self.patientAge.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: getLanguage["age"] ?? "age", Font: fontRegular16, setBorder: true)
        self.patientGender.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: getLanguage["patient_gender"] ?? "patient_gender", Font: fontRegular16, setBorder: true)
        self.patientWeight.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: getLanguage["weight"] ?? "weight", Font: fontRegular16, setBorder: true)
        self.issueTextField.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: getLanguage["issue_complaint"] ?? "issue_complaint", setBorder: false)
        self.issueTextField.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 0, right: 8)
        self.bookbutton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "book")
        self.issueTitleLbl.config(color: UIColor(named: "BorderColor"), font: fontRegular16, align: .left, text: getLanguage["issue_complaint"] ?? "issue_complaint")
        self.patientName.styleTextField()
        self.patientAge.styleTextField()
        self.patientGender.styleTextField()
        self.patientWeight.styleTextField()
        
        self.issueTextField.layer.cornerRadius = 5
        self.issueTextField.linkTextAttributes = [.underlineStyle: 0]
        self.issueShadowView.layer.cornerRadius = 5
        self.issueShadowView.clipsToBounds = false
        self.issueShadowView.layer.shadowOpacity = 0.3
        self.issueShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        
    @IBAction func bookbuttonAct(_ sender: UIButton) {
        if ((patientName.text == "") || (patientAge.text == "") || (patientGender.text == "") || (patientWeight.text == "") || (issueTextField.text == "")){
            let alert = UIAlertController(title: "", message: (Utility().language().value(forKey: "fill_fields") as? String ?? "fill_fields"), preferredStyle: .alert)
            let action = UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel) { (UIAlertAction) in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
    }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.containsEmoji{
            return false
        }
        if textView == issueTextField {
            let maxLength = 500
            let currentString: NSString = (textView.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        return true
    }

}
extension PatientDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if issueTextField.text == "" {
            self.issueTitleLbl.isHidden = false
        }
        else {
            self.issueTitleLbl.isHidden = true
        }
    }
}
