 //
 //  ProfileFirstCell.swift
 //  Meetdoc
 //
 //  Created by BTMani on 26/05/18.
 //  Copyright © 2018 BTMani. All rights reserved.
 //

 import UIKit
 import SDWebImage
 class ProfileFirstCell: UITableViewCell {

     @IBOutlet weak var userImageView: UIImageView!
     @IBOutlet weak var usernameLabel: UILabel!
 //    @IBOutlet weak var lineView: UIView!

     @IBOutlet weak var viewButton: UIButton!
     @IBOutlet weak var viewandeditLbl: UILabel!
     override func awakeFromNib() {
         super.awakeFromNib()
         var loginData = [UserLoginResultModel]()
         loginData = [UserDefaultModule.shared.getLoginData()]
          self.usernameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: tableHeaderFont, align: .left, text: "firstname")
          let fristNameStr : String = loginData.first?.firstName ?? ""
         let lastName : String = loginData.first?.lastName ?? ""
         self.usernameLabel.text = "\(fristNameStr) \(lastName)"
          self.userImageView.contentMode = .scaleAspectFill
          self.userImageView.sd_setImage(with: URL(string: loginData.first?.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "placeholder"))
          userImageView.cornerViewRadius()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
     
     func configureCellWithDetails(userDict:NSDictionary)  {

         usernameLabel.text = "HTS"
         viewandeditLbl.text = "View and Edit"
         userImageView.backgroundColor = UIColor.red
          self.settingFontAndColor()
     }
     
     func settingFontAndColor()
     {
 //       lineView.backgroundColor = lineColor
         usernameLabel.font = largeFont
         viewandeditLbl.font = smallFont
         usernameLabel.textColor = UIColor(named: "primary_text") ?? .white
         viewandeditLbl.textColor = UIColor(named: "SubTitleColor") ?? .white
     }
   }

