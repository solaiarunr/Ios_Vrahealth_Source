//
//  NotificationPage.swift
//  AirFinch_Swift
//
//  Created by BTMani on 29/05/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class NotificationPage: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var notificationErrorLabel: UIImageView!
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!

    var notificationMainArray = NSMutableArray()
    var viewModel = NotificationViewModel()
    var limit = 10
    var offset = 0
    var isFound = true
    var refreshControl = UIRefreshControl()
    var notificationList = [NotificationResultModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromAppdelegate = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.checkReachability()
         self.view.addSubview(indicatorView)
//        performSelector(inBackground: #selector(self.getDataFromService), with: nil)
        notificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        notificationTableView.estimatedRowHeight = 70.0  //Give an approximation here
        notificationTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
         self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    
    func configUI() {
        self.bannerWholeView.isHidden = true
        self.offset = 0
        self.notificationList.removeAll()
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "notifications") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)

//        self.notificationErrorLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .center, text: "empty_notification")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        notificationTableView.addSubview(refreshControl)
        Utility().startAnimation(viewController: self)
//        self.loadAddOns()
        self.loadData()
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.notificationList.removeAll()
        self.offset = 0
        self.notificationTableView.reloadData()
        self.loadData()
    }
    @objc func barButtonAction(_ notification: Notification) {
        if isFromAppdelegate{
            if UserDefaultModule.shared.getLoginData().type.lowercased() == "user" {
                let pageobj = UserTabbarController()
                pageobj.selectedIndex = 4
                self.appDelegate.setInitialViewController(initialView: pageobj)
            }
            else if UserDefaultModule.shared.getLoginData().type.lowercased() == "digitalclinic"{
                let pageobj = DCTabbarViewController()
                pageobj.selectedIndex = 4
                self.appDelegate.setInitialViewController(initialView: pageobj)
            }
            else {
                let pageobj = DoctorTabViewController()
                pageobj.selectedIndex = 4
                self.appDelegate.setInitialViewController(initialView: pageobj)

            }
        }
        else{
            print(notification)
            if let isLeft = notification.userInfo?["isLeft"] as? Int {
                print(isLeft)
                if isLeft == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadData() {
        notificationErrorLabel.isHidden = true
        var type = "users"
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            type = "doctor"
        }
        
        self.viewModel.getAllNotification(user_id: UserDefaultModule.shared.getCurrentUserID()! as String,type: type, offset: "\(offset)",limit: "20", onSuccess: { (success) in
            if self.viewModel.getAllNotification?.status == false {
                if self.notificationList.count == 0 {
                    self.notificationErrorLabel.isHidden = false
                }
                self.isFound = false
            }
            else {
                if self.viewModel.getAllNotification?.result != nil {
                    self.notificationList += self.viewModel.getAllNotification!.result
                }
                if self.notificationList.count == 0 {
                    self.notificationErrorLabel.isHidden = false
                }
                self.notificationTableView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.loaderView.isHidden = true
            self.loaderView.stopAnimating()
            Utility().stopAnimation(viewController: self)
        }) { (failure) in
            self.refreshControl.endRefreshing()
            if self.notificationList.count == 0 {
                self.notificationErrorLabel.isHidden = false
            }
            Utility().stopAnimation(viewController: self)
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.loadData(notificationModel: self.notificationList[indexPath.row])
        
        cell.notificationLabel.tag = indexPath.row
        cell.notificationLabel.isUserInteractionEnabled = true
        cell.notificationLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:))))
        if indexPath.row == (self.notificationList.count - 1) && self.isFound == true && self.notificationList.count >= 10 {
            self.offset = self.notificationList.count
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
            self.loadData()
        }
        return cell
    }
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        var sec = 0
        var row = 0
        if let labelView = gesture.view as? UILabel {
            sec = labelView.tag / 10
            row = labelView.tag % 10
        }
        if let cell = notificationTableView.cellForRow(at: IndexPath(row: row, section: sec)) as? NotificationCell {
            let text = (cell.notificationLabel.text)!
            let notify = self.notificationList[row]
            var nameRange = (text as NSString).range(of: notify.userName)
            if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" {
                nameRange = (text as NSString).range(of: "Dr.\(notify.userName ?? "")")
            }
            if notify.type == "prescription" {
                let pageObj = PrescriptionViewController()
                pageObj.booking_id = notify.booking_id
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else if gesture.didTapAttributedTextInLabel(label: cell.notificationLabel, inRange: nameRange) && (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" && notify.type != "adminmessage" && notify.type != "adminlog" && notify.type != "hospital_approve"{
                let pageObj = DoctorDetailsViewController()
                pageObj.doctorID = "\(notify.userId ?? 0)"
                self.navigationController?.pushViewController(pageObj, animated: true)
            } else {
                if (notify.type ?? "") == "review" {
                    let pageObj = ReviewPage()
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
                else if (notify.type ?? "") != "adminmessage" && (notify.type ?? "") != "adminlog"{
                    let pageObj = BookingDetailsViewController()
                    pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
                    pageObj.booking_id = "\(notify.booking_id ?? "0")"
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.notificationList[indexPath.row].type ?? "") == "prescription" {
            let pageObj = PrescriptionViewController()
            pageObj.booking_id = self.notificationList[indexPath.row].booking_id
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if (self.notificationList[indexPath.row].type ?? "") == "review" {
            let pageObj = ReviewPage()
//            pageObj.isFromDoctorProfile = UserDefaultModule.shared.getLoginData().type == "doctor" ? true : false
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if (self.notificationList[indexPath.row].type ?? "") == "chat" {
            let pageObj = ChatViewController()
//            pageObj.listID = "\(self.notificationList[indexPath.row].booking_id ?? "0")"
            pageObj.id = "\(self.notificationList[indexPath.row].booking_id ?? "0")"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if (self.notificationList[indexPath.row].type ?? "") != "adminmessage" && (self.notificationList[indexPath.row].type ?? "") != "adminlog"{
            let pageObj = BookingDetailsViewController()
            pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
            pageObj.booking_id = "\(self.notificationList[indexPath.row].booking_id ?? "0")"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
	else if (self.notificationList[indexPath.row].type ?? "") == "adminmessage"{
        /*  //New Changes
            let pageObj = BookingDetailsViewController()
            pageObj.type = (UserDefaultModule.shared.getLoginData().type ?? "").lowercased()
            pageObj.booking_id = "\(self.notificationList[indexPath.row].booking_id ?? "0")"
            self.navigationController?.pushViewController(pageObj, animated: true)
        */
    }
    }
    
     @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
/*
extension NotificationPage: GADBannerViewDelegate {
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
}
