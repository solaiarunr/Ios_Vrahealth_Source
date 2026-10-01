//
//  DatePickerViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 26/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol calendarPickerDelegate {
    func datePickerAct(_ startDate: Date, _ endDate: Date)
}
class CalendarPickerViewController: UIViewController {
    @IBOutlet weak var DcavailabelView: UIView!
    @IBOutlet weak var AvailableText: UILabel!
    @IBOutlet weak var DayOnOffBtn: UISwitch!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var pickerView: UIStackView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet var weekDayCollectionLabel: [UILabel]!
    @IBOutlet weak var bookingListButton: UIButton!

    var delegate: calendarPickerDelegate?
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var calendarDescLabel: UILabel!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var calendarStackView: UIStackView!
    
    @IBOutlet weak var dayonoffLabel: UILabel!
    @IBOutlet weak var bookingListLabel: UILabel!
    var isFromTab = true
    var viewModel = CalendarViewModel()
    
    // isFormBooking == 3
    var type = ""
    var daytype = ""
    var clickDate = Int()
    var currentIndex = 0
    var selectedDate = [Int]()
    var selectDate = [Int]()
    var solts = [SlotModel]()
    var bookeddates = [Int]()
    var hide = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        Utility.shared.startAnimation(viewController: self)
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.setNavigationBar()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationItem.rightBarButtonItems = nil
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
        self.nextButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.previousButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
         }
        self.loadCalendarData()
    }
    func configUI() {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.DcavailabelView.isHidden = false
            self.saveButton.isHidden = true
            self.calendarStackView.isHidden = true
            self.pickerView.isHidden = false
            self.bookingListButton.isHidden = false
            self.bookingListLabel.isHidden = false
        }else{
            self.DcavailabelView.isHidden = true
            self.calendarStackView.isHidden = true
            self.pickerView.isHidden = false
            self.bookingListButton.isHidden = true
            self.bookingListLabel.isHidden = true
        }
        self.bannerView.isHidden = true
        self.setNavigationBarItems()
        self.hideView.isHidden = true
