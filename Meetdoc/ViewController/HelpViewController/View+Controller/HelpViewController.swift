//
//  HelpViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 08/02/21.
//  Copyright © 2021 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HelpViewController: UIViewController {
    
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = HelpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        Utility.shared.startAnimation(viewController: self)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: false)
      NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.configUI()
    }
    
    func loadData() {
        self.viewModel.getHelpList(language: Utility.shared.getLanguageCode(), onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            self.tableView.reloadData()
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
     }
    
    func configUI() {
        self.bannerWholeView.isHidden = true
//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
         self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "help") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
          self.tableView.register(UINib(nibName: "ProfileTabelCell", bundle: nil), forCellReuseIdentifier: "ProfileTabelCell")
//        self.loadAddOns()
        self.loadData()
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
    override func viewWillDisappear(_ animated: Bool) {
        
       NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.helpData?.result.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTabelCell", for: indexPath) as! ProfileTabelCell
        cell.listIcon.isHidden = false
        cell.listIcon.image = #imageLiteral(resourceName: "right_next").imageFlippedForRightToLeftLayoutDirection()
        cell.detailLabel.isHidden = true
        cell.listName.text = self.viewModel.helpData?.result[indexPath.row].title ?? ""
        cell.listName.font = regularFont
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageObj = TermsAndCoditionPage()
        pageObj.termsString = (self.viewModel.helpData?.result[indexPath.row].mainContent ?? "") + (self.viewModel.helpData?.result[indexPath.row].subContent ?? "")
        pageObj.titleString = self.viewModel.helpData?.result[indexPath.row].title ?? ""
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
/*
extension HelpViewController: GADBannerViewDelegate {
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
