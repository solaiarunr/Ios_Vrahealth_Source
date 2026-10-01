//
//  MedicineCell.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class MedicineCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLbl.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
    }

    
    
}
