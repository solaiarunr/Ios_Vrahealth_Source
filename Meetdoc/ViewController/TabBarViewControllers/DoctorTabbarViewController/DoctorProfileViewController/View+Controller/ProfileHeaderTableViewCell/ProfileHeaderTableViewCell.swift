 //
 //  ProfileHeaderTableViewCell.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 16/10/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //
 
 import UIKit
 
 class ProfileHeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.profileImageView.cornerViewRadius()
        self.userNameLabel.config(color: UIColor(named: "TitleColor"), font: headerFont, align: .left, text: "")
    }
    func loadUserData() {
        self.profileImageView.sd_setImage(with: URL(string: UserDefaultModule.shared.getLoginData().userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "doctorProfile"))
        self.profileImageView.contentMode = .scaleAspectFill
        self.userNameLabel.text = UserDefaultModule.shared.getLoginData().firstName
    }
    
 }
 
