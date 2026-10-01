  //
  //  FilterViewController.swift
  //  Meetdoc
  //
  //  Created by Hitasoft on 12/02/20.
  //  Copyright © 2020 BTMani. All rights reserved.
  //
  
  import UIKit
  import GoogleMaps
  import GooglePlaces
  
  class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = FilterViewModel()
    var filterDetailVC: FilterDetailsViewController?
    var titleArr = ["specialities", "location", "insurance", "availability", "illness", "select_Language", "gender", "near_by"]
    var userData = DoctorSignupModel()
    var selectedInsurance = [InsuranceResultModel]()
    var selectedIllness = [IllnessResultModel]()
    var getSpecialities = [LanguageModel]()
    var commonAmenitiesArr = [AmenitiesModel]()
    var listingTypeArr = [RoomTypeModel]()
    var homeTypeArr = [HomeTypeModel]()
    var settingViewModel = SettingViewModel()
    var viewModel1 = AuthenticationViewModel()
    var filterStruct = FilterData()
    var doctorProfileData: DoctorProfileResultModel?
    
    var lat = ""
    var long = ""
    var passId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkReachability()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        configUI()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    func configUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.navigationController?.navigationBar.backgroundColor = AppRed
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (getLanguage["filter"] ?? ""), fColor: "White", fontName: fontRegular18, imageName: "close_x", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.customRightBarButtonView(title: (getLanguage["reset"] ?? ""), fColor: "White", fontName: fontRegular18, imageName: "", isLeft: false, vc: self, transparantView: false)

        self.filterButton.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "apply")
        self.filterButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.filterButton.layer.cornerRadius = 3
        self.tableView.register(UINib(nibName: "ExploreFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "ExploreFilterTableViewCell")
        self.tableView.reloadData()
        // self.loadAmenities()
        //self.loadFilterDatas()
    }
    func loadFilterDatas() {
        let speciality = self.filterStruct.speciality_id
        self.filterStruct = FilterData()
        self.filterDetailVC?.filterStruct = self.filterStruct
        self.filterDetailVC?.filterStruct.speciality_id = speciality
        self.filterDetailVC?.isFromSpecialist = false
        self.filterDetailVC?.loadFromFilter()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.loadFilterDatas()
            }
        }
    }
    @IBAction func filterButtonAct(_ sender: UIButton) {
        self.filterDetailVC?.filterStruct = self.filterStruct
        self.filterDetailVC?.isFromSpecialist = false
        self.filterDetailVC?.loadFromFilter()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func genderButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            filterStruct.gender = "male"
        }
        else if sender.tag == 1 {
            filterStruct.gender = "female"
        }
        else {
            filterStruct.gender = ""
        }
        self.tableView.reloadData()
    }
  }
  extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreFilterTableViewCell") as! ExploreFilterTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = getLanguage[self.titleArr[indexPath.section]] ?? self.titleArr[indexPath.section]
        if indexPath.section == 6 {
            cell.genderStackView.isHidden = false
            cell.genderTitleLabel.text = getLanguage[self.titleArr[indexPath.section]] ?? self.titleArr[indexPath.section]
            cell.detailsStackView.isHidden = true
            cell.femaleCheckButton.tag = 1
            cell.femaleButton.tag = 1
            cell.femaleCheckButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.femaleButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.maleTitleButton.tag = 0
            cell.maleCheckButton.tag = 0
            cell.maleTitleButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.maleCheckButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.bothButton.tag = 2
            cell.bothCheckButton.tag = 2
            cell.bothButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.bothCheckButton.addTarget(self, action: #selector(self.genderButtonAct), for: .touchUpInside)
            cell.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
            cell.maleTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "male")
            cell.femaleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "female")
            cell.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
            cell.bothButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "both")
            cell.bothCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)

            if filterStruct.gender == "male"{
                cell.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
                cell.maleTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
            }
            else if filterStruct.gender == "female" {
                cell.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
                cell.femaleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
            }
            else{
                cell.bothCheckButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
                cell.bothButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
            }
        }
        else if indexPath.section == 7 {
            cell.detailsStackView.isHidden = false
            cell.genderStackView.isHidden = true
            cell.selectButton.imageView?.tintColor = UIColor(named: "SubTitleColor")
            
            cell.descLabel.isHidden = true
            cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
           
            if indexPath.section == 7 && filterStruct.isNearby {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            cell.selectButton.tag = indexPath.section
            cell.selectButton.addTarget(self, action: #selector(self.checkBoxAct(_:)), for: .touchUpInside)
        }
        else {
            cell.selectButton.imageView?.tintColor = UIColor(named: "TitleColor")
            cell.genderStackView.isHidden = true
            cell.detailsStackView.isHidden = false
            cell.selectButton.setImage(#imageLiteral(resourceName: "next"), for: .normal)
            if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                cell.selectButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            cell.descLabel.isHidden = false
            if indexPath.section == 0 {
                if filterStruct.speciality_id != nil {
                    if filterStruct.speciality_id.name == "" {
                        cell.descLabel.text = getLanguage["choose_specialities"] ?? "choose_specialities"
                    }else {
                        cell.descLabel.text = filterStruct.speciality_id.name
                    }
                }else {
                    cell.descLabel.text = getLanguage["choose_specialities"] ?? "choose_specialities"
                }
            }
            else if indexPath.section == 1 {
                cell.descLabel.text = filterStruct.location
                if filterStruct.location == "" {
                    cell.descLabel.text = getLanguage["change_location"] ?? "change_location"
                }
            }
            else if indexPath.section == 2 {
                cell.descLabel.text = filterStruct.insurance_id.name
                if filterStruct.insurance_id.name == "" {
                    cell.descLabel.text = getLanguage["choose_insurance"] ?? "choose_insurance"
                }
            }
            else if indexPath.section == 3 {
                cell.descLabel.text = filterStruct.availability
                if filterStruct.availability == "" {
                    cell.descLabel.text = getLanguage["choose_availability"] ?? "choose_availability"
                }
                else {
                    let date = Date(timeIntervalSince1970: (Double(filterStruct.availability ?? "0") ?? Double(0)))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-YYYY"
                    cell.descLabel.text = "\(formatter.string(from: date))"
                }
            }
            else if indexPath.section == 4 {
                cell.descLabel.text = filterStruct.illness_id.name
                if filterStruct.illness_id.name == "" {
                    cell.descLabel.text = getLanguage["choose_illness"] ?? "choose_illness"
                }
            }
            else if indexPath.section == 5 {
                if filterStruct.doctor_language.count == 0 {
                    cell.descLabel.text = getLanguage["choose_language"] ?? "choose_language"
                }
                else {
                    cell.descLabel.text = filterStruct.doctor_language.map({$0.lname ?? ""}).joined(separator: ", ")
                }
            }
        }
        return cell
    }
    @objc func checkBoxAct(_ sender: UIButton) {
        if sender.tag == 7 {
            if self.filterStruct.location != "" {
                self.filterStruct.isNearby = !self.filterStruct.isNearby
            }
            else {
                self.view.makeToast(getLanguage["choose_location"] ?? "choose_location")
            }
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 0
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if indexPath.section == 0{
            let pageObj = SpecialitiesViewController()
            pageObj.delegate = self
            pageObj.isFromExplore = true
            pageObj.isFromFilter = true
            if self.filterStruct.speciality_id != nil {
                if self.filterStruct.speciality_id.name != "" {
                    pageObj.selectedArray = [self.filterStruct.speciality_id]
                }
            }
           
            pageObj.navigationController?.navigationBar.barTintColor = AppRed
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else  if indexPath.section == 1 {
            let pageObj = HospitalLocationPage()
            pageObj.isFromHospital = true
            pageObj.delegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if indexPath.section == 2{
            let pageObj = SelectInsurancePage()
            pageObj.isFromFilter = true
            if self.filterStruct.insurance_id.name != "" {
                pageObj.selectedArray = [self.filterStruct.insurance_id]
            }
            pageObj.delegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if indexPath.section == 4{
            if filterStruct.speciality_id != nil {
                let pageObj = SelectIllnessPage()
                pageObj.isFromFilter = true
                pageObj.getSpecilityId = [self.filterStruct.speciality_id.id ?? 0]
                if self.filterStruct.illness_id.name != "" {
                    pageObj.selectedArray = [self.filterStruct.illness_id]
                }
                pageObj.delegate = self
                self.navigationController?.pushViewController(pageObj, animated: true)
            }else {
                let alert = UIAlertController(title: nil, message: getLanguage["please_choose_specialities"] ?? "please_choose_specialities", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else if indexPath.section == 5{
            let pageObj = LanguageViewController()
            pageObj.isFromFilter = true
            if self.filterStruct.doctor_language.count != 0 {
                pageObj.selectedArray = self.filterStruct.doctor_language
            }
            pageObj.delegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else if indexPath.section == 3 {
            let pageObj = BookingCalendarViewController()
            pageObj.isFromFilter = true
            pageObj.filterVC = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
  }
  extension FilterViewController: Select_Specialities,Select_Language, Select_Illness, Select_Insurance,select_Location{
    func locationData(_ location: LocationModel) {
    }
    func locationDetails(_ location: String, lat: String, long: String, countryCode: String) {
        self.filterStruct.location = location
        self.filterStruct.latitude = lat
        self.filterStruct.longitude = long
        self.tableView.reloadData()
    }
    func addLanguage(_ language: [LanguageModel]){
//        let sArray: [String] = language.map({($0.name ?? "")})
        userData.doctorLanguage = language
        self.filterStruct.doctor_language = language
        self.tableView.reloadData()
    }
    func addSpecialities(_ specialities: [LanguageModel]) {
        getSpecialities = specialities
        if getSpecialities.count > 0 {
            let sArray: [String] = getSpecialities.map({$0.name ?? ""})
            self.filterStruct.speciality_id = getSpecialities.first
            self.tableView.reloadData()
            //            self.specialitiesLabel.text = sArray.joined(separator: ", ")
        }
    }
    func selectedInsurance(_ insuranceArray: [InsuranceResultModel]) {
        self.filterStruct.insurance_id = insuranceArray.first
        self.tableView.reloadData()
    }
    func selectedIllness(_ illnessArray: [IllnessResultModel]) {
        self.filterStruct.illness_id = illnessArray.first
        self.tableView.reloadData()
    }
  }
  extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
  }
  extension FilterViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //        self.locationLabel.text = place.name
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
  }
  
  
