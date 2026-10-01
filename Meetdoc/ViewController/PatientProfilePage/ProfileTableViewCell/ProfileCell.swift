//
//  ProfileCell.swift
//  Meetdoc
//
//  Created by Arun Andiselvam on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var listName: UILabel!
     @IBOutlet weak var nextIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellWithDetails(list_name:String)
    {
        listName.text = Utility().language().value(forKey: list_name) as? String ?? ""
        listName.font = regularFont
        listName.textColor = UIColor(named: "TitleColor") ?? .white
        
    }
    
}
