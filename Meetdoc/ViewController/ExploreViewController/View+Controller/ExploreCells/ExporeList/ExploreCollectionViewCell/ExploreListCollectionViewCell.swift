//
//  ExploreListCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class ExploreListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var totalReviewView: UIView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var DescLabel: UILabel!
    @IBOutlet weak var ListTitleLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var seperatorView: UILabel!
    @IBOutlet weak var InstituteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ListTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular13, align: .center, text: "reviews")
        self.DescLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .center, text: "reviews")
        self.locationLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .center, text: "reviews")
        self.InstituteLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .center, text: "reviews")
        self.locationLabel.numberOfLines = 2
        self.ratingCountLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .left, text: "")
       // self.seperatorView.backgroundColor = UIColor(named: "shadColor")
        self.seperatorView.backgroundColor =  UIColor(named: "shadColor") ?? .white

        self.listImageView.layer.cornerRadius = 3
        self.listImageView.clipsToBounds = true
        self.listImageView.contentMode = .scaleAspectFill
        self.shadowView.layer.cornerRadius = 5
        self.videoButton.cornerRoundRadius()
        self.shadowView.elevationEffect()
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.shadowView.elevationEffect()
    }
}
extension ExploreListCollectionViewCell {
     func loadRecentData(_ result: DoctorModel, type: String) {
        self.ListTitleLabel.isHidden = false
        self.ListTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular13, align: .center, text: "reviews")
        self.ListTitleLabel.text = "Dr.\(result.doctorName ?? "")"
        self.DescLabel.text = result.doctor_qualification ?? ""
        self.InstituteLabel.text = result.institute_name ?? ""
         let str = result.languages.joined(separator: ",")
//        self.locationLabel.text = result.doctor_location ?? ""
         self.locationLabel.text = str
        let totalReviewCount = (Int(result.totalReview ?? "0") ?? 0)
        if totalReviewCount > 0 {
            self.totalReviewView.isHidden = false
            self.ratingView.rating = (Double(result.averageRating ?? "0") ?? 0)
            self.ratingCountLabel.text = "\(totalReviewCount)"
        }
        else {
            self.ratingCountLabel.text = "0"
            self.ratingView.rating = Double(0)
            self.totalReviewView.isHidden = false
        }
        // Load Image
        self.listImageView.cornerViewRadius()
        self.listImageView.sd_setImage(with: URL(string: result.doctorImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
        if "\(result.doctorId ?? "0")" == (UserDefaultModule().getCurrentUserID() as? String ?? "") {
            self.likeButton.isHidden = true
        }
        else {
            // Updated Liked Status
            self.likeButton.isHidden = false
            if !result.isliked {
                self.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            }
            else {
                self.likeButton.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
            }
        }
        self.videoButton.isHidden = !result.isVideovisit
    }
}
