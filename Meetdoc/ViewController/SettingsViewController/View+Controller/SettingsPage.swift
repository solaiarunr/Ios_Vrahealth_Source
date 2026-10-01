//
//  SettingsPage.swift
//  Meetdoc
//
//  Created by Hitasoft on 18/06/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsPage: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!

    var titleLbltext: String!
    var requestdict = NSMutableDictionary()
    var titleDetails: NSDictionary!
    var ChangingArray = NSMutableArray()
    var settingArr = ["notifications", "changePassword", "changeLanguage", "currency", "contactUs", "change_theme"]
    var viewModel = SettingViewModel()
    var isFromDoctor = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "setting") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.customUI()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func customUI() {
        self.bannerWholeView.isHidden = true
        if isFromDoctor {
//            settingArr = ["payout_preference","notifications", "changePassword", "changeLanguage", "currency", "contactUs"]  //"payout_preference only for stripe payment gateway"
            settingArr = ["notifications", "changePassword", "changeLanguage", "currency", "contactUs"]
        }
        else {
            settingArr = ["notifications", "changePassword", "changeLanguage", "currency", "contactUs"]
        }
        if #available(iOS 13.0, *) {
            self.settingArr.append("change_theme")
        }
        self.settingsTable.register(UINib(nibName: "ProfileTabelCell", bundle: nil), forCellReuseIdentifier: "ProfileTabelCell")
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "setting") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
//        self.loadAddOns()
          self.loadCurrencyData()
    }
    func loadCurrencyData() {
        self.viewModel.getCurrencyList(user_id: UserDefaultModule.shared.getCurrentUserID() as String? ?? "", onSuccess: { (success) in
            print(success)
            self.settingsTable.reloadData()
        }) { (error) in
            print(error)
        }
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTabelCell") as! ProfileTabelCell
        
        cell.listIcon.isHidden = false
        cell.listIcon.image = UIImage(named: "next")
          if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
             cell.listIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        cell.listName.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: self.settingArr[indexPath.row])
//        let index = isFromDoctor ? indexPath.row-1 : indexPath.row // if we use stripe need to use this.
        let index = isFromDoctor ? indexPath.row : indexPath.row
        if index == 3 {
            cell.listIcon.isHidden = true
            cell.detailLabel.isHidden = false
             cell.detailLabel.config(color: UIColor(named: "AppColor") ?? .white, font: fontRegular16, align: .right, text: "")
            cell.detailLabel.text = selectedCurrency.currencyCode
            cell.detailLabel.textColor = UIColor(named: "AppColor") ?? .white
            cell.accessoryType = .none
        }
        else {
            cell.detailLabel.isHidden = true
        }
//        if indexPath.row == (self.settingArr.count - 1) {
//            cell.lineView.isHidden = true
//        }
        return cell
    }
    
     func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath)
    {
        if isFromDoctor {
//            if indexPath.row == 0 {
//                let pageNaviObj = StripeViewController()
//                self.navigationController?.pushViewController(pageNaviObj, animated: true)
//             }
//            else
              if indexPath.row == 0
            {
                let pageNaviObj = NotificationsSettingsPage()
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 1
            {
                let pageNaviObj = ChangePassword()
                pageNaviObj.TitleText = Utility().language().value(forKey: "changePassword") as? String
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 2
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "changeLanguage"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 3
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "currency"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 4
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "contactUs"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 5 {
                let pageObj = ChangeThemeViewController()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
        else {
            if indexPath.row == 0
            {
                let pageNaviObj = NotificationsSettingsPage()
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 1
            {
                let pageNaviObj = ChangePassword()
                pageNaviObj.TitleText = Utility().language().value(forKey: "changePassword") as? String
                self.navigationController?.pushViewController(pageNaviObj, animated: true)
            }
            else if indexPath.row == 2
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "changeLanguage"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 3
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "currency"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 4
            {
                let pageObj = SettingTableViewController()
                pageObj.titleString = "contactUs"
                pageObj.viewModel = self.viewModel
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if indexPath.row == 5 {
                let pageObj = ChangeThemeViewController()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
     }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
}
/*
extension SettingsPage: GADBannerViewDelegate {
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
