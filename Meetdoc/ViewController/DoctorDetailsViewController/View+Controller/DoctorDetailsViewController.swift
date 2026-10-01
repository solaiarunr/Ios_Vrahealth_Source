//
//  DoctorDetailsViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorDetailsViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bookingTypeStackView: UIStackView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var doctorID = ""
    var type = ""
    var viewModel = DoctorViewModel()

    var titleArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
      }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.titleArray = ["", "about_doctor", "new_skills", "specialities","gender", "languages", "qualification", "new_Institute","new_register_number", "photos","reviews", "new_hospital_location"]
        self.loadData()
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.leftNavigationBarButtonItem()
        self.rightNavigationBarButtonItem()
        self.tableView.register(UINib(nibName: "DoctorProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorProfileTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorAboutTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorAboutTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorDetailsTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorLocationTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DoctorHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        self.tableView.register(UINib(nibName: "DetailsFooterTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DetailsFooterTableViewCell")

        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40
        
        self.videoButton.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "video_visit")
        self.videoButton.backgroundColor = UIColor(named: "VideoButtonColor")
        self.videoButton.cornerMiniumRadius()
        self.bookButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "book")
        self.bookButton.backgroundColor = UIColor(named: "AppColor")
        self.bookButton.cornerMiniumRadius()
        self.bookButton.isHidden = true
        self.bookingTypeStackView.isHidden = true
        Utility.shared.startAnimation(viewController: self)
     }
    func loadData() {
        self.viewModel.getDoctorData(user_id: UserDefaultModule.shared.getLoginData().userId ?? "1", doctor_id: doctorID, onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            
            if self.viewModel.doctorModel?.result.portfolioImages.count == 0 && self.viewModel.doctorModel?.result.insurancelist.count == 0 {
                self.titleArray = ["", "about_doctor", "new_skills", "specialities", "gender", "languages", "qualification","new_Institute", "new_register_number","reviews", "new_hospital_location"]
            }else if self.viewModel.doctorModel?.result.portfolioImages.count == 0 {
                self.titleArray = ["", "about_doctor", "new_skills","specialities", "gender", "languages", "qualification","new_Institute", "new_register_number","reviews", "new_hospital_location"]
            }else if self.viewModel.doctorModel?.result.insurancelist.count == 0 {
                self.titleArray = ["", "about_doctor", "new_skills", "specialities", "gender", "languages", "qualification","new_Institute", "new_register_number", "photos","reviews", "new_hospital_location"]
            }
            self.tableView.reloadData()
            self.bookingTypeStackView.isHidden = false
            if (self.viewModel.doctorModel?.result.slotBookingtype ?? "") == "directvisit" {
                self.videoButton.isHidden = true
                self.bookButton.isHidden = false
            }
            else if (self.viewModel.doctorModel?.result.slotBookingtype ?? "") == "videovisit" && (self.viewModel.doctorModel?.result.isVideovisit ?? false){
                self.videoButton.isHidden = false
                self.bookButton.isHidden = true
            }
            else {
                self.videoButton.isHidden = false
                self.bookButton.isHidden = false
            }
            
            
            self.rightNavigationBarButtonItem()
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func leftNavigationBarButtonItem() {
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        barButton.addTarget(self, action: #selector(barButtonAct(_:)), for: .touchUpInside)
        barButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 4, right: 3)
        barButton.setImage(UIImage(named: "left_arrow"), for: .normal)
        barButton.tintColor = UIColor(named: "White")
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton)]
    }
    @objc func barButtonAct(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func rightNavigationBarButtonItem() {
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        button.tintColor = UIColor(named: "whitecolor")
        if (self.viewModel.doctorModel?.result?.isliked ?? false) {
            button.setImage(#imageLiteral(resourceName: "heart_filled"), for: UIControl.State.normal)
        }
        else {
            button.setImage(#imageLiteral(resourceName: "unlike"), for: UIControl.State.normal)
        }
        button.imageView?.tintColor = UIColor(named: "White")
        button.tag = 0
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
         let button1: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        button1.setImage(#imageLiteral(resourceName: "share_icon"), for: UIControl.State.normal)
        button1.tag = 1
//        button1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button1.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button1.imageView?.tintColor = UIColor(named: "White")
        button1.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
         let stackview = UIStackView.init(arrangedSubviews: [button,button1])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 10
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackview)
    }
    
    @IBAction func videoButtonAct(_ sender: UIButton) {
        if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != "") {
            let pageObj = BookingCalendarViewController()
            pageObj.doctorData = self.viewModel.doctorModel?.result
            pageObj.type = self.type
            print("TYPE:\(pageObj.type)")
            pageObj.booking_type = "videovisit"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.setInitialViewController(initialView: UserSigninViewController())
        }
        
    }
    @IBAction func bookButtonAct(_ sender: UIButton) {
        if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != "") {
            let pageObj = BookingCalendarViewController()
            pageObj.doctorData = self.viewModel.doctorModel?.result
            pageObj.type = self.type
            pageObj.booking_type = "videovisit"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.setInitialViewController(initialView: UserSigninViewController())
        }
    }
    @objc func rightBarButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != "") {
                if (sender.imageView?.image ?? #imageLiteral(resourceName: "heart")) == #imageLiteral(resourceName: "unlike") {
                    sender.setImage(#imageLiteral(resourceName: "heart_filled"), for: UIControl.State.normal)
                }
                else {
                    sender.setImage(#imageLiteral(resourceName: "unlike"), for: UIControl.State.normal)
                }
                let savedViewModel = ExploreViewModel()
                savedViewModel.likeAct(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", doctor_id: "\(self.viewModel.doctorModel?.result.doctorId ?? "")", onSuccess: { (success) in
                    if success {
                        self.viewModel.doctorModel?.result.isliked = !(self.viewModel.doctorModel?.result.isliked ?? false)
                    }
                    self.tableView.reloadData()
                }) { (failure) in
                    self.tableView.reloadData()
                }
            }
            else {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.setInitialViewController(initialView: UserSigninViewController())
            }
        }
        else {
            let textToShare = [self.viewModel.doctorModel?.result.shareUrl ?? webURL]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}
