//
//  StripeCountryCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class StripeCountryCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countryLabel.config(color: UIColor(named: "secondary_text") ?? .white, font: fontRegular16, align: .left, text: "country")

        // Initialization code
    }
    
    func configUI(countryList: StripeCountry?) {
        self.countryLabel.text = (countryList?.countryName ?? "") + " (\(countryList?.currencyCode ?? ""))"
        if self.selectButton.tag == 0 {
             self.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            self.selectButton.tintColor = UIColor(named: "TitleColor")
        }
        else {
            self.selectButton.setImage(#imageLiteral(resourceName: "accent_check_box"), for: .normal)
            self.selectButton.tintColor = UIColor(named: "AppColor")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
