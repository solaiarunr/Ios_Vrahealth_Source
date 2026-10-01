//
//  BookingCalendarViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 24/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView

class BookingCalendarViewController: UIViewController,BookingStatusDelegate {
    func responsesuccess() {
        let pageObj = BookingStatusViewController()
        pageObj.bookingType = "request"
        pageObj.requestType = self.booking_type
        self.hideView.isHidden = true
        self.loaderView.stopAnimating()
        print("SUCCESSSS")
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    
    
    @IBOutlet weak var calendarStackView: UIStackView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var feesTitleLabel: UILabel!
    @IBOutlet weak var noSlotsButton: UIButton!
    @IBOutlet weak var reasonArrowBtn: UIImageView!
    @IBOutlet weak var policyContentLabel: UILabel!
    @IBOutlet weak var policyNameLabel: UILabel!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cancellationpolicyStackView: UIStackView!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var resonLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var weekDayCollectionLabel: [UILabel]!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var rescheduleAlertLbl: UILabel!
    @IBOutlet weak var qualificationLbl: UILabel!
    @IBOutlet weak var inisitueLbl: UILabel!
    
    @IBOutlet weak var downLabel: UILabel!
    var doctorData: DoctorResultModel?
    var type = ""
    var booking_type = ""
    var viewModel = DoctorViewModel()
    var titleArray = ["earlymorning","morning", "afternoon", "evening", "night"]
    var resechudle_date = Int()

    var currentIndex = 0
    var selectedSlot: BookingSlotSubModel?
    var slotTimeArr = [[BookingSlotSubModel]]()
    var selectedIllness = [IllnessResultModel]()
    var selectedDate: Int?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromFilter = false
    var filterVC: FilterViewController?
    var isFirstTime = true
    var bookedTime = [String]()
    var rescheduled_time = [String]()
    var accepted_bookings = [String]()
    var redoctorID = String()
    var sendType = String()
    var bookingID = String()
    var bookingResultModel: BookingHistoryResultModel?
    var res = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideView.isHidden = true
        self.configUI()
        self.sendType = "new"
        print("DOCTORID1:\(self.redoctorID)")
        self.cancellationpolicyStackView.isHidden = true
        self.detailsView.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            self.reasonArrowBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.previousButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.nextButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tableViewHeightConst.constant = newsize.height
            }
        }
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["appointment"] ?? "appointment", fColor: "White", fontName: fontRegular16, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.doctorImageView.contentMode = .scaleAspectFill
        self.doctorImageView.cornerViewRadius()
        self.doctorNameLabel.numberOfLines = 0
        self.doctorNameLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
        self.noSlotsButton.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .left, title: "slots_not_available")
        self.noSlotsButton.isHidden = true
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.qualificationLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.inisitueLbl.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.downLabel.config(color: UIColor(named: "primary"), font: headerFont, align: .left, text: "")
        self.ratingCountLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.previousButton.imageView?.tintColor = UIColor(named: "SubTitleColor") ?? .white
        self.nextButton.imageView?.tintColor = UIColor(named: "SubTitleColor") ?? .white
        self.monthYearLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, text: "")
        self.resonLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "reason_for_your_visit")
        self.rescheduleAlertLbl.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "same_day")
        if sendType == "redoctor"{
            self.payButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "confirm")
        }else{
        self.payButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "pay")
        }
        self.payButton.cornerMiniumRadius()
        self.payButton.backgroundColor = UIColor(named: "AppColor")
        self.policyNameLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "")
        self.policyContentLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.feesTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "consulting_fees")
        self.feesLabel.config(color: UIColor(named: "TitleColor"), font: smallFont, align: .left, text: "")

        for lbl in weekDayCollectionLabel {
            lbl.config(color: UIColor(named: "fifth_text") ?? .white, font: fontRegular12, align: .center, text: "")
            if DatePickerData.shared.DayArray.count > lbl.tag {
                lbl.text = DatePickerData.shared.DayArray[lbl.tag]
            }
        }
        self.collectionView.register(UINib(nibName: "DatePickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DatePickerCollectionViewCell")
        self.tableView.register(UINib(nibName: "DoctorHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DoctorHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "BookingTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40
        self.tableView.sectionFooterHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionFooterHeight = 40
        self.rescheduleAlertLbl.isHidden = true
        self.loadMonthData(IndexPath(item: 0, section: 0))
        self.tableView.reloadData()
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            //self.sendType = "redoctor"
            self.profileStackView.isHidden = true
            self.reasonView.isHidden = true
            self.calendarStackView.isHidden = true
            self.rescheduleAlertLbl.isHidden = false
            self.reshedule()
        }else{
            self.reasonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reasonViewAct(_:))))
            // If Calendar From Filter
            if isFromFilter {
                self.reasonView.isHidden = true
                self.tableView.isHidden = true
                self.payButton.isHidden = true
                self.profileStackView.isHidden = true
            }
            else {
                self.loadData()
                self.loadProfileData()
            }
        }