extension DoctorDetailsViewController: UITableViewDelegate, UITableViewDataSource, imageDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewModel.doctorModel?.result) != nil {
            if self.titleArray[section] == "reviews" {
                return (self.viewModel.doctorModel?.result.reviews.count ?? 0) > 3 ? 3 : (self.viewModel.doctorModel?.result.reviews.count ?? 0)
            }
//            if section == 10 {
//
//            }
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.viewModel.doctorModel?.result) != nil {
            return self.titleArray.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DoctorHeaderTableViewCell") as! DoctorHeaderTableViewCell
        cell.titleLabel.text = getLanguage[titleArray[section]] ?? titleArray[section]
        if (self.viewModel.doctorModel?.result) != nil {
            if self.titleArray[section] == "reviews" && (self.viewModel.doctorModel?.result.reviews.count ?? 0) == 0 {
                cell.contentLabel.text = getLanguage["no_review_there"] ?? "no_review_there"
                cell.contentLabel.isHidden = false
            }
            else {
                cell.contentLabel.isHidden = true
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.titleArray[section] == "reviews" && (self.viewModel.doctorModel?.result.reviews.count ?? 0) > 3{
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.titleArray[section] == "reviews" && (self.viewModel.doctorModel?.result.reviews.count ?? 0) > 3{
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailsFooterTableViewCell") as! DetailsFooterTableViewCell
            cell.readMoreButton.addTarget(self, action: #selector(self.reviewAct(_:)), for: .touchUpInside)
            return cell
        }
        return nil
    }
    @objc func reviewAct(_ sender: UIButton) {
        if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != "") {
            let pageObj = ReviewPage()
            pageObj.userID = (self.viewModel.doctorModel?.result.doctorId ?? "")
            pageObj.isFromDoctorDetails = true
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.setInitialViewController(initialView: UserSigninViewController())
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.titleArray[indexPath.section] == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileTableViewCell") as! DoctorProfileTableViewCell
            cell.selectionStyle = .none
            if let res = self.viewModel.doctorModel?.result {
                cell.loadData(res, type: self.type)
            }
            cell.reportView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reportAct)))
            return cell
        }
        else if self.titleArray[indexPath.section] == "about_doctor" || self.titleArray[indexPath.section] == "new_skills"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAboutTableViewCell") as! DoctorAboutTableViewCell
            cell.refreshTable = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            cell.selectionStyle = .none
            if let res = self.viewModel.doctorModel?.result {
                cell.loadData(res, index: indexPath.section,title:self.titleArray)
            }
            return cell
        }
        else if self.titleArray[indexPath.section] == "reviews" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
            cell.reviewerNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "verify_info")
            cell.editBtn.isHidden = true
            if let reviewArray = self.viewModel.doctorModel?.result.reviews {
                cell.loadHostReviewData(reviewArray[indexPath.row])
            }
            cell.editBtn.tag = indexPath.row
