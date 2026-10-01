//
//  HospitalDetailsTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class HospitalDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.hospitalImageView.cornerViewRadius()
        self.hospitalImageView.contentMode = .scaleAspectFill
        self.hospitalNameLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
     }
    func loadData(_ hospitalData: HospitalResultDetailsModel) {
        if !hospitalData.image.contains(webURL) {
             self.hospitalImageView.sd_setImage(with: URL(string: "\(webURL)\(hospitalData.image ?? "")")) { (image, error, cache, url) in
                if error != nil {
                    self.hospitalImageView.image = #imageLiteral(resourceName: "sheeticon")
                }
            }
        }
        else {
            self.hospitalImageView.sd_setImage(with: URL(string: hospitalData.image)) { (image, error, cache, url) in
                if error != nil {
                    self.hospitalImageView.image = #imageLiteral(resourceName: "sheeticon")
                }
            }
        }
        self.hospitalNameLabel.text = hospitalData.hospitalName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
