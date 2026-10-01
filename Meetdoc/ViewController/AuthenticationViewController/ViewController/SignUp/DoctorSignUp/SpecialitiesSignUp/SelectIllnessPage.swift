  //
  //  SelectIllnessPage.swift
  //  Meetdoc
  //
  //  Created by Arun Andiselvam on 12/10/20.
  //  Copyright © 2020 BTMani. All rights reserved.
  //
  
  import UIKit
  protocol Select_Illness {
    func selectedIllness(_ illnessArray: [IllnessResultModel])
  }
  
  class SelectIllnessPage: UIViewController {
    
    let language : NSDictionary = Utility().language()
    let child = SpinnerViewController()
    var selectedIllness = [String]()
    var toastLabel = UILabel()
    var offset = 0
    var delegate: Select_Illness?
    var viewModel = AuthenticationViewModel()
    var illnessArray = [IllnessResultModel]()
    var filterArray = [IllnessResultModel]()
    var selectedArray = [IllnessResultModel]()
    var isSearchFlag = false
    var isFromFilter = false
     var specialities = LanguageModel()
     var getSpecilityId = [Int]()
    
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.addSubview(indicatorView)
     }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
          self.configUI()
        self.loadIllnessData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.noLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "illness_not_found")
        var navTitle = "illness"
        if !self.isFromFilter {
            navTitle = "reason_for_your_visit"
            self.noLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "select_illness")
        }
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage[navTitle] ?? navTitle, fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        
        self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        
        self.applyBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
        self.noStackView.isHidden = true
    }
    func loadIllnessData(){
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.getIllnessDatas(speciality_id:  self.getSpecilityId, offset: "\(offset)", limit: "20", onSuccess: { (success) in
            self.illnessArray = self.viewModel.illnessModel?.result ?? [IllnessResultModel]()
               Utility.shared.stopAnimation(viewController: self)
            self.tableView.reloadData()
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    @IBAction func applyBtnTapped(_ sender: Any) {
        if self.selectedArray.count == 0 && !self.isFromFilter {
            self.view.makeToast(getLanguage["select_reason"] ?? "")
        }
        else {
            self.delegate?.selectedIllness(self.selectedArray)
            self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func textFieldEditingChangedAct(_ sender: Any) {
        var tempProductModel = [IllnessResultModel]()
        if let specialitiesResult = self.viewModel.illnessModel?.result {
            tempProductModel = specialitiesResult
            self.filterArray.removeAll()
        }
        let filterVal = tempProductModel.filter({$0.name.localizedCaseInsensitiveContains((sender as AnyObject).text)})
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
  extension SelectIllnessPage : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearchFlag == true && self.filterArray.count == 0) || (self.isSearchFlag == false && self.illnessArray.count == 0) && !indicatorView.isAnimating {
            self.noStackView.isHidden = false
            self.applyBtn.isHidden = true
        }
        else {
            self.noStackView.isHidden = true
            self.applyBtn.isHidden = false
        }
        return self.isSearchFlag == true ? self.filterArray.count : self.illnessArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        let illnessVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.illnessArray[indexPath.row]
        cell.titleLabel.text = illnessVal.name
        if self.selectedArray.contains(where: {$0.name == illnessVal.name}) {
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
        }
        else {
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialitiesVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.illnessArray[indexPath.row]
        
        if self.selectedArray.contains(where: {$0.id == specialitiesVal.id}) {
            self.selectedArray.removeAll(where: {$0.id == specialitiesVal.id})
        }
        else {
            self.selectedArray.append(specialitiesVal)
        }
        
        if isFromFilter {
            self.delegate?.selectedIllness([specialitiesVal])
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.tableView.reloadData()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
  }
  extension Select_Illness {
    func selectedIllness(_ illnessArray: [IllnessResultModel]){
    }
  }
  
