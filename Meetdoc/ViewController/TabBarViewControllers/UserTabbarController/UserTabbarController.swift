//
//  UserTabbarController.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class UserTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
          self.delegate = self
          let dashboardVC = ExploreCollectionViewController()
          dashboardVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "home") as! String), image: #imageLiteral(resourceName: "usersearch"), selectedImage: #imageLiteral(resourceName: "userfillsearch"))
          dashboardVC.tabBarItem.tag = 0
          dashboardVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
          let calenderVC = SavedListViewController()
          calenderVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "saved") as! String), image: #imageLiteral(resourceName: "tab_saved"), selectedImage: #imageLiteral(resourceName: "tab_saved1"))
          calenderVC.tabBarItem.tag = 0
          calenderVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
//          let bookingVC = MyBookingSegmentViewController()
//          bookingVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "booking") as! String), image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))
//          bookingVC.tabBarItem.tag = 0
//          bookingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        let bookingVC = HostListViewController()
        bookingVC.isNotFromTabbar = false
        bookingVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "booking") as! String), image: #imageLiteral(resourceName: "tab_booking"), selectedImage: #imageLiteral(resourceName: "tab_booking1"))
        bookingVC.tabBarItem.tag = 0
        bookingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
          let chatVC = InboxViewController()
          chatVC.viewType = "user"
          chatVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "message") as! String), image: #imageLiteral(resourceName: "tab_message"), selectedImage: #imageLiteral(resourceName: "tab_message1"))
          chatVC.tabBarItem.tag = 0
          chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          
          let profileVC = TripProfilePage()
          profileVC.tabBarItem = UITabBarItem(title: (Utility().language().value(forKey: "profile") as! String), image: #imageLiteral(resourceName: "tab_user_profile"), selectedImage: #imageLiteral(resourceName: "tab_user_profile1"))
          profileVC.tabBarItem.tag = 0
          profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

          let tabBarList = [dashboardVC, calenderVC, bookingVC, chatVC, profileVC]
          self.tabBar.unselectedItemTintColor = UIColor(named: "TitleColor") ?? .white
          self.extendedLayoutIncludesOpaqueBars = true
          self.tabBar.backgroundColor = UIColor(named: "appbg") ?? .white
          self.tabBar.tintColor = UIColor(named: "AppColor") ?? .white
          viewControllers = tabBarList
  //        self.setNeedsStatusBarAppearanceUpdate()
      }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         if !(viewController.isKind(of: ExploreCollectionViewController.self)){
            if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") == "") {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                  appdelegate.setInitialViewController(initialView: UserSigninViewController())
//                appdelegate.setInitialViewController(initialView: DigitalClinicSignupViewController())
               // appdelegate.setInitialViewController(initialView: DigitalClinicSigninViewController())
                return false
            }
            //  return true
         }
          return true
    }
}
