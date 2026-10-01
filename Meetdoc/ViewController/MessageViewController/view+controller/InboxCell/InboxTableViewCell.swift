//
//  InboxTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import SwiftUI

class InboxTableViewCell: UITableViewCell {

    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var unReadImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var listDetailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        //self.shadowView.cornerViewMiniumRadius()
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.cornerViewRadius()
        self.dateLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .right, text: "")
        self.userNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: headerFont, align: .left, text: "")
        self.listDetailsLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.listNameLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.statusLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular12, align: .left, text: "")
        self.videoButton.cornerRoundRadius()
    }
    func loadData(_ inboxData: InboxResultModel) {
        let reason: [String] = inboxData.bookingReason.map({$0.name})
        self.listNameLabel.text = reason.joined(separator: ", ")
        
        let bookingDate = Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(inboxData.bookingDate ?? 0)", dateFormat: "dd-MM-YYYY")
        self.dateLabel.text = "\(bookingDate) \(inboxData.booking_time ?? "")"

//        if inboxData.durationType == "perhour" {
//            dateString = "\(Utility().timeStampWithDateFormat(timeStamp: "\(inboxData.startDate ?? 0)", dateFormat: "dd MMM hh:mm aa"))" + " - " + "\(Utility().timeStampWithDateFormat(timeStamp: "\(inboxData.endDate ?? 0)", dateFormat: "hh:mm aa"))"
//        }
//        else {
//            dateString = "\(Utility().timeStampWithDateFormat(timeStamp: "\(inboxData.startDate ?? 0)", dateFormat: "dd MMM"))" + " - " + "\(Utility().timeStampWithDateFormat(timeStamp: "\(inboxData.endDate ?? 0)", dateFormat: "dd MMM"))"
//        }
        self.statusLabel.text = getLanguage[inboxData.status.lowercased()] ?? inboxData.status //+ " " + dateString
        print("checking the lbl \(statusLabel.text)")
        if statusLabel.text == "Accepted" {
            self.statusLabel.textColor = UIColor(named: "AppColor")
        } else if statusLabel.text == "cancelled" {
            self.statusLabel.text = "Cancelled"
            self.statusLabel.textColor = #colorLiteral(red: 0.6705882353, green: 0, blue: 0, alpha: 1)
        } else if statusLabel.text == "Expired" {
            self.statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else if statusLabel.text == "Declined" {
            self.statusLabel.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
        } else if statusLabel.text == "Completed" {
            self.statusLabel.textColor = #colorLiteral(red: 0, green: 0.6705882353, blue: 0.2549019608, alpha: 1)
        }
        else {
            self.statusLabel.textColor = UIColor(named: "SubTitleColor")
        }
        self.unReadImageView.isHidden = true
        // check Read Status
        if (inboxData.read ?? "") == "0"{
            self.userNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: headerFont, align: .left, text: "")
            self.listDetailsLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
            self.unReadImageView.isHidden = true
        }
        else {
            self.userNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "")
            self.listDetailsLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontSemi14, align: .left, text: "")
            self.userNameLabel.textColor = UIColor(named: "TitleColor") ?? .white
            self.listDetailsLabel.textColor = UIColor(named: "SubTitleColor") ?? .white
            self.unReadImageView.isHidden = false
        }
        if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" {
            self.videoButton.isHidden = !inboxData.isVideovisit
            self.userNameLabel.text = "Dr.\(inboxData.userName ?? "")"
        }
        else
        {
            self.videoButton.isHidden = true
            self.userNameLabel.text = "\(inboxData.userName ?? "")"
        }
        if inboxData.chatType == "audio" {
            self.listDetailsLabel.text = getLanguage["send_audio"] ?? "send_audio"
        }
        else if inboxData.chatType == "gif" {
            self.listDetailsLabel.text = getLanguage["send_gif"] ?? "send_gif"
        }
        else if inboxData.chatType == "chatimage"{
            self.listDetailsLabel.text = getLanguage["sent an image"] ?? "Sent an image"
        }
        else if inboxData.chatType == "chatdocument"{
            self.listDetailsLabel.text = getLanguage["sent a file"] ?? "Sent a file"
    }
        else {
            var message = ((getLanguage[inboxData.lastMessage] ?? inboxData.lastMessage)?.decode() ?? "")
            if !message.containsEmoji {
                message = getLanguage[inboxData.lastMessage] ?? inboxData.lastMessage
            }
            self.listDetailsLabel.text = message
        }
        
        self.dateLabel.text = Utility().getTimeAgo(millis: Double(inboxData.chatTime ?? 0) , currentMills: Double(inboxData.time ?? "0") ?? 0)
        self.profileImageView.sd_setImage(with: URL(string: inboxData.userImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
       // self.shadowView.elevationEffect()
    }
    
}
