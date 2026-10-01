//
//  DCTabbarViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 12/08/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class DCTabbarViewController: UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        let exploreVC = ExploreCollectionViewController()
     //   let exploreVC = PrescriptionViewController()
        exploreVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "home") as! String), image: #imageLiteral(resourceName: "homeig"), selectedImage: #imageLiteral(resourceName: "homefilll"))
//        exploreVC.tabBarItem.tag = 0
//        exploreVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //
        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(title: getLanguage["dashboard"] ?? "dashboard", image: #imageLiteral(resourceName: "tab_dashboard"), selectedImage: #imageLiteral(resourceName: "dashboard_active-1"))
//        dashboardVC.tabBarItem.tag = 0
//        dashboardVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        let bookingVC = MyBookingSegmentViewController()
//        bookingVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "booking") as! String), image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))
        
        
        
        let bookingVC = HostListViewController()
        bookingVC.isNotFromTabbar = false
        bookingVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "booking") as! String), image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))

        
        let calenderVC = CalendarPickerViewController()
        calenderVC.tabBarItem = UITabBarItem(title: getLanguage["calender"] ?? "calender", image: #imageLiteral(resourceName: "tab_calender"), selectedImage: #imageLiteral(resourceName: "tab_calender1"))
//        calenderVC.tabBarItem.tag = 0
//        calenderVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
       //  let profileVC = TripProfilePage()
       
        let profileVC = DCprofileViewController()
        profileVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "profile") as! String), image: #imageLiteral(resourceName: "tab_profile"), selectedImage: #imageLiteral(resourceName: "profile_Doc_active"))
//        profileVC.tabBarItem.tag = 0
//        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let tabBarList = [exploreVC, dashboardVC, bookingVC, calenderVC, profileVC]
        self.tabBar.unselectedItemTintColor = UIColor(named: "TitleColor") ?? .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.tabBar.backgroundColor = UIColor(named: "appbg") ?? .white
        self.tabBar.tintColor = UIColor(named: "AppColor") ?? .white
        viewControllers = tabBarList
//        self.setNeedsStatusBarAppearanceUpdate()
    }
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//         if !(viewController.isKind(of: ExploreCollectionViewController.self)){
//            if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") == "") {
//                let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                appdelegate.setInitialViewController(initialView: DigitalClinicSigninViewController())
////                appdelegate.setInitialViewController(initialView: DigitalClinicSignupViewController())
//                return false
//            }
//            //  return true
//         }
//          return true
//    }
}
