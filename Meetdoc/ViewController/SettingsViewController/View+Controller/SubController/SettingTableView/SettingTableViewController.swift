//
//  SettingTableViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
        
    var titleString = ""
//    var languageArray = ["english", "french", "arabic"]
    var languageArray = ["english"/*,"french"*/]

    var helpArray = ["Help", "Policies", "Appointment", "Contact doctor"]

    var viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func loadData() {
        if titleString == "currency" {
            Utility.shared.startAnimation(viewController: self)
            self.viewModel.getCurrencyList(user_id: UserDefaultModule.shared.getCurrentUserID()! as String, onSuccess: { (success) in
                print(success)
                if (self.viewModel.currencyData?.currencylist.count ?? 0) > Int(self.viewModel.currencyData?.defaultCurrency ?? "0") ?? 0 {
                    selectedCurrency = self.viewModel.currencyData?.currencylist[Int(self.viewModel.currencyData?.defaultCurrency ?? "0") ?? 0] ?? Currencylist()
                }
                Utility.shared.stopAnimation(viewController: self)
                self.tableView.reloadData()
            }) { (error) in
                Utility.shared.stopAnimation(viewController: self)
                print(error)
            }
        }
        else if titleString == "contactUs" {
            Utility.shared.startAnimation(viewController: self)
            self.viewModel.getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), onSuccess: { (success) in
                print(success)
                self.tableView.reloadData()
                Utility.shared.stopAnimation(viewController: self)
            }) { (fail) in
                print(fail)
                Utility.shared.stopAnimation(viewController: self)
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: titleString) as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
         self.tableView.register(UINib(nibName: "ProfileTabelCell", bundle: nil), forCellReuseIdentifier: "ProfileTabelCell")
        self.loadData()
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.titleString == "currency" {
            return (self.viewModel.currencyData?.currencylist.count ?? 0)
        }
        else if titleString == "contactUs" {
            if self.viewModel.adminData?.result == nil {
                return 0
            }
            return 3
        }
        else if titleString == "changeLanguage"{
            return languageArray.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTabelCell", for: indexPath) as! ProfileTabelCell
        cell.listName.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "")
        cell.listIcon.isHidden = false
        cell.detailLabel.isHidden = true
        cell.listIcon.image = #imageLiteral(resourceName: "Check_UnSel")
        cell.listIcon.tag = 0
        if self.titleString == "currency" {
            let tag = Int(self.viewModel.currencyData?.defaultCurrency ?? "0")
            cell.listName.text = (self.viewModel.currencyData?.currencylist[indexPath.row].currencyName ?? "") + " (\(self.viewModel.currencyData?.currencylist[indexPath.row].currencyCode ?? ""))"
            if tag == (Int(self.viewModel.currencyData?.defaultCurrency ?? "0") ?? 0) {
                if self.viewModel.currencyData?.currencylist[indexPath.row].currencyId == "\(tag ?? 0)"{
                    cell.listIcon.image = #imageLiteral(resourceName: "Check_Sel")
                }
            }
        }
        else if self.titleString == "changeLanguage" {
            cell.listName.text = Utility().language().value(forKey: self.languageArray[indexPath.row]) as? String
            if UserDefaultModule.shared.getAppLanguage().lowercased() == self.languageArray[indexPath.row] {
                cell.listIcon.image = #imageLiteral(resourceName: "Check_Sel")
            }
        }
        else if self.titleString == "contactUs" {
            cell.lineView.isHidden = false
             if indexPath.row == 0 {
                cell.listName.text = self.viewModel.adminData?.result.contactDetails.address
                cell.listIcon.image = #imageLiteral(resourceName: "contact_address")
            }
            else if indexPath.row == 1 {
                 cell.listIcon.image = #imageLiteral(resourceName: "message_icon-1")
//                cell.listName.text = self.viewModel.adminData?.result.contactDetails.email
                cell.listName.attributedText = NSAttributedString(string: (self.viewModel.adminData?.result.contactDetails.email ?? ""), attributes:
                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.listName.textColor = UIColor(named: "primary") ?? .white
            }
            else {
                cell.listIcon.image = #imageLiteral(resourceName: "contact_phone")
                cell.listName.text = self.viewModel.adminData?.result.contactDetails.phone
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.titleString == "currency" {
            let currencyID = (self.viewModel.currencyData?.currencylist[indexPath.row].currencyId ?? "1")
            self.viewModel.currencyData?.defaultCurrency = currencyID
            self.tableView.reloadData()
            
            self.viewModel.changeCurrency(user_id: UserDefaultModule.shared.getCurrentUserID()! as String, currency_id: currencyID, onSuccess: { (success) in
                                
                selectedCurrency = self.viewModel.currencyData?.currencylist[indexPath.row] ?? Currencylist()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                                       self.navigationController?.popViewController(animated: true)
                                   }

            }) { (failure) in
                self.view.makeToast(Utility().language().value(forKey: "failed") as? String)
             }
            
        }
        else if self.titleString == "changeLanguage" {
            UserDefaultModule.shared.setAppLanguage(language: self.languageArray[indexPath.row].capitalized)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            DispatchQueue.main.async {
                if UserDefaultModule.shared.getFCMToken() != nil && (UserDefaultModule().getCurrentUserID() != nil) {
                    Utility.shared.pushLogoutService(type: "language")
                }
            }
            appDelegate.setLanguage(languageName: self.languageArray[indexPath.row].capitalized)

        }
        else if self.titleString == "contactUs" {
            if indexPath.row != 0 {
                var urlString = ""
                if indexPath.row == 2 {
                    urlString = "tel://\(self.viewModel.adminData?.result.contactDetails.phone ?? "")"
                    if let url = URL(string: urlString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
                else if indexPath.row == 1{
                   sendEmail()
                    // urlString = "message://\(self.viewModel.adminData?.result.contactDetails.email ?? "")"
                 }
             }
            
        }
    }
    func sendEmail() {
        print(self.viewModel.adminData?.result.contactDetails.email ?? "")
          if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([(self.viewModel.adminData?.result.contactDetails.email ?? "")])
            mail.setMessageBody("", isHTML: true)
             self.present(mail, animated: true, completion: nil)
         } else {
            // show failure alert
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
//extension SettingTableViewController: MFMailComposeViewControllerDelegate {
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//    }
//
//}
