  //
  //  HospitalSignUpPage.swift
  //  Meetdoc
  //
  //  Created by Arun Andiselvam on 25/09/20.
  //  Copyright © 2020 BTMani. All rights reserved.
  //
  
  import UIKit
  protocol select_hospitalName {
    func addHospitalName(_ hospitalName: String)
    func passLocation (_ location: String)
    func addHospitalDetails(_ hospital: HospitalResultModel, location: LocationModel)
  }
  
  class HospitalSignUpPage: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, select_Location, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var offset = 0
    var delegate: select_hospitalName?
    
    @IBOutlet weak var plsAddHospLbl: UILabel!
    @IBOutlet weak var addHospitalBtn: UIButton!
    @IBOutlet weak var hospNotFoundImage: UIImageView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = AuthenticationViewModel()
    
    var hospitalModelArray = [HospitalResultModel]()
    var filterArray = [HospitalResultModel]()
    var selectedHospital: HospitalResultModel?
    var selectedLocation: LocationModel?
    
    var isSearchFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noStackView.isHidden = true
        self.view.addSubview(indicatorView)
        self.loadHoaspitalData()
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
        configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func configUI() {
        
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "hospital") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search", Font: fontRegular16)
        
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        
        self.applyBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
        self.addHospitalBtn.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "add_hospital")
        self.plsAddHospLbl.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .center, text: "hospital_not_found")
    }
    func loadHoaspitalData(){
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.getHospitalData(search: self.searchTextField.text!, offset: "\(offset)", onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            if success {
                if self.offset == 0 {
                    self.hospitalModelArray.removeAll()
                }
                if (self.viewModel.hospitalModel?.result.count ?? 0) > 0 {
                    self.hospitalModelArray += self.viewModel.hospitalModel?.result ?? [HospitalResultModel]()
                }
                self.tableView.reloadData()
            }
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
        if let hospital = self.selectedHospital, let location = self.selectedLocation {
            self.delegate?.addHospitalDetails(hospital, location: location)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: nil, message: getLanguage["select_hospital"] ?? "select_hospital", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func addHospitalBtnTapped(_ sender: Any) {
        let pageObj = AddHospitalPage()
        pageObj.delegate = self
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func textFieldEditingChangedAct(_ sender: UITextField) {
        var tempProductModel = [HospitalResultModel]()
        if let hospitalResult = self.viewModel.hospitalModel?.result {
            tempProductModel = hospitalResult
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearchFlag == true && self.filterArray.count == 0) || (self.isSearchFlag == false && self.hospitalModelArray.count == 0) && !indicatorView.isAnimating {
            self.noStackView.isHidden = false
            self.applyBtn.isHidden = true
        }
        else if (self.isSearchFlag == true && self.hospitalModelArray.count == 0){
            self.applyBtn.isHidden = true
            self.noStackView.isHidden = false
        }
        else {
            self.applyBtn.isHidden = false
            self.noStackView.isHidden = true
        }
        return self.isSearchFlag == true ? self.filterArray.count : self.hospitalModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        let hospitalVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.hospitalModelArray[indexPath.row]
        cell.titleLabel.text = hospitalVal.name
        if let selectedVal = self.selectedHospital {
            if selectedVal.id == hospitalVal.id {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        else {
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageObj = HospitalLocationPage()
        pageObj.delegate = self
        let hospitalVal = self.isSearchFlag == true ? self.filterArray[indexPath.row] : self.hospitalModelArray[indexPath.row]
        if let selectedVal = self.selectedHospital {
            if selectedVal.id == hospitalVal.id {
                self.selectedHospital = nil
                self.tableView.reloadData()
            }
            else {
                self.selectedHospital = hospitalVal
                pageObj.selectedHospital = selectedHospital
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
        else {
            self.selectedHospital = hospitalVal
            pageObj.selectedHospital = selectedHospital
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.containsEmoji {
            return false
        }
        return true
    }
  }
  extension HospitalSignUpPage: select_hospitalName, getHospitalData{
    
    
    func addHospitalDetails(_ hospital: HospitalResultModel, location: LocationModel) {
    }
    
    func locationDetails(_ location: String, lat: String, long: String, countryCode: String) {
        
    }
    func addHospitalDetails(_ hospitalData: AddHospitalResultModel) {
        //        let hospitalRes = HospitalResultModel(id: hospitalData.hospitalId, name: hospitalData.hospitalName)
        //        let locationData = LocationModel(id: hospitalData.locationId, location: hospitalData.location)
        //        self.delegate?.addHospitalDetails(hospitalRes, location: locationData)
        //        self.navigationController?.popViewController(animated: true)
    }
    func selectedHospital(_ hospitalData: AddHospitalResultModel) {
        let hospitalRes = HospitalResultModel(id: hospitalData.hospitalId, name: hospitalData.hospitalName)
        let locationData = LocationModel(id: hospitalData.locationId, location: hospitalData.location)
        self.delegate?.addHospitalDetails(hospitalRes, location: locationData)
        self.navigationController?.popViewController(animated: true)
    }
    func locationData(_ location: LocationModel) {
        self.selectedLocation = location
        self.tableView.reloadData()
    }
    func addHospitalName(_ hospitalName: String){
        
    }
    
  }
  
  
  
