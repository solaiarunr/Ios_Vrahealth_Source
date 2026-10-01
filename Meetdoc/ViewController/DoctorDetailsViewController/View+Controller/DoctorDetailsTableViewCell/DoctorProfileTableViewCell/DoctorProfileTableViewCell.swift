//
//  DoctorProfileTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class DoctorProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingWholeView: UIView!
    @IBOutlet weak var verifyWholeView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var mailVerifyLabel: UILabel!
    @IBOutlet weak var mobileVerifyLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var feeTitleLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var instituteLabel: UILabel!
    @IBOutlet weak var lanuguageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.doctorImageView.contentMode = .scaleAspectFill
        self.doctorImageView.cornerViewRadius()
        self.doctorNameLabel.numberOfLines = 0
        self.doctorNameLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
        self.feeTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "consulting_fees")
        self.feesLabel.config(color: UIColor(named: "TitleColor"), font: smallFont, align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.qualificationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.lanuguageLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.instituteLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.ratingCountLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.mobileVerifyLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "verify")
        self.mailVerifyLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "verify")
        self.reportLabel.config(color: UIColor(named: "secondary_text"), font: regular14, align: .left, text: "")
        self.videoButton.cornerRoundRadius()
        self.reportView.cornerViewMiniumRadius()
    }
    func loadData(_ doctorData: DoctorResultModel, type: String) {
        self.doctorNameLabel.text = "Dr.\(doctorData.doctorName ?? "")"
        self.qualificationLabel.text = doctorData.qualification ?? ""
        self.instituteLabel.text = doctorData.Institute ?? ""
        let lanuguagearray = doctorData.languages.joined(separator: ",")
        self.lanuguageLabel.text = lanuguagearray
        self.self.feesLabel.text = "\(doctorData.currencyValue ?? "") \(doctorData.consultFees ?? "0")"
        self.locationLabel.text = doctorData.location
        let totalReviewCount = (Int(doctorData.totalReview ?? "0") ?? 0)
        if totalReviewCount > 0 {
            self.ratingView.rating = (Double(doctorData.averageRating ?? "0") ?? 0)
            self.ratingCountLabel.text = "\(totalReviewCount)"
        }
        else {
            self.ratingCountLabel.text = "0"
            self.ratingView.rating = Double(0)
        }
        if doctorData.reportId != "" {
            self.reportLabel.text = (getLanguage["undo"] ?? "undo")
        }
        else {
            self.reportLabel.text = getLanguage["report"] ?? "report"
        }
        self.doctorImageView.sd_setImage(with: URL(string: doctorData.doctorImage), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
        self.videoButton.isHidden = !doctorData.isVideovisit
    }
    func loadPrescriptionData(_ bookingResultModel: ReservationModel?) {
        if bookingResultModel != nil {
            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() != "doctor" {
                if (bookingResultModel?.slotType.lowercased() ?? "") == "videovisit" {
                    self.videoButton.isHidden = false
                }
                else {
                    self.videoButton.isHidden = true
                }
            }
            else {
                self.videoButton.isHidden = true
            }
            if (UserDefaultModule.shared.getLoginData().type ?? "") == "user" {
                self.doctorNameLabel.text = "Dr.\(bookingResultModel?.firstname ?? "")"
            }
            else {
                self.doctorNameLabel.text = bookingResultModel?.firstname ?? ""
            }
            self.feeTitleLabel.text = bookingResultModel?.address ?? ""
            self.locationLabel.text = ""
//            let bookingDate = Date(timeIntervalSince1970: Double(bookingResultModel?.bookingDate ?? 0))
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MMM dd,YYYY"
//            self.locationLabel.text = formatter.string(from: bookingDate)
            self.doctorImageView.sd_setImage(with: URL(string: (bookingResultModel?.profileImage ?? "")), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)
            self.lineView.isHidden = true
            self.ratingWholeView.isHidden = true
            self.verifyWholeView.isHidden = true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
