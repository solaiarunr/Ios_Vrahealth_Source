 //
 //  SelectInsurancePage.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 26/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import UIKit
 protocol Select_Insurance {
     func addInsurance(_ Insurance: String)
     func selectedInsurance(_ insuranceArray: [InsuranceResultModel])
 }

 class SelectInsurancePage: UIViewController {
     
     @IBOutlet weak var noLabel: UILabel!
     @IBOutlet weak var noStackView: UIStackView!
     @IBOutlet weak var searchView: UIView!
     @IBOutlet weak var searchTextField: UITextField!

     @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var applyBtn: UIButton!
     var offset = 0
     var delegate: Select_Insurance?
     
     var viewModel = AuthenticationViewModel()
     var insuranceArray = [InsuranceResultModel]()
     var filterArray = [InsuranceResultModel]()
     var selectedArray = [InsuranceResultModel]()
     var isSearchFlag = false
    var isFromFilter = false
     
    // Check if Sub Insurance
    var isSubInsurance = false
    var subInsuranceArray = [SubPlanModel]()
    var selectedSubInsurance = [SubPlanModel]()
    
     override func viewDidLoad() {
         super.viewDidLoad()

         self.view.addSubview(indicatorView)
     }
     override func viewWillAppear(_ animated: Bool) {
         if Profile.currentProfile != nil {
             CallsApp.connect()
         }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
         super.viewWillAppear(animated)
         self.configUI()
         self.loadInsuranceData()
     }
    override func viewDidAppear(_ animated: Bool) {
    }
     override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

     }
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     func configUI() {

        if !isSubInsurance {
            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "insurance") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        }
        else {
            self.searchView.isHidden = true
            self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        }
         self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
         self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
         self.searchView.viewRadius(radius:5)
          self.applyBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
         self.noLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "speciality_not_found")
         self.noStackView.isHidden = true
        self.applyBtn.isHidden = isSubInsurance
     }
     func loadInsuranceData(){
         Utility.shared.startAnimation(viewController: self)
         self.viewModel.getInsurenceData(offset: "\(offset)", onSuccess: { (success) in
             self.insuranceArray = self.viewModel.insuranceModel?.result ?? [InsuranceResultModel]()
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
     @IBAction func applyBtnTapped(_ sender: Any) {
        if self.selectedArray.count > 0 {
            if isFromFilter {
                self.delegate?.selectedInsurance(self.selectedArray)
            }
            else {
                self.delegate?.selectedInsurance(self.selectedArray)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: nil, message: getLanguage["select_insurance"] ?? "select_insurance", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     }
     @IBAction func textFieldEditingChangedAct(_ sender: UITextField) {
         var tempProductModel = [InsuranceResultModel]()
         if let specialitiesResult = self.viewModel.insuranceModel?.result {
             tempProductModel = specialitiesResult
             self.filterArray.removeAll()
         }
         let filterVal = tempProductModel.filter({$0.name.localizedCaseInsensitiveContains(sender.text!)})
         if filterVal.count > 0 {
             for filter in filterVal {
                 if !self.filterArray.contains(where: {$0.id == filter.id}) {
                     self.filterArray.append(filter)
                 }
             }
         }
         if self.filterArray.count == 0 && self.searchTextField.text == "" {
             self.isSearchFlag = false
         }
         else {
             self.isSearchFlag = true
         }
         self.tableView.reloadData()
     }
 }
 extension SelectInsurancePage: UITableViewDelegate,UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSubInsurance {
            if (self.isSearchFlag == true && self.filterArray.count == 0) || (self.isSearchFlag == false && self.insuranceArray.count == 0) && !indicatorView.isAnimating {
                self.noStackView.isHidden = false
            }
            else {
                self.noStackView.isHidden = true
            }
            return self.isSearchFlag == true ? self.filterArray.count : self.self.insuranceArray.count
        }
        else {
            return self.subInsuranceArray.count
        }
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
         cell.selectionStyle = .none
        if !isSubInsurance {
            let insuranceVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.insuranceArray[indexPath.row]
            cell.titleLabel.text = insuranceVal.name
            if self.selectedArray.contains(where: {$0.name == insuranceVal.name}) {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        else {
            let insuranceVal = self.subInsuranceArray[indexPath.row]
            cell.titleLabel.text = insuranceVal.name
            if self.selectedSubInsurance.contains(where: {$0.name == insuranceVal.name}) {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSubInsurance {
            let specialitiesVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.insuranceArray[indexPath.row]
             
             if self.selectedArray.contains(where: {$0.name == specialitiesVal.name}) {
                 self.selectedArray.removeAll(where: {$0.name == specialitiesVal.name})
             }
             else {
                if isFromFilter {
                    self.selectedArray.removeAll()
                }
                 self.selectedArray.append(specialitiesVal)
             }
            if isFromFilter && self.selectedArray.count > 0 {
                let pageObj = SelectInsurancePage()
                pageObj.subInsuranceArray = specialitiesVal.subPlan
                pageObj.isSubInsurance = true
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
            else {
                self.tableView.reloadData()
            }
        }
        else {
            self.tableView.reloadData()
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70
     }
 }
 extension SelectInsurancePage: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
 }
 extension Select_Insurance {
     func addInsurance(_ Insurance: String){
     }
 }

