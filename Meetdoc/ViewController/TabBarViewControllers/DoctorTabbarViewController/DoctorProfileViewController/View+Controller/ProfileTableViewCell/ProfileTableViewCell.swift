//
//  ProfileTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var listImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configUI() {
        self.listNameLabel.config(color: UIColor(named: "TitleColor"), font: regularFont, align: .left, text: "")
    }
    func loadData(_ profileData: DoctorProfileModel) {
        self.listNameLabel.text = getLanguage[profileData.title]
        self.listImageView.image = UIImage(named: profileData.image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
