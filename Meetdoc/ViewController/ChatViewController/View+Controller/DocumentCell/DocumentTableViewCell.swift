//
//  DocumentTableViewCell.swift
//  Meetdoc
//
//  Created by APPLE on 27/04/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var FullStack: UIStackView!
    @IBOutlet weak var insideStack: UIStackView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var FullView: UIView!
    @IBOutlet weak var docicon: UIImageView!
    @IBOutlet weak var docNameLbl: UILabel!
    @IBOutlet weak var doctypeLbl: UILabel!
    
    @IBOutlet weak var docViewBtn: UIButton!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    var chatUserId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI(){
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.cornerViewRadius()
        self.dateLbl.config(color: UIColor(named: "HeaderColor") ?? .white, font: fontRegular12, align: .left, text: "")
        self.dateLbl.isHidden = false
        self.doctypeLbl.isHidden = true
    }
    override func layoutIfNeeded() {
        let userID = "\(UserDefaultModule().getCurrentUserID() as String? ?? "")"

        if userID == chatUserId && UserDefaultModule.shared.getAppLanguage().capitalized != "Arabic" {
            self.FullView.clipsToBounds = true
            self.FullView.layer.cornerRadius = 10
            self.FullView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        else {
            self.FullView.clipsToBounds = true
            self.FullView.layer.cornerRadius = 10
            self.FullView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }

    
    }

    func loadData(_ chatData: ChatResultModel) {
        self.chatUserId = "\(chatData.userId ?? 0)"
        self.profileImageView.sd_setImage(with: URL(string: chatData.userImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
        
       if chatData.chatType == "chatdocument" || chatData.chatType == "prescription"{

            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
//           self.dateLbl.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd MMM yy HH:mm:ss"))
           self.dateLbl.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))
            if userID == "\(chatData.userId ?? 0)"{
                self.FullView.backgroundColor = UIColor(named: "HeaderColor")
                self.dateLbl.textColor = UIColor(named: "White") ?? .white
                self.doctypeLbl.config(color: UIColor.white, font: fontRegular12, align: .center, text: "")
                self.docNameLbl.config(color: UIColor.white, font: regular14, align: .left, text: "")
                self.FullStack.alignment = .trailing
                self.insideStack.removeArrangedSubview(profileView)
                self.insideStack.insertArrangedSubview(profileView, at: 1)
                
                var docURL = (chatData.message ?? "")
                self.doctypeLbl.text = chatData.doctype
                if chatData.chatType == "chatdocument" {
                    self.docNameLbl.text = chatData.message.fileName()
                }else {
                    self.docNameLbl.text = "Prescription"
                }
                
                print("checking name \(chatData.message.fileName())")
                
            }else{
                self.FullView.backgroundColor = UIColor(named: "ChatBGColor")
                self.dateLbl.textColor = UIColor(named: "HeaderColor") ?? .white
                self.doctypeLbl.config(color: UIColor(named: "BlackColor"), font: fontRegular12, align: .center, text: "")
                self.docNameLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "")
                self.FullStack.alignment = .leading
                self.insideStack.removeArrangedSubview(profileView)
                self.insideStack.insertArrangedSubview(profileView, at: 0)
                
                var docURL = (chatData.message ?? "")
                
                self.doctypeLbl.text = chatData.doctype
                if chatData.chatType == "chatdocument" {
                    self.docNameLbl.text = chatData.message.fileName()
                }else {
                    self.docNameLbl.text = "Prescription"
                }
                
                print("checking name 2 \(chatData.message.fileName())")

            }
            
        }
        self.layoutIfNeeded()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
