//
//  DCBookingDetailsViewController.swift
//  Meetdoc
//
//  Created by HTS-49 on 18/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class DCBookingDetailsViewController: UIViewController{
    
    @IBOutlet weak var noitemimgView: UIView!
    @IBOutlet weak var noitemimg: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    var viewModel = BookingHistoryViewModel()
    var limit = 20
    var offset = 0
    var isFound = true
    var doctorType = ""
    var ListData = [BookingHistoryResultModel]()
    var ListData1 = [BookingHistoryResultModel]()
    var historyType = "all"
    var refreshControl = UIRefreshControl()
    var tag = Int()
    var selectDate = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI(){
        let Date = (Utility.shared.convertTimeStampWithDateFormat1(timeStamp: "\((self.selectDate))", dateFormat: "MMM dd,yyyy"))
        print("DATEE:\(Date)")
        self.navigationController?.NavigationBarWithBackButtonAndTitle1(title: "\(getLanguage["booking_available"] ?? "booking_available") on \(Date)", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.tableview.register(UINib(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.reloadData()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableview.addSubview(refreshControl)
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                }
        }
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.ListData.removeAll()
        self.offset = 0
        self.tableview.reloadData()
        self.loadData()
    }
    func loadData(){
        Utility.shared.startAnimation(viewController: self)
//        let bookingDate = Date(timeIntervalSince1970: Double(self.selectDate ))
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            self.doctorType = "doctor"
        }
        else {
            self.doctorType = "user"
        }
        self.viewModel.viewList(user_id:(UserDefaultModule().getCurrentUserID() as String? ?? ""),type: UserDefaultModule.shared.getLoginData().type, date: self.selectDate,booking_type: historyType, offset: "\(offset)", limit: "\(limit)", onSuccess: { (success) in
            print(success)
            Utility.shared.stopAnimation(viewController: self)
            self.noitemimgView.isHidden = true
            self.noitemimg.isHidden = true
            self.refreshControl.endRefreshing()
            if self.viewModel.historyModel?.status == false {
                self.isFound = false
                self.noitemimg.isHidden = false
                self.noitemimgView.isHidden = false
            }
            else {
                if self.viewModel.historyModel?.result != nil {
                        if self.offset == 0 {
                            self.ListData.removeAll()
                            self.ListData1.removeAll()
                        }
                        self.ListData1 += self.viewModel.historyModel!.result
                        for listdate in self.ListData1{
                            let selectDate = Utility.shared.timeStampWithDateFormat1(timeStamp: "\(self.selectDate)", dateFormat: "MMM dd,yyyy")
                            let endDate = Utility.shared.timeStampWithDateFormat1(timeStamp: "\(listdate.bookingDate ?? 0)", dateFormat: "MMM dd,yyyy")
                            print("SELECTDATE:\(selectDate)")
                            print("ENDDATE:\(endDate)")
//                            if self.selectDate == listdate.bookingDate{
                            if selectDate == endDate{
                                self.ListData.append(listdate)
                            }
                        }
                }
            }
            self.tableview.reloadData()

        }) { (failure) in
            self.refreshControl.endRefreshing()
            Utility.shared.stopAnimation(viewController: self)
            print(failure)
        }
    }

}
extension DCBookingDetailsViewController:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        cell.selectionStyle = .none        
        let doctor_name = self.ListData[indexPath.row].userName ?? ""
        let start_time = self.ListData[indexPath.row].time ?? ""
        let end_time = self.ListData[indexPath.row].end_time ?? ""
//        cell.PatientNameLbl.text = "Dr.\(doctor_name)"
        cell.TimeLbl.text = start_time
        cell.endTimeLbl.text = end_time
 //       cell.DCNameLbl.text = self.ListData[indexPath.row].patientname
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            var type = self.ListData[indexPath.row].type
            if type == "digitalclinic" {
                cell.DCNameLbl.text = self.ListData[indexPath.row].userName
                cell.PatientNameLbl.text = self.ListData[indexPath.row].patientname
                cell.PatientIcon.image = UIImage(named: "patfill")
                cell.DCIcon.image = UIImage(named: "Dcimage_new")
            } else {
               
                cell.PatientNameLbl.text = self.ListData[indexPath.row].userName
                cell.PatientIcon.image = UIImage(named: "patfill")
                cell.DCNameLbl.isHidden = true
                cell.DCIcon.isHidden = true
            }
            
        }else{
            cell.DCNameLbl.text = "Dr.\(self.ListData[indexPath.row].userName ?? "")"
            cell.DCIcon.image = UIImage(named: "doctor_icon_new")
            cell.PatientNameLbl.text = self.ListData[indexPath.row].patientname
            cell.PatientIcon.image = UIImage(named: "patfill")
        }
        
        cell.statusLbl.text = self.ListData[indexPath.row].status
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        cell.ViewButton.tag = indexPath.row
        cell.ViewButton.addTarget(self, action: #selector(self.viewButtonAct(_:)), for: .touchUpInside)
        cell.borderView.backgroundColor = UIColor(named: "BorderColor")
        cell.codeLbl.text = "-"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @objc func viewButtonAct(_ sender: UIButton){
        let pageObj = BookingDetailsViewController()
        pageObj.type = self.doctorType
        pageObj.historyType = self.historyType
        pageObj.bookingResultModel = self.ListData[sender.tag]
        pageObj.booking_id = self.ListData[sender.tag].bookingId
        pageObj.user_id = self.ListData[sender.tag].userId
        pageObj.bookingResultModel?.type = self.historyType
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
   
}
