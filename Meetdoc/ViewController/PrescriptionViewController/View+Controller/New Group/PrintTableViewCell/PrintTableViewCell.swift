//
//  PrintTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 07/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class PrintTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var componentNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.componentNameLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
        self.strengthLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
        self.frequencyLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
        self.durationLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
        self.routeLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
        self.directionLabel.config(color: UIColor(named: "TitleColor"), font: regularVerySmall, align: .left, text: "")
    }
    func loadData(_ prescriptionData: PrescriptionResultModel, section: Int) {
        if section == 0 {
            self.componentNameLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "medicine")
            self.strengthLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "strength")
            self.frequencyLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "frequency")
            self.durationLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "duration")
            self.routeLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "route")
            self.directionLabel.config(color: UIColor(named: "TitleColor"), font: fontSemi9, align: .left, text: "direction")
        }
        else {
            self.configUI()
            self.componentNameLabel.text = prescriptionData.medicineName
            self.strengthLabel.text = prescriptionData.drugStrength
            self.frequencyLabel.text = getLanguage[prescriptionData.frequency.lowercased()] ?? prescriptionData.frequency
            self.durationLabel.text = prescriptionData.duration
            self.routeLabel.text = prescriptionData.route
            var localizeArray = [String]()
            for val in prescriptionData.direction {
                localizeArray.append(getLanguage[val.lowercased()] ?? val)
            }
            self.directionLabel.text = localizeArray.joined(separator: ", ")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
