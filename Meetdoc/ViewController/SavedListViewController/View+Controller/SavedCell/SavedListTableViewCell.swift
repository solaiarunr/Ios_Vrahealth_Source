//
//  SavedListTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import Cosmos

class SavedListTableViewCell: UITableViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var viewAvailablityLabel: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var useNAmeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var instituteNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    override func layoutIfNeeded() {
        self.shadowView.elevationEffect()
    }
    func configUI() {
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.cornerViewRadius()
        self.useNAmeLabel.config(color: UIColor(named: "TitleColor"), font: fontsemi16, align: .left, text: "")
        self.specialityLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.ratingLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.instituteNameLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.viewAvailablityLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, title: "view_all_availability")
        self.profileLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "profile")
        shadowView.layer.cornerRadius = 5
        self.videoButton.cornerRoundRadius()
    }
    func loadData(_ wishList: WhishedList) {
      self.profileImageView.sd_setImage(with: URL(string: wishList.doctorImage), placeholderImage:#imageLiteral(resourceName: "doctorProfile"))
            self.useNAmeLabel.text = "Dr.\(wishList.doctorName ?? "")"
//        self.specialityLabel.text = wishList.speciality.joined(separator: ", ")
        self.specialityLabel.text = wishList.doctor_qualification ?? ""
        self.instituteNameLabel.text = wishList.institute_name ?? ""
//        self.locationLabel.text = wishList.doctor_location ?? ""
        let str = wishList.languages.joined(separator: ",")
        self.locationLabel.text = str
        let totalReviewCount = (Int(wishList.totalReview ?? "0") ?? 0)
        if totalReviewCount > 0 {
            self.ratingView.rating = (Double(wishList.averageRating ?? "0") ?? 0)
            self.ratingLabel.text = "\(totalReviewCount)"
        }
        else {
            self.ratingLabel.text = "0"
            self.ratingView.rating = Double(0)
        }
        if "\(wishList.doctorId ?? "0")" == (UserDefaultModule().getCurrentUserID() as? String ?? "") {
            self.likeButton.isHidden = true
        }
        else {
            // Updated Liked Status
            self.likeButton.isHidden = false
            if !wishList.isliked {
                self.likeButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            }
            else {
                self.likeButton.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
            }
        }
        self.videoButton.isHidden = !wishList.isVideovisit
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
