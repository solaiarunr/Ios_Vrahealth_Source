//
//  DoctorDetailsCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorDetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        // Initialization code
    }
    

}
