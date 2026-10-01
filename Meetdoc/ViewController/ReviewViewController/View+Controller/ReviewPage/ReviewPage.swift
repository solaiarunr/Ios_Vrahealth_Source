//
//  ReviewPage.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ReviewPage: UIViewController {
    
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    var ratingVal = Double(0)
    var reviewCount = ""
    var reviewDataArr = [ReviewModel]()
    var offset = 0
    var listId = 0
    var userID = "0"
    var viewModel = ReviewViewModel()
    var refreshControl = UIRefreshControl()
    var isFromDoctorDetails = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCell()
        //self.checkReachability()
        self.view.addSubview(indicatorView)
        Utility().startAnimation(viewController: self)
        configUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.loadData()
    }
    
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "reviews") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.bannerWholeView.isHidden = true
        self.descLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .center, text: "no_review_there")
//        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
        Utility().stopAnimation(viewController: self)
        self.noStackView.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
//        self.loadAddOns()
        
    }
    @objc func refresh(_ sender:UIRefreshControl) {
        self.loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func loadData(){
        var type = "user"
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            type = "doctor"
        }
        var userID = UserDefaultModule.shared.getLoginData().userId ?? ""
        if isFromDoctorDetails {
            userID = self.userID
            type = "doctor"
        }
        self.viewModel.getReviewList(user_id: userID, type: type, onSuccess: {
            (success) in
            if self.viewModel.reviewModel?.status ?? false {
                let res = self.viewModel.reviewModel?.review
                self.reviewDataArr = res!
                print(res?.count as Any)
                self.tableView.reloadData()
            }
            if self.reviewDataArr.count == 0 {
                self.noStackView.isHidden = false
                
            }
            else {
                self.noStackView.isHidden = true
            }
            self.refreshControl.endRefreshing()
            Utility().stopAnimation(viewController: self)
        }) { (failure) in
            self.refreshControl.endRefreshing()
            Utility().stopAnimation(viewController: self)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
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
    @objc func editBtnTapped(_ sender: UIButton) {
        let pageObj = ReviewViewController()
        pageObj.reviewData = self.reviewDataArr[sender.tag]
        pageObj.refreshChat = {
            
        }
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func configCell() {
        self.tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
    }
}
extension ReviewPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        cell.loadHostReviewData(self.reviewDataArr[indexPath.row])
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(self.editBtnTapped(_:)), for: .touchUpInside)
        cell.editBtn.isHidden = true
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            cell.editBtn.isHidden = true
        }
        else if !self.isFromDoctorDetails{
            cell.editBtn.isHidden = false
        }
         return cell
    }
}
/*
extension ReviewPage: GADBannerViewDelegate {
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
