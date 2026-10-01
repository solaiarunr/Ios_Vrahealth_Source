//
//  BannerCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.customUI()
        // Initialization code
    }
    func customUI() {
        self.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi25, align: .left, text: "")
        self.descLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "")
    }
    func loadData(_ banner: Speciality) {
        self.titleLabel.text = banner.specialityName
        self.descLabel.text = banner.totalListcount
    }

}
