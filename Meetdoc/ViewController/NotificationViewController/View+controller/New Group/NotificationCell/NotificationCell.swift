//
//  NotificationCell.swift
//  AirFinch_Swift
//
//  Created by BTMani on 30/05/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell
{
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
     @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var notificationDict: NotificationResultModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.userImgView.cornerViewRadius()
        self.userNameLabel.config(color: UIColor(named: "BlackColor") ?? .white, font: regular14, align: .left, text: "")
         self.notificationLabel.config(color: UIColor(named: "BlackColor") ?? .white, font: regular14, align: .left, text: "")
    }
    func loadData(notificationModel: NotificationResultModel) {
        self.notificationDict = notificationModel
        self.userImgView.sd_setImage(with: URL(string: notificationModel.userImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
//        self.userImageView.contentMode = .scaleAs
        let  startDate = "\(Utility().unixTimeStamptoDate(timeStamp:String(format:"%f", Double(notificationModel.date))))"
        self.dateLabel.config(color: UIColor(named: "BlackColor") ?? .white, font: fontRegular16, align: .left, text: "")
        self.dateLabel.text = startDate
//        switch (notificationModel.type) {
//        case "review":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "review_notify_message", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//        case "prescription":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "added_prescription", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//
//        case "accepted":
//            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
//                self.customizeLabel(firstUsername: notificationModel.userName, type: "accept_notify_message", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//            }
//            else {
//                self.customizeLabel(firstUsername: notificationModel.userName, type: "accept_notify_message", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//            }
//        case "cancelled":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "cancel_notify_message", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//        case "declined":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "decline_notify_message", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//        case "reservation":
//            self.customizeLabel(firstUsername: "", type: "reservation_got_notify_message", username: notificationModel.userName, appendText: "at", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//        case "request":
//            if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
//                self.customizeLabel(firstUsername: "", type:
//                                        "reservation_got_notify_message", username: notificationModel.userName, appendText: "", listName: "", status: notificationModel.block, msgType: notificationModel.type)
//            }
//            else {
//                self.customizeLabel(firstUsername: "", type:
//                    "reservation_made_notify_message", username: notificationModel.userName, appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//
//            }
//        case "refunded":
//            if notificationModel.notifymessage == "Appointment has been Cancelled and refunded to patient" {
//                self.customizeLabel(firstUsername: notificationModel.userName, type: "refunded_cancelled_successfully", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//            }
//            else {
//                self.customizeLabel(firstUsername: notificationModel.userName, type: "refunded_successfully", username: "", appendText: "", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//
//            }
//        case "paid":
//            self.customizeLabel(firstUsername: "", type: "you_got_payment", username: "", appendText: "", listName: notificationModel.userName, status: notificationModel.block, msgType: notificationModel.type)
//        case "message":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "message_notify_message", username: "", appendText: "", listName: notificationModel.message, status: notificationModel.block, msgType: notificationModel.type)
//        case "claim":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: notificationModel.notifymessage, username: "", appendText: "on", listName: notificationModel.listName, status: notificationModel.block, msgType: notificationModel.type)
//        case "adminmessage":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "message_notify_message", username: "", appendText: "", listName: notificationModel.message, status: "", msgType: notificationModel.type)
//        case "adminlog":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "", username: notificationModel.message, appendText: "", listName: "", status: "", msgType: notificationModel.type)
//        case "hospital_approve":
//            self.customizeLabel(firstUsername: notificationModel.userName, type: "Your Hospital has been Approved", username: "", appendText: "", listName: notificationModel.message, status: "", msgType: notificationModel.type)
//        default:
//      //  let notitificationString = notificationModel.userName + " " + notificationModel.notifymessage
//             self.userNameLabel.text = notificationModel.userName
//            self.notificationLabel.text = notificationModel.notifymessage
//        }
        self.notificationLabel.text = notificationModel.notifymessage
    }
    func  customizeColor(string: String, color: UIColor, Font: UIFont?) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes:
            [NSAttributedString.Key.foregroundColor : color ])
    }
        
    func customizeLabel(firstUsername: String, type: String, username: String, appendText: String, listName: String, status: String, msgType: String) {
        var name = firstUsername
        if (UserDefaultModule.shared.getLoginData().type ?? "") != "doctor" && firstUsername.lowercased() != "Admin".lowercased(){
            name = "Dr.\(firstUsername)"
        }
        var notitificationString = name + type + username + (Utility().language().value(forKey: appendText) as? String ?? "") + listName
        if msgType != "claim" {
            notitificationString = name + " " + (Utility().language().value(forKey: type) as? String ?? type) + " " + username + " "
            notitificationString += (Utility().language().value(forKey: appendText) as? String ?? "") + " " + listName
        }
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor(named: "BlackColor") ?? .white, NSAttributedString.Key.font: headerFont]

        let underlineAttriString = NSMutableAttributedString(string: notitificationString)
        let text = notitificationString as NSString
        let range1 = text.range(of: username)
        underlineAttriString.addAttributes(myAttribute as [NSAttributedString.Key : Any], range: range1)
        
        let range2 = text.range(of: listName)
        underlineAttriString.addAttributes(myAttribute as [NSAttributedString.Key : Any], range: range2)
        
        let range3 = text.range(of: name)
        underlineAttriString.addAttributes(myAttribute as [NSAttributedString.Key : Any], range: range3)

        self.notificationLabel.attributedText = underlineAttriString
        self.notificationLabel.isUserInteractionEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let notify = self.notificationDict {
            self.loadData(notificationModel: notify)
        }
        //        self.shadowView.darkElevationEffect()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithDetails(userDict:NSDictionary)
    {
        dateLabel.text = "29-12-1988"
        userImgView.backgroundColor = UIColor.red
        userImgView.layer.cornerRadius = userImgView.frame.size.height/2
        userImgView.layer.masksToBounds = true
    }
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String, Color: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: Color , range: range)
        self.attributedText = attribute
    }
}

