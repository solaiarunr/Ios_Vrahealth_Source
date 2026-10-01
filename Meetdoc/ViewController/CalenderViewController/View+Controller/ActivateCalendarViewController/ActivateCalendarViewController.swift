//
//  ActivateCalendarViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Toast_Swift

class ActivateCalendarViewController: UIViewController {
    
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencyTitleLabel: UILabel!
    @IBOutlet weak var currencyStackView: UIStackView!
    @IBOutlet weak var basePriceLabel: UILabel!
    @IBOutlet weak var dayOnButton: UIButton!
    @IBOutlet weak var dayOnLabel: UILabel!
    @IBOutlet weak var dayStackView: UIStackView!
    @IBOutlet weak var dayoffStackView: UIStackView!
    @IBOutlet weak var dayOnStackView: UIStackView!
    @IBOutlet weak var dayOffButton: UIButton!
    @IBOutlet weak var dayOffLabel: UILabel!
    @IBOutlet weak var bookingTypeStackView: UIStackView!
    @IBOutlet weak var bookingTitleLabel: UILabel!
    @IBOutlet weak var instantSelectButton: UIButton!
    @IBOutlet weak var instantTitleButton: UIButton!
    @IBOutlet weak var requestSelectButton: UIButton!
    @IBOutlet weak var requestTitleButton: UIButton!
    @IBOutlet weak var slotStackView: UIStackView!
    @IBOutlet weak var slotTitleLabel: UILabel!
    @IBOutlet weak var addSlotButton: UIButton!
    @IBOutlet weak var slotTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var consultingFeeStackView: UIStackView!
    @IBOutlet weak var consultingFeeTitleLabel: UILabel!
    @IBOutlet weak var consultingFeeTextField: UITextField!
    @IBOutlet weak var consultTimeStackView: UIStackView!
    @IBOutlet weak var consultTimeTitleLabel: UILabel!
    @IBOutlet weak var consultTimeTextField: UITextField!
    @IBOutlet weak var holidayStackView: UIStackView!
    @IBOutlet weak var holidayTitleLabel: UILabel!
    @IBOutlet weak var holidayCollectionView: UICollectionView!
    @IBOutlet weak var cancellationStackView: UIStackView!
    @IBOutlet weak var cancellationTitleLabel: UILabel!
    @IBOutlet weak var cancellationTextField: UITextField!
    @IBOutlet weak var activateDetailsStackView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    var holidayArray = [["S", "sunday"], ["M", "monday"], ["T", "tuesday"], ["W", "wednesday"], ["T", "thursday"], ["F", "friday"], ["S", "saturday"]]
    var pickerArray = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]
    var viewModel = CalendarViewModel()
    var calenderData = ActivateCalendarResultModel()
    var isFromEdit = false
    var dayOff = ""
    var enterPage = String()
    var datetype = ""
    var days = [Int]()
    var selectedOffDate = [Int]()
    var settingViewModel = SettingViewModel()
    let nextIcon = UIImageView()
    var bookedDateArray = [Int]()
    var slotBookingType = SlotModel()
    var dayViewModel  = BookingHistoryViewModel()
    
    var stripe_currency: [String: Double] = ["USD": 0.50, "AUD": 0.50, "BGN": 1.00, "BRL": 0.50, "CAD": 0.50, "CHF": 0.50, "CZK": 15.00, "DKK": 2.50, "EUR": 0.50, "GBP": 0.30, "HKD": 4.00, "HUF":175.00, "INR": 0.50, "JPY": 50, "MXN": 10, "MYR": 2, "NOK": 3.00, "NZD": 0.50, "PLN": 2.00, "RON": 2.00, "SEK": 3.00, "SGD": 0.50]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        loadapi()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.currencyTextField.text = selectedCurrency.currencyCode
        if self.stripe_currency.contains(where: {$0.key == selectedCurrency.currencyCode}){
            let val = self.stripe_currency.filter { (key, value) -> Bool in
                return key == selectedCurrency.currencyCode
            }
            print("valval: \(val)")
            self.basePriceLabel.text = "\(getLanguage["base_price"] ?? "base_price"): \(val.first?.value ?? 0.0)"
        }
        else {
            self.basePriceLabel.text = "\(getLanguage["base_price"] ?? "base_price"): 10.00"
        }
        if Profile.currentProfile != nil {
                   CallsApp.connect()
               }
    }
    func loadCurrency() {
        DispatchQueue.main.async {
            self.view.addSubview(indicatorView)
            Utility.shared.startAnimation(viewController: self)
            self.settingViewModel.getCurrencyList(user_id: (UserDefaultModule.shared.getLoginData().userId ?? "")) { (success) in
                if (self.settingViewModel.currencyData?.defaultCurrency ?? "") != "" && (self.settingViewModel.currencyData?.currencylist.count ?? 0) > 0 {
                    selectedCurrency = self.settingViewModel.currencyData?.currencylist.filter({($0.currencyId ?? "") == (self.settingViewModel.currencyData?.defaultCurrency ?? "")}).first ?? Currencylist()
                    self.currencyTextField.text = selectedCurrency.currencyCode
                    if self.stripe_currency.contains(where: {$0.key == selectedCurrency.currencyCode}){
                        let val = self.stripe_currency.filter { (key, value) -> Bool in
                            return key == selectedCurrency.currencyCode
                        }
                        print("valval: \(val)")
                        self.basePriceLabel.text = "\(getLanguage["base_price"] ?? "base_price"): \(val.first?.value ?? 0.0)"
                    }
                    else {
                        self.basePriceLabel.text = "\(getLanguage["base_price"] ?? "base_price"): 10.00"
                    }
//                    self.basePriceLabel.text = "\(getLanguage["base_price"] ?? "base_price"): 10.00"
                    Utility.shared.stopAnimation(viewController: self)
                }
            } onFailure: { (failure) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {
        self.cancellationStackView.isHidden = true
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "activate_callendar") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.slotTableView.register(UINib(nibName: "SlotTableViewCell", bundle: nil), forCellReuseIdentifier: "SlotTableViewCell")
        self.holidayCollectionView.register(UINib(nibName: "HolidayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HolidayCollectionViewCell")
        self.dayOffLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "dayoff")
        self.dayOffButton.imageView?.tintColor = UIColor(named: "SubTitleColor")
        self.dayOnLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "day_on")
        self.bookingTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "booking_type")
        self.instantTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, title: "instant")
        self.requestTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, title: "request")
        self.slotTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "slot_new")
        self.addSlotButton.config(color: UIColor(named: "AppColor"), font: regular14, align: .left, title: "add_slot_new")
        self.consultingFeeTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "consulting_fees")
        self.consultingFeeTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "", Font: regular14, setBorder: true)
        self.currencyTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "currency")
        self.basePriceLabel.config(color: UIColor(named: "AppColor"), font: regular14, align: .left, text: "base_price")
        self.requestSelectButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.requestTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
        self.currencyTextField.config(color: UIColor(named: "SubTitleColor"), align: .center, placeHolder: "", Font: regular14, setBorder: false)
        self.currencyTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.currencyGestureAct(_:))))
        self.consultTimeTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "consult_time")
        self.consultTimeTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "", Font: regular14, setBorder: true)
        self.holidayTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "holiday")
        self.cancellationTitleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "cancellation")
        self.cancellationTextField.config(color: UIColor(named: "SubTitleColor"), align: .left, placeHolder: "choose_cancel_policy", Font: regular14, setBorder: true)
        self.saveButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "save")
        self.saveButton.cornerViewMiniumRadius()
        self.saveButton.backgroundColor = UIColor(named: "AppColor")
        
        self.loadData()
        if self.isFromEdit {
            self.dayStackView.isHidden = false
            self.activateDetailsStackView.isHidden = true
            self.saveButton.isHidden = true
        }
        else {
            self.dayStackView.isHidden = true
            self.activateDetailsStackView.isHidden = false
            self.saveButton.isHidden = false
        }
        self.calenderData.bookingType = "request"
        let datePickerView = UIPickerView()
        datePickerView.delegate = self
        self.consultTimeTextField.inputView = datePickerView
        self.loadCurrency()
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.frame = CGRect(x: 0, y: CGFloat(0), width: CGFloat(40), height: CGFloat(40))
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "SubTitleColor") ?? .white
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            button.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancellationTextField.leftViewMode = .always
            self.cancellationTextField.leftView = button
        }
        else {
            self.cancellationTextField.rightViewMode = .always
            self.cancellationTextField.rightView = button
        }
     }
    @objc func currencyGestureAct(_ sender: UITapGestureRecognizer) {
        self.currencyTextField.resignFirstResponder()
        let pageObj = SettingTableViewController()
        pageObj.titleString = "currency"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func loadData() {
        //        if let calenderModel = self.calenderData {
        if self.calenderData.slots.count == 0 {
            self.calenderData.slots.append(SlotModel())
        }
        self.slotTableView.reloadData()
        DispatchQueue.main.async {
            self.updateViewConstraints()
        }
        if self.calenderData.consultTime == "0" || self.calenderData.consultTime == "" {
            self.consultTimeTextField.text = ""
            self.calenderData.consultTime = ""
        }
        else {
            self.consultTimeTextField.text = "\(self.calenderData.consultTime ?? "") Mins"
        }
        if (self.calenderData.consultFees ?? 0) != 0 {
            self.consultingFeeTextField.text = "\(self.calenderData.consultFees ?? 0)"
        }
        self.holidayCollectionView.reloadData()
        if self.calenderData.bookingType == "instant" {
            self.bookingTypeButtonAct(self.instantTitleButton)
        }
        else if self.calenderData.bookingType == "request" {
            self.bookingTypeButtonAct(self.requestTitleButton)
        }
        if self.calenderData.policyId != "" {
            self.cancellationTextField.text = self.calenderData.policyName
        }
    }
    override func updateViewConstraints() {
        if Int(self.slotTableView.contentSize.height) < (self.calenderData.slots.count*127) {
//            tableViewHeightConst.constant = CGFloat(self.calenderData.slots.count*70)
            tableViewHeightConst.constant = CGFloat(self.calenderData.slots.count*108)
        }
        else {
            tableViewHeightConst.constant = (self.slotTableView.contentSize.height)
        }
        if tableViewHeightConst.constant == 0 {
            self.slotTableView.isHidden = true
        }
        else {
            self.slotTableView.isHidden = false
        }
        super.updateViewConstraints()
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                var minPrice = Double(10)
                if self.stripe_currency.contains(where: {$0.key == selectedCurrency.currencyCode}){
                    let val = self.stripe_currency.filter { (key, value) -> Bool in
                        return key == selectedCurrency.currencyCode
                    }
                    print("valval: \(val)")
                    minPrice = (val.first?.value ?? 0.0)
                }
//                if Double(self.calenderData.consultFees ?? 0) < minPrice {
//                    let message = (getLanguage["select_on_or_off"] ?? "select_on_or_off")
//                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
//                    self.navigationController?.present(alert, animated: true, completion: nil)
//                }
               // else {
                    calenderData.slots = [SlotModel]()
                    self.navigationController?.popViewController(animated: true)
               // }
            }
        }
    }
    func loadapi(){
        var dateArray = [Int]()
        dateArray.removeAll()
        for day in self.days{
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let localDate = Int(Double(day ?? 0) + Double(timezoneOffset))
            dateArray.append(localDate)
        }
        
        self.dayViewModel.dayoffCall(user_id: UserDefaultModule.shared.getLoginData().userId, Dayoff: "\(dateArray)", onSuccess: { (success) in
            var status = self.dayViewModel.dayoffModel?.status
            if status == "true" {
                var message = self.dayViewModel.dayoffModel?.result
                print("dayViewjbfjas",message ?? "")
                if message == "dayon" {
                    self.dayOffButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                    self.dayOnButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
                } else if message == "dayoff" {
                    self.dayOffButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
                    self.dayOnButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                } else {
                    self.dayOffButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                    self.dayOnButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                }
            } else {
                self.dayOffButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                self.dayOnButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
            
        }, onFailure: { (failure) in
            
        })
    }
    @IBAction func addSlotButtonAct(_ sender: UIButton) {
        if self.calenderData.slots.count < 5 {
            self.calenderData.slots.append(SlotModel())
            self.slotTableView.reloadData()
            DispatchQueue.main.async {
                self.updateViewConstraints()
            }
        }
        else {
            let alert = UIAlertController(title: nil, message: (getLanguage["Maximum slots reached"] ?? "Maximum slots reached"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? "OK"), style: .cancel, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func cancellationTextFieldAct(_ sender: UITextField) {
        sender.resignFirstResponder()
        let pageObj = CancellationViewController()
        pageObj.delegate = self
        pageObj.selectedID = self.calenderData.policyId
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func dayOffButtonAct(_ sender: UIButton) {
        var isBooking = false
        print(self.selectedOffDate)
        var dateArray = [Int]()
        dateArray.removeAll()
//        for day in self.days{
//            let timezoneOffset =  TimeZone.current.secondsFromGMT()
//            let localDate = Int(Double(day ?? 0) + Double(timezoneOffset))
//            dateArray.append(localDate)
//        }
        for date in self.selectedOffDate {
            if !self.calenderData.offdate.contains(date) {
                let timezoneOffset =  TimeZone.current.secondsFromGMT()
                let localDate = Int(Double(date ?? 0) + Double(timezoneOffset))
                let selected = Date(timeIntervalSince1970: Double(localDate))
                for avl in self.calenderData.booked_dates {
                    let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                    if (selected == startAvlDate) {
                        print(selected)
                        isBooking = true
                    }
                    print("SelecteDate:\(selected)")
                    print("BookingDate:\(startAvlDate)")
                }
                self.calenderData.offdate.append(date)
            }
        }
        self.dayOnButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
        self.dayOff = "true"
        if isBooking {
            let alert = UIAlertController(title: nil, message: (getLanguage["Are you sure want to cancel the bookings"] ?? "Are you sure want to cancel the bookings"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? "OK"), style: .default, handler: { (UIAlertAction) in
                self.dayOffAct()
            }))
            alert.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? "cancel"), style: .cancel, handler: { (UIAlertAction) in
                self.calenderData.offdate.removeAll()
                sender.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.dayOffAct()
        }
    }
    @IBAction func dayOnButtonAct(_ sender: UIButton) {
//        self.calenderData.offdate = [Int]()
        for date in self.selectedOffDate {
            if self.calenderData.offdate.contains(date) {
                self.calenderData.offdate.removeAll(where: {$0 == date})
            }
        }
        self.dayOffButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        sender.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
        self.dayOff = "false"
        self.dayOffAct()
    }
    func dayOffAct() {
        Utility.shared.startAnimation(viewController: self)
        var dateArray = [Int]()
        dateArray.removeAll()
        for day in self.days{
            let timezoneOffset =  TimeZone.current.secondsFromGMT()
            let localDate = Int(Double(day ?? 0) + Double(timezoneOffset))
            dateArray.append(localDate)
        }
        self.viewModel.setCalendarSetting(user_id: UserDefaultModule.shared.getLoginData().userId, caledarData: self.calenderData, dayoff: self.dayOff, days: "\(dateArray)", onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            var message = (getLanguage[(self.viewModel.setCalenderModel?.message ?? "")] ?? (self.viewModel.setCalenderModel?.message ?? ""))
            if success {
                message = getLanguage["successfully saved"] ?? "successfully saved"
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                if success {
                    isCalendar = true
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }) { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    @IBAction func bookingTypeButtonAct(_ sender: UIButton) {
        self.instantSelectButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.instantTitleButton.setTitleColor((UIColor(named: "TitleColor") ?? UIColor.white), for: .normal)
        self.requestSelectButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.requestTitleButton.setTitleColor((UIColor(named: "TitleColor") ?? UIColor.white), for: .normal)
        if sender == instantSelectButton || sender == instantTitleButton {
            self.calenderData.bookingType = "instant"
            self.instantSelectButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
            self.instantTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
        }
        else {
            self.calenderData.bookingType = "request"
            self.requestSelectButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
            self.requestTitleButton.setTitleColor((UIColor(named: "AppColor") ?? UIColor.white), for: .normal)
        }
    }
    @IBAction func saveButtonAct(_ sender: UIButton) {
        self.calenderData.consultFees = Int(self.consultingFeeTextField.text!.doubleValue)
        var isValid = false
        var message = ""
        var minPrice = Double(10)
        self.calenderData.bookingType = "request"
        if self.stripe_currency.contains(where: {$0.key == selectedCurrency.currencyCode}){
            let val = self.stripe_currency.filter { (key, value) -> Bool in
                return key == selectedCurrency.currencyCode
            }
            print("valval: \(val)")
            minPrice = (val.first?.value ?? 0.0)
        }
        if self.calenderData.slots.count > 0 {
            for val in self.calenderData.slots {
                val.type = "videovisit"
                }
        }
        if self.calenderData.bookingType == "" {
            message = (getLanguage["choose_booking_basis"] ?? "choose_booking_basis")
        }
        else if self.calenderData.slots.count == 0 {
            message = (getLanguage["add_minimum_one_slot"] ?? "add_minimum_one_slot")
        }
        else if self.calenderData.consultFees == 0 {
            message = (getLanguage["enter_the_consulting_fee"] ?? "enter_the_consulting_fee")
        }
        else if Double(self.calenderData.consultFees ?? 0) < minPrice {
            message = (getLanguage["enter_valid_consulting_fee"] ?? "enter_valid_consulting_fee")
        }
        else if self.calenderData.consultTime == "" || self.calenderData.consultTime == "0" {
            message = (getLanguage["enter_the_consulting_time"] ?? "enter_the_consulting_time")
        }
        else if self.calenderData.holiday.count == 7 {
            message = (getLanguage["all_days_should_not_holiday"] ?? "all_days_should_not_holiday")
        }
//        else if self.calenderData.policyId == "" {
//            message = (getLanguage["choose_policy"] ?? "choose_policy")
//        }
        else if self.calenderData.slots.count > 0 {
            for val in self.calenderData.slots {
                if val.slotFromTime == "" {
                    message = getLanguage["choose_start_time_in_slot"] ?? "choose_start_time_in_slot"
                    isValid = false
                    break
                }
                else if val.slotToTime == "" {
                    message = getLanguage["choose_end_time_in_slot"] ?? "choose_end_time_in_slot"
                    isValid = false
                    break
                }
                else if val.type == "" {
                    message = getLanguage["choose_type_in_slot"] ?? "choose_type_in_slot"
                    isValid = false
                    break
                }
                else {
                    isValid = true
                }
            }
        }
        
        if isValid {
            self.dayOffAct()
        }
        else {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}
extension ActivateCalendarViewController: UITableViewDelegate, UITableViewDataSource, slotDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calenderData.slots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlotTableViewCell") as! SlotTableViewCell
        cell.delegate = self
        cell.slotArray = self.calenderData.slots ?? [SlotModel]()
        cell.loadData(self.calenderData.slots[indexPath.row], index: indexPath.row)
        cell.closeButton.tag = indexPath.row
        cell.closeButton.addTarget(self, action: #selector(self.cancelAct(_:)), for: .touchUpInside)
        cell.videoTitleButton.tag = indexPath.row
        cell.videoOptionButton.tag = indexPath.row
        cell.directOptionButton.tag = indexPath.row
        cell.directTitleButton.tag = indexPath.row
        cell.videoTitleButton.addTarget(self, action: #selector(self.videoButtonAct(_:)), for: .touchUpInside)
        cell.videoOptionButton.addTarget(self, action: #selector(self.videoButtonAct(_:)), for: .touchUpInside)
        self.calenderData.slots[indexPath.row].type = "videovisit"
        cell.directOptionButton.addTarget(self, action: #selector(self.directButtonAct(_:)), for: .touchUpInside)
        cell.directTitleButton.addTarget(self, action: #selector(self.directButtonAct(_:)), for: .touchUpInside)
        
        // Hide Cancel option for first slot
        if indexPath.row == 0 {
            cell.closeButton.isHidden = true
        }
        else {
            cell.closeButton.isHidden = false
        }
        return cell
    }
    @objc func videoButtonAct(_ sender: UIButton) {
        if self.calenderData.slots.count > sender.tag {
            self.calenderData.slots[sender.tag].type = "videovisit"
        }
        self.slotTableView.reloadData()
    }
    @objc func directButtonAct(_ sender: UIButton) {
        if self.calenderData.slots.count > sender.tag {
            self.calenderData.slots[sender.tag].type = "directvisit"
        }
        self.slotTableView.reloadData()
    }
    @objc func cancelAct(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: (getLanguage["delete_slot_alert"] ?? "delete_slot_alert"), preferredStyle: .alert)
        if self.calenderData.slots.count > sender.tag {
            alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? "OK").capitalized, style: .default, handler: { (UIAlertAction) in
                self.calenderData.slots.remove(at: sender.tag)
                self.slotTableView.reloadData()
                DispatchQueue.main.async {
                    self.updateViewConstraints()
                }
            }))
            alert.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? "cancel"), style: .cancel, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    func slotTimerAct(_ isFromTime: Bool, index: Int, time: String) {
        if self.calenderData.slots.count > index {
            if isFromTime {
                self.calenderData.slots[index].slotFromTime = time
            }
            else {
                self.calenderData.slots[index].slotToTime = time
            }
        }
    }
    func showError(_ isFromTime: Bool) {
        self.view.makeToast(getLanguage["invalid_time"] ?? "")
    }
}
extension ActivateCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.holidayArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HolidayCollectionViewCell", for: indexPath) as! HolidayCollectionViewCell
        cell.holidayLabel.text = holidayArray[indexPath.row][0]
        cell.holidayLabel.backgroundColor = UIColor(named: "appbg")
        cell.holidayLabel.textColor = UIColor(named: "TitleColor")
        if (calenderData.holiday.count) > 0 {
            if self.calenderData.holiday.contains(where: {$0 == holidayArray[indexPath.row][1]}) {
                cell.holidayLabel.backgroundColor = UIColor(named: "AppColor")
                cell.holidayLabel.textColor = UIColor(named: "White")
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.holidayCollectionView.frame.height - 10), height: (self.holidayCollectionView.frame.height - 10))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.calenderData.holiday.contains(where: {$0 == holidayArray[indexPath.row][1]}) {
            self.calenderData.holiday.removeAll(where: {$0 == holidayArray[indexPath.row][1]})
        }
        else {
            self.calenderData.holiday.append(self.holidayArray[indexPath.row][1])
        }
        self.holidayCollectionView.reloadData()
    }
    
}
extension ActivateCalendarViewController: cancellationPolicyDelegate, UITextFieldDelegate {
    
    func selectCancellationPolicy(_ selectedID: String, policyName: String) {
        self.calenderData.policyId = selectedID
        self.calenderData.policyName = policyName
        self.cancellationTextField.text = policyName
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == consultTimeTextField && textField.text == "" {
            self.consultTimeTextField.text = "\(self.pickerArray[0]) Mins"
            self.calenderData.consultTime = "\(self.pickerArray[0])"
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == consultingFeeTextField {
            let amountString: NSString = textField.text! as NSString
            let newString: NSString = amountString.replacingCharacters(in: range, with: string) as NSString
            let regex = "\\d{0,6}(\\.\\d{0,2})?"

            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)

            return predicate.evaluate(with:newString) && allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
extension ActivateCalendarViewController: UIPickerViewAccessibilityDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerArray[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.consultTimeTextField.text = "\(pickerArray[row]) Mins"
        self.calenderData.consultTime = "\(pickerArray[row])"
    }
}

