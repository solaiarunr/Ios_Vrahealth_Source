 //
 //  HSTextField+UITextField.swift
 //  HSTaxiUserApp
 //
 //  Created by APPLE on 10/03/18.
 //  Copyright © 2018 APPLE. All rights reserved.
 //

 import Foundation
 import UIKit

 extension UITextField{
     
     //MARK: configure textField
     public func config(color:UIColor?, align:NSTextAlignment,placeHolder:String, Font: UIFont?, setBorder: Bool = false){
         self.tintColor = UIColor(named: "AppColor")
         self.textColor = color
         self.textAlignment = align
         if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
             if align == .left {
                 self.textAlignment = .right
             }
             else if align == .right {
                 self.textAlignment = .left
             }
         }
         //         self.attributedPlaceholder = NSAttributedString(string: (Utility().language().value(forKey: placeHolder) as? String ?? ""), attributes: [NSAttributedString.Key.foregroundColor: (UIColor(named: "BorderColor") ?? .white), NSAttributedString.Key.font: fontRegular13 ?? UIFont.boldSystemFont(ofSize: 13)])

         self.placeholder = getLanguage[placeHolder] ?? placeHolder
         self.font = Font ?? UIFont.systemFont(ofSize: 14)
         if setBorder {
             self.setTextFieldBorder()
         }
     }
     func setTextFieldBorder() {
         self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
         self.leftViewMode = .always
         self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
         self.rightViewMode = .always
          self.layer.cornerRadius = 5
         self.layer.borderWidth = 0.5
         self.layer.borderColor = (UIColor(named: "BorderColor") ?? .white).cgColor
     }
     func textFieldWithShowAct(title: String, image: UIImage?) {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: CGFloat(0), width: CGFloat(40), height: CGFloat(40))
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if title != "" {
            button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(40), height: CGFloat(40))
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            button.setTitle(getLanguage[title] ?? "", for: .normal)
        }
        else {
            button.setImage(image, for: .normal)
        }
        button.tintColor = UIColor(named: "secondary_text") ?? .white
        button.addTarget(self, action: #selector(showButtonAct), for: .touchUpInside)
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            button.config(color: UIColor(named: "AppRedColor") ?? .white, font: regularFont, align: .right, title: title)
            self.leftViewMode = .always
            self.leftView = button
        }
        else {
            button.config(color: UIColor(named: "AppRedColor") ?? .white, font: regularFont, align: .right, title: title)
            self.rightViewMode = .always
            self.rightView = button
        }
    }
     @objc func showButtonAct(_ sender: UIButton) {
          if sender.tag == 0 {
             self.isSecureTextEntry = false
             sender.tag = 1
             sender.imageView?.tintColor = UIColor(named: "AppColor")
             sender.config(color: UIColor(named: "secondary_text") ?? .white, font: regularFont, align: .right, title: "")
         }
         else {
             sender.imageView?.tintColor = UIColor(named: "SubTitleColor")
             sender.config(color: UIColor(named: "secondary_text") ?? .white, font: regularFont, align: .right, title: "")
             self.isSecureTextEntry = true
             sender.tag = 0
         }
     }
     //MARK: Rounded radius
     func cornerRoundRadius() {
         self.layer.cornerRadius = self.frame.size.height/2
         self.clipsToBounds = true
     }
     //minimum radius
     func cornerMiniumRadius() {
         self.layer.cornerRadius = 5
         self.clipsToBounds = true
     }
     // set border
     func setBorder() {
         self.layer.borderWidth = 1
         self.layer.borderColor = UIColor.white.cgColor
     }
     //MARK: email Validation
     func isValidEmail() -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailTest.evaluate(with: self.text)
     }
     //MARK: left padding
     func setLeftPadding(){
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
         self.leftView = paddingView
         self.leftViewMode = .always
     }
    func setRightPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
     
     //MARK: check textfield is empty
     func isEmpty() -> Bool {
         if  (self.text! == "") || (self.text! == "NULL") || (self.text! == "(null)")  || (self.text! == "<null>") || (self.text! == "Json Error") || (self.text! == "0") || (self.text!.isEmpty) ||  self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
             return true
         }
         return false
     }
 }
 extension UITextView {
     // add Done button to keyboard
     @IBInspectable var doneAccessory: Bool{
         get{
             return self.doneAccessory
         }
         set (hasDone) {
             if hasDone{
                 addDoneButtonOnKeyboard()
             }
         }
     }
     
     func addDoneButtonOnKeyboard()
     {
         let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
         doneToolbar.barStyle = .default
         
         let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
         
         let items = [flexSpace, done]
         doneToolbar.items = items
         doneToolbar.sizeToFit()
          self.inputAccessoryView = doneToolbar
     }
     
     @objc func doneButtonAction()
     {
         self.resignFirstResponder()
     }
 }
 extension UIToolbar {
     
     func ToolbarPiker(mySelect : Selector) -> UIToolbar {
         
         let toolBar = UIToolbar()
         
         toolBar.barStyle = UIBarStyle.default
         toolBar.isTranslucent = true
         toolBar.tintColor = UIColor.black
         toolBar.sizeToFit()
         
         let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
         doneButton.setTitleTextAttributes([kCTForegroundColorAttributeName as NSAttributedString.Key: AppGreen], for: .normal)
         
         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         
         toolBar.setItems([ spaceButton, doneButton], animated: false)
         toolBar.isUserInteractionEnabled = true
         
         return toolBar
     }
     
 }


