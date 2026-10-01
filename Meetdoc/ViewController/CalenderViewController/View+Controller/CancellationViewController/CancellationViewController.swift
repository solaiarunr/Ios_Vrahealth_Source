//
//  CancellationViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
protocol cancellationPolicyDelegate {
    func selectCancellationPolicy(_ selectedID: String, policyName: String)
}
class CancellationViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var noStackView: UIStackView!
    var viewModel = CalendarViewModel()
    var filterPolicyArray = [AdminPropertyResultModel]()
    var isSearchFlag = false
    var selectedID = ""
    var delegate: cancellationPolicyDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewDidLayoutSubviews() {
        
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "cancellation") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.applyButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
        self.applyButton.cornerMiniumRadius()
        self.applyButton.backgroundColor = UIColor(named: "AppColor")
        self.noLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "policy _not_found")
        self.noStackView.isHidden = true
        self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        self.tableView.register(UINib(nibName: "CancellationTableViewCell", bundle: nil), forCellReuseIdentifier: "CancellationTableViewCell")
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func loadData() {
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.getAdminListProperties(onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            self.tableView.reloadData()
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
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
    @IBAction func applyButtonAct(_ sender: UIButton) {
        if let cancellation = self.viewModel.adminModel?.result.filter({"\($0.id ?? 0)" == self.selectedID}).first {
            self.delegate?.selectCancellationPolicy(self.selectedID, policyName: cancellation.policyName)
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func textFieldEditingChangedAct(_ sender: UITextField) {
        var tempProductModel = [AdminPropertyResultModel]()
        if let specialitiesResult = self.viewModel.adminModel?.result {
            tempProductModel = specialitiesResult
            self.filterPolicyArray.removeAll()
        }
        let filterVal = tempProductModel.filter({$0.policyName.localizedCaseInsensitiveContains(sender.text!)})
        if filterVal.count > 0 {
            for filter in filterVal {
                if !self.filterPolicyArray.contains(where: {$0.id == filter.id}) {
                    self.filterPolicyArray.append(filter)
                }
            }
        }
        if self.filterPolicyArray.count == 0 && self.searchTextField.text == "" {
            self.isSearchFlag = false
        }
        else {
            if self.filterPolicyArray.count == 0 {
                self.noStackView.isHidden = false
            }
            else {
                self.noStackView.isHidden = true
            }
            self.isSearchFlag = true
        }
        self.tableView.reloadData()
    }
}
extension CancellationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearchFlag == true ? self.filterPolicyArray.count : (self.viewModel.adminModel?.result.count ?? 0)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.noStackView.isHidden = true
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CancellationTableViewCell") as! CancellationTableViewCell
        cell.selectionStyle = .none
        let cancellationData = self.isSearchFlag == true ? self.filterPolicyArray[indexPath.row] : (self.viewModel.adminModel?.result[indexPath.row])
        if let cancellation = cancellationData {
            cell.titleLabel.text = cancellation.policyName
            cell.descLabel.text = cancellation.content
            if selectedID == "\(cancellation.id ?? 0)" {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let specialitiesVal = self.isSearchFlag == true ? self.filterPolicyArray[indexPath.row] : (self.viewModel.adminModel?.result[indexPath.row]) {
            if selectedID == "\(specialitiesVal.id ?? 0)" {
                self.selectedID = ""
            }
            else {
                self.selectedID = "\(specialitiesVal.id ?? 0)"
            }
        }
        self.tableView.reloadData()
    }
}
extension CancellationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewDidLayoutSubviews()
    }
}
