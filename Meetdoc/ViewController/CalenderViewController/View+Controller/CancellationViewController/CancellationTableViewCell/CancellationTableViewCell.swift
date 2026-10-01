//
//  CancellationTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class CancellationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.titleLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.descLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.selectButton.isUserInteractionEnabled = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
