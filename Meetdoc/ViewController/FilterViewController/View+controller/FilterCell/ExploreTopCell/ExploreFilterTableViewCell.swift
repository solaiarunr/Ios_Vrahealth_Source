//
//  ExploreFilterTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ExploreFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var bothCheckButton: UIButton!
    @IBOutlet weak var bothStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var maleStackView: UIStackView!
    @IBOutlet weak var maleCheckButton: UIButton!
    @IBOutlet weak var maleTitleButton: UIButton!
    @IBOutlet weak var femaleStackView: UIStackView!
    @IBOutlet weak var femaleCheckButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.titleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.descLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.genderTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "gender")
        self.genderTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "gender")
        self.maleTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, title: "male")
        self.maleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.femaleButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "female")
        self.femaleCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.bothButton.config(color: UIColor(named: "SubTitleColor"), font: regularFont, align: .left, title: "female")
        self.bothCheckButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
