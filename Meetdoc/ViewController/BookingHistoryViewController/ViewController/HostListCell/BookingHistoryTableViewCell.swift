//
//  BookingHistoryTableViewCell2.swift
//  Meetdoc
//
//  Created by HTS-49 on 21/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class BookingHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var bookingTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var qualificationLabel: UILabel!
    
    var timer: Timer!
    var create_time = 0
    var book_status = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        self.updatetime()
    }
    override func layoutSubviews() {
        self.shadowView.elevationEffect()
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configUI() {
        self.shadowView.elevationEffect()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .left, text: "")
        self.addressLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.qualificationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.dateLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .right, text: "")
        self.bookingTimeLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .right, text: "")
        self.specialityLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.statusLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.acceptButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "accept")
        self.declineButton.config(color: UIColor(named: "White"), font: regular14, align: .center, title: "decline")
        self.rescheduleButton.config(color: UIColor(named: "White"), font: fontRegular13, align: .center, title: "reschedule")
        self.videoButton.cornerRoundRadius()
        
        self.shadowView.cornerViewMiniumRadius()
        self.acceptButton.cornerViewMiniumRadius()
        self.declineButton.cornerViewMiniumRadius()
        self.rescheduleButton.cornerViewMiniumRadius()
        self.doctorImageView.contentMode = .scaleAspectFill
        self.doctorImageView.image = UIImage(named: "doctorProfile")
        self.doctorImageView.cornerViewRadius()
        self.acceptButton.backgroundColor = UIColor(named: "AppColor")
        self.declineButton.backgroundColor = UIColor(named: "AppColor")
        self.rescheduleButton.backgroundColor = UIColor(named: "AppColor")
        self.bookingTimeLabel.isHidden = false
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.qualificationLabel.isHidden = true
        }else{
            self.qualificationLabel.isHidden = false
        }
    }
    @objc func updatetime() {
            var timestamp = NSDate().timeIntervalSince1970
            if Int(timestamp)  >= self.create_time && (book_status.lowercased() ?? "") == "pending"{
                self.declineButton.isHidden = false

                print("check4")
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    func loadData(_ result: BookingHistoryResultModel) {
        if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" {
            self.titleLabel.text = "Dr.\(result.userName ?? "")"
        }
        else {
            self.titleLabel.text = result.userName
        }
        self.specialityLabel.isHidden = true
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.addressLabel.text = result.location
        }else{
            self.addressLabel.text = result.doctor_location
        }
//        self.addressLabel.sizeToFit()
//        self.addressLabel.numberOfLines = 0
        self.doctorImageView.sd_setImage(with: URL(string: result.userImage), placeholderImage: #imageLiteral(resourceName: "doctorProfile"), completed: nil)

        self.specialityLabel.text = result.speciality
        self.qualificationLabel.text = result.doctor_qualification ?? ""
        self.statusLabel.text = getLanguage[result.status.lowercased()] ?? result.status
        let bookingDate = Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\((result.utcappstart ?? "0"))", dateFormat: "dd-MM-YYYY")
        self.dateLabel.text = "\(bookingDate)"
        if result.reschedule_time == "" {
            self.bookingTimeLabel.text = "\(result.time ?? "")"
        }else{
            self.bookingTimeLabel.text = result.reschedule_time ?? ""
        }
        self.videoButton.isHidden = true
        if UserDefaultModule.shared.getLoginData().type != "doctor" {
            self.videoButton.isHidden = result.slotBookingtype == "videovisit" ? false : true
        }
        self.layoutSubviews()
//        self.bookingTimeLabel.text = result.time
    }
    
}
