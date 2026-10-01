//
//  FilterDetailsTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class FilterDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var likeButton: UIButton!
     @IBOutlet weak var ratingCountLabel: UILabel!
     @IBOutlet weak var totalReviewView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
     @IBOutlet weak var DescLabel: UILabel!
    @IBOutlet weak var ListTitleLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ListTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .left, text: "reviews")
        self.DescLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: UIFont(name: boldFontName, size: 13), align: .left, text: "reviews")
         self.ratingCountLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .left, text: "reviews")
        
        self.listImageView.layer.cornerRadius = 5
        self.listImageView.clipsToBounds = true
        self.listImageView.contentMode = .scaleAspectFill
       
        self.outerView.layer.cornerRadius = 5
        self.outerView.layer.borderWidth = 2
        self.outerView.layer.borderColor = UIColor.lightGray.cgColor
          // Initialization code
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        bounds = bounds.inset(by: padding)
//    }
    func loadRecentData(_ result: ExploreListing) {
        let roomType = result.roomType + " · " + "\(result.beds ?? 0)" + " "
        self.ListTitleLabel.text = roomType + (Utility().language().value(forKey: "beds") as? String ?? "").capitalized
         self.DescLabel.text = result.listName
        let totalReviewCount = Int(result.totalReviews ?? 0)
        if totalReviewCount > 0 {
            self.totalReviewView.isHidden = false
            self.ratingView.rating = Double(result.averageRating ?? 0)
            self.ratingCountLabel.text = "\(totalReviewCount)"
        }
        else {
            self.totalReviewView.isHidden = true
        }
        
        // Load Image
        if result.listPhotos.count > 0 {
            let imageName : String = result.listPhotos.first?.imageUrl ?? ""
            self.listImageView.sd_setImage(with: URL(string: imageName), placeholderImage:#imageLiteral(resourceName: "placeholder"))
        }
        if "\(result.hostId ?? 0)" == (UserDefaultModule().getCurrentUserID() as? String ?? "") {
            self.likeButton.isHidden = true
        }
        else {
            self.likeButton.isHidden = false
            if result.liked == "no" {
                self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            }
            else {
                self.likeButton.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
            }
        }
    }
    
    func loadWishedList(_ wishedData: WhishedList) {
        self.likeButton.isHidden = true
        self.DescLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "reviews")
 
        self.ListTitleLabel.isHidden = true
        self.totalReviewView.isHidden = true
         self.DescLabel.text = "Dr.\(wishedData.doctorName ?? "")"
      //  self.priceLabel.text = "\(wishedData.listingCount ?? 0) " + (Utility().language().value(forKey: "listings") as? String ?? "listings")
        self.listImageView.sd_setImage(with: URL(string: wishedData.doctorImage ?? ""), placeholderImage:#imageLiteral(resourceName: "placeholder"))
        self.totalReviewView.isHidden = false
        self.ratingView.isHidden = true
        self.ratingCountLabel.text = ""
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
