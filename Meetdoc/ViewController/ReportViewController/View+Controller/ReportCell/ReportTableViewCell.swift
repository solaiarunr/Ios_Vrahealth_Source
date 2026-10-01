//
//  ReportTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 16/03/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.checkBoxButton.isUserInteractionEnabled = false
        self.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "")
        self.checkBoxButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
        self.checkBoxButton.tintColor = UIColor(named: "TitleColor") ?? .white
    }
    func loadData(_ reportData: ReportResultModel) {
        self.titleLabel.text = reportData.reportName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
