//
//  HostListViewController.swift
//  AirFinch_Swift
//
//  Created by Hitasoft on 04/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class HostListViewController: UIViewController {
    
//    @IBOutlet weak var bottomConst: NSLayoutConstraint!
//    @IBOutlet weak var previousView: UIView!
//    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultStackView: UIStackView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var previousView: UIView!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var btnStackViewConst: NSLayoutConstraint!
    /// Used to toggle the built-in booking buttons; default is to show them unless explicitly hidden.
    var isNotFromTabbar = true
    var viewModel = BookingHistoryViewModel()
    var viewModel1 = DoctorViewModel()
    var selectedDate: Int?
    var booking_type = ""
    var limit = 20
    var offset = 0
    var isFound = true
    var ListData = [BookingHistoryResultModel]()
    var previousListData = [BookingHistoryResultModel]()

    var refreshControl = UIRefreshControl()
    var doctorData: DoctorResultModel?
//    var historyType = ""
//    var doctorType = ""
    var historyType = "current"
    var doctorType = ""
    var patientID = ""
    var patientdatabase = ""
var isfromdatabase = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        self.view.bringSubviewToFront(self.tableView)
        self.tableView.showsVerticalScrollIndicator = false
        self.ListData.removeAll()
        self.offset = 0
        self.hideView.isHidden = false
        self.activityIndicatorView.startAnimating()
        self.addGesture()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let bottomPadding = window.safeAreaInsets.bottom