//        DispatchQueue.main.async {
//            self.tableViewHeightConst.constant = self.tableView.contentSize.height
////            self.updateViewConstraints()
//        }
       
    }
    @objc func reasonViewAct(_ sender: UITapGestureRecognizer) {
        if isProfileUpdate {
            let pageObj = SelectIllnessPage()
            pageObj.isFromFilter = false
            pageObj.getSpecilityId = self.doctorData?.speciality.map({$0.id}) ?? [Int]()
            pageObj.selectedArray = self.selectedIllness
            pageObj.delegate = self
            self.navigationController?.pushViewController(pageObj, animated: true)
        } else {
            let alert = UIAlertController(title: nil, message: getLanguage["please_update_profile"] ?? "please_update_profile", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? ""), style: .default, handler: { (UIAlertAction) in
                let pageObj = ProfilePage()
                pageObj.delegate = self
                self.navigationController?.pushViewController(pageObj, animated: true)
            }))
            alert.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
//    override func updateViewConstraints() {
//        tableViewHeightConst.constant = self.tableView.contentSize.height
//        super.updateViewConstraints()
//    }
    func loadProfileData() {
        self.doctorNameLabel.text = "Dr.\(doctorData?.doctorName ?? "")"
        self.qualificationLbl.text = doctorData?.qualification ?? ""
        self.inisitueLbl.text = doctorData?.Institute ?? ""
        self.feesLabel.text = "\(doctorData?.currencyValue ?? "")\(doctorData?.consultFees ?? "")"
        self.locationLabel.text = doctorData?.location ?? ""
        let totalReviewCount = (Int(doctorData?.totalReview ?? "0") ?? 0)
        self.downLabel.text = "Select Date and Time Below"
        if totalReviewCount > 0 {
            self.ratingView.rating = (Double(doctorData?.averageRating ?? "0") ?? 0)
            self.ratingCountLabel.text = "\(totalReviewCount)"
        }
        else {
            self.ratingCountLabel.text = "0"
            self.ratingView.rating = Double(0)
        }
        self.doctorImageView.sd_setImage(with: URL(string: (doctorData?.doctorImage ?? "")), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
    }
    func timeStampFromString(_ time: String) -> Date {
        let slotArr = time.components(separatedBy: ":")
        let toDate = Calendar.current.date(bySettingHour: Int(slotArr.first ?? "0") ?? 0, minute: Int(slotArr.last ?? "0") ?? 0, second: 0, of: Date())!
        return toDate
    }
    func loadData() {
        
        var dateVal = (self.selectedDate ?? 0)
        if dateVal == 0 {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let date = Calendar.current.date(from: components)
            dateVal = Int(date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        }
        self.hideView.isHidden = false
        self.loaderView.startAnimating()
        self.viewModel.getSlotData(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: "\(self.doctorData?.doctorId ?? "")", type: booking_type, date: dateVal, onSuccess: { (success) in
            if self.viewModel.bookingSlotModel?.status ?? false {
                self.bookedTime.removeAll()
                if let slot = self.viewModel.bookingSlotModel?.result.bookedTime{
                    for val in slot{
                        self.bookedTime.append(val.time)
                    }
                    print("THIS TIME LOAD:\(self.bookedTime)")
                }
                self.rescheduled_time.removeAll()
                if let rescheduledslot = self.viewModel.bookingSlotModel?.result.rescheduled_time{
                    for val in rescheduledslot{
                        self.rescheduled_time.append(val.time)
                    }
                    print("THIS TIME LOAD:\(self.rescheduled_time)")
                }
                self.accepted_bookings.removeAll()
                if let acceptedslot = self.viewModel.bookingSlotModel?.result.accepted_bookings{
                    for val in acceptedslot{
                        self.accepted_bookings.append(val.time)
                    }
                    print("THIS TIME LOAD:\(self.accepted_bookings)")
                }
                self.slotTimeArr.removeAll()
                if let slotVal = self.viewModel.bookingSlotModel?.result.results {
                    
                    let morningArray = slotVal.morning ?? [BookingSlotSubModel]()
                    let noonArray = slotVal.afternoon ?? [BookingSlotSubModel]()
                    let evngArray = slotVal.evening ?? [BookingSlotSubModel]()
                    let nightArray = slotVal.night ?? [BookingSlotSubModel]()
                    let earlyMorningArray = slotVal.earlymorning ?? [BookingSlotSubModel]()

                    self.slotTimeArr.append(earlyMorningArray)
                    self.slotTimeArr.append(morningArray)
                    self.slotTimeArr.append(noonArray)
                    self.slotTimeArr.append(evngArray)
                    self.slotTimeArr.append(nightArray)
                    if self.slotTimeArr.count == 0 {
                        self.view.makeToast(getLanguage["slot_not_available"] ?? "slot_not_available")
                    }
//                    self.payButton.setTitle("\(getLanguage["pay"] ?? "") \(self.viewModel.bookingSlotModel?.result.currency ?? "")\(self.viewModel.bookingSlotModel?.result.grandTotal ?? "0")", for: .normal)
                    self.payButton.setTitle("\(getLanguage["pay"] ?? "") \(self.viewModel.bookingSlotModel?.result.currency ?? "") \(self.viewModel.bookingSlotModel?.result.grandTotal ?? "0") \(getLanguage["pay2"] ?? "")", for: .normal)
                }
                self.policyNameLabel.text = (self.viewModel.bookingSlotModel?.result.policy_name ?? "")
                self.policyContentLabel.text = (self.viewModel.bookingSlotModel?.result.content ?? "")
            }
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
            if DatePickerData.shared.months.count > 0 && self.isFirstTime {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
            }
            self.isFirstTime = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.viewDidLayoutSubviews()
            }
            self.hideView.isHidden = true
            self.loaderView.stopAnimating()
        }) { (failure) in
            self.hideView.isHidden = true
            self.loaderView.stopAnimating()
        }
    }
    func reshedule(){
        var dateVal = (self.selectedDate ?? 0)
        if dateVal == 0 {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let date = Calendar.current.date(from: components)
            dateVal = Int(date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        }
        self.hideView.isHidden = false
        self.loaderView.startAnimating()
        //"\(self.doctorData?.doctorId ?? "")"
        self.viewModel.reseheduleSlotDate(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: self.redoctorID, type: booking_type, date: self.resechudle_date, onSuccess: { (success) in
            if self.viewModel.bookingSlotModel?.status ?? false {
                if let slot = self.viewModel.bookingSlotModel?.result.bookedTime{
                    for val in slot{
                        self.bookedTime.append(val.time)
                        print("THIS TIME RESHEDULE:\(val.time ?? "")")
                    }
                }
                self.rescheduled_time.removeAll()
                if let rescheduledslot = self.viewModel.bookingSlotModel?.result.rescheduled_time{
                    for val in rescheduledslot{
                        self.rescheduled_time.append(val.time)
                    }
                }
                if let acceptedslot = self.viewModel.bookingSlotModel?.result.accepted_bookings{
                    for val in acceptedslot{
                        self.accepted_bookings.append(val.time)
                    }
                    print("THIS TIME LOAD:\(self.accepted_bookings)")
                }
                if let slotVal = self.viewModel.bookingSlotModel?.result.results {
                    self.slotTimeArr.removeAll()
                    let morningArray = slotVal.morning ?? [BookingSlotSubModel]()
                    let noonArray = slotVal.afternoon ?? [BookingSlotSubModel]()
                    let evngArray = slotVal.evening ?? [BookingSlotSubModel]()
                    let nightArray = slotVal.night ?? [BookingSlotSubModel]()
                    let earlyMorningArray = slotVal.earlymorning ?? [BookingSlotSubModel]()

                    self.slotTimeArr.append(earlyMorningArray)
                    self.slotTimeArr.append(morningArray)
                    self.slotTimeArr.append(noonArray)
                    self.slotTimeArr.append(evngArray)
                    self.slotTimeArr.append(nightArray)
                    if self.slotTimeArr.count == 0 {
                        self.view.makeToast(getLanguage["slot_not_available"] ?? "slot_not_available")
                    }
                    self.payButton.setTitle(getLanguage["confirm"], for: .normal)
                }
                self.policyNameLabel.text = (self.viewModel.bookingSlotModel?.result.policy_name ?? "")
                self.policyContentLabel.text = (self.viewModel.bookingSlotModel?.result.content ?? "")
            }
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
            if DatePickerData.shared.months.count > 0 && self.isFirstTime {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
            }
            self.isFirstTime = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.viewDidLayoutSubviews()
            }
            self.hideView.isHidden = true
            self.loaderView.stopAnimating()
        }) { (failure) in
            self.hideView.isHidden = true
            self.loaderView.stopAnimating()
        }
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
            self.collectionView.layoutIfNeeded()
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .left, animated: true)
            self.loadMonthData(IndexPath(item: self.currentIndex, section: 0))
            
        }
    }
    @IBAction func payButtonAct(_ sender: UIButton) {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            print("DOCTOR",self.selectedSlot?.startTime)
            if self.selectedSlot?.startTime != nil{
                self.hideView.isHidden = false
                self.loaderView.startAnimating()
                self.viewModel.bookAppointment(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: UserDefaultModule.shared.getLoginData().userId, paytoken: "", illness_id: "" , date: selectedDate ?? 0, time: (self.selectedSlot?.startTime ?? ""), slot_bookingtype: booking_type, booking_type: "\(self.doctorData?.bookingType ?? "")", currency: "", grand_total: "", endTime: "",doctor_fees: "",tax: "",sitefees: "",price: "",currencycode: "",convertedcurrencycode: "",paymentprice: "",usercurrencyrate: "",doctorcurrencyrate: "", cancelpercentage: "",type: UserDefaultModule.shared.getLoginData().type, patient_name: "", patient_age: "", patient_gender: "", patient_weight: "", patient_illness: "", appointment: "reschedule", dc_name: "", booking_id: self.bookingID, patient_phone: "",patient_height:"",patient_bp:"",patient_bprs:"", onSuccess: { (success) in
                    self.hideView.isHidden = true
                    self.loaderView.stopAnimating()
                    if success {
                        let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            let pageObj = BookingStatusViewController()
                            pageObj.bookingType = "request"
                            pageObj.requestType = self.booking_type
                            self.navigationController?.pushViewController(pageObj, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: nil, message: getLanguage[(self.viewModel.bookingModel?.message ?? "")] ?? (self.viewModel.bookingModel?.message ?? ""), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }) { (failure) in
                    self.hideView.isHidden = true
                    self.loaderView.stopAnimating()
                }
            }else{
                let alert = UIAlertController(title: "", message: "Please select the session time", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel)
                alert.addAction(okay)
                self.present(alert, animated: true)
            }
        }else{
            let illnessID: [String] = self.selectedIllness.map({("\($0.id ?? 0)")})
            if self.selectedIllness.count == 0 {
                //self.selectedIllness.count == 0 && self.sendType != "redoctor"  {
                self.view.makeToast(getLanguage["select_illness"] ?? "select_illness")
            }
            
            else if self.selectedDate == nil {
                self.view.makeToast(getLanguage["select_date"] ?? "select_date")
            }
            else if self.selectedSlot == nil {
                if Array(self.slotTimeArr.joined()).count == 0 {
                    self.view.makeToast(getLanguage["slots_not_available"] ?? "slots_not_available")
                }
                else {
                    self.view.makeToast(getLanguage["select_time"] ?? "select_time")
                }
            }
            else {
                if isProfileUpdate {
                    let pageVc = DetailsfillViewController()
                    pageVc.modalPresentationStyle = .overCurrentContext
                    pageVc.illnessID = illnessID
                    pageVc.selectedDate = selectedDate
                    pageVc.booking_type = booking_type
                    pageVc.doctoravailable = self.doctorData?.bookingType ?? ""
                    pageVc.doctor_id = self.doctorData?.doctorId ?? ""
                    pageVc.currency = self.viewModel.bookingSlotModel?.result.currency ?? ""
                    pageVc.grand_total = self.viewModel.bookingSlotModel?.result.grandTotal ?? "0"
                    pageVc.doctor_fees = self.viewModel.bookingSlotModel?.result.consultFees ?? "0"
                    pageVc.tax = self.viewModel.bookingSlotModel?.result.tax ?? "0"
                    pageVc.sitefees = self.viewModel.bookingSlotModel?.result.sitefees ?? "0"
                    pageVc.price = self.viewModel.bookingSlotModel?.result.price ?? "0"
                    pageVc.currencycode = self.viewModel.bookingSlotModel?.result.currencycode ?? ""
                    pageVc.convertedcurrencycode = self.viewModel.bookingSlotModel?.result.convertedcurrencycode ?? ""
                    pageVc.paymentprice = self.viewModel.bookingSlotModel?.result.paymentprice ?? ""
                    pageVc.usercurrencyrate = self.viewModel.bookingSlotModel?.result.usercurrencyrate ?? ""
                    pageVc.doctorcurrencyrate = self.viewModel.bookingSlotModel?.result.doctorcurrencyrate ?? ""
                    pageVc.cancelpercentage = self.viewModel.bookingSlotModel?.result.cancelpercentage ?? ""
                    pageVc.docbookType = self.doctorData?.bookingType ?? ""
                    pageVc.time = self.selectedSlot?.startTime ?? ""
                    pageVc.endTime = self.selectedSlot?.endTime ?? ""
                    pageVc.delegate = self
                    self.present(pageVc, animated: true)
                }
                else {
                    let alert = UIAlertController(title: nil, message: getLanguage["please_update_profile"] ?? "please_update_profile", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: (getLanguage["OK"] ?? ""), style: .default, handler: { (UIAlertAction) in
                        let pageObj = ProfilePage()
                        pageObj.delegate = self
                        self.navigationController?.pushViewController(pageObj, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: (getLanguage["cancel"] ?? ""), style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
extension BookingCalendarViewController: UITableViewDelegate, UITableViewDataSource, bookingDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.slotTimeArr[indexPath.section].count == 0 ? 0 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.slotTimeArr[section].count == 0 ? 0 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func checkHoliday() -> Bool {
        if self.viewModel.bookingSlotModel?.result != nil {
            for day in (self.viewModel.bookingSlotModel?.result.holiday ?? [String]()) {
                let weekDayIndex = Calendar.current.component(.weekday, from: Date())
                let weekDay = DatePickerData.shared.dateFormatter.weekdaySymbols[weekDayIndex-1]
                print("weekDay\(weekDay), day\(day)")
                if (weekDay.lowercased() == day.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
    func checkBlockedDate() -> Bool {
        for day in (self.doctorData?.offdate ?? [Int]()) {
            let startAvlDate = Date(timeIntervalSince1970: Double(day))
            if Calendar.current.isDateInToday(startAvlDate) {
                return true
            }
        }
        return false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        let dateVal = Date(timeIntervalSince1970: Double(self.selectedDate ?? 0))
        
        if Calendar.current.isDateInToday(dateVal) {
            if checkHoliday() {
                self.noSlotsButton.isHidden = false
                return 0
            }
            else if checkBlockedDate(){
                self.noSlotsButton.isHidden = false
                return 0
            }
        }
        if Array(self.slotTimeArr.joined()).count == 0 && !isFromFilter{
            self.noSlotsButton.isHidden = false
        }
        else {
            self.noSlotsButton.isHidden = true
        }
        return self.slotTimeArr.count
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.noSlotsButton.isHidden = true
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DoctorHeaderTableViewCell") as! DoctorHeaderTableViewCell
        cell.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "")
        cell.titleLabel.text = getLanguage[titleArray[section]] ?? titleArray[section]
        return self.slotTimeArr[section].count == 0 ? nil : cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell") as! BookingTableViewCell
        cell.selectionStyle = .none
        cell.loadData(selectedSlot, slots: self.slotTimeArr[indexPath.section])
        cell.newbookedTime = self.bookedTime
        cell.rescheduled_time = self.rescheduled_time
        cell.accepted_bookings = self.accepted_bookings
        cell.delegate = self
        if self.slotTimeArr[indexPath.section].count == 0 {
            cell.isHidden = true
        }
        else {
            cell.isHidden = false
        }
//        cell.collectionView.layoutSubviews()
//        cell.layoutSubviews()
//        cell.contentView.layoutSubviews()
        return cell
    }
    func getValidSlots(_ slots: [BookingSlotSubModel], bookingArray: [BookedTimeModel]) -> [BookingSlotSubModel] {
        var bookingSlots = [BookingSlotSubModel]()
        for slot in slots {
            let slotArr = slot.startTime.components(separatedBy: ":")
            if (slotArr.count) > 1 {
                let date = Date(timeIntervalSince1970: (Double(self.selectedDate ?? 0)))
                let toDate = Calendar.current.date(bySettingHour: Int(slotArr.first ?? "0") ?? 0, minute: Int(slotArr.last ?? "0") ?? 0, second: 0, of: date)!
                if selectedDate == nil {
                    selectedDate = Int(Date().timeIntervalSince1970)
                }
                if toDate < Date() {
                    print("InValid Time")
                }
                else {
                    if !bookingArray.contains(where: {$0.time == slot.startTime}) {
                        bookingSlots.append(slot)
                    }
                }
            }
        }
        return bookingSlots
    }
    func bookingAct(_ selectedTime: BookingSlotSubModel){
        let slotArr = selectedTime.startTime.components(separatedBy: ":")
        if (slotArr.count) > 1 {
            let date = Date(timeIntervalSince1970: (Double(self.selectedDate ?? 0)))
            let toDate = Utility.calendar.date(bySettingHour: Int(slotArr.first ?? "0") ?? 0, minute: Int(slotArr.last ?? "0") ?? 0, second: 0, of: date)!
            print("DATECHECKTEST:\(toDate),SELCTDATE:\(self.selectedDate ?? 0)")
            if UserDefaultModule.shared.getLoginData().type == "doctor" {
                if self.resechudle_date != 0 {
                    self.selectedSlot = selectedTime
                print("SSSS:\(selectedTime)")
                    self.tableView.reloadData()
                }
                else {
                    self.view.makeToast(getLanguage["select_date"] ?? "select_date")
                }
                
            }else {
                if selectedDate != nil {
                    let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    var comp = DateComponents()
                    comp.timeZone = TimeZone(abbreviation: Utility.calendar.timeZone.identifier)
//                    if toDate < Utility.calendar.date(from: components)! { //Option -1
//                    if toDate < Calendar.current.date(from: comp)! { //Option-2
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ" // Define the desired format

                    let currentDate = Date()
                    let milliseconds = Int(toDate.timeIntervalSince1970 * 1000)
                    if milliseconds < Int(currentDate.timeIntervalSince1970 * 1000){
                        self.view.makeToast(getLanguage["invalid_time"] ?? "invalid_time")
                    }
                    else {
                        self.selectedSlot = selectedTime
                        self.tableView.reloadData()
                    }
                }
                else {
                    self.view.makeToast(getLanguage["select_date"] ?? "select_date")
                }
            }
        }
    }
}
extension BookingCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, updateSelectedDateDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.viewModel.bookingSlotModel?.status != nil || isFromFilter{
            return DatePickerData.shared.months.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatePickerCollectionViewCell", for: indexPath) as! DatePickerCollectionViewCell
        cell.delegate = self
        cell.days = DatePickerData.shared.days
        if isFromFilter {
            cell.loadData(indexPath.row, offDate: [Int]())
        }
        else {
            if self.viewModel.bookingSlotModel?.result != nil {
//                cell.holidayArray = self.viewModel.bookingSlotModel?.result.holiday ?? [String]()
            }
            cell.selectedBookingDate = self.selectedDate ?? 0
            cell.loadData(indexPath.row, offDate: [Int]())
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
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
        
    }
    func selectedBookingDate(_ selectedDate: Int, isSelect: Bool, type: String) {
        self.selectedDate = selectedDate
        if isSelect {
            self.selectedSlot = nil
        }
        self.tableView.reloadData()
        if isFromFilter && isSelect{
            if self.selectedDate == 0 {
                self.selectedDate = Int(Date().timeIntervalSince1970)
            }
            self.filterVC?.filterStruct.availability = "\(self.selectedDate ?? 0)"
            self.navigationController?.popViewController(animated: true)
        }
        else if isSelect && !isFromFilter{
            if selectedDate != 0 {
                self.selectedDate = selectedDate
                if UserDefaultModule.shared.getLoginData().type == "doctor"{
                    self.reshedule()
                }else{
                self.loadData()
                }
            }
        }
        print(selectedDate)
    }
}
extension BookingCalendarViewController: Select_Illness, userData {
    func selectedIllness(_ illnessArray: [IllnessResultModel]) {
        self.selectedIllness = illnessArray
        self.resonLabel.config(color: UIColor(named: "red"), font: regular14, align: .left, text: "")
        self.resonLabel.text = self.selectedIllness.map({("\($0.name ?? "")")}).joined(separator: ", ")

    }
    func addUserName(name: String, lastName : String, userImage: UIImage) {
        self.loadData()
    }
}
