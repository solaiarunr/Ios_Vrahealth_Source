//
//  StripeProofHeaderTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 10/04/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class StripeProofHeaderTableViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var proofTitleLabel: UILabel!
    @IBOutlet weak var proofDescLabel: UILabel!
    @IBOutlet weak var proofDetailLabel: UILabel!
    @IBOutlet weak var proofTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func loadData(index: Int) {
        self.proofDescLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "host_document_desc")
        self.proofDetailLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "size_type_format")
        if index == 0 {
            self.proofTitleLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: tableHeaderFont, align: .left, text: "host_identity_document")
            self.proofTypeLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: regular14, align: .left, text: "identity_color_scan")
        }
        else {
            self.proofTitleLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: tableHeaderFont, align: .left, text: "host_address_document")
            self.proofTypeLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "address_color_scan")

        }
    }
}
