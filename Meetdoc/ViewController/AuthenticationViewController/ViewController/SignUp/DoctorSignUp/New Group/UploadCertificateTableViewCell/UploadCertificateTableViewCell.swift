//
//  UploadCertificateTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class UploadCertificateTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var docNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.docNameLabel.config(color: UIColor(named: "SubTitleColor"), font: fontRegular16, align: .left, text: "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
