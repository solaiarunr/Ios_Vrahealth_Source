 //
 //  NotificationsSettingsPage.swift
 //  AirFinch_Swift
 //
 //  Created by HTS-SERVICETEAM on 12/11/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //

 import UIKit

 class NotificationsSettingsPage: UIViewController {
  
     @IBOutlet weak var receiveMailButton: UIButton!
     @IBOutlet weak var receiveMailDescLabel: UILabel!
     @IBOutlet weak var receiveMailSubTitleLabel: UILabel!
     @IBOutlet weak var receiveMailTitleLabel: UILabel!
     @IBOutlet weak var reservationButton: UIButton!
     @IBOutlet weak var reservationDescLabel: UILabel!
     @IBOutlet weak var reservationTitleLabel: UILabel!
     @IBOutlet weak var receiveMessageButton: UIButton!
     @IBOutlet weak var receiveDescLabel: UILabel!
     @IBOutlet weak var receiveMessageLabel: UILabel!
     @IBOutlet weak var receiveNotificationTitleLabel: UILabel!
     @IBOutlet weak var pushNotificationButton: UIButton!
     @IBOutlet weak var pushNotificationLabel: UILabel!

     
     var TitleText:String?
     var viewModel = NotificationViewModel()

     override func viewDidLoad() {
         super.viewDidLoad()
        self.view.addSubview(indicatorView)
         self.checkReachability()
        Utility.shared.startAnimation(viewController: self)
                // Do any additional setup after loading the view.
 //        performSelector(inBackground: #selector(self.loadData), with: nil)
     }
     override func viewWillAppear(_ animated: Bool) {
         if Profile.currentProfile != nil {
             CallsApp.connect()
         }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
         self.configUI()
     }
     override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: nil)

     }
     func configUI() {
         
         self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "notifications") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
 //        self.navigationController?.customNavigationBarView(title: "notifications", fColor: "TitleColor", fontName: regular22, vc: self)

         NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: nil)
           
         self.pushNotificationLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .left, text: "pushnotification")
        
         self.receiveNotificationTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .left, text: "receivenotification")
        
         self.receiveMessageLabel.config(color: UIColor(named: "primary_text") ?? .white, font: fontRegular16, align: .left, text: "notification_messages")
        
        // self.receiveDescLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: fontRegular16, align: .left, text: "forhost")
        
         self.reservationTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .left, text: "notification_reservation")
        
       //  self.reservationDescLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: regular14, align: .left, text: "notresertext")
         self.receiveMailTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .left, text: "emailfor")
         self.receiveMailSubTitleLabel.config(color: UIColor(named: "primary_text") ?? .white, font: fontRegular18, align: .left, text: "notification_reservation")
        // self.receiveMailDescLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: regular14, align: .left, text: "notresertext")
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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     @objc func loadData() {
          viewModel.getCheckBoxDetails(user_id: UserDefaultModule.shared.getCurrentUserID()! as String, onSuccess: { (success) in
             print(success)
             self.updateNotificationStatus(self.pushNotificationButton, value: (self.viewModel.notificationSetting?.pushNotification ?? ""))
             self.updateNotificationStatus(self.receiveMailButton, value: (self.viewModel.notificationSetting?.emailReservation ?? ""))
             self.updateNotificationStatus(self.reservationButton, value: (self.viewModel.notificationSetting?.notificationReservation ?? ""))
             self.updateNotificationStatus(self.receiveMessageButton, value: (self.viewModel.notificationSetting?.notificationMessages ?? ""))
            Utility.shared.stopAnimation(viewController: self)
         }) { (fail) in
            Utility.shared.stopAnimation(viewController: self)
             print(fail)
         }
     }
     func updateNotificationStatus(_ sender: UIButton, value: String) {
         let tag = sender.tag / 10
          if value == "enable" {
             sender.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
             sender.tag = (tag * 10) + 1
         }
         else {
             sender.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
             sender.tag = (tag * 10) + 0
         }
     }
     @IBAction func notificationButtonAct(_ sender: UIButton) {
         let tag = sender.tag / 10
         let val = sender.tag % 10

         if val == 0 {
             self.updateNotificationStatus(sender, value: "enable")
          }
         else {
             self.updateNotificationStatus(sender, value: "disable")
         }
         let param = ["text_notification":"0",
         "push_notification":(self.pushNotificationButton.tag % 10) == 1 ? "1" : "0",
         "notification_messages": (self.receiveMessageButton.tag % 10) == 1 ? "1" : "0",
         "notification_reservation":(self.reservationButton.tag % 10) == 1 ? "1" : "0",
         "email_reservation":(self.receiveMailButton.tag % 10) == 1 ? "1" : "0",
         "user_id":UserDefaultModule.shared.getCurrentUserID()! as String]
                 
         viewModel.setCheckBoxDetails(params: param, onSuccess: { (success) in
             print(success)
         }) { (fail) in
             print(fail)
         }
     }
 }

