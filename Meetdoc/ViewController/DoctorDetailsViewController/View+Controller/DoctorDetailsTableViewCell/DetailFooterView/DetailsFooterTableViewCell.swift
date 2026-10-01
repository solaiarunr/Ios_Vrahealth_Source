//
//  DetailsFooterTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 02/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DetailsFooterTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var readMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }

    func configUI() {
        self.readMoreButton.config(color: UIColor(named: "AppColor"), font: regular14, align: .left, title: "read_more")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
