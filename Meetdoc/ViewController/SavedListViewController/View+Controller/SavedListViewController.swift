//
//  SavedListViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 18/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SavedListViewController: UIViewController {
    
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!

    var viewModel = SavedListViewModel()
    var offset = 0
    var limit = 50
    var isFound = true
    var whishedData = [WhishedList]()
    var viewModel1 = DoctorViewModel()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        Utility.shared.startAnimation(viewController: self)
        self.checkReachability()
        self.noStackView.isHidden = true
        
        self.noLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "doctors_not_saved")
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "my_doctor") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.configUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        if Profile.currentProfile != nil {
            CallsApp.connect()
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
    
    func setBarButtonItem() {
        let barButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle(Utility().language().value(forKey: "saved") as? String ?? "", for: .normal)
        self.parent?.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton1)]
    }
    func configUI() {
        self.bannerView.isHidden = true
        self.edgesForExtendedLayout = .all
        self.extendedLayoutIncludesOpaqueBars = false

        self.tableView.register(UINib(nibName: "SavedListTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedListTableViewCell")
        self.offset = 0
        self.whishedData.removeAll()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl.endRefreshing()
//        self.loadAddOns()
        self.loadData()
     }
     
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.offset = 0
        self.whishedData.removeAll()
        self.loadData()
    }
    
    func loadData() {
        self.viewModel.getSavedList(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", offset: "\(offset)", limit: "\(limit)", onSuccess: { (success) in
            if self.viewModel.savedData?.status == false {
                self.isFound = false
                
            }
            else {
                if self.viewModel.savedData?.result != nil {
                    let val = self.viewModel.savedData!.result
                    self.whishedData += val ?? [WhishedList]()
                }
            }
            if self.whishedData.count == 0 {
                self.noStackView.isHidden = false
            }
            else {
                self.noStackView.isHidden = true
            }
            self.refreshControl.endRefreshing()
             Utility().stopAnimation(viewController: self)
            self.tableView.reloadData()
        }) { (failure) in
            Utility().stopAnimation(viewController: self)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
}
extension SavedListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.whishedData.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func startExploringButtonAct(_ sender: UIButton) {
        self.delegate.setInitialViewController(initialView: UserTabbarController())
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListTableViewCell") as! SavedListTableViewCell
        if self.whishedData.count > indexPath.row {
            cell.loadData(self.whishedData[indexPath.row])
            cell.likeButton.tag = Int(self.whishedData[indexPath.row].doctorId) ?? 0
            cell.likeButton.addTarget(self, action: #selector(self.likeButtonAct(_:)), for: .touchUpInside)
            cell.viewAvailablityLabel.tag = Int(self.whishedData[indexPath.row].doctorId) ?? 0
            cell.viewAvailablityLabel.addTarget(self, action: #selector(self.availblityBtn(_:)), for: .touchUpInside)
        }
        return cell
    }
    @objc func availblityBtn(_ sender: UIButton){
        self.viewModel1.getDoctorData(user_id: UserDefaultModule.shared.getLoginData().userId ?? "1", doctor_id: "\(sender.tag)", onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            let pageObj = BookingCalendarViewController()
            pageObj.doctorData = self.viewModel1.doctorModel?.result
            print("TYPE:\(pageObj.type)")
            pageObj.booking_type = "videovisit"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    @objc func likeButtonAct(_ sender: UIButton) {
        if (sender.imageView?.image ?? #imageLiteral(resourceName: "heart")) == #imageLiteral(resourceName: "HomeLike") {
            sender.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        else {
            sender.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
        }
        let savedViewModel = ExploreViewModel()
        savedViewModel.likeAct(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", doctor_id: "\(sender.tag)", onSuccess: { (success) in
            if success {
                self.whishedData.removeAll(where: {$0.doctorId == "\(sender.tag)"})
                if self.whishedData.count == 0 {
                    self.noStackView.isHidden = false
                }
            }
            self.tableView.reloadData()
        }) { (failure) in
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageObj = DoctorDetailsViewController()
        pageObj.doctorID = self.whishedData[indexPath.row].doctorId
        pageObj.type = self.whishedData[indexPath.row].speciality.first ?? ""
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
}
/*
extension SavedListViewController: GADBannerViewDelegate {
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
