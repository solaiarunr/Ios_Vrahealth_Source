//
//  DatePickerHeaderCell.swift
//  AirFinch_Swift
//
//  Created by Hitasoft on 26/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DatePickerHeaderCell: UICollectionReusableView {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var startEndDateStackView: UIStackView!
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet var weekDayCollectionLabel: [UILabel]!
    var DayArray = ["SUN","MON","TUE","WED","THU","FRI","SAT"]

    override func awakeFromNib() {
        self.configUI()
    }
    func configUI() {
        self.titleButton.config(color: UIColor(named: "primary_text") ?? .white, font: fontRegular18, align: .center, title: "")
        self.titleButton.setTitle("March 2020", for: .normal)
        self.previousButton.tintColor = UIColor(named: "primary_text") ?? .white
        self.nextButton.tintColor = UIColor(named: "primary_text") ?? .white
        self.DayArray = Utility().language().value(forKey: "weekdays") as! Array

        for lbl in weekDayCollectionLabel {
            lbl.config(color: UIColor(named: "fifth_text") ?? .white, font: fontRegular12, align: .center, text: "")
            if DayArray.count > lbl.tag {
                lbl.text = DayArray[lbl.tag]
            }

        }
    }
}