//        self.saveButton.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "activate_callendar")
         self.saveButton.cornerViewRadius()
         self.saveButton.elevationEffect1()
        self.saveButton.isHidden = hide
        self.bookingListButton.cornerViewRadius()
        self.bookingListButton.elevationEffect1()
        self.AvailableText.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "Dc_available1")
        self.DayOnOffBtn.onTintColor = UIColor(named: "shadColor")
        self.DayOnOffBtn.thumbTintColor = UIColor(named: "AppColor")
        self.previousButton.imageView?.tintColor = UIColor(named: "SubTitleColor") ?? .white
        self.nextButton.imageView?.tintColor = UIColor(named: "SubTitleColor") ?? .white
        self.monthYearLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, text: "")
        self.dayonoffLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular12, align: .left, text: "new_dayon/off")
        self.bookingListLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular12, align: .left, text: "view_day")
        for lbl in weekDayCollectionLabel {
            lbl.config(color: UIColor(named: "fifth_text") ?? .white, font: fontRegular12, align: .center, text: "")
            if DatePickerData.shared.DayArray.count > lbl.tag {
                lbl.text = DatePickerData.shared.DayArray[lbl.tag]
            }
        }
        if UserDefaultModule.shared.getLoginData().type != "doctor"{
            self.dayonoffLabel.isHidden = true
            self.bookingListLabel.isHidden = true
        }
        self.bookingListButton.isHidden = true
        self.bookingListLabel.isHidden = true
        self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "onetime_des")
        self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "activate_callendar")
        self.calendarButton.cornerMiniumRadius()
        self.calendarButton.backgroundColor = UIColor(named: "AppColor")
        self.collectionView.register(UINib(nibName: "DatePickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DatePickerCollectionViewCell")
        
        // Hidden date View
        self.calendarStackView.isHidden = true
      //  self.pickerView.isHidden = true
        self.saveButton.isHidden = true
        self.loadPayoutUI()
        self.collectionView.isScrollEnabled = true
//        self.loadAddOns()
        if self.DayOnOffBtn.isOn == true{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            if "\(hour):\(minutes)" == "00:00"{
                self.DayOnOffBtn.isOn = false
                self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "enable", onSuccess: { (success) in
                    print("Success")
                }) { (failure) in
                    print("Failure")
                }
            }else   if "\(hour):\(minutes)" < self.solts[0].slotFromTime || "\(hour):\(minutes)" > self.solts[0].slotToTime {
                self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "disable", onSuccess: { (success) in
                    print("Success")
                    self.DayOnOffBtn.isOn == false
                }) { (failure) in
                    print("Failure")
                }
            }
        }
    }
    func setNavigationBar() {
        let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle(Utility().language().value(forKey: "activate_callendar") as? String ?? "", for: .normal)
        self.parent?.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barButton1)]
        self.parent?.navigationItem.rightBarButtonItems = nil
    }
    func loadData() {
        
        SettingViewModel().getAdminData(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            self.loadPayoutUI()
            Utility.shared.stopAnimation(viewController: self)
        }) { (failure) in
            self.loadPayoutUI()
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func loadPayoutUI() {
        if !isCalendar {
            if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
            self.calendarStackView.isHidden = false
            self.pickerView.isHidden = true
            }
            self.saveButton.isHidden = true
        }
        else {
            self.calendarStackView.isHidden = true
            self.pickerView.isHidden = false
            self.saveButton.isHidden = false
        }
        self.setNavigationBarItems()
        if !isPayout {
            if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
            self.calendarStackView.isHidden = false
            self.pickerView.isHidden = true
            }
            self.saveButton.isHidden = true
            self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "dc_your_payout")
            self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "continue")
        }
        else {
            self.calendarDescLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "onetime_des")
            self.calendarButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "activate_callendar")
        }
    }
    func loadCalendarData() {
            self.viewModel.getCalenderData(user_id: "\(UserDefaultModule().getCurrentUserID() as String? ?? "")", onSuccess: { (success) in
                Utility().stopAnimation(viewController: self)
                if (self.viewModel.activateCalendwdarModel?.status ?? false) {
                    if self.viewModel.activateCalendwdarModel?.result != nil {
                        self.solts = self.viewModel.activateCalendwdarModel?.result.slots ?? [SlotModel]()
                        self.daytype = self.viewModel.activateCalendwdarModel?.result.dayoff ?? ""
                        self.bookeddates = self.viewModel.activateCalendwdarModel?.result.booked_dates ?? [0]
                    }
                    self.loadPayoutUI()
                }
                if UserDefaultModule.shared.getLoginData().type == "doctor"{
                    if self.viewModel.activateCalendwdarModel?.result != nil{
                        //                    print("UNUSALTIME:\(self.viewModel.activateCalendwdarModel?.result.unusual_time ?? "")")
                        if self.viewModel.activateCalendwdarModel?.result.unusual_time ?? "" == "disable"{
                            self.DayOnOffBtn.isOn = false
                        }else{
                            self.DayOnOffBtn.isOn = true
                        }
                    }
                }
                self.loadData()
                self.selectedDate.removeAll()
                self.loadMonthData(IndexPath(item: 0, section: 0))
                self.collectionView.reloadData()
            }) { (failure) in
                Utility().stopAnimation(viewController: self)
            }
        }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
                self.calendarStackView.isHidden = false
                self.pickerView.isHidden = true
                }
                self.saveButton.isHidden = true
                self.navigationItem.leftBarButtonItems = nil
                self.navigationItem.rightBarButtonItems = nil
            }
        }
    }
    @IBAction func clearButtonAct(_ sender: UIButton) {

    }
    
    @IBAction func dayonoffBtn(_ sender: UISwitch) {
        
        if sender.isOn {
            self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "enable", onSuccess: { (success) in
                Utility().stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: self.viewModel.setCalenderModel?.message ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                    if !success{
                        self.DayOnOffBtn.setOn(false, animated: true)
                    }else{
                        self.DayOnOffBtn.setOn(true, animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            })
            { (failure) in
                Utility().stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: getLanguage["Something went wrong"] ?? "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                    self.DayOnOffBtn.setOn(false, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "disable", onSuccess: { (success) in
                Utility().stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: self.viewModel.setCalenderModel?.message ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                    if !success{
                        self.DayOnOffBtn.setOn(false, animated: true)
                    }else{
                        self.DayOnOffBtn.setOn(false, animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            })
            { (failure) in
                Utility().stopAnimation(viewController: self)
                let alert = UIAlertController(title: nil, message: getLanguage["Something went wrong"] ?? "Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                    self.DayOnOffBtn.setOn(false, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        /*
        let date = Date()
        let calendar = Utility.calendar
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let CurrDate = Utility.calendar.date(bySettingHour: hour, minute: minutes, second: 0, of: date)!
        let CurrTimeinMilliSecs = Int(CurrDate.timeIntervalSince1970 * 1000) //Current Time
        
        let startArray = self.solts[0].slotFromTime.components(separatedBy: ":")
        let endArray = self.solts[0].slotToTime.components(separatedBy: ":")
        
        let startTime = Utility.calendar.date(bySettingHour: Int(startArray[0])!, minute: Int(startArray[1])!, second: 0, of: date)!
        let StartTimeinMilliSecs = Int(startTime.timeIntervalSince1970 * 1000) //Start Time
        
        let endTime = Utility.calendar.date(bySettingHour: Int(endArray[0])!, minute: Int(endArray[1])!, second: 0, of: date)!
        let EndTimeinMilliSecs = Int(endTime.timeIntervalSince1970 * 1000) //End Time
        
        
        print("CURRENTTIME:\(hour):\(minutes)")
        print("UNUSUALSTARTTIME:\(startTime) InMilliSecs:\(StartTimeinMilliSecs)")
        print("UNUSUALENDTIME:\(endTime) InMillisecs:\(EndTimeinMilliSecs)")
//        if "\(hour):\(minutes)" < self.solts[0].slotFromTime || "\(hour):\(minutes)" > self.solts[0].slotToTime { //old
        if CurrTimeinMilliSecs < StartTimeinMilliSecs || CurrTimeinMilliSecs > EndTimeinMilliSecs { //New
            if sender.isOn{
                //Switch is in On
                self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "enable", onSuccess: { (success) in
                    let alert = UIAlertController(title: nil, message: getLanguage["Dc_available1"] ?? "Dc_available1", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }) { (failure) in
                    Utility().stopAnimation(viewController: self)
                    let alert = UIAlertController(title: nil, message: getLanguage["Something went wrong"] ?? "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                //Switch is Off
                self.viewModel.unusualbooking(doctor_id: UserDefaultModule.shared.getLoginData().userId, unusualtime_status: "disable", onSuccess: { (success) in
                    let alert = UIAlertController(title: nil, message: getLanguage["unusual_time"] ?? "unusual_time", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }) { (failure) in
                    Utility().stopAnimation(viewController: self)
                    let alert = UIAlertController(title: nil, message: getLanguage["Something went wrong"] ?? "Something went wrong", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            self.DayOnOffBtn.isOn = false
            Utility().stopAnimation(viewController: self)
            let alert = UIAlertController(title: nil, message: getLanguage["unusual_slot_time"] ?? "unusual_slot_time", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .default, handler: { (UIAlertAction) in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        */
    }
    @objc func backButtonAct(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type != "digitalclinic"{
        self.calendarStackView.isHidden = false
        self.pickerView.isHidden = true
        }
        self.saveButton.isHidden = true
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
    }
    func setNavigationBarItems() {
        let barButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        barButton.addTarget(self, action: #selector(backButtonAct(_:)), for: .touchUpInside)
        barButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 3, bottom: 4, right: 3)
        barButton.setImage(UIImage(named: "left_arrow"), for: .normal)
        barButton.tintColor = UIColor(named: "White")
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            barButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        let barButton1 = UIButton(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        barButton1.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        barButton1.titleLabel?.lineBreakMode = .byWordWrapping
        barButton1.titleLabel?.font = fontRegular18 ?? UIFont.systemFont(ofSize: 14)
        barButton1.contentHorizontalAlignment = .leading
        barButton1.setTitleColor(UIColor(named: "White") ?? .white, for: .normal)
        barButton1.setTitle((getLanguage["booking_calendar"] ?? "booking_calendar"), for: .normal)
        if self.tabBarController?.selectedIndex == 1 {
            self.parent?.navigationItem.leftBarButtonItems = [ UIBarButtonItem(customView: barButton1)]
            self.parent?.navigationItem.rightBarButtonItems = nil
            if !self.pickerView.isHidden {
                let barButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                barButton2.addTarget(self, action: #selector(self.settingButtonAct), for: .touchUpInside)
                barButton2.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
                barButton2.setImage(UIImage(named: "settings_icon-1"), for: .normal)
                barButton2.tintColor = UIColor(named: "White")
                if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                    barButton2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
                self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barButton2)]
            }
        }
    }
    
    @objc func settingButtonAct() {
        let pageObj = ActivateCalendarViewController()
        pageObj.isFromEdit = false
        pageObj.datetype = self.daytype
        pageObj.enterPage = "1"
        var calenderData = ActivateCalendarResultModel()
        print("Count12:  \(calenderData.slots.count)")
        calenderData = self.viewModel.activateCalendwdarModel?.result ?? ActivateCalendarResultModel()
        print(ActivateCalendarResultModel().slots.count)
        print("Count12:  \(calenderData.slots.count)")
        calenderData.dayoff = ""
        calenderData.offdate = [Int]()
        calenderData.slots = self.solts
        pageObj.calenderData = calenderData
        print("Count12:  \(pageObj.calenderData.slots.count)")
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func activateCalenddarButtonAct(_ sender: UIButton) {
        if !isPayout {
            let pageObj = ViewDoctorProfileViewController()
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
        else {
            let pageObj = ActivateCalendarViewController()
            pageObj.isFromEdit = false
            pageObj.enterPage = "1"
            pageObj.datetype = self.daytype
            var calenderData = ActivateCalendarResultModel()
            calenderData = self.viewModel.activateCalendwdarModel?.result ?? ActivateCalendarResultModel()
            calenderData.dayoff = ""
            calenderData.offdate = [Int]()
            calenderData.slots = self.solts
            pageObj.calenderData = calenderData
            self.navigationController?.pushViewController(pageObj, animated: true)
//            self.calendarStackView.isHidden = true
//            self.parent?.navigationItem.leftBarButtonItems = nil
//            self.parent?.navigationItem.rightBarButtonItems = nil
//            self.pickerView.isHidden = false
//            if isCalendar {
//                self.saveButton.isHidden = false
//            }
        }
        self.setNavigationBarItems()
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
//        if self.selectedDate.count > 0 {
            let pageObj = ActivateCalendarViewController()
            pageObj.bookedDateArray = self.viewModel.activateCalendwdarModel?.result.booked_dates ?? [Int]()
            pageObj.enterPage = "2"
            pageObj.isFromEdit = true
            pageObj.datetype = self.daytype
            var calenderData = ActivateCalendarResultModel()
            calenderData = self.viewModel.activateCalendwdarModel?.result ?? ActivateCalendarResultModel()
            calenderData.dayoff = ""
            calenderData.bookingType = ""
            calenderData.consultFees = 0
            calenderData.consultTime = ""
            calenderData.holiday = [String]()
            calenderData.policyId = ""
            calenderData.slots = [SlotModel]()
            calenderData.policyName = ""
        print("ashjdfgajsd",self.selectDate)
        print("calenderData",calenderData.dayoff)
            pageObj.selectedOffDate = self.selectedDate
         pageObj.days = self.selectedDate
            pageObj.calenderData = calenderData
       
        
            self.navigationController?.pushViewController(pageObj, animated: true)
//        }
//        else {
//            self.view.makeToast(getLanguage["select dates"] ?? "select dates")
//        }
        
    }
    @IBAction func nextButtonAct(_ sender: UIButton) {
        if DatePickerData.shared.months.count > (currentIndex+1) && (currentIndex+1) < DatePickerData.shared.initialNumberOfMonths {
            self.currentIndex = (currentIndex+1)
            self.collectionView.layoutIfNeeded()
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: true)
            self.loadMonthData(IndexPath(item: self.currentIndex, section: 0))
        }
    }
    @IBAction func previousButtonAct(_ sender: UIButton) {
        if DatePickerData.shared.months.count > (currentIndex-1) && (currentIndex-1) >= 0{
            self.currentIndex = (currentIndex-1)
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: true)
            self.loadMonthData(IndexPath(item: self.currentIndex, section: 0))

        }
    }
    @IBAction func bookingListButtonAct(_ sender: UIButton) {
        let pageObj = DCBookingDetailsViewController()
        print("77676555:\(self.selectDate)")
        print("self.clickDate:\(self.clickDate)")
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let localDate = Int(Double(self.clickDate) + Double(timezoneOffset))
        pageObj.selectDate = localDate
        self.navigationController?.pushViewController(pageObj, animated: true)
        print(self.selectDate)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CalendarPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, updateSelectedDateDelegate {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DatePickerData.shared.months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatePickerCollectionViewCell", for: indexPath) as! DatePickerCollectionViewCell
        cell.delegate = self
        if self.viewModel.activateCalendwdarModel?.result != nil {
            cell.holidayArray = self.viewModel.activateCalendwdarModel?.result.holiday ?? [String]()
        }

        cell.days = DatePickerData.shared.days
        cell.offDates = self.selectedDate
        cell.bookingdates = self.bookeddates
        cell.loadCalendarData(indexPath.row, calenderData: self.viewModel.activateCalendwdarModel?.result)
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in self.collectionView.visibleCells {
            if let indexPath = self.collectionView.indexPath(for: cell) {
                self.currentIndex = indexPath.row
                self.loadMonthData(indexPath)
            }
        }
    }
    func loadMonthData(_ indexPath: IndexPath) {
        if DatePickerData.shared.months.count > indexPath.row && indexPath.row >= 0{
            let selectedMonth = DatePickerData.shared.months[indexPath.row]
            let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
            let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
            self.monthYearLabel.text = "\(DatePickerData.shared.dateFormatter.monthSymbols[month - 1]) \(year)"
        }
    }
    func selectedDate(_ calenderData: [Int]) {
        self.selectedDate = calenderData
        self.selectDate = calenderData
        if self.selectDate.count == 1{
            self.bookingListButton.isHidden = false
            self.bookingListLabel.isHidden = false
        }
        else{
            self.bookingListButton.isHidden = true
            self.bookingListLabel.isHidden = true
        }
        
         if UserDefaultModule.shared.getLoginData().type == "doctor"{
             if self.selectDate.count == 1{
                 self.bookingListButton.isHidden = false
                 self.bookingListLabel.isHidden = false
             }
             else{
                 self.bookingListButton.isHidden = true
                 self.bookingListLabel.isHidden = true
             }
         }else{
             self.bookingListButton.isHidden = true
             self.bookingListLabel.isHidden = true
         }
         
    }
    func selectedBookingDate(_ selectedDate: Int, isSelect: Bool,type: String) {
        self.clickDate = selectedDate
        print("CLICKDATE:\(self.clickDate)")
        
         if UserDefaultModule.shared.getLoginData().type == "doctor"{
             self.clickDate = selectedDate
             print("CLICKDATE:\(self.clickDate)")
         }else{
             if type == "clicked" {
                 self.clickDate = selectedDate
                 let pageObj = DCBookingDetailsViewController()
                 print("77676555:\(self.selectDate)")
                 print("self.clickDate:\(self.clickDate)")
                 let timezoneOffset =  TimeZone.current.secondsFromGMT()
                 let localDate = Int(Double(self.clickDate) + Double(timezoneOffset))
                 pageObj.selectDate = localDate
                 self.navigationController?.pushViewController(pageObj, animated: true)
                 print("CLICKDATE:\(self.clickDate)")
             }
         }
         
    }
//    func check(_ status: Bool){
//        self.hide = status
//    }
}
/*
extension CalendarPickerViewController: GADBannerViewDelegate {
    func loadAddOns() {
        bannerView.isHidden = true
        if IS_GOOGLE_ADSENSE {
            bannerView.isHidden = false
            bannerView.adUnitID = BANNNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        bannerView.isHidden = false
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
*/
