//
//  DoctorHeaderTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorHeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentLabel.isHidden = true
        self.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "")
        self.contentLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")

        // Initialization code
    }
    
}
