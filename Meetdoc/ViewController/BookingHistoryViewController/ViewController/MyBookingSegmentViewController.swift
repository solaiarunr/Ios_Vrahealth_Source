//
//  MyBookingSegmentViewController.swift
//  AirFinch_Swift
//
//  Created by Arun Andiselvam on 26/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import MXSegmentedPager

class MyBookingSegmentViewController: MXSegmentedPagerController {
    let yourBookingVC = HostListViewController()
    let previousBookingVC = HostListViewController()
    var bookingArray = [HostListViewController]()
    var titleArray = ["your_booking", "previous_booking"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    func setNavigationBar() {
        let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle(Utility().language().value(forKey: "booking") as? String ?? "", for: .normal)
        self.parent?.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton1)]
        self.parent?.navigationItem.rightBarButtonItems = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.setNavigationBar()
        if self.segmentedPager.segmentedControl.selectedIndex == 0 {
            self.yourBookingVC.loadData()
        }
        else {
            self.previousBookingVC.loadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    func configUI() {
        self.setNavigationBar()
        self.yourBookingVC.historyType = "current"
        self.previousBookingVC.historyType = "previous"
        self.bookingArray = [yourBookingVC, previousBookingVC]
        segmentedPager.backgroundColor = UIColor(named: "appbg")
        segmentedPager.segmentedControl.backgroundColor = UIColor(named: "appbg")
        
        segmentedPager.segmentedControl.textColor = (UIColor(named: "secondary_text") ?? .white)
        segmentedPager.segmentedControl.font = regularFont!
        segmentedPager.segmentedControl.selectedTextColor = (UIColor(named: "AppColor") ?? .white)
        segmentedPager.segmentedControl.indicator.lineView.backgroundColor = (UIColor(named: "AppColor") ?? .white)
        segmentedPager.parallaxHeader.height = 0
        let bottomLine = CALayer()
         bottomLine.frame = CGRect(x: 0, y: segmentedPager.frame.height - 1, width: segmentedPager.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        segmentedPager.layer.addSublayer(bottomLine)
        
          if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            self.segmentedPager.segmentedControl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.segmentedPager.pager.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.yourBookingVC.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.previousBookingVC.view.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return getLanguage[titleArray[index]] ?? titleArray[index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
    }
    override func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return titleArray.count
    }
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = bookingArray[index]
        vc.view.tag = index
        return vc
    }
}