//            self.bottomConst.constant = UITabBarController().tabBar.frame.height + bottomPadding + 15
        }
        else {
//            self.bottomConst.constant = UITabBarController().tabBar.frame.height + 20
        }
        self.loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
        self.view.bringSubviewToFront(self.tableView)
        if isfromdatabase == "true"{
            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["booking"] ?? "booking", fColor: "White", fontName: regularFont, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
            NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
        self.historyType = "current"
        self.configUI()
        self.addGesture()
        self.setUpNavTitle()
    }
    
    
    func addGesture() {
        if !self.isNotFromTabbar {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeLeft.direction = .left
            self.tableView.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeRight.direction = .right
            self.tableView.addGestureRecognizer(swipeRight)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func updateNoResultUI() {
        self.noResultStackView.isHidden = true
        self.noResultLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular16, align: .center, text: "no_res_yet")
    }
    
    func setUpNavTitle() {
        if !self.isNotFromTabbar {
            let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
            barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            barButton1.titleLabel?.lineBreakMode = .byWordWrapping
            barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
            barButton1.contentHorizontalAlignment = .leading
            barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
            barButton1.setTitle((getLanguage["booking"] ?? "booking"), for: .normal)
            self.parent?.navigationItem.leftBarButtonItems = [ UIBarButtonItem(customView: barButton1)]
            self.parent?.navigationItem.rightBarButtonItems = nil
        }
    }

    func configUI() {
        self.bannerView.isHidden = true
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        
        self.tableView.register(UINib(nibName: "BookingHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingHistoryTableViewCell")
        self.tableView.estimatedRowHeight = 45
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //Utility().startAnimation(viewController: self)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        self.updateNoResultUI()
//        if (bookingResultModel?.status.lowercased() ?? "") == "accepted" && (bookingResultModel?.paytoken ?? "") != ""{
    //    if self.ListData[indexPath.row].status.lowercased() == "pending" {
         
 //
//        }
//        if self.historyType == "current" {
//            self.previousView.isHidden = false
//            self.currentView.isHidden = true
//        }
//        else {
//            self.previousView.isHidden = true
//            self.currentView.isHidden = false
//        }
//        self.loadAddOns()
        self.currentButton.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, title: "your_booking")
        self.previousButton.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, title: "previous_booking")
        self.currentView.backgroundColor = UIColor(named: "AppColor")
        self.previousView.backgroundColor = .clear
        self.btnStackViewConst.constant = !self.isNotFromTabbar ? 50 : 0
        self.loadData()
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.ListData.removeAll()
        self.previousListData.removeAll()
        self.offset = 0
        self.tableView.reloadData()
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
    func loadData() {
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            self.doctorType = "doctor"
        }
        else if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "digitalclinic"{
            self.doctorType = "digitalclinic"
        }
        else {
            self.doctorType = "user"
        }
        self.viewModel.viewList(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""),type: UserDefaultModule.shared.getLoginData().type, date: 0,booking_type: historyType, offset: "\(offset)", limit: "\(limit)", onSuccess: { (success) in
            print(success)
            self.refreshControl.endRefreshing()
            if self.viewModel.historyModel?.status == false {
                self.isFound = false
            }
            else {
                self.noResultStackView.isHidden = true
                if self.viewModel.historyModel?.result != nil {
                    if self.historyType == "current" {
                        if self.offset == 0 {
                            self.ListData.removeAll()
                        }
                        self.ListData += self.viewModel.historyModel!.result
                    }
                    else {
                        if self.offset == 0 {
                            self.previousListData.removeAll()
                        }
                        self.previousListData += self.viewModel.historyModel!.result
                    }
                    
                }
            }
            if (self.ListData.count == 0 && self.historyType == "current") || (self.previousListData.count == 0 && self.historyType == "previous"){
                self.noResultStackView.isHidden = false
            }
            else {
                self.noResultStackView.isHidden = true
            }
            self.hideView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.tableView.reloadData()

        }) { (failure) in
            self.hideView.isHidden = true
            self.activityIndicatorView.stopAnimating()
            self.refreshControl.endRefreshing()
            print(failure)
        }
    }
    @IBAction func btnActs(_ sender: UIButton) {
        if sender == self.currentButton {
            self.historyType = "current"
            self.currentView.backgroundColor = UIColor(named: "AppColor")
            self.previousView.backgroundColor = .clear
            self.currentButton.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, title: "your_booking")
            self.previousButton.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, title: "previous_booking")
        } else {
            self.historyType = "previous"
            self.previousView.backgroundColor = UIColor(named: "AppColor")
            self.currentView.backgroundColor = .clear
            self.currentButton.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, title: "your_booking")
            self.previousButton.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, title: "previous_booking")
        }
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            self.historyType = "current"
            self.currentView.backgroundColor = UIColor(named: "AppColor")
            self.previousView.backgroundColor = .clear
            self.currentButton.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, title: "your_booking")
            self.previousButton.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, title: "previous_booking")
        } else if gesture.direction == .left {
            self.historyType = "previous"
            self.previousView.backgroundColor = UIColor(named: "AppColor")
            self.currentView.backgroundColor = .clear
            self.currentButton.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, title: "your_booking")
            self.previousButton.config(color: UIColor(named: "AppColor"), font: regularFont, align: .center, title: "previous_booking")
        }
        DispatchQueue.main.async {
            self.loadData()
        }
    }

    
    
}
extension HostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.historyType == "current" {
            return self.ListData.count
        }
        else {
            return self.previousListData.count
        }
         
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingHistoryTableViewCell") as! BookingHistoryTableViewCell
        if self.doctorType == "user" {
            cell.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "cancel")
        }
        else {
            cell.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "decline")
        }
        if self.historyType == "current" {
            if self.ListData.count > indexPath.row {
                cell.actionStackView.isHidden = false
                if (self.ListData[indexPath.row].status.lowercased() == "accepted"){
                    cell.actionStackView.isHidden = true
                    if self.ListData[indexPath.row].bookingType.lowercased() == "request" && UserDefaultModule.shared.getLoginData().type == "doctor" {
                        cell.actionStackView.isHidden = true
                    }
                    else {
                        cell.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "cancel")
                        cell.declineButton.isHidden = (self.ListData[indexPath.row].cancelStatus == nil)
                        cell.acceptButton.isHidden = false
                        cell.acceptButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "pay_new")
                        cell.actionStackView.isHidden = false
                        cell.rescheduleButton.isHidden = true
                        cell.declineButton.isHidden = true
                        if self.ListData[indexPath.row].orderstatus == "paid"{
                            cell.acceptButton.isHidden = true
                        }else{
                            if UserDefaultModule.shared.getLoginData().type != "doctor"{
                                cell.acceptButton.isHidden = false
                            }else{
                                cell.acceptButton.isHidden = true
                            }
                        }
                    }
                 }
                else if self.ListData[indexPath.row].status.lowercased() == "pending" {
                    cell.create_time = (self.ListData[indexPath.row].createdDate ?? 0)+900
                    print("15 mins add",(self.ListData[indexPath.row].createdDate ?? 0)+900)
                    
                    cell.book_status = self.ListData[indexPath.row].status ?? ""
                    if self.doctorType == "user" {
                        cell.acceptButton.isHidden = true
                        cell.rescheduleButton.isHidden = true
                        cell.declineButton.isHidden = true
                    }else if self.doctorType == "digitalclinic"{
                        cell.acceptButton.isHidden = true
                        cell.rescheduleButton.isHidden = true
                        cell.declineButton.isHidden = true
                    }
                    else {
                        cell.acceptButton.isHidden = false
                        cell.acceptButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "accept")
                        cell.declineButton.isHidden = false
                        cell.rescheduleButton.isHidden = false
                    }
                }
                else if self.ListData[indexPath.row].status == "Rescheduled" {
                    if self.doctorType == "doctor"{
                        cell.rescheduleButton.isHidden = true
                        cell.acceptButton.isHidden = true
                        cell.declineButton.isHidden = true
                    }else{
                        let date = Date()
                        let currentTime = Int(date.timeIntervalSince1970)
                        
                        let schedule_time =  (Int(self.ListData[indexPath.row].utcappstart ?? "0") ?? 0)
//                        let schedule_time =  (Int(self.ListData[indexPath.row].slot_endtime ?? "0") ?? 0)
                        
                        
                        print("rescheduled Time",Int(self.ListData[indexPath.row].utcappstart ?? "0") ?? 0)
                        print("rescheduled Time",currentTime)
                        if currentTime  >= schedule_time {
                            if self.ListData[indexPath.row].orderstatus == "paid"{
                                cell.acceptButton.isHidden = true
                            }else{
                                if UserDefaultModule.shared.getLoginData().type != "doctor"{
                                    cell.acceptButton.isHidden = false
                                    cell.declineButton.isHidden = false
                                    cell.rescheduleButton.isHidden = true
                                    cell.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "confrim")
                                    cell.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "cancel")
                                }else{
                                    cell.acceptButton.isHidden = true
                                }
                            }
                           // cell.declineButton.isHidden = true
                            cell.rescheduleButton.isHidden = true
                            
                        } else {
                            cell.acceptButton.isHidden = false
                            cell.declineButton.isHidden = false
                            cell.rescheduleButton.isHidden = true
                            cell.acceptButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "confrim")
                            cell.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "cancel")
                        }
                        
                        
                        
                        
                    }
                }
                else if self.ListData[indexPath.row].status == "Confirmed"{
                    cell.rescheduleButton.isHidden = true
                    cell.declineButton.isHidden = true
                    if UserDefaultModule.shared.getLoginData().type != "doctor"{
                        cell.acceptButton.isHidden = false
                    }else{
                        cell.acceptButton.isHidden = true
                    }
                    cell.acceptButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "pay_new")
                }
                else if self.ListData[indexPath.row].status.lowercased() == "cancelled" || self.ListData[indexPath.row].status.lowercased() == "refunded" || self.ListData[indexPath.row].status.lowercased() == "declined" || self.ListData[indexPath.row].status.lowercased() == "expired"{
                    cell.actionStackView.isHidden = true
                }
                else {
                    cell.declineButton.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, title: "cancel")
                    cell.declineButton.isHidden = (self.ListData[indexPath.row].cancelStatus == nil)
                    cell.acceptButton.isHidden = true
                }
                cell.loadData(self.ListData[indexPath.row])
                if indexPath.row == (self.ListData.count - 1) && self.isFound == true && self.ListData.count >= 10{
                    self.offset = self.ListData.count
                    self.loadData()
                }
            }
            // Check if current date in reached check in date
            let toArray = (self.ListData[indexPath.row]).time.components(separatedBy: ":")
            let timeZone = TimeZone(identifier: self.ListData[indexPath.row].timezone) ?? TimeZone.current
            let currentDate = self.changeToSystemTimeZone(Date(), from: TimeZone.current, to: timeZone)
            let bookingDate = Date(timeIntervalSince1970: Double(self.ListData[indexPath.row].bookingDate))

            var calendar = Calendar.current
            if let toDate = calendar.date(bySettingHour: Int(toArray.first ?? "0") ?? 0, minute: Int(toArray.last ?? "0") ?? 0, second: 0, of: bookingDate) {
                print("Current Date \(currentDate)")
                print("toDate Date \(toDate)")
                if currentDate >= toDate {
                    if self.ListData[indexPath.row].status == "accepted" {
                        if self.ListData[indexPath.row].orderstatus == "pending"{
                            if UserDefaultModule.shared.getLoginData().type != "doctor"{
                                cell.acceptButton.isHidden = false
                                cell.actionStackView.isHidden = false
                                cell.rescheduleButton.isHidden = true
                                cell.declineButton.isHidden = true
                            }
                        }else{
                            cell.acceptButton.isHidden = true
                            cell.declineButton.isHidden = true
                            cell.actionStackView.isHidden = true
                        }
                    }
                }
            }
        }
        else {
            if self.previousListData.count > indexPath.row {
                cell.loadData(self.previousListData[indexPath.row])
                cell.actionStackView.isHidden = true
                if indexPath.row == (self.previousListData.count - 1) && self.isFound == true && self.previousListData.count >= 10{
                    self.offset = self.previousListData.count
                    self.loadData()
                }
                if (self.previousListData[indexPath.row].status.lowercased()) == "accepted" || (self.previousListData[indexPath.row].status.lowercased()) == "completed" {
                    if (self.previousListData[indexPath.row].paytoken ?? "") != "" {
                        if self.doctorType == "user" {
                            cell.actionStackView.isHidden = false
                            cell.acceptButton.isHidden = false
                            cell.rescheduleButton.isHidden = true
//                            if self.previousListData[indexPath.row].
                            if self.previousListData[indexPath.row].review == "" {
                                cell.acceptButton.setTitle(getLanguage["write_review"] ?? "Write Review", for: .normal)
                            }
                            else {
                                cell.acceptButton.setTitle(getLanguage["edit_review"] ?? "edit_review", for: .normal)
                            }
                            cell.acceptButton.sizeToFit()
                            cell.declineButton.isHidden = true
                        }else if self.doctorType == "digitalclinic"{
                            cell.actionStackView.isHidden = false
                            cell.acceptButton.isHidden = false
                            cell.rescheduleButton.isHidden = true
//                            if self.previousListData[indexPath.row].
                            if self.previousListData[indexPath.row].review == "" {
                                cell.acceptButton.setTitle(getLanguage["write_review"] ?? "Write Review", for: .normal)
                            }
                            else {
                                cell.acceptButton.setTitle(getLanguage["edit_review"] ?? "edit_review", for: .normal)
                            }
                            cell.acceptButton.sizeToFit()
                            cell.declineButton.isHidden = true
                        }
                    }
                }
            }
        }

        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        cell.rescheduleButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(self.acceptButtonAct(_:)), for: .touchUpInside)
        cell.rescheduleButton.addTarget(self, action: #selector(self.rescheduleButtonAct(_:)), for: .touchUpInside)
        cell.declineButton.addTarget(self, action: #selector(self.cancelButtonAct(_:)), for: .touchUpInside)

        return cell
    }
    func changeToSystemTimeZone(_ date: Date, from: TimeZone, to: TimeZone = TimeZone.current) -> Date {
        let sourceOffset = from.secondsFromGMT(for: date)
        let destinationOffset = to.secondsFromGMT(for: date)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
        return Date(timeInterval: timeInterval, since: date)
    }
    @objc func acceptButtonAct(_ sender: UIButton) {
        var bookingID = ""

          if self.historyType == "current" {
              bookingID = self.ListData[sender.tag].bookingId ?? ""
          }
          else {
              bookingID = self.previousListData[sender.tag].bookingId ?? ""
          }
        if (sender.currentTitle ?? "") == (getLanguage["write_review"] ?? "write_review") || (sender.currentTitle ?? "") == (getLanguage["edit_review"] ?? "edit_review"){
            let pageObj = ReviewViewController()
            
            if self.historyType == "current" {
                pageObj.reviewData = ReviewModel(bookingId: bookingID, reviewDate: 0, reviewId: self.ListData[sender.tag].reviewId, reviewRating: (self.ListData[sender.tag].rating ?? "0"), reviewerId: self.ListData[sender.tag].doctorId, reviewerImage: self.ListData[sender.tag].userImage, reviewerName: self.ListData[sender.tag].userName, userReview: self.ListData[sender.tag].review)
            }
            else {
                pageObj.reviewData = ReviewModel(bookingId: bookingID, reviewDate: 0, reviewId: self.previousListData[sender.tag].reviewId, reviewRating: (self.previousListData[sender.tag].rating ?? "0"), reviewerId: self.previousListData[sender.tag].doctorId, reviewerImage: self.previousListData[sender.tag].userImage, reviewerName: self.previousListData[sender.tag].userName, userReview: self.previousListData[sender.tag].review)
            }
            pageObj.refreshChat = {
                self.isFound = true
                self.previousListData.removeAll()
                self.offset = 0
                self.tableView.reloadData()
                self.hideView.isHidden = false
                self.activityIndicatorView.startAnimating()
                self.loadData()

            }
           // pageObj.resModel = self.reviewDataArr
            NCTRL.pushViewController(pageObj, animated: true)
        }
        else {
            if UserDefaultModule.shared.getLoginData().type != "doctor"{
                if self.ListData[sender.tag].status == "accepted" || self.ListData[sender.tag].status == "Confirmed"{
                    print("IF CONDITION WORKING")
                    
                    let pageObj = PaymentViewController()
                    
                    let doctorDetails = DoctorResultModel(averageRating: self.doctorData?.averageRating ?? "", bookingType: self.doctorData?.bookingType ?? "", doctorId: self.doctorData?.doctorId ?? "", doctorImage: self.doctorData?.doctorImage ?? "", consultFees: self.doctorData?.consultFees ?? "", slotBookingtype: self.doctorData?.slotBookingtype ?? "")
                    pageObj.doctorData = doctorDetails
                    pageObj.bookingSlotModel = BookingSlotResultModel(consultFees: (self.ListData[sender.tag].price ?? ""), currency: (self.ListData[sender.tag].currency ?? ""), grandTotal: (self.ListData[sender.tag].grandTotal ?? ""), sitefees: (self.ListData[sender.tag].sitefees ?? ""), tax: (self.ListData[sender.tag].tax ?? ""), currencycode: (self.ListData[sender.tag].currencycode ?? ""), price: (self.ListData[sender.tag].price ?? ""), convertedcurrencycode: (self.ListData[sender.tag].convertedcurrencycode ?? ""))
                    pageObj.stripeKey = (self.ListData[sender.tag].stripePublishkey ?? "")
                    pageObj.doctor_id = (self.ListData[sender.tag].doctorId ?? "")
                    pageObj.booking_id = (self.ListData[sender.tag].bookingId ?? "")
                    
                    NCTRL.pushViewController(pageObj, animated: true)
                }else{
                    self.hideView.isHidden = false
                    self.activityIndicatorView.startAnimating()
                    self.viewModel.reschudlebooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: "Reschedule", booking_id: bookingID, status: "Accepted", onSuccess: { (success) in
                        let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                        if success {
                            alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                        }
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            if success {
                                if self.historyType == "current" {
                                    self.ListData[sender.tag].status = "accepted"
                                }
                                else {
                                    self.previousListData[sender.tag].status = "accepted"
                                }
                            }
                            self.tableView.reloadData()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.hideView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                    }) { (failure) in
                        self.hideView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }else{
                self.hideView.isHidden = false
                self.activityIndicatorView.startAnimating()
                self.viewModel.CancelBooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: doctorType, booking_id: bookingID, status: "accepted", onSuccess: { (success) in
                    let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                    if success {
                        alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                    }
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                        if success {
                            if self.historyType == "current" {
                                self.ListData[sender.tag].status = "accepted"
                            }
                            else {
                                self.previousListData[sender.tag].status = "accepted"
                            }
                        }
                        self.tableView.reloadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    self.hideView.isHidden = true
                    self.activityIndicatorView.stopAnimating()
                }) { (failure) in
                    self.hideView.isHidden = true
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }

    }
    @objc func rescheduleButtonAct(_ sender: UIButton){
//        var dateVal = (self.selectedDate ?? 0)
//        if dateVal == 0 {
//            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//            let date = Calendar.current.date(from: components)
//            dateVal = Int(date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
//        }
        let pageObj = BookingCalendarViewController()
        pageObj.doctorData = self.viewModel1.doctorModel?.result
        pageObj.type = "request"
        pageObj.booking_type = "videovisit"
        pageObj.redoctorID = self.ListData[sender.tag].doctorId ?? ""
        pageObj.sendType = "redoctor"
        pageObj.res = "1"
        pageObj.bookingID = self.ListData[sender.tag].bookingId ?? ""
        pageObj.resechudle_date = self.ListData[sender.tag].bookingDate
//        pageObj.doctorData?.doctorId = self.ListData[sender.tag].doctorId ?? ""
//        print("DOCTORID:\(self.ListData[sender.tag].doctorId ?? "")")
//        viewModel1.getSlotData(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: "\(self.ListData[sender.tag].doctorId ?? "")", type:"videovisit" , date: dateVal, onSuccess: { (success) in
//            pageObj.tableView.reloadData()
//            pageObj.collectionView.reloadData()
//            print("SUCCESS")
//        }, onFailure: { (failure) in
//            print("FAILURE")
//        })
        NCTRL.pushViewController(pageObj, animated: true)
    }
    @objc func cancelButtonAct(_ sender: UIButton) {
        var bookingID = ""
        if self.historyType == "current" {
            bookingID = self.ListData[sender.tag].bookingId ?? ""
        }
        else {
            bookingID = self.previousListData[sender.tag].bookingId ?? ""
        }
        var status = "cancelled"
        if (sender.currentTitle?.lowercased() ?? "") == "decline" {
            status = "declined"
        }
        if UserDefaultModule.shared.getLoginData().type != "doctor"{
            self.hideView.isHidden = false
            self.activityIndicatorView.startAnimating()
            self.viewModel.reschudlebooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: "Reschedule", booking_id: bookingID, status: "Rejected", onSuccess: { (success) in
                let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                if success {
                    alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                }
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                    if success {
                        if self.historyType == "current" {
                            self.ListData[sender.tag].status = "cancelled"
                        }
                        else {
                            self.previousListData[sender.tag].status = "cancelled"
                        }
                    }
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion: nil)
                self.hideView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }) { (failure) in
                self.hideView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }else{
            self.hideView.isHidden = false
            self.activityIndicatorView.startAnimating()
            self.viewModel.CancelBooking(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), type: doctorType, booking_id: bookingID, status: status, onSuccess: { (success) in
                let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? ""), preferredStyle: .alert)
                if success {
                    alert.message = getLanguage[(self.viewModel.actionModel?.message ?? "")] ?? (self.viewModel.actionModel?.message ?? "")
                }
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                    if success {
                        if self.historyType == "current" {
                            self.ListData[sender.tag].status = "Declined"
                        }
                        else {
                            self.previousListData[sender.tag].status = "Declined"
                        }
                    }
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true, completion: nil)
                self.hideView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }) { (failure) in
                self.hideView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageObj = BookingDetailsViewController()
        pageObj.type = self.doctorType
        
        pageObj.historyType = self.historyType
        if self.historyType == "current" {
            pageObj.bookingResultModel = self.ListData[indexPath.row]
            pageObj.booking_id = self.ListData[indexPath.row].bookingId
            pageObj.user_id = self.ListData[indexPath.row].userId
        }
        else {
            pageObj.bookingResultModel = self.previousListData[indexPath.row]
            pageObj.booking_id = self.previousListData[indexPath.row].bookingId
            pageObj.user_id = self.previousListData[indexPath.row].userId
        }
        pageObj.bookingResultModel?.type = self.historyType
        NCTRL.pushViewController(pageObj, animated: true)
    }
}
/*
extension HostListViewController: GADBannerViewDelegate {
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
