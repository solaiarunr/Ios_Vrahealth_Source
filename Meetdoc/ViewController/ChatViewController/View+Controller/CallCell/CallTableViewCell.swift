//
//  CallTableViewCell.swift
//  Meetdoc
//
//  Created by HTS-MAC on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class CallTableViewCell: UITableViewCell {

    @IBOutlet weak var calliconImageView: UIImageView!
    @IBOutlet weak var callTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.callTextLabel.config(color: UIColor(named: "DarkAppColor"), font: fontRegular13, align: .left, text: "")
        self.layoutIfNeeded()
        // Initialization code
    }
    func loadData(_ chatData: ChatResultModel) {
        if chatData.chatType == "audiocallstart"{
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            
            if userID == "\(chatData.userId ?? 0)" {
                self.callTextLabel.text = "Audio \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "outgoincall")
                
            }
            else{
                self.callTextLabel.text = "Audio call reveived \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "incomeingcall")
            }
        }
        else if chatData.chatType == "audiocallend" {
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            if userID == "\(chatData.userId ?? 0)" {
                self.callTextLabel.text = "Audio \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "outgoincall")
            }
            else{
                self.callTextLabel.text = "Audio\(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "incomeingcall")
                
            }
        }
        else if chatData.chatType ==  "missedaudiocall" {
            self.callTextLabel.text = "Audio \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
            self.calliconImageView.image = UIImage(named: "missedcall")
        }
        else if chatData.chatType ==  "videocallstart" {
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            if userID == "\(chatData.userId ?? 0)" {
                self.callTextLabel.text = "Video \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "outgoincall")
                
            }
            else{
                self.callTextLabel.text = "Video call reveived \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "incomeingcall")
            }
        }
        else if chatData.chatType == "videocallend" {
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            if userID == "\(chatData.userId ?? 0)" {
                self.callTextLabel.text = "Video \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "outgoincall")
            }
            else{
                self.callTextLabel.text = "Video\(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
                self.calliconImageView.image = UIImage(named: "incomeingcall")
            }
        }
        else if chatData.chatType ==  "missedvideocall" {
            self.callTextLabel.text = "Video \(chatData.message ?? "") \(Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))"
            self.calliconImageView.image = UIImage(named: "missedcall")
        }
   //     self.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
