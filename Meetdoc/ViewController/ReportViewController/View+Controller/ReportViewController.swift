//
//  ReportViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = ReportViewModel()
    var isFromUser = false
    var reportResult = [ReportResultModel]()
    var reportID = 0
    var listID = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(indicatorView)
        self.checkReachability()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)

        self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        self.tableView.register(UINib(nibName: "SavedHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SavedHeaderTableViewCell")
        self.tableView.estimatedSectionHeaderHeight = 75
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "White", fontName: fontRegular18, imageName: "close_x", isLeft: true, vc: self, transparantView: true)
         self.loadData()

    }
    override func viewDidAppear(_ animated: Bool) {
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
        self.viewModel.Report(onSuccess: { (success) in
            if let res = self.viewModel.reportModel?.result {
                self.reportResult = res
                self.tableView.reloadData()
            }
        }) { (failure) in
            
        }
    }
}
extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.reportResult.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 105))
        headerView.backgroundColor = .clear
        let btn = UIButton()
        btn.frame = CGRect.init(x: (self.view.frame.width - 115), y: 30, width: 100, height: 45)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "next"))
        imageView.tintColor = UIColor(named: "White") ?? .white
        imageView.frame = CGRect(x: (self.view.frame.width - 130), y: 30, width: 100, height: 45)
        imageView.contentMode = .right
        view.addSubview(imageView)
        btn.titleLabel?.font = regularFont
        btn.isUserInteractionEnabled = true
        btn.contentHorizontalAlignment = .center
        btn.titleLabel?.textAlignment = .center
        btn.cornerMiniumRadius()
        btn.addTarget(self, action: #selector(self.submitButtonAct(_:)), for: .touchUpInside)
        btn.backgroundColor = UIColor(named: "AppColor")
        btn.setTitleColor(UIColor(named: "White"), for: .normal)
        let titleStr = (Utility().language().value(forKey: "next") as? String ?? "")
        btn.setTitle(titleStr, for: .normal)
        headerView.addSubview(btn)
        headerView.addSubview(imageView)
        return headerView
    }
    @objc func submitButtonAct(_ sender: UIButton) {
        if reportID != 0 {
            Utility().startAnimation(viewController: self)
            if isFromUser {
                self.viewModel.setReportUser(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", reportuser_id: "\(listID)", report_id: "\(reportID)", onSuccess: { (success) in
                    Utility().stopAnimation(viewController: self)
                    self.navigationController?.popViewController(animated: true)
                }) { (failure) in
                    Utility().stopAnimation(viewController: self)
                }
            }
            else {
                self.viewModel.setReportList(user_id: "\(UserDefaultModule().getCurrentUserID() as? String ?? "")", doctor_id: "\(listID)", report_id: "\(reportID)", onSuccess: { (success) in
                    Utility().stopAnimation(viewController: self)
                    self.navigationController?.popViewController(animated: true)
                }) { (failure) in
                    Utility().stopAnimation(viewController: self)
                }
            }
            
        }
        else {
            self.view.makeToast(Utility().language().value(forKey: "select_anyone") as? String ?? "select_anyone")
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedHeaderTableViewCell") as! SavedHeaderTableViewCell
        cell.headerLabel.isHidden = false
        cell.descLabel.isHidden = true
        cell.exploreButton.isHidden = true
        if isFromUser {
            cell.headerLabel.text = (Utility().language().value(forKey: "report_user_title") as? String ?? "report_user_title")
        }
        else {
            cell.headerLabel.text = (Utility().language().value(forKey: "report_listing") as? String ?? "report_listing")
        }
        cell.headerLabel.numberOfLines = 2
        cell.headerLabel.font = fontsemi25
        //        cell.exploreButton.addTarget(self, action: #selector(startExploringButtonAct), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as! ReportTableViewCell
        cell.loadData(self.reportResult[indexPath.row])
        if self.reportID == self.reportResult[indexPath.row].reportId {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
            cell.checkBoxButton.tintColor = UIColor(named: "AppColor") ?? .white
        }
        else {
            cell.checkBoxButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            cell.checkBoxButton.tintColor = UIColor(named: "TitleColor") ?? .white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.reportID != self.reportResult[indexPath.row].reportId {
            self.reportID = self.reportResult[indexPath.row].reportId
            self.tableView.reloadData()
        }
    }
}
