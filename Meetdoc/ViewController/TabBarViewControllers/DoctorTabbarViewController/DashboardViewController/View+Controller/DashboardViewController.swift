//
//  DashboardViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DashboardViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var calendarDescLabel: UILabel!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var calendarStackView: UIStackView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var contactUsButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        AppDelegate().loadAdminData()
        appDelegate.callinit()  //MARK: Zego check
        Utility.shared.startAnimation(viewController: self)
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
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

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.setNavigationBar()
        self.loadData()
    }
    func setNavigationBar() {
        let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle(Utility().language().value(forKey: "dashboard") as? String ?? "dashboard", for: .normal)
        self.parent?.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton1)]
        self.parent?.navigationItem.rightBarButtonItems = nil
    }
    func configUI() {
        self.bannerView.isHidden = true
        self.blockView.isHidden = true
        self.blockLabel.config(color: UIColor(named: "White"), font: smallFont, align: .left, text: "hospital_blocked")
        self.calendarStackView.isHidden = true
        self.collectionView.register(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionViewCell")
        self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "onetime_des")
        self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "activate_callendar")
        self.calendarButton.cornerMiniumRadius()
        self.calendarButton.backgroundColor = UIColor(named: "AppColor")
        self.contactUsButton.cornerViewMiniumRadius()
        self.contactUsButton.config(color: UIColor(named: "TitleColor"), font: fontRegular12, align: .center, title: "contactUs")
        self.contactUsButton.backgroundColor = UIColor(named: "BorderColor")
//        self.loadAddOns()
    }
    func loadData() {
        
        self.viewModel.getAdminData(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            if success {
                if UserDefaultModule.shared.getLoginData().type == "doctor"{
                    if !isPayout {
                        self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "dc_your_payout")
                        self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "continue")
                    }
                    else {
                        self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "onetime_des")
                        self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "activate_callendar")
                    }
                    if !isPayout || !isCalendar {
                        self.calendarStackView.isHidden = false
                    }
                    else {
                        self.calendarStackView.isHidden = true
                    }
                    if hospitalStatus {
                        self.blockView.isHidden = true
                    }
                    else {
                        self.blockView.isHidden = false
                    }
                }else
                {
                    self.blockView.isHidden = true
                    self.calendarStackView.isHidden = true
                }
                self.collectionView.reloadData()
            }
            Utility.shared.stopAnimation(viewController: self)
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    
    @IBAction func contactUsButtonAct(_ sender: UIButton) {
        let pageObj = SettingTableViewController()
        pageObj.titleString = "contactUs"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func activateCalenddarButtonAct(_ sender: UIButton) {
        if !isPayout {
            let pageObj = ViewDoctorProfileViewController()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let pageObj = ActivateCalendarViewController()
            pageObj.isFromEdit = false
            pageObj.calenderData = ActivateCalendarResultModel()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
}
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            if self.viewModel.adminData?.result != nil && isCalendar{
                return 5
            }
            return 0
        }else{
            return 6
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.calendarStackView.isHidden = true
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        cell.loadData(indexPath)
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            if indexPath.row == 0 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.messageCount ?? "") \(getLanguage["new_messages"] ?? "new_messages")"
            }
            else if indexPath.row == 1 {
                cell.dashboardLabel.text = "\(getLanguage["transaction"] ?? "transaction")"
            }
            else if indexPath.row == 2 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.bookingCount ?? "") \(getLanguage["total_booking"] ?? "total_booking")"
            }
            else if indexPath.row == 3 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.notificationCount ?? "") \(getLanguage["new_notification"] ?? "new_notification")"
            }
            else if indexPath.row == 4 {
                cell.dashboardLabel.text = "\(getLanguage["invite_friends"] ?? "invite_friends")"
            }
        }else{
            if indexPath.row == 0 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.messageCount ?? "") \(getLanguage["new_messages"] ?? "new_messages")"
            }
            else if indexPath.row == 1 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.reviewCount ?? "") \(getLanguage["reviews"] ?? "reviews")"
            }
            else if indexPath.row == 2 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.bookingCount ?? "") \(getLanguage["total_booking"] ?? "total_booking")"
            }
            else if indexPath.row == 3 {
                cell.dashboardLabel.text = "\(self.viewModel.adminData?.result.notificationCount ?? "") \(getLanguage["new_notification"] ?? "new_notification")"
            }
            else if indexPath.row == 4 {
                cell.dashboardLabel.text = "\(getLanguage["invite_friends"] ?? "invite_friends")"
            }
            else if indexPath.row == 5 {
                cell.dashboardLabel.text = "\(getLanguage["my_doctor"] ?? "my_doctor")"
            }
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.width / 2)-5), height: ((self.collectionView.frame.width / 2)-5))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                self.tabBarController?.selectedIndex = 3
            }else{
                let pageObj = InboxViewController()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
        else if indexPath.row == 1 {
            if UserDefaultModule.shared.getLoginData().type == "doctor"{
                let pageObj = TransactionViewController()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }else{
                let pageObj = ReviewPage()
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
//            pageObj.isFromDoctorProfile = true
        }
        else if indexPath.row == 2 {
            self.tabBarController?.selectedIndex = 2
        }
        else if indexPath.row == 3 {
            let pageNaviObj = NotificationPage()
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        else if indexPath.row == 4 {
            let pageObj = InviteFriends()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if indexPath.row == 5 {
            let pageObj = SavedListViewController()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
}
/*
extension DashboardViewController: GADBannerViewDelegate {
    func loadAddOns() {
        bannerView.isHidden = true
        if IS_GOOGLE_ADSENSE {
            bannerView.isHidden = false
            bannerView.adUnitID = BANNNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerView.isHidden = false
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
*/
