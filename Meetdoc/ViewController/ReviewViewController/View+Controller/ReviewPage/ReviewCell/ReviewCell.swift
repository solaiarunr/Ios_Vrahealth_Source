//
//  ReviewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 11/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewMessageLabel: UILabel!
    @IBOutlet weak var RatingView: CosmosView!
    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //   self.reviewTitleLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular22, align: .left, text: "reviews")
        self.shadowView.cornerViewMiniumRadius()
        self.reviewerNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontsemi16, align: .left, text: "verify_info")
        self.dateLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "mail_address")
        self.reviewMessageLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular13, align: .left, text: "")
        self.reviewMessageLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: regular14, align: .left, text: "phone_no")
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
            // Initialization code
    }
    override func layoutSubviews() {
        self.shadowView.elevationEffect()
        super.layoutSubviews()
    }
    func loadHostReviewData(_ reviewData: ReviewModel) {
        // UI Changes
        self.reviewerNameLabel.text = reviewData.reviewerName
        let  reviewDate = "\(Utility().unixTimeStamptoDate(timeStamp:String(format:"%f", (Double(reviewData.reviewDate)))))"
        self.dateLabel.text = reviewDate
        
        self.reviewMessageLabel.text = reviewData.userReview
        self.RatingView.rating = Double(reviewData.reviewRating) ?? Double(0)
        self.profileImageView.sd_setImage(with: URL(string: reviewData.reviewerImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
    }
//    func loadData(_ reviewData: ReviewModel, result: viewDetailsResut) {
//        self.reviewerNameLabel.text = reviewData.reviewerName
//        let  reviewDate = "\(Utility().unixTimeStamptoDate(timeStamp:String(format:"%f", (Double(reviewData.reviewDate)))))"
//        self.dateLabel.text = reviewDate
//        let reviewCount = (Utility().language().value(forKey: "read_all") as? String ?? "") + " \(result.totalReviews ?? "") " + " \(Utility().language().value(forKey: "reviews") as? String ?? "")"
//
//        self.reviewMessageLabel.text = reviewData.userReview
//        self.RatingView.rating = Double(result.averageRating) ?? Double(0)
//        let imageName : String = reviewData.reviewerImage
//        self.profileImageView.sd_setImage(with: URL(string: imageName), placeholderImage:#imageLiteral(resourceName: "placeholder"))
//    }
    func configData(_ profileDataDict: NSMutableDictionary) {
        if let reviewData = profileDataDict.value(forKey: "review") as? NSDictionary {
            self.reviewerNameLabel.text = reviewData.value(forKey: "reviewer_name") as? String ?? ""
            var startunixtimeStamp = NSNumber()
            startunixtimeStamp = (reviewData.value(forKey: "review_date") as? NSNumber)!
            let  reviewDate = "\(Utility().unixTimeStamptoDate(timeStamp:String(format:"%f", startunixtimeStamp.doubleValue)))"
            self.dateLabel.text = reviewDate
        let reviewCount = (Utility().language().value(forKey: "read_all") as? String ?? "") + " \(profileDataDict.value(forKey: "total_reviews") as? Int ?? 0)" + " \(Utility().language().value(forKey: "reviews") as? String ?? "")"
            self.reviewMessageLabel.text = reviewData.value(forKey: "user_review") as? String ?? ""
            self.RatingView.rating = (profileDataDict.value(forKey: "average_rating") as? Double ?? Double(0))
            let imageName : String = reviewData.object(forKey: "reviewer_image") as! String
            self.profileImageView.sd_setImage(with: URL(string: imageName), placeholderImage:#imageLiteral(resourceName: "placeholder"))
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
