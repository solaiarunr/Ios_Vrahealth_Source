//
//  PrescriptionTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class PrescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var prescriptionImageView: UIImageView!
    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var componentLabel: UILabel!
    @IBOutlet weak var drugStrenthTitleLabel: UILabel!
    @IBOutlet weak var drugStrenthLabel: UILabel!
    @IBOutlet weak var frequencyTitleLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var durationTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var routeTitleLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var directionTitleLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var instructionsTitleLabel: UILabel!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.componentTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "component_name")
        self.componentLabel.config(color: UIColor(named: "AppColor"), font: regular14, align: .left, text: "")
        self.drugStrenthTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "drug_strength")
        self.drugStrenthLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.frequencyTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "frequency")
        self.frequencyLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.durationTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "duration")
        self.durationLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.routeTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "route")
        self.routeLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.directionTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "direction")
        self.directionLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .left, text: "")
        self.instructionsTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "instructions")
        self.instructionLabel.config(color: UIColor(named: "BlackColor"), font: regular14, align: .left, text: "")
        self.instructionView.cornerViewMiniumRadius()
    }
    func loadData(_ prescriptionData: PrescriptionResultModel) {
        self.componentLabel.text = prescriptionData.medicineName
        self.drugStrenthLabel.text = prescriptionData.drugStrength
        self.frequencyLabel.text = getLanguage[prescriptionData.frequency.lowercased()] ?? prescriptionData.frequency
        self.durationLabel.text = prescriptionData.duration
        self.routeLabel.text = prescriptionData.route
        var localizeArray = [String]()
        for val in prescriptionData.direction {
            localizeArray.append(getLanguage[val.lowercased()] ?? val)
        }
        self.directionLabel.text = localizeArray.joined(separator: ", ")
        self.instructionLabel.text = prescriptionData.instruction
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
