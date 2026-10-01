//
//  ExploreHeaderCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ExploreHeaderCollectionViewCell: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showAllBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "")
        self.showAllBtn.config(color: UIColor(named: "AppColor"), font: fontRegular16, align: .center, title: "show_all")
        // Initialization code
    }
    func loadData(_ specialities: SpecialityModel) {
        self.titleLabel.text = specialities.specialityName
    }
}
