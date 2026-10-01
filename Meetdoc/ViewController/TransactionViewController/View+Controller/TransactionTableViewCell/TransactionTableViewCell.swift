//
//  TransactionTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/11/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bookingTypeLabel: UILabel!
    @IBOutlet weak var transactionHistoryLabel: UILabel!
    @IBOutlet weak var userDetailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.shadowView.cornerViewMiniumRadius()
        self.dateLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular16, align: .left, text: "")
        self.priceLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular16, align: .right, text: "")
        self.userDetailsLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.transactionHistoryLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular16, align: .left, text: "")
        self.bookingTypeLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "")
        self.dateLabel.text = "HHHH"
    }
    func loadData(_ transactionData: TransactionResultModel) {
        self.userDetailsLabel.text = transactionData.guestName
        self.dateLabel.text = "\(Utility().timeStampWithDateFormat(timeStamp: "\(transactionData.orderedDate ?? 0)", dateFormat: "MMM dd, yyyy"))"
        self.transactionHistoryLabel.text = transactionData.transactionId
        self.bookingTypeLabel.text = transactionData.listName
        self.priceLabel.text = "\(transactionData.currency ?? "") \(transactionData.doctor_fees ?? "0")"
    }
    override func layoutSubviews() {
        self.shadowView.elevationEffect()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
