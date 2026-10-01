//
//  ExploreFilterCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ExploreFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customUI()
        // Initialization code
    }
    func customUI() {
        self.dateButton.config(color: UIColor(named: "AppColor") ?? .white, font: regularFont, align: .center, title: "alldates")
        self.dateButton.setBorder(UIColor(named: "boxColor") ?? .white)
        self.filterButton.config(color: UIColor(named: "AppColor") ?? .white, font: regularFont, align: .center, title: "alldates")
        self.filterButton.setBorder(UIColor(named: "boxColor") ?? .white)
        self.filterButton.isHidden = true
    }

}
