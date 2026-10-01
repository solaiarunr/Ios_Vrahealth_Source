//
//  HolidayCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class HolidayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var holidayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI () {
        self.holidayLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, text: "")
        self.holidayLabel.setBorder((UIColor(named: "BorderColor") ?? .white))
        self.holidayLabel.cornerViewMiniumRadius()
    }

}
