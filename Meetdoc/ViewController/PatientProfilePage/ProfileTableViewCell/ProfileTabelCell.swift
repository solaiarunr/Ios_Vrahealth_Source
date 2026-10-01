//
//  ProfileTabelCell.swift
//  Meetdoc
//
//  Created by BTMani on 26/05/18.
//  Copyright © 2018 BTMani. All rights reserved.
//

import UIKit

class ProfileTabelCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailLabel.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithDetails(list_name:String)
    {
        listName.text = Utility().language().value(forKey: list_name) as? String ?? ""
        listName.font = regular17
        listName.textColor = UIColor(named: "TitleColor") ?? .white
    }

}
