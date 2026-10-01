//
//  FilterDetailsViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FilterDetailsViewController: UIViewController, Select_Specialities1 {
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var specalistView: UIView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var specialistBtn: UIButton!
    @IBOutlet weak var arrowImg: UIImageView!
    var filterData = [WhishedList]()

    var filterStruct = FilterData()
    var offset = 0
    var limit = 10
    var isFound = true
    var selectedTitle = ""
    var noFilter = 0
    var filterCount = 0
    var dateFilter = ""
    var viewType = ""
    var refreshControl = UIRefreshControl()
    var viewModel = ExploreViewModel()
    var viewModel1 = DoctorViewModel()
    var isFromSpecialist = false
    var isSpeciality = false
    var specialities: LanguageModel?
    
    var filterDoctor = [WhishedList]()
    var isSearchFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        self.view.addSubview(indicatorView)
        Utility().startAnimation(viewController: self)
        self.searchTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "search_doctor", Font: fontRegular16)
        self.specialistBtn.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .leading, title: "select_specalist")
        self.searchTextField.text = selectedTitle
        self.loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor") ?? .white
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: "search", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        filterStruct.speciality_id = self.specialities
        self.specialistBtn.setTitle(self.specialities?.name ?? "Select spacalist", for: .normal)
        self.navigationController?.customRightBarButtonView(title:  "", fColor: "White", fontName: fontRegular16, imageName: "filterIcon", isLeft: false, vc: self, transparantView: false)
        self.configUI()
        if viewType == "seeall" {
            self.specialistBtn.isUserInteractionEnabled = false
            self.arrowImg.isHidden = true
        }else {
            self.specialistBtn.isUserInteractionEnabled = true
            self.arrowImg.isHidden = false
        }
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                if isSpeciality {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                    if viewControllers.count >= 3 {
                        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.searchTextField.endEditing(true)
                DispatchQueue.main.async {
                    let pageObj = FilterViewController()
                    pageObj.filterDetailVC = self
                    pageObj.filterStruct = self.filterStruct
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }
            }
        }
    }
    
    @IBAction func spacialistBtnTapped(_ sender: Any) {
        let pageObj = SpecialitiesViewController()
        pageObj.isFromExplore = true
        pageObj.delegate1 = self
        pageObj.navigationController?.navigationBar.barTintColor = AppRed
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    func addSpecialities1(_ specialities: LanguageModel) {
        
        self.isFromSpecialist = false
        self.isSpeciality = false
        self.specialities = specialities
        print("specialities \(specialities.name)\(specialities.id)")
        self.specialistBtn.titleLabel?.text = "\(specialities.name ?? "")"
        self.loadData()
    }
    
    func configUI() {
        
        self.noStackView.isHidden = true
        self.noLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "doctors_not_found")
        self.tableView.register(UINib(nibName: "SavedListTableViewCell", bundle: nil), forCellReuseIdentifier: "SavedListTableViewCell")
        self.tableView.register(UINib(nibName: "SavedHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SavedHeaderTableViewCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.searchView.viewRadius(radius:5)
        self.specalistView.layer.borderWidth = 0.5
        self.specalistView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.specalistView.viewRadius(radius:5)
        self.tableView.estimatedSectionHeaderHeight = 75
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)

    }
    
    @IBAction func textFieldEditingChangedAct(_ sender: UITextField) {
        isFromSpecialist = false
//        self.filterData.removeAll()
        self.offset = 0
        self.isFound = true
        self.loadData()
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.offset = 0
        self.filterData.removeAll()
        self.loadData()
    }
    func loadFromFilter() {
        if self.filterStruct.speciality_id != nil {
            if self.filterStruct.speciality_id.name != ""{
                self.specialities = self.filterStruct.speciality_id
                self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (self.specialities?.name ?? ""), fColor: "appbg", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
                
            }
        }
        self.isFound = true
        self.offset = 0
        self.filterData.removeAll()
        self.filterDoctor.removeAll()
        self.loadData()
    }
    func loadData() {
        
        if isFromSpecialist {
            self.viewModel.getSpecialistSearchData(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", offset: "\(self.offset)", speciality_id: "\(self.specialities?.id ?? 0)", onSuccess: { (success) in
                if self.viewModel.filterData?.status == false {
                    self.isFound = false
                }
                else if success {
                    
                    if self.offset == 0 {
                        self.filterData.removeAll()
                    }
                    if self.viewModel.filterData?.doctors != nil && (self.viewModel.filterData?.doctors.count ?? 0) > 0 {
                        self.tableView.isHidden = false
                        let val = self.viewModel.filterData!.doctors
                        self.filterData += val ?? [WhishedList]()
                        if self.filterData.count == 0 {
                            self.noStackView.isHidden = false
                        }
                        self.noFilter = Int(self.viewModel.filterData?.totalListcount ?? "0") ?? 0
                        self.tableView.reloadData()
                        Utility().stopAnimation(viewController: self)
                        self.loaderView.isHidden = true
                        self.loaderView.stopAnimating()
                       
                    //        self.tableView.reloadData()
                       
                    }
                    else {
                        self.isFound = false
                        Utility().stopAnimation(viewController: self)
                        self.loaderView.isHidden = true
                        self.loaderView.stopAnimating()
                    }
                   
                }
                
            }) { (failure) in
                Utility().stopAnimation(viewController: self)
            }
         }
        else {
            self.tableView.isHidden = true
            filterStruct.speciality_id = self.specialities
            self.viewModel.getDoctorSearchData(FilterData: self.filterStruct, offset: "\(self.offset)", search: self.searchTextField.text!, onSuccess: { (success) in
                if self.viewModel.savedList?.status == false {
                    self.isFound = false
                }
                else if success {
                    if self.viewModel.savedList?.resultCount != 0 {
                        self.tableView.isHidden = false
                        if self.viewModel.savedList?.result != nil && (self.viewModel.savedList?.result.count ?? 0) > 0 {
                            let val = self.viewModel.savedList!.result
                            if self.offset == 0 {
                                self.filterData.removeAll()
                            }
                            self.filterData += val ?? [WhishedList]()
//                            if self.filterData.count == 0 {
//                                self.noStackView.isHidden = false
//                            }
            //                self.noFilter = self.filterData.count
                            self.noFilter = (self.viewModel.savedList?.resultCount ?? 0)
                            self.tableView.reloadData()
                            Utility().stopAnimation(viewController: self)
                            self.loaderView.isHidden = true
                            self.loaderView.stopAnimating()
//                            self.tableView.reloadData()
                          
                        }
                    }else {
                        self.isFound = false
                        self.noStackView.isHidden = false
                        Utility().stopAnimation(viewController: self)
                        self.loaderView.isHidden = true
                        self.loaderView.stopAnimating()
                        self.tableView.isHidden = true
                    }
//                    if self.viewModel.savedList?.result != nil && (self.viewModel.savedList?.result.count ?? 0) > 0 {
//                        let val = self.viewModel.savedList!.result
//                        if self.offset == 0 {
//                            self.filterData.removeAll()
//                        }
//                        self.filterData += val ?? [WhishedList]()
//                        if self.filterData.count == 0 {
//                            self.noStackView.isHidden = false
//                        }
//        //                self.noFilter = self.filterData.count
//                        self.noFilter = (self.viewModel.savedList?.resultCount ?? 0)
//                        Utility().stopAnimation(viewController: self)
//                        self.loaderView.isHidden = true
//                        self.loaderView.stopAnimating()
//                        self.tableView.reloadData()
//                    }
//                    else {
                        
//                    }
                    
                }
               
            }) { (failure) in
                Utility().stopAnimation(viewController: self)
            }

        }
    }
    
 }
