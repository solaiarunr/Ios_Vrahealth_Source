//
//  ChangePassword.swift
//  Meetdoc
//
//  Created by HTS-SERVICETEAM on 14/11/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit
import Toast_Swift

class ChangePassword: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    @IBOutlet weak var UpdateBtn: UIButton!
    
    //    var Passwrd:String?
    
    var TitleText: String? = nil
    var viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)

    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "changePassword") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)

 
        //self.titleLabel.config(color: UIColor(named: "primary_text") ?? .white, font: regular22, align: .left, text: "changePassword")

        self.newPasswordTextField.config(color: UIColor(named: "secondary_text") ?? .white, align: .left, placeHolder: "new_password", Font: regularFont)
        
        self.newPasswordTextField.textFieldWithShowAct(title: "", image: #imageLiteral(resourceName: "Eye"))
        self.oldPasswordTextField.config(color: UIColor(named: "secondary_text") ?? .white, align: .left, placeHolder: "current_password", Font: regularFont)
        self.oldPasswordTextField.textFieldWithShowAct(title: "", image: #imageLiteral(resourceName: "Eye"))
        self.ConfirmPasswordTextField.config(color: UIColor(named: "secondary_text") ?? .white, align: .left, placeHolder: "repeat_password", Font: regularFont)
        self.ConfirmPasswordTextField.textFieldWithShowAct(title: "", image: #imageLiteral(resourceName: "Eye"))
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            self.oldPasswordTextField.setRightPadding()
            self.newPasswordTextField.setRightPadding()
            self.ConfirmPasswordTextField.setRightPadding()
        }
        else {
            self.oldPasswordTextField.setLeftPadding()
            self.newPasswordTextField.setLeftPadding()
            self.ConfirmPasswordTextField.setLeftPadding()
        }
        self.UpdateBtn.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "update")
        self.UpdateBtn.backgroundColor = AppRed
        self.UpdateBtn.layer.cornerRadius = 3
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
        self.oldPasswordTextField.inputAccessoryView = toolBar
        self.newPasswordTextField.inputAccessoryView = toolBar
        self.ConfirmPasswordTextField.inputAccessoryView = toolBar
//       self.oldPasswordTextField.attributedPlaceholder = NSAttributedString(string: Utility().language().value(forKey: "current_password") as? String ?? "",attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SubTitleColor") ?? .white])
//        self.newPasswordTextField.attributedPlaceholder = NSAttributedString(string: Utility().language().value(forKey: "new_password") as? String ?? "",attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SubTitleColor") ?? .white])
//        self.ConfirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: Utility().language().value(forKey: "repeat_password") as? String ?? "",attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SubTitleColor") ?? .white])

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissPicker)))
    }
    @objc func dismissPicker()
    {
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
    @IBAction func UpdateBtnTapped(_ sender: Any) {
        if self.oldPasswordTextField.text == "" || self.newPasswordTextField.text == "" || self.ConfirmPasswordTextField.text == "" {
            self.view.makeToast(Utility().language().value(forKey: "fill_fields") as? String)
        }
        else if ((self.newPasswordTextField.text?.count)! < 6 || (self.newPasswordTextField.text?.count)! > 12) {
            self.view.makeToast(Utility().language().value(forKey: "password_error") as? String)
        }
        else if self.newPasswordTextField.text != self.ConfirmPasswordTextField.text {
            self.view.makeToast(Utility().language().value(forKey: "mismatched") as? String)
        }
        else if self.oldPasswordTextField.text == self.newPasswordTextField.text {
            self.view.makeToast(Utility().language().value(forKey: "passwordsame") as? String)
        }
        else {
            self.viewModel.changePassword(user_id: UserDefaultModule.shared.getCurrentUserID()! as String, old_password: self.oldPasswordTextField.text!, new_password: self.newPasswordTextField.text!, onSuccess: { (success) in
                if (self.viewModel.settingData?.status ?? false) {
                    self.view.makeToast(Utility().language().value(forKey: "password_changed") as? String)
                    self.oldPasswordTextField.text = ""
                    self.newPasswordTextField.text = ""
                    self.ConfirmPasswordTextField.text = ""
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    self.view.makeToast(Utility().language().value(forKey: "incorrect_password") as? String)
                }
            }) { (error) in
                
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
extension ChangePassword: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            self.newPasswordTextField.becomeFirstResponder()
        }
        else if textField == newPasswordTextField {
            self.ConfirmPasswordTextField.becomeFirstResponder()
        }
        else {
            self.ConfirmPasswordTextField.endEditing(true)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
                   return false
               }
        return true
    }
}