//            cell.editBtn.addTarget(self, action: #selector(self.editBtnTapped(_:)), for: .touchUpInside)
            return cell
        }
        else if self.titleArray[indexPath.section] == "new_hospital_location" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorLocationTableViewCell") as! DoctorLocationTableViewCell
            cell.selectionStyle = .none
            if let res = self.viewModel.doctorModel?.result {
                cell.loadData(res)
            }
            cell.directionLabel.isUserInteractionEnabled = true
            cell.directionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
            cell.locationImageView.isUserInteractionEnabled = true
            cell.locationImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
            cell.hospitalNameLabel.isUserInteractionEnabled = true
            cell.hospitalNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hospitalLabelAct)))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDetailsTableViewCell") as! DoctorDetailsTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            if let res = self.viewModel.doctorModel?.result {
                cell.loadData(res, index: indexPath.section,title:self.titleArray)
            }
            cell.layoutIfNeeded()
            return cell
        }
    }
    @objc func reportAct(_ sender: UITapGestureRecognizer) {
        
        let reportModel = ReportViewModel()
        if (self.viewModel.doctorModel?.result.reportId ?? "") != "" {
            let alert = UIAlertController(title: nil, message: getLanguage["undo_report_alert"] ?? "undo_report_alert", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? "OK").capitalized, style: .default, handler: { (UIAlertAction) in
                let reportId = (self.viewModel.doctorModel?.result.reportId ?? "")
                self.viewModel.doctorModel?.result.reportId = ""
                Utility().startAnimation(viewController: self)
                reportModel.setReportList(user_id: "\(UserDefaultModule().getCurrentUserID() as String? ?? "")", doctor_id: "\(self.viewModel.doctorModel?.result.doctorId ?? "0")", report_id: reportId, onSuccess: { (success) in
                    self.loadData()
                    self.view.makeToast(getLanguage[reportModel.resultModel?.result ?? ""] ?? reportModel.resultModel?.result ?? "")
                }) { (failure) in
                    Utility().stopAnimation(viewController: self)
                }
            }))
            alert.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? "cancel"), style: .cancel, handler: nil))
                        
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        else {
            if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != "") {
                let pageObj = ReportViewController()
                pageObj.listID = self.viewModel.doctorModel?.result.doctorId ?? "0"
                pageObj.isFromUser = false
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.setInitialViewController(initialView: UserSigninViewController())
            }
        }
        
    }
    @objc func hospitalLabelAct() {
        let pageObj = HospitalDetailsViewController()
        pageObj.hospitalID = self.viewModel.doctorModel?.result.hospitalId ?? ""
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @objc func directionGestureAct() {
        if let url = URL(string: "http://maps.google.com/maps?q=\(self.viewModel.doctorModel?.result.latitude ?? ""),\(self.viewModel.doctorModel?.result.longitude ?? "")&zoom=14&views=traffic") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func selectImageAct(_ selectedIndex: Int) {
        let pageObj = FullImageViewController()
        pageObj.imageModel = self.viewModel.doctorModel?.result.portfolioImages ?? [ImageResultModel]()
        pageObj.selectedIndex = selectedIndex
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
