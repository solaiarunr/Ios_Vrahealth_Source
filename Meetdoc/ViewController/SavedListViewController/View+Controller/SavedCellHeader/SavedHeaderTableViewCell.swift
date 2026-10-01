//
//  SavedHeaderTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class SavedHeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var exploreButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.exploreButton.config(color: UIColor(named: "AppColor") ?? .white, font: fontRegular16, align: .left, title: "start_exploring")
        self.headerLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "saved")
        self.headerLabel.text = self.headerLabel.text?.capitalized
        self.descLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular16, align: .left, text: "save_desc")
     }
    
}
