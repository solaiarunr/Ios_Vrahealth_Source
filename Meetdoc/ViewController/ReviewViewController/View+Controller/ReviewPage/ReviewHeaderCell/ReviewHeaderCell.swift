 //
 //  ReviewHeaderCell.swift
 //  Meetdoc
 //
 //  Created by Hitasoft on 13/01/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import UIKit
 import Cosmos

 class ReviewHeaderCell: UITableViewHeaderFooterView {

     @IBOutlet weak var ratingView: CosmosView!
     @IBOutlet weak var titleLabel: UILabel!
     override func awakeFromNib() {
         super.awakeFromNib()
         self.contentView.backgroundColor = .white
         self.titleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: boldLargeFont, align: .left, text: "reviews")

         // Initialization code
     }
     func configData(reviewCount: String, RatingValue: Double) {
         let reviewFor = (Utility().language().value(forKey: "reviews") as? String ?? "") + " " + (Utility().language().value(forKey: "for") as? String ?? "")
         let userDetails = UserDefaultModule.shared.getLoginData()
         self.titleLabel.text = "\(reviewCount) \(reviewFor) \(userDetails.firstName) \(userDetails.lastName)"
         self.ratingView.rating = RatingValue
     }
     
 }

