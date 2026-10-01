//
//  PrescriptionViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class PrescriptionViewController: UIViewController {
    
    @IBOutlet weak var medicineTitleLabel: UILabel!
    @IBOutlet weak var printView: UIView!
    @IBOutlet weak var noErrorLabel: UILabel!
    @IBOutlet weak var noStackView: UIStackView!
    @IBOutlet weak var addPrescriptionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var printDateLabel: UILabel!
    @IBOutlet weak var printTitleLabel: UILabel!
    @IBOutlet weak var printTableView: UITableView!
    @IBOutlet weak var printPageNumberLabel: UILabel!
    @IBOutlet weak var printurlLabel: UILabel!

//    var bookingResultModel: BookingHistoryResultModel?
    var booking_id = ""
    var viewModel = PrescriptionViewModel()
    var patientName = ""
    var patientAge = ""
    var patientWeight = ""
    var slotTime = ""
    var bookingDate = ""
    var doctorName = ""
    var doctorqualification = ""
    var speciality = ""
    var doctorregno = ""
    var patientGender = ""
    var viewFrom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        Utility.shared.startAnimation(viewController: self)
        self.configUI()
        print("SOCTOREDETAILS:\(doctorqualification)")
        // Do any additional setup after loading the view.
    }
    func addPrintOption() {
        let rbutton1: UIButton = UIButton(type: UIButton.ButtonType.custom)
        rbutton1.setImage(#imageLiteral(resourceName: "print"), for: UIControl.State.normal)
        rbutton1.tintColor = UIColor(named: "whitecolor")
        rbutton1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rbutton1.tag = 1
        rbutton1.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        rbutton1.addTarget(self, action: #selector(self.rightBarButtonTabbed), for: .touchUpInside)
        if UserDefaultModule.shared.getLoginData().type != "doctor" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rbutton1)
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func rightBarButtonTabbed(_ sender: UIButton) {
        let _ = self.printView.exportAsPdfFromView()
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("yourPDF.pdf")
        do {
            let printData = try Data(contentsOf: pdfPath)
            let printController = UIPrintInteractionController.shared
            if UIPrintInteractionController.canPrint(printData) {
                printController.delegate = self
                let printInfo = UIPrintInfo.printInfo()
                printInfo.outputType = .general
                printInfo.jobName = pdfPath.lastPathComponent
                printInfo.duplex = .longEdge
                printController.printInfo = printInfo
                printController.printingItem = printData
            }
            printController.present(animated: true)
        } catch _ {
        }
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["prescription"] ?? "prescription", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        
        self.addPrescriptionButton.config(color: UIColor(named: "White"), font: regularFont, align: .center, title: "add_prescription")
        self.tableView.register(UINib(nibName: "PrescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "PrescriptionTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorProfileTableViewCell")
        self.tableView.register(UINib(nibName: "DoctorHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DoctorHeaderTableViewCell")
        self.printTableView.register(UINib(nibName: "DoctorHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "DoctorHeaderTableViewCell")
        self.printTableView.register(UINib(nibName: "PrintTableViewCell", bundle: nil), forCellReuseIdentifier: "PrintTableViewCell")
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 40
        self.noStackView.isHidden = true
        self.noErrorLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .center, text: "no_medication")
        self.loadPrintPage()
        if UserDefaultModule.shared.getLoginData().type.lowercased() != "doctor" {
            self.addPrescriptionButton.isHidden = true
        }
    }
    func loadData() {
        self.noStackView.isHidden = true
        self.viewModel.getPrescriptionList(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), booking_id: self.booking_id, type: self.viewFrom) { (success) in
            if ((self.viewModel.prescriptionListModel?.results.count ?? 0) == 0) {
                self.noStackView.isHidden = false
            }
            else {
                self.addPrintOption()
            }
            Utility.shared.stopAnimation(viewController: self)
            self.tableView.reloadData()
            self.printTableView.reloadData()
        } onFailure: { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    func loadPrintPage() {
        self.medicineTitleLabel.config(color: UIColor(named: "appblackcolor"), font: headerFont, align: .left, text: "medicines")
        self.printTitleLabel.config(color: UIColor(named: "appblackcolor"), font: fontRegular10, align: .left, text: "")
        self.printTitleLabel.text = "\(getLanguage["appname"] ?? "") | \(getLanguage["appname"] ?? "") \(getLanguage["print_title"] ?? "")"
        self.printDateLabel.config(color: UIColor(named: "appblackcolor"), font: fontRegular10, align: .right, text: "")
        self.printDateLabel.text = Utility.shared.timeStampWithDateFormat(timeStamp: "\(Date().timeIntervalSince1970)", dateFormat: "dd/MM/yy HH:mm a")
        self.printurlLabel.config(color: UIColor(named: "appblackcolor"), font: fontRegular10, align: .left, text: "")
        self.printurlLabel.text = webURL
        self.printPageNumberLabel.config(color: UIColor(named: "appblackcolor"), font: fontRegular10, align: .right, text: "")
        self.printPageNumberLabel.text = "Page 1 of 1"
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.loadData()
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
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func profileAct() {
        if (UserDefaultModule.shared.getLoginData().type) != "doctor" {
            let pageObj = DoctorDetailsViewController()
            pageObj.doctorID = self.viewModel.prescriptionListModel?.reservation.hostid ?? ""
            pageObj.type = ""
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
    @objc func directionViewAct(_ gestureRecognizer: UITapGestureRecognizer) {
      print("TAPPEDD")
        let resultArray = self.viewModel.prescriptionListModel!.results
        let img = resultArray![gestureRecognizer.view!.tag].prescription_images
      let pageObj = prescriptionImageViewController()
        pageObj.patientName = self.patientName
        pageObj.patientAge = self.patientAge
        pageObj.patientWeight = self.patientWeight
        pageObj.slotTime = self.slotTime
        pageObj.bookingDate = self.bookingDate
        pageObj.doctorName = self.doctorName
        pageObj.doctorqualification = self.doctorqualification
        pageObj.speciality = self.speciality
        pageObj.patientGender = self.patientGender
        pageObj.doctorregno = self.doctorregno
        pageObj.prescriptionImageUrl = img ?? ""
        print("DONE:\(self.patientName)")
      self.navigationController?.pushViewController(pageObj, animated: true)
    }
    @IBAction func prescriptionButtonAct(_ sender: UIButton) {
        if self.viewFrom == "online"{
            let pageObj = AddEditPrescriptionViewController()
            pageObj.bookingID = self.booking_id
            self.navigationController?.pushViewController(pageObj, animated: true)
        }else{
            let pageObj = PrescriptionUploadViewController()
            pageObj.bookingID = self.booking_id
            self.navigationController?.pushViewController(pageObj, animated: true)
        }
    }
}
extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return (self.viewModel.prescriptionListModel?.results.count ?? 0)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.viewModel.prescriptionListModel?.results.count ?? 0) == 0 {
            return  0
        }
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || tableView == self.printTableView {
            return 0
        }
        else {
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || tableView == self.printTableView{
            return nil
        }
        else {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DoctorHeaderTableViewCell") as! DoctorHeaderTableViewCell
            cell.titleLabel.text = getLanguage["medication"] ?? "medication"
            cell.contentLabel.isHidden = true
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.printTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrintTableViewCell") as! PrintTableViewCell
            cell.topView.isHidden = true
            cell.bottomView.isHidden = true
            if let prescriptionData = self.viewModel.prescriptionListModel?.results[indexPath.row] {
                cell.loadData(prescriptionData, section: indexPath.section)
                if indexPath.section == 0 {
                    cell.topView.isHidden = false
                }
                else {
                    if ((self.viewModel.prescriptionListModel?.results.count ?? 0) - 1) == indexPath.row {
                        cell.bottomView.isHidden = false
                    }
                }
            }
            return cell
        }
        else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileTableViewCell") as! DoctorProfileTableViewCell
                cell.selectionStyle = .none
                cell.loadPrescriptionData(self.viewModel.prescriptionListModel?.reservation)
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionTableViewCell") as! PrescriptionTableViewCell
                if self.viewModel.prescriptionListModel?.results[indexPath.row].type == "handwritten"{
                    cell.prescriptionImageView.isHidden = false
                    cell.prescriptionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.directionViewAct(_:))))
                    cell.prescriptionImageView.tag = indexPath.row
                    cell.prescriptionImageView.isUserInteractionEnabled = true
                    cell.prescriptionImageView.tag = indexPath.row
                    cell.contentStackView.isHidden = true
                }else{
                    cell.prescriptionImageView.isHidden = true
                    cell.contentStackView.isHidden = false
                }
                if let prescriptionData = self.viewModel.prescriptionListModel?.results[indexPath.row] {
                    cell.loadData(prescriptionData)
                }
                cell.moreButton.tag = indexPath.row
                cell.moreButton.isHidden = true
                /*
                if UserDefaultModule.shared.getLoginData().type.lowercased() != "doctor" {
                    cell.moreButton.isHidden = true
                }
                else {
                    cell.moreButton.isHidden = false
                }
                */
                cell.moreButton.addTarget(self, action: #selector(self.moreButtonAct(_:)), for: .touchUpInside)
                return cell
            }
        }
 
    }
    func deleteMedicine(_ id: String) {
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.deletePrescription(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), id: (id)) { (success) in
            Utility.shared.stopAnimation(viewController: self)
            let alert = UIAlertController(title: nil, message: (getLanguage[(self.viewModel.addPrescriptionModel?.message ?? "")] ?? (self.viewModel.addPrescriptionModel?.message ?? "")), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
                self.loadData()
            }))
            self.present(alert, animated: true, completion: nil)
        } onFailure: { (failure) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }
    @objc func moreButtonAct(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if sender.tag < (self.viewModel.prescriptionListModel?.results.count ?? 0) {
            if let prescriptionData = self.viewModel.prescriptionListModel?.results[sender.tag] {
                alert.addAction(UIAlertAction(title: getLanguage["edit"] ?? "edit", style: .default, handler: {_ in
                    let pageObj = AddEditPrescriptionViewController()
                    pageObj.bookingID = self.booking_id
                    pageObj.prescriptionResultModel = prescriptionData
                    self.navigationController?.pushViewController(pageObj, animated: true)
                }))
                alert.addAction(UIAlertAction(title: getLanguage["delete"] ?? "delete", style: .default, handler: { (UIAlertAction) in
                    self.deleteMedicine(prescriptionData.id)
                }))
            }
            
        }
        alert.addAction(UIAlertAction(title: getLanguage["cancel"] ?? "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension PrescriptionViewController: UIPrintInteractionControllerDelegate {
    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self.navigationController
    }
    func printInteractionControllerDidPresentPrinterOptions(_ printInteractionController: UIPrintInteractionController) {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "whitecolor")
        self.navigationController?.topViewController?.navigationController?.navigationBar.tintColor = UIColor(named: "whitecolor")
    }
}
