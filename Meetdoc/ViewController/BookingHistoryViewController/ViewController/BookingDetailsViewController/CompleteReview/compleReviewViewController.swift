//
//  compleReviewViewController.swift
//  Meetdoc
//
//  Created by HTS-MAC on 30/05/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

protocol dismissDelegate {
    func dismissAct()
}

class compleReviewViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var completeBtnView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var completBtn: UIButton!
    @IBOutlet weak var CloseView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var completeLblBtn: UIButton!
    @IBOutlet weak var completeTittleLbl: UILabel!
    @IBOutlet weak var reviewonlyTittleLbl: UILabel!
    @IBOutlet weak var reviewonlyBtn: UIButton!
    @IBOutlet weak var investigationTittleLbl: UILabel!
    @IBOutlet weak var investigationBtn: UIButton!
    @IBOutlet weak var admissonTittleLbl: UILabel!
    @IBOutlet weak var emergencyTittleLbl: UILabel!
    @IBOutlet weak var admissonBtn: UIButton!
    @IBOutlet weak var emergencyBtn: UIButton!
    
    var viewModel = DoctorViewModel()
    var viewModel1 = BookingHistoryViewModel()
    var booking_id = ""
    var status = ""
    var patientStatus = ""
    var delegate: dismissDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
    }
    func configUI(){
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        self.completeTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "completed")
        self.reviewonlyTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "review_only")
        self.investigationTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "investigation_review")
        self.admissonTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "admission")
        self.emergencyTittleLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .left, text: "emergency")
        self.headerLbl.config(color: UIColor(named: "TitleColor"), font: fontSemi14, align: .center, text: "")
        
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.headerLbl.text = "Prescription feedback"
    }
    
    override func viewDidLayoutSubviews() {
        self.wholeView.cornerViewMiniumRadius()
        self.completeBtnView.cornerViewRadius()
        self.CloseView.cornerViewRadius()
    }
    @IBAction func completBtnTapped(_ sender: Any) {
        Utility.shared.startAnimation(viewController: self)
        self.viewModel.completbooking(user_id: UserDefaultModule.shared.getLoginData().userId, booking_id: self.booking_id, status: self.status, patient_status: self.patientStatus, onSuccess: { (success) in
            Utility.shared.stopAnimation(viewController: self)
            
            let alert = UIAlertController(title: "", message: getLanguage["feed_back"], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: getLanguage["OK"], style: .cancel, handler: { (UIAlertAction) in
                self.dismiss(animated: true)
                self.delegate?.dismissAct()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }, onFailure: {_ in
            Utility.shared.stopAnimation(viewController: self)
        })
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.dismissAct()
    }
    
    @IBAction func completeLbtBtn(_ sender: Any) {
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.patientStatus = "Completed"
    }
    @IBAction func reviewTittleBtn(_ sender: Any) {
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.patientStatus = "Needs Review only"
    }
    
    @IBAction func emergencyBtn(_ sender: Any) {
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.patientStatus = "Emergency"
    }
    @IBAction func admissonBtn(_ sender: Any) {
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.patientStatus = "Admission"
    }
    @IBAction func investigationBtn(_ sender: Any) {
        self.completeLblBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.reviewonlyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.investigationBtn.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.admissonBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.emergencyBtn.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.patientStatus = "Investigation & review"
    }
    
}
