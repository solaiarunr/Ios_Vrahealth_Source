//
//  BookingTimeCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class BookingTimeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.timeLabel.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, text: "")
        self.timeLabel.cornerViewMiniumRadius()
        self.timeLabel.setBorder(UIColor(named: "AppColor") ?? .white)
    }

}
