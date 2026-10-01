//
//  InboxViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InboxViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = InboxViewModel()
    var viewType = ""
    var inboxData = [InboxResultModel]()
    var offset = 0
    var limit = 10
    var isFound = true
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        self.view.addSubview(indicatorView)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
//        self.tableView.isHidden = true
        Utility().startAnimation(viewController: self)
        self.offset = 0
        self.isFound = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.offset = 0
        self.inboxData.removeAll()
        self.tableView.reloadData()
        self.loadData()
    }
    func setNavigationBar() {
        let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle(Utility().language().value(forKey: "message") as? String ?? "", for: .normal)
        self.parent?.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton1)]
        self.parent?.navigationItem.rightBarButtonItems = nil

    }
    func configUI() {
        self.bannerView.isHidden = true
        self.setNavigationBar()

        self.tableView.register(UINib(nibName: "InboxTableViewCell", bundle: nil), forCellReuseIdentifier: "InboxTableViewCell")
        self.tableView.register(UINib(nibName: "SavedHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SavedHeaderTableViewCell")
        self.noStackView.isHidden = true
        self.descLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .center, text: "no_message_yet")
        self.exploreButton.config(color: UIColor(named: "AppColor") ?? .white, font: regularFont, align: .center, title: "start_exploring")
        self.exploreButton.setBorder(UIColor(named: "boxColor") ?? .white)
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 50
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 50
        self.tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
//        self.loadAddOns()
        self.loadData()
    }
    func loadData() {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.viewType = "doctor"
        }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            self.viewType = "digitalclinic"
        }else{
            self.viewType = "user"
        }
        self.viewModel.getInboxData(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", offset: "\(offset)", limit: "\(limit)", type: self.viewType, onSuccess: { (success) in
            if !(self.viewModel.inboxModel?.status ?? false) {
                self.isFound = false
            }
            else {
                if self.offset == 0 {
                    self.inboxData.removeAll()
                }
                if self.viewModel.inboxModel?.result != nil {
                    self.inboxData += self.viewModel.inboxModel!.result
                }
                else {
                    self.isFound = false
                }
            }
            if self.inboxData.count == 0{
                self.noStackView.isHidden = false
            }
            Utility().stopAnimation(viewController: self)
            self.tableView.isHidden = false
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }) { (failure) in
            if self.inboxData.count == 0 {
                self.noStackView.isHidden = false
                self.tableView.reloadData()
            }
            Utility().stopAnimation(viewController: self)
        }
    }
    
    @IBAction func exploreButtonAct(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type == "user"{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.setInitialViewController(initialView: UserTabbarController())
        }
        else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.setInitialViewController(initialView: DCTabbarViewController())
        }
        else{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.setInitialViewController(initialView: DoctorTabViewController())
        }
    }
}
extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inboxData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxTableViewCell") as! InboxTableViewCell
        if self.inboxData.count > indexPath.row {
            cell.loadData(self.inboxData[indexPath.row])
            
        }
        
        if indexPath.row == (self.inboxData.count - 1) && self.isFound == true {
//            self.offset = self.inboxData.count
//            self.loadData()
        }
        
//        if cell.statusLabel.text == "cancelled" {
//            cell.statusLabel.textColor = .red
//        } else if cell.statusLabel.text == "accepted" {
//            cell.statusLabel.textColor = .green
//        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageObj = ChatViewController()
//        pageObj.listID = self.inboxData[indexPath.row].bookingId
        pageObj.id = self.inboxData[indexPath.row].chatId
        pageObj.userName = self.inboxData[indexPath.row].userName
        pageObj.receiverImage = self.inboxData[indexPath.row].userImage
        pageObj.hide_status = self.inboxData[indexPath.row].status.lowercased()
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
/*
extension InboxViewController: GADBannerViewDelegate {
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