extension FilterDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterVal = self.isSearchFlag == true ? self.filterDoctor : self.filterData
        return filterVal.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let filterVal = self.isSearchFlag == true ? self.filterDoctor : self.filterData
        if filterVal.count > 0 {
            return 50
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if isFromSpecialist{
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedHeaderTableViewCell") as! SavedHeaderTableViewCell
            cell.headerLabel.isHidden = false
            cell.descLabel.isHidden = true
            cell.exploreButton.isHidden = true
            cell.headerLabel.text = "\(getLanguage["showing"] ?? "showing") \(self.noFilter) \(getLanguage["listingsleftforthissearch"] ?? "results")"
            if isSearchFlag == true{
                let filterVal = self.isSearchFlag == true ? self.filterDoctor : self.filterData
                cell.headerLabel.text = "\(getLanguage["showing"] ?? "showing") \(filterVal.count) \(getLanguage["listingsleftforthissearch"] ?? "results")"
                print(filterVal.count)
             }

            return cell
//        }
        return nil
    }
    @objc func searchButonAct(_ sender: UIButton) {
        self.searchTextField.endEditing(true)
        DispatchQueue.main.async {
            let pageObj = SearchViewController()
            pageObj.filterStruct = self.filterStruct
            pageObj.delegate = self
            pageObj.currentString = self.selectedTitle
            self.parent?.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    @objc func backBtnAct(_ sender: UIButton) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    @objc func filterButtonAct(_ sender: UIButton) {
        if sender.tag == 0 {
            self.searchTextField.endEditing(true)
            DispatchQueue.main.async {
                let pageObj = FilterViewController()
                pageObj.filterDetailVC = self
                pageObj.filterStruct = self.filterStruct
                self.navigationController?.pushViewController(pageObj, animated: true)
            }
        }
        else {
//            let pageObj = DatePickerViewController()
//            pageObj.delegate = self
//            pageObj.filterStruct = self.filterStruct
//            pageObj.isFormBooking = 2
//            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedListTableViewCell") as! SavedListTableViewCell
        self.noStackView.isHidden = true
        let filterVal = self.isSearchFlag == true ? self.filterDoctor[indexPath.row] : self.filterData[indexPath.row]
        cell.loadData(filterVal)
//        cell.specialityLabel.text = (self.specialities?.name ?? "")
        cell.likeButton.tag = Int(filterVal.doctorId) ?? 0
        cell.likeButton.addTarget(self, action: #selector(self.likeButtonAct(_:)), for: .touchUpInside)
        cell.viewAvailablityLabel.tag = Int(filterVal.doctorId) ?? 0
        cell.viewAvailablityLabel.addTarget(self, action: #selector(self.availblityBtn(_:)), for: .touchUpInside)
        if self.isSearchFlag == true && indexPath.row == (self.filterDoctor.count - 1) && self.isFound == true{
            self.offset = self.filterDoctor.count
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
            self.loadData()
        }
        else if self.isSearchFlag == false && indexPath.row == (self.filterData.count - 1) && self.isFound == true && self.filterData.count >= 20 {
            self.offset = self.filterData.count
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
            self.loadData()
        }
        
        return cell
    }
    @objc func likeButtonAct(_ sender: UIButton) {
        if (sender.imageView?.image ?? #imageLiteral(resourceName: "heart")) == #imageLiteral(resourceName: "HomeLike") {
            sender.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }
        else {
            sender.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
        }
        let savedViewModel = ExploreViewModel()
        savedViewModel.likeAct(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", doctor_id: "\(sender.tag)", onSuccess: { (success) in
            if success {
                if self.isSearchFlag {
                    self.filterDoctor.filter({$0.doctorId == "\(sender.tag)"}).first?.isliked = !(self.filterDoctor.filter({$0.doctorId == "\(sender.tag)"}).first?.isliked ?? false)
                }
                else {
                    self.filterData.filter({$0.doctorId == "\(sender.tag)"}).first?.isliked = !(self.filterData.filter({$0.doctorId == "\(sender.tag)"}).first?.isliked ?? false)
                }
            }
            self.tableView.reloadData()
        }) { (failure) in
            self.tableView.reloadData()
        }
    }
    @objc func availblityBtn(_ sender: UIButton){
        self.viewModel1.getDoctorData(user_id: UserDefaultModule.shared.getLoginData().userId ?? "1", doctor_id: "\(sender.tag)", onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            let pageObj = BookingCalendarViewController()
            pageObj.doctorData = self.viewModel1.doctorModel?.result
            print("TYPE:\(pageObj.type)")
            pageObj.booking_type = "videovisit"
            self.navigationController?.pushViewController(pageObj, animated: true)
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.endEditing(true)
//        DispatchQueue.main.async {
        self.tableView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            let filterVal = self.isSearchFlag == true ? self.filterDoctor[indexPath.row] : self.filterData[indexPath.row]
            let pageObj = DoctorDetailsViewController()
            pageObj.doctorID = filterVal.doctorId
            pageObj.type = filterVal.speciality.first ?? ""
            self.tableView.isUserInteractionEnabled = true
            self.navigationController?.pushViewController(pageObj, animated: true)
        })
    }
}
extension FilterDetailsViewController {
    func updateFilterData(_ filterVal: FilterData, count: Int) {
        self.filterCount = count
        self.filterStruct = filterVal
        self.filterData.removeAll()
        self.offset = 0
        self.loadData()
    }
}
extension FilterDetailsViewController: searchFilterDelegate {
    func filterViewData(_ filterStruct: FilterData, dateFilter: String){
        self.navigationController?.popViewController(animated: false)
        self.dateFilter = dateFilter
        self.filterStruct = filterStruct
        self.isFound = true
        self.offset = 0
        self.filterData.removeAll()
        self.loadData()
    }
    func searchFilterAct(filterStruct: FilterData, title: String) {
        self.navigationController?.popViewController(animated: false)
        self.filterStruct = filterStruct
        self.selectedTitle = title
        self.searchTextField.text = selectedTitle
        self.isFound = true
        self.offset = 0
        self.filterData.removeAll()
        self.loadData()
    }
}

