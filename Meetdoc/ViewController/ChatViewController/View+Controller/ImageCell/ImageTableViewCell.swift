//
//  ImageTableViewCell.swift
//  Meetdoc
//
//  Created by APPLE on 26/04/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var FullStack: UIStackView!
    @IBOutlet weak var insideStack: UIStackView!
    @IBOutlet weak var FullView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var Imageview: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ImageviewBtn: UIButton!

    @IBOutlet weak var dateLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    var chatUserId = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI(){

        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.cornerViewRadius()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        
       if chatData.chatType == "chatimage"{
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            if userID == "\(chatData.userId ?? 0)"{
                
                self.FullStack.alignment = .trailing
                self.insideStack.removeArrangedSubview(profileView)
                self.insideStack.insertArrangedSubview(profileView, at: 1)
                
                self.Imageview.contentMode = .scaleAspectFill
           
               var imageURL = (chatData.message ?? "")
                
               if !(chatData.message ?? "").contains("http") {
                   //imageURL = CHAT_IMAGE_URL+imageURL
               }
                
                self.Imageview.sd_setImage(with: URL(string: imageURL)) { (image, error, cache, url) in
                    if error != nil {
                        self.Imageview.image = #imageLiteral(resourceName: "placeholder")
                    }
                }
                self.dateLabel.config(color: UIColor(named: "HeaderColor"), font: fontRegular12, align: .left, text: "")
                self.dateLabelLeading.constant = 180

            }else{

                self.FullStack.alignment = .leading
                self.Imageview.contentMode = .scaleAspectFill
                self.insideStack.removeArrangedSubview(profileView)
                self.insideStack.insertArrangedSubview(profileView, at: 0)
                self.dateLabel.config(color: UIColor(named: "HeaderColor"), font: fontRegular12, align: .left, text: "")
               var imageURL = (chatData.message ?? "")
               if !(chatData.message ?? "").contains("http") {
                   //imageURL = CHAT_IMAGE_URL+imageURL
                   
               }
                self.Imageview.sd_setImage(with: URL(string: imageURL)) { (image, error, cache, url) in
                    if error != nil {
                        self.Imageview.image = #imageLiteral(resourceName: "placeholder")
                    }
                }
            }
           self.dateLabel.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))
            
        }
        self.layoutIfNeeded()
    }
    
    
}
