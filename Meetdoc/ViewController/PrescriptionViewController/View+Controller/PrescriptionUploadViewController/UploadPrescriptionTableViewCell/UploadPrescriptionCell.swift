//
//  UploadPrescriptionCell.swift
//  Meetdoc
//
//  Created by HTS-49 on 01/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class UploadPrescriptionCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var PrescriptionNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.PrescriptionNameLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
