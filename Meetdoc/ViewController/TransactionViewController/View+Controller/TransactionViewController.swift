//
//  TransactionViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class TransactionViewController: UIViewController {
    

    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityView: NVActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var alignStackView: UIStackView!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var pendingButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    var viewModel = ProgressViewModel()
    var id = ""
    var offset = 0
    var limit = 10
    var isFound = true
    var transactionData = [TransactionResultModel]()
    var refreshControl = UIRefreshControl()
    var status = ""
    var tag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TableViewLoadAnimation(0)
        self.view.addSubview(indicatorView)
        self.checkReachability()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        
        self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    @objc func refresh(_ sender:UIRefreshControl) {
        self.offset = 0
        self.isFound = true
        self.transactionData.removeAll()
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.bannerWholeView.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title:         Utility().language().value(forKey: "transaction_history") as? String ?? "transaction_history", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.errorLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular18, align: .center, text: "no_trans_yet")
        self.tableView.register(UINib(nibName: "TransactionHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionHistoryTableViewCell")
//        self.pendingButton.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.sectionHeaderHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        tableView.addSubview(refreshControl)
        Utility().startAnimation(viewController: self)
        self.transactionData.removeAll()
        self.offset = 0
        self.isFound = true
//        self.loadAddOns()
        self.loadData()
        self.completedButton.setTitleColor(UIColor(named: "AppColor") ?? .white, for: .normal)
        
        self.ButtonColor()
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
    func TableViewLoadAnimation(_ tag: Int) {
        if tag == 0 {
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
        }
        else {
            self.activityView.isHidden = false
            self.activityView.startAnimating()
        }
    }
    func loadData() {
        self.viewModel.getTransactionData(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", offset: "\(self.offset)", limit: "\(self.limit)", option: "\(self.tag)", onSuccess: { (success) in
            if (self.viewModel.transactionModel?.result.count ?? 0 == 0) {
                self.isFound = false
            }
            else {
                if self.viewModel.transactionModel?.result != nil {
                            self.transactionData += self.viewModel.transactionModel!.result
                    }
                    }
            self.refreshControl.endRefreshing()
            Utility().stopAnimation(viewController: self)
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }) { (failure) in
            Utility().stopAnimation(viewController: self)
        }
    }
    func ButtonColor() {
        self.completedButton.config(color: UIColor(named: "primary_text") ?? .white, font: regularFont, align: .center, title: "completed")
        self.pendingButton.config(color: UIColor(named: "primary_text") ?? .white, font: regularFont, align: .center, title: "pending")
        self.othersButton.config(color: UIColor(named: "primary_text") ?? .white, font: regularFont, align: .center, title: "others")
    }
    @IBAction func statusButtonAct(_ sender: UIButton) {
        self.ButtonColor()
        sender.setTitleColor(UIColor(named: "AppColor") ?? .white, for: .normal)
        if sender.tag == 0 {
            self.isFound = true
            self.alignStackView.alignment = .leading
        }
        else if sender.tag == 1 {
            self.isFound = true
            self.alignStackView.alignment = .center
        }
        else if sender.tag == 2 {
            self.isFound = true
            self.alignStackView.alignment = .trailing
        }
        self.transactionData.removeAll()
        self.offset = 0
        self.tag = sender.tag
        self.loadData()
    }
}
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transactionData.count == 0 {
            self.errorLabel.isHidden = false
        }
        return self.transactionData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.errorLabel.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryTableViewCell") as! TransactionHistoryTableViewCell
        
        if self.transactionData.count > indexPath.row {
                cell.loadData(transactionData[indexPath.row])
        }
        cell.bookingTypeLabel.isHidden = true
        if "\(self.tag)" == "2" {
            cell.bookingTypeLabel.isHidden = false
        }
        if indexPath.row == (self.transactionData.count - 1) && self.isFound == true {
            self.offset = self.transactionData.count
            self.loadData()
        }
        return cell
    }
    
}
/*
extension TransactionViewController: GADBannerViewDelegate {
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
