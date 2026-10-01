//
//  DoctorTabViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        
        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: getLanguage["dashboard"] ?? "dashboard", image: #imageLiteral(resourceName: "tab_dashboard"), selectedImage: #imageLiteral(resourceName: "dashboard_active-1"))
        
        let calenderVC = CalendarPickerViewController()
        calenderVC.tabBarItem = UITabBarItem(title: getLanguage["calender"] ?? "calender", image: #imageLiteral(resourceName: "tab_calender"), selectedImage: #imageLiteral(resourceName: "tab_calender1"))

//        let bookingVC = MyBookingSegmentViewController()
//        bookingVC.tabBarItem = UITabBarItem(title: getLanguage["booking"] ?? "booking", image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))
        
        let bookingVC = HostListViewController()
        bookingVC.isNotFromTabbar = false
        bookingVC.tabBarItem = UITabBarItem(title: getLanguage["booking"] ?? "booking", image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))

        let chatVC = InboxViewController()
        chatVC.viewType = "doctor"
        chatVC.tabBarItem = UITabBarItem(title: getLanguage["message"] ?? "message", image: #imageLiteral(resourceName: "tab_message"), selectedImage: #imageLiteral(resourceName: "message_active"))

        let profileVC = DoctorProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: getLanguage["profile"] ?? "profile", image: #imageLiteral(resourceName: "tab_profile"), selectedImage: #imageLiteral(resourceName: "profile_Doc_active"))

        let tabBarList = [dashboardVC, calenderVC, bookingVC, chatVC, profileVC]
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.tabBar.unselectedItemTintColor = UIColor(named: "TitleColor") ?? .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBar.backgroundColor = UIColor(named: "appbg") ?? .white
        self.tabBar.tintColor = UIColor(named: "AppColor") ?? .white
        self.viewControllers = tabBarList
    }

}
