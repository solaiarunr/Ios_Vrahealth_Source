//
//  HospitalDetailsViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class HospitalDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = DoctorViewModel()
    
    var hospitalID = ""
    var titleArray = ["", "more_about", "insurance_plan", "specialities" , "hospital_location"]
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        Utility.shared.startAnimation(viewController: self)

        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.leftNavigationBarButtonItem()
        self.rightNavigationBarButtonItem()
        self.tableView.register(UINib(nibName: "HospitalDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "HospitalDetailsTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorAboutTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorAboutTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorDetailsTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorLocationTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorLocationTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DoctorHeaderTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40
        self.loadData()

    }
    func loadData() {
        self.viewModel.getHospitalData(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", hospital_id: hospitalID, onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            self.tableView.reloadData()
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
        
        let button1: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        button1.setImage(#imageLiteral(resourceName: "share"), for: UIControl.State.normal)
        button1.tag = 1
        //        button1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button1.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button1.imageView?.tintColor = UIColor(named: "White")
        button1.addTarget(self, action: #selector(self.rightBarButtonAct(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button1)
    }
    @objc func rightBarButtonAct(_ sender: UIButton) {
        let textToShare = [self.viewModel.hospitalModel?.result.shareUrl ?? webURL]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    
 }
extension HospitalDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let res = self.viewModel.hospitalModel?.result {
            if section == 4 {
                return res.location.count
            }
            return 1
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let res = self.viewModel.hospitalModel?.result {
            return 5
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DoctorHeaderTableViewCell") as! DoctorHeaderTableViewCell
        cell.titleLabel.text = getLanguage[titleArray[section]] ?? titleArray[section]
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalDetailsTableViewCell") as! HospitalDetailsTableViewCell
            cell.selectionStyle = .none
            if let res = self.viewModel.hospitalModel?.result {
                cell.loadData(res)
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAboutTableViewCell") as! DoctorAboutTableViewCell
            cell.refreshTable = {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            cell.selectionStyle = .none
            if let res = self.viewModel.hospitalModel?.result {
                cell.aboutLabel.text = res.descriptionField
            }
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorLocationTableViewCell") as! DoctorLocationTableViewCell
            cell.selectionStyle = .none
            if let res = self.viewModel.hospitalModel?.result {
                cell.loadHospitalData(res, index: indexPath.row)
            }
            cell.directionLabel.tag = indexPath.row
            cell.locationImageView.tag = indexPath.row
            
            cell.directionLabel.isUserInteractionEnabled = true
            cell.directionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
            cell.locationImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
            cell.locationImageView.isUserInteractionEnabled = true
            cell.hospitalNameLabel.isUserInteractionEnabled = true
            cell.hospitalNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionGestureAct)))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorDetailsTableViewCell") as! DoctorDetailsTableViewCell
            cell.selectionStyle = .none
            if let res = self.viewModel.hospitalModel?.result {
                cell.loadHospitalData(res, index: indexPath.section)
            }
            return cell
        }
    }
    @objc func directionGestureAct(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "http://maps.google.com/maps?q=\(self.viewModel.hospitalModel?.result.location[sender.view?.tag ?? 0].latitude ?? ""),\(self.viewModel.hospitalModel?.result.location[sender.view?.tag ?? 0].longitude ?? "")&zoom=14&views=traffic") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
