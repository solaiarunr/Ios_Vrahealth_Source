//
//  SelectionTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 15/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.titleLabel.config(color: UIColor(named: "TitleColor"), font: fontRegular16, align: .left, text: "")
        self.selectButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
