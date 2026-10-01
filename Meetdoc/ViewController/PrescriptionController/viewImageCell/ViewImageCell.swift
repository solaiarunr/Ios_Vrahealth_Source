//
//  ViewImageCell.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 03/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class ViewImageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    @IBOutlet weak var digitalprescriptionLbl: UILabel!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var digitalBtn: UIButton!
    @IBOutlet weak var digitalstackView: UIStackView!
    @IBOutlet weak var imagestackView: UIStackView!
    
    
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI(){
        self.fullView.layer.borderWidth = 0.5
        self.fullView.layer.borderColor = (UIColor(named: "lineColor") ?? .white).cgColor
        self.fullView.viewRadius(radius: 5)
        self.nameLbl.config(color: UIColor(named: "AppColor"), font: fontSemi14, align: .left, text: "")
        self.dateLbl.config(color: UIColor(named: "appblackcolor"), font: fontRegular12, align: .right, text: "")
        self.doctorNameLbl.config(color: UIColor(named: "appblackcolor"), font: fontRegular12, align: .left, text: "")
        self.timeLbl.config(color: UIColor(named: "appblackcolor"), font: fontRegular12, align: .right, text: "")
        self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "image")
        self.digitalprescriptionLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "digital_prescription")
        self.dateLbl.text = "Date: 07/08/2023"
        self.timeLbl.text = "Time: 6:30 p.m"
        self.doctorNameLbl.text = "Doctor: Siva"
    }
    
    func loaddata(model: ViewPrescriptionResultModel) {
        if model.digital_prescription_url != "" && model.image_precription_url == "" {
            self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "digital_prescription")
        }else if model.digital_prescription_url == "" && model.image_precription_url != "" {
            self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "image")
        }else if model.digital_prescription_url != "" && model.image_precription_url != "" {
            self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "image")
            self.digitalprescriptionLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "digital_prescription")
        }
        if model.digital_prescription_url == "" || model.image_precription_url == "" {
            self.digitalBtn.isHidden = true
            self.digitalstackView.isHidden = true
            //           if  model.digital_prescription_url == "" {
            //               self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "image")
            //           }else {
            //               self.imageLbl.config(color: UIColor(named: "appblackcolor"), font: smallFont, align: .center, text: "digital_prescription")
            //           }
        }else if model.digital_prescription_url != "" && model.image_precription_url != "" {
            self.digitalBtn.isHidden = false
            self.digitalstackView.isHidden = false
        }
        self.dateLbl.text = "Date: \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(model.date ?? "")", dateFormat: "dd/MM/yyyy")))"
        self.timeLbl.text = "Time: \((Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(model.time ?? "")", dateFormat: "h:mm a")))"
        self.doctorNameLbl.text = "Doctor: \(model.doctor_name ?? "")"
    }
    
    

}
