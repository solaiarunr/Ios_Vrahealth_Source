//
//  DoctorProfileViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DoctorProfileViewController: UIViewController {
    
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!

    var doctorProfileArray = [DoctorProfileModel]()
    var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.tableView.reloadData()
        self.loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = false
    }
    func loadData() {
        self.viewModel.loadDoctorProfileData(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            if success {
                self.tableView.reloadData()
            }
        }) { (failure) in
        }
        DispatchQueue.main.async {
            if (UserDefaultModule.shared.getLoginData().userId ?? "") != "" {
                SettingViewModel().getAdminData(user_id: (UserDefaultModule().getCurrentUserID() as? String ?? ""), onSuccess: { (success) in
                    if hospitalStatus {
                        self.blockView.isHidden = true
                    }
                    else {
                        self.blockView.isHidden = false
                    }
                    print(success)
                }) { (fail) in
                    print(fail)
                }
            }
        }
    }
    func configUI() {
        self.bannerWholeView.isHidden = true
        self.blockView.isHidden = true
        self.blockLabel.config(color: UIColor(named: "White"), font: smallFont, align: .left, text: "hospital_blocked")
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 50
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        self.tableView.register(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ProfileHeaderTableViewCell")
        self.contactUsButton.cornerViewMiniumRadius()
        self.contactUsButton.config(color: UIColor(named: "TitleColor"), font: fontRegular12, align: .center, title: "contactUs")
        self.contactUsButton.backgroundColor = UIColor(named: "BorderColor")
        self.getProfileValues()
//        self.loadAddOns()
    }
    func getProfileValues() {
        self.doctorProfileArray.append(DoctorProfileModel(title: "view_edit_profile", image: "profile"))
        self.doctorProfileArray.append(DoctorProfileModel(title: "notifications", image: "notification_icon"))
        self.doctorProfileArray.append(DoctorProfileModel(title: "setting", image: "settings_icon"))
      //  self.doctorProfileArray.append(DoctorProfileModel(title: "payment", image: "payment"))
//        self.doctorProfileArray.append(DoctorProfileModel(title: "review", image: "Review"))
    //    self.doctorProfileArray.append(DoctorProfileModel(title: "invite_friends", image: "invite_icon"))
        self.doctorProfileArray.append(DoctorProfileModel(title: "help", image: "help_icon"))
        self.doctorProfileArray.append(DoctorProfileModel(title: "account_delete", image: "account_deletion"))
        self.doctorProfileArray.append(DoctorProfileModel(title: "logout", image: "Logout"))
        self.tableView.reloadData()
    }
    @IBAction func contactUsButtonAct(_ sender: UIButton) {
        let pageObj = SettingTableViewController()
        pageObj.titleString = "contactUs"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func deleteAccount(){
        ProfileViewModel().accountdeletion(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            var Model = ProfileViewModel().deletionModel
            Model = success
                let actionSheet = UIAlertController(title: nil, message: Model?.message, preferredStyle: .alert)
                actionSheet.setTitlet(font: fontRegular, color: .black)
                let logOut = UIAlertAction(title: (Utility().language().value(forKey: "OK") as? String ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                    if Model?.status == true{
                        UserDefaultModule().userLogout()
                    }
                })
                actionSheet.addAction(logOut)
                //                actionSheet.addAction(cancel)
                self.present(actionSheet, animated: true, completion: nil)
        }) { (failure) in
        }
    }
}
extension DoctorProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doctorProfileArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            cell.nextImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
          cell.loadData(self.doctorProfileArray[indexPath.row])
         return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
        cell.loadUserData()
        cell.profileImageView.setBorder(color: UIColor(named: "AppColor") ?? .white)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hospitalStatus {
            if indexPath.row == 0 {
                let pageObj = ViewDoctorProfileViewController()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            if indexPath.row == 1
            {
                let pageNaviObj = NotificationPage()
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 2
            {
                let pageNaviObj = SettingsPage()
                pageNaviObj.isFromDoctor = true
                pageNaviObj.titleLbltext = doctorProfileArray[indexPath.row].title
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
//            else if indexPath.row == 3
//            {
//                let pageObj = TransactionViewController()
//                self.navigationController?.pushViewController(pageObj, animated: true)
//            }
//            else if indexPath.row == 3
//            {
//                let pageObj = ReviewPage()
////                pageObj.isFromDoctorProfile = true
//                self.navigationController?.pushViewController(pageObj, animated: true)
//            }
//            else if indexPath.row == 5{
//                let pageNaviObj = InviteFriends()
//                self.navigationController?.pushViewController(pageNaviObj, animated: true)
//            }
            //help
            else if indexPath.row == 3
            {
                let pageNaviObj = HelpViewController()
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 4
            {
                let actionSheet = UIAlertController(title: nil, message: Utility().language().value(forKey: "delete_account") as? String ?? "delete_account", preferredStyle: .alert)
                actionSheet.setTitlet(font: fontRegular, color: .black)
                let logOut = UIAlertAction(title: (Utility().language().value(forKey: "OK") as? String ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                    self.deleteAccount()
                })
                let cancel = UIAlertAction(title: (Utility().language().value(forKey: "cancel") as? String ?? "cancel").capitalized, style: .default, handler: { (action) -> Void in
                })
                actionSheet.addAction(logOut)
                actionSheet.addAction(cancel)
                self.present(actionSheet, animated: true, completion: nil)
            }

        }
        if self.doctorProfileArray[indexPath.row].title == "logout" {
            let actionSheet = UIAlertController(title: nil, message: getLanguage["logout_title"] ?? "logout_title", preferredStyle: .alert)
              let logOut = UIAlertAction(title: (getLanguage["OK"] ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                UserDefaultModule().userLogout()
            })
            let cancel = UIAlertAction(title: (getLanguage["cancel"] ?? "cancel").capitalized, style: .default, handler: { (action) -> Void in
            })
            actionSheet.addAction(logOut)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
}
/*
extension DoctorProfileViewController: GADBannerViewDelegate {
    func loadAddOns() {
        bannerWholeView.isHidden = true
        if IS_GOOGLE_ADSENSE {
            bannerWholeView.isHidden = false
            bannerView.adUnitID = BANNNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerWholeView.isHidden = false
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
*/
