//
//  DateCollectionViewCell.swift
//  TimeView
//
//  Created by Hitasoft on 26/02/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookedView: UIView!
    @IBOutlet weak var imageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var calenderImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    var type: CellType! = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.bookedView.cornerViewRadius()
        self.bookedView.backgroundColor = UIColor(named: "AppColor")
        self.calenderImageView.isHidden = true
        self.dateLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .center, text: "")
        self.bookedView.isHidden = true
    }
    func configTimeCell() {
        if type.contains(.Selected) {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.backgroundColor = (UIColor(named: "AppColor") ?? .white).cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "White") ?? .white
            dateLabel.layer.cornerRadius = 0
        }
        else {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.backgroundColor = (UIColor(named: "White") ?? .white).cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "TitleColor") ?? .white
        }
    }
    func configureCell() {
        self.bookedView.isHidden = false
         if type.contains(.Selected)  {
            dateLabel.layer.cornerRadius = 0
             if bookedView.backgroundColor == UIColor(named: "AppColor"){
                 dateLabel.layer.borderColor = (UIColor(named: "AppColor") ?? .white).cgColor
                 dateLabel.layer.backgroundColor = (UIColor(named: "AppColor") ?? .white).cgColor
             }else{
                 dateLabel.layer.borderColor = (UIColor(named: "AppColor") ?? .white).cgColor
                 dateLabel.layer.backgroundColor = (UIColor(named: "AppColor") ?? .white).cgColor
             }
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "White") ?? .white
            dateLabel.layer.cornerRadius = 3
            self.bookedView.isHidden = true
        }
        else if type.contains(.Disabled)  {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = (UIColor(named: "fifth_text") ?? .white).cgColor
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = (UIColor(named: "fifth_text") ?? .white).cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "TitleColor") ?? .white
            dateLabel.layer.cornerRadius = 3
            self.bookedView.isHidden = true
        }
        else if type.contains(.Booked) {
            self.bookedView.isHidden = false
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "TitleColor") ?? .white
            self.bookedView.backgroundColor = UIColor(named: "AppColor")
        }
        else if type.contains(.PastDate) || type.contains(.leaveDate){
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "fifth_text") ?? .white
            self.bookedView.isHidden = true
        }
        else if type.contains(.Today) {
            dateLabel.layer.cornerRadius = 3
            dateLabel.layer.borderColor = (UIColor(named: "fifth_text") ?? .white).cgColor
            dateLabel.layer.borderWidth = 1
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "TitleColor") ?? .white
            
        }
        else {
            dateLabel.layer.cornerRadius = 0
            dateLabel.layer.borderColor = UIColor.clear.cgColor
            dateLabel.layer.borderWidth = 0
            dateLabel.layer.backgroundColor = UIColor.clear.cgColor
            dateLabel.layer.mask = nil
            dateLabel.textColor = UIColor(named: "TitleColor") ?? .white
            //aj changed
            self.bookedView.isHidden = true
//            self.bookedView.backgroundColor = UIColor(named: "AppColor")
            
        }
        
        
        //        if type.contains(.Highlighted) {
        //            shadowView.backgroundColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 0.6)
        //            shadowView.layer.cornerRadius = frame.size.width / 2
        //        } else {
        ////            shadowView.backgroundColor = UIColor.clear
        //        }
    }
}
struct CellType: OptionSet {
    let rawValue: Int
    static let Date = CellType(rawValue: 1 << 0)                    // has number
    static let Empty = CellType(rawValue: 1 << 1)                   // has no number
    static let PastDate = CellType(rawValue: 1 << 2)                // disabled
    static let Today = CellType(rawValue: 1 << 3)                   // has circle
    static let Selected = CellType(rawValue: 1 << 4)                // has filled circle
    static let Booked = CellType(rawValue: 1 << 5)                // has filled circle
    static let Disabled = CellType(rawValue: 1 << 6)                // has filled circle
    static let leaveDate = CellType(rawValue: 1 << 7)                // disabled

}
