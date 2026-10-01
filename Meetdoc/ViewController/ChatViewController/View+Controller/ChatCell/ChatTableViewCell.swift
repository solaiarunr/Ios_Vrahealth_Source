//
//  ChatTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var bgViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var wholeStackView: UIStackView!
    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var chatBackgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chatPreviewimage: UIImageView!
    @IBOutlet weak var textStackView: UIStackView!
    var chatUserId = ""
    var userimage = ""
    var refreshChat: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.profileImageView.contentMode = .scaleAspectFill
        self.chatPreviewimage.contentMode = .scaleToFill
        self.profileImageView.cornerViewRadius()
        self.titleLabel.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .left, text: "")
        self.dateLabel.config(color: UIColor(named: "HeaderColor") ?? .white, font: fontRegular12, align: .left, text: "")
        self.dateLabel.isHidden = false
    }
    override func layoutIfNeeded() {
//        self.bgView.layer.cornerRadius = 10
//        self.bgView.clipsToBounds = true
        let userID = "\(UserDefaultModule().getCurrentUserID() as String? ?? "")"
        if userID == chatUserId && UserDefaultModule.shared.getAppLanguage().capitalized != "Arabic" {
            self.bgView.clipsToBounds = true
            self.bgView.layer.cornerRadius = 10
            self.bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        else {
            self.bgView.clipsToBounds = true
            self.bgView.layer.cornerRadius = 10
            self.bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    func loadData(_ chatData: ChatResultModel) {
        self.chatUserId = "\(chatData.userId ?? 0)"
        self.profileImageView.sd_setImage(with: URL(string: chatData.userImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
        self.titleLabel.text = chatData.message
        self.titleLabel.sizeToFit()
        

//        self.dateLabel.text = Utility().getTimeAgo(millis: Double(chatData.date ?? 0), currentMills: Double(chatData.time ?? 0))
//        self.dateLabel.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd MMM yy HH:mm:ss"))
        self.dateLabel.text = (Utility.shared.convertTimeStampWithDateFormat(timeStamp: "\(chatData.date ?? 0)", dateFormat: "dd.MM.yyyy 'time:' h:mm a"))
        let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
        if userID == "\(chatData.userId ?? 0)" {
            self.titleLabel.textColor = UIColor(named: "White") ?? .white
            self.dateLabel.textColor = UIColor(named: "White") ?? .white
            self.chatStackView.removeArrangedSubview(profileView)
            self.chatStackView.insertArrangedSubview(profileView, at: 1)
            self.wholeStackView.alignment = .trailing
            self.chatBackgroundImageView.image = #imageLiteral(resourceName: "chatbg_right.9")
            self.bgView.backgroundColor = UIColor(named: "HeaderColor")
            self.languageButton.isHidden = true
        }
        else {
            self.titleLabel.textColor = UIColor(named: "TitleColor") ?? .white
            self.dateLabel.textColor = UIColor(named: "HeaderColor") ?? .white
            self.chatStackView.removeArrangedSubview(profileView)
            self.chatStackView.insertArrangedSubview(profileView, at: 0)
            self.chatBackgroundImageView.image = #imageLiteral(resourceName: "chatbg_left.9")
            self.wholeStackView.alignment = .leading
            self.bgView.backgroundColor = UIColor(named: "ChatBGColor")
            self.languageButton.isHidden = false
        }
        self.layoutIfNeeded()
    }
    @IBAction func languageButtonAct(_ sender: UIButton) {
        //let trimmedString = chatData.message!.trimmingCharacters(in: .whitespacesAndNewlines)
        /*
        let targetLanguage = SwiftGoogleTranslate.shared.selectdLanguage.language

        print("ChatTranslationTabbed")
        if targetLanguage.lowercased() != "none" {
            SwiftGoogleTranslate.shared.translate(msg: self.titleLabel.text ?? "", callback: { translatedTxt in
                DispatchQueue.main.async {
                    print("instanttranslatedtext \(translatedTxt)")
                    self.titleLabel.text = translatedTxt
                    self.refreshChat!()
                }
            })
        }
 */
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
