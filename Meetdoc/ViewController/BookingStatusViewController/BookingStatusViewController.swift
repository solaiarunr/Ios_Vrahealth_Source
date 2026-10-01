//
//  BookingStatusViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 28/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class BookingStatusViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dashboardButton: UIButton!
    
    
    var bookingType = "" // "pay", "request", "book"
    var requestType = "" // "video", "direct"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserDefaultModule.shared.getLoginData().type == "user"{
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                let pageObj = UserTabbarController()
                pageObj.selectedIndex = 2
                self.appDelegate.setInitialViewController(initialView: pageObj)
            }
        }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                let pageObj = DCTabbarViewController()
                pageObj.selectedIndex = 2
                self.appDelegate.setInitialViewController(initialView: pageObj)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                let pageObj = DoctorTabViewController()
                pageObj.selectedIndex = 2
                self.appDelegate.setInitialViewController(initialView: pageObj)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func configUI() {

        self.messageLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "")
        self.dashboardButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "Go to booking")
        self.dashboardButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.dashboardButton.cornerMiniumRadius()
        if self.bookingType == "pay" {
            self.imageView.image = #imageLiteral(resourceName: "Group 167")
            self.messageLabel.text = getLanguage["Payment successfully"] ?? "Payment successfully"
        }
        else if self.bookingType == "request" {
            self.imageView.image = requestType == "videovisit" ? #imageLiteral(resourceName: "Group 386") :#imageLiteral(resourceName: "Group 385")
            self.messageLabel.text = getLanguage["Appointment requested successfully, waiting for doctor approval"] ?? "Appointment requested successfully, waiting for doctor approval"
        }
    }

    @IBAction func dahsboardButtonAct(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type == "user"{
            let pageObj = UserTabbarController()
            pageObj.selectedIndex = 2
            self.appDelegate.setInitialViewController(initialView: pageObj)
        }else if UserDefaultModule.shared.getLoginData().type == "digitalclinic"{
            let pageObj = DCTabbarViewController()
            pageObj.selectedIndex = 2
            self.appDelegate.setInitialViewController(initialView: pageObj)
        }else{
            let pageObj = DoctorTabViewController()
            pageObj.selectedIndex = 2
            self.appDelegate.setInitialViewController(initialView: pageObj)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
