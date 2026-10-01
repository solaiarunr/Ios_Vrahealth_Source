//
//  DetailsTableViewCell.swift
//  Meetdoc
//
//  Created by HTS-49 on 18/07/22.
//  Copyright © 2022 BTMani. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var PatientIcon: UIImageView!
    @IBOutlet weak var DCIcon: UIImageView!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var PatientNameLbl: UILabel!
    @IBOutlet weak var DCNameLbl: UILabel!
    @IBOutlet weak var ViewButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    let FULL_WIDTH = UIScreen.main.bounds.width
    let FULL_HEIGHT = UIScreen.main.bounds.height
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configUI(){
        self.clockIcon.image = UIImage(named: "clock")
//        self.PatientIcon.image = UIImage(named: "tab_user_profile1")
//        self.DCIcon.image = UIImage(named: "profile_host")
        self.ViewButton.config(color: UIColor(named: "AppColor"), font: regular14, align: .right, title: "view")
        self.TimeLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "10.20 AM")
        self.PatientNameLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "Maarimuthu")
        self.DCNameLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "Apollo")
        self.codeLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "-")
        self.endTimeLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "10.20 AM")
        self.statusLbl.config(color: UIColor(named: "BlackColor"), font: regular14, align: .center, text: "")
    }
    
}
