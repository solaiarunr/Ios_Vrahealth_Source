//
//  SpecialitiesSignUpPage.swift
//  Meetdoc
//
//  Created by Arun Andiselvam on 24/09/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol Select_Specialities {
    func addSpecialities(_ specialities: [LanguageModel])
    
}


protocol Select_Specialities1 {
    
    func addSpecialities1(_ specialities: LanguageModel)
}
class SpecialitiesViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImageView: UIImageView!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var illnessId = "0"
    var hospitalId = "0"
    
    var viewModel = AuthenticationViewModel()
    var specialitiesArray = [LanguageModel]()
    var filterSpecialitiesArray = [LanguageModel]()
    var selectedArray = [LanguageModel]()
    var isSearchFlag = false
    
    var delegate: Select_Specialities?
    var delegate1: Select_Specialities1?
    
    var isFromExplore = false
    var isFromFilter = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

         configUI()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadSpecialities()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)

        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "specialities") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent

        self.applyBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
        self.noLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "speciality_not_found")
        self.noStackView.isHidden = true
        
        self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        self.applyBtn.isHidden = isFromExplore
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
    func loadSpecialities(){
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.getSpecialistiesData(illnessId: illnessId, hospitalId: hospitalId, onSuccess: { (success) in
            if success {
                self.specialitiesArray = self.viewModel.specialitiesModel?.result ?? [LanguageModel]()
                self.tableView.reloadData()
            }
            Utility.shared.stopAnimation(viewController: self)
        }) { (success) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    
    @IBAction func applyBtnTapped(_ sender: UIButton) {
        if self.selectedArray.count > 0 {
            self.delegate?.addSpecialities(selectedArray)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: nil, message: getLanguage["select_anyone_specialization"] ?? "select_anyone_specialization", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func textFieldEditingChangedAct(_ sender: UITextField) {
        var tempProductModel = [LanguageModel]()
        if let specialitiesResult = self.viewModel.specialitiesModel?.result {
            tempProductModel = specialitiesResult
            self.filterSpecialitiesArray.removeAll()
        }
        let filterVal = tempProductModel.filter({$0.name.localizedCaseInsensitiveContains(sender.text!)})
        if filterVal.count > 0 {
            for filter in filterVal {
                if !self.filterSpecialitiesArray.contains(where: {$0.id == filter.id}) {
                    self.filterSpecialitiesArray.append(filter)
                }
            }
        }
        if self.filterSpecialitiesArray.count == 0 && self.searchTextField.text == "" {
            self.isSearchFlag = false
        }
        else {
            self.isSearchFlag = true
        }
        self.tableView.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
}
extension SpecialitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearchFlag == true && self.filterSpecialitiesArray.count == 0) || (self.isSearchFlag == false && self.specialitiesArray.count == 0) && !indicatorView.isAnimating {
            self.noStackView.isHidden = false
        }
        else {
            self.noStackView.isHidden = true
        }
        return self.isSearchFlag == true ? self.filterSpecialitiesArray.count : self.self.specialitiesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        let specialitiesVal = self.isSearchFlag == true ? self.filterSpecialitiesArray[indexPath.row] : self.specialitiesArray[indexPath.row]
        cell.titleLabel.text = specialitiesVal.name
        if self.selectedArray.contains(where: {$0.name == specialitiesVal.name}) {
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
        }
        else {
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialitiesVal = self.isSearchFlag == true ? self.filterSpecialitiesArray[indexPath.row] : self.specialitiesArray[indexPath.row]
        
        if self.selectedArray.contains(where: {$0.name == specialitiesVal.name}) {
            self.selectedArray.removeAll(where: {$0.name == specialitiesVal.name})
        }
        else {
            self.selectedArray.append(specialitiesVal)
        }
        if isFromExplore && !isFromFilter {
            self.tableView.reloadData()
            self.delegate1?.addSpecialities1(specialitiesVal)
            self.navigationController?.popViewController(animated: true)
//            let pageObj = FilterDetailsViewController()
//            pageObj.isFromSpecialist = true
//            pageObj.isSpeciality = true
//            pageObj.specialities = specialitiesVal
//            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if isFromFilter{
            self.delegate?.addSpecialities([specialitiesVal])
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.tableView.reloadData()
        }
    }
    
}
extension Select_Specialities {
    func addSpecialities(_ specialities: String){
        
    }
}
