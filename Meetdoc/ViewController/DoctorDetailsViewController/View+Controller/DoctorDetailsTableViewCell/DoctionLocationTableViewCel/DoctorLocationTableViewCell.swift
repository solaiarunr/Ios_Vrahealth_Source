//
//  DoctorLocationTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    var getLat = String()
    var getLon = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.locationImageView.cornerViewMiniumRadius()
        self.hospitalNameLabel.config(color: UIColor(named: "TitleColor"), font: largeFont, align: .left, text: "")
        self.locationLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.directionLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "get_direction")
        let attributedString = NSMutableAttributedString.init(string: getLanguage["get_direction"] ?? "get_direction")
        
        // Add Underline Style Attribute.
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: (UIColor(named: "AppColor") ?? .white), NSAttributedString.Key.underlineColor: (UIColor(named: "AppColor") ?? .white),], range: NSRange.init(location: 0, length: attributedString.length))
        self.directionLabel.attributedText = attributedString
    }
    func loadData(_ doctorData: DoctorResultModel) {
        self.hospitalNameLabel.text = doctorData.hospitalName
        self.locationLabel.text = doctorData.location
                    let url = "https://maps.googleapis.com/maps/api/staticmap?center=" + "\(doctorData.latitude ?? "0"),\(doctorData.longitude ?? "0")" + "&zoom=16&size=200x200&maptype=roadmap&key=" + GOOGLE_API_KEY
        self.locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "placeholder"))

    }
    func loadHospitalData(_ hospitalData: HospitalResultDetailsModel, index: Int) {
        self.hospitalNameLabel.text = hospitalData.hospitalName
        self.locationLabel.text = hospitalData.location[index].location
        let url = "https://maps.googleapis.com/maps/api/staticmap?center=" + "\(hospitalData.location[index].latitude ?? "0"),\(hospitalData.location[index].longitude ?? "0")" + "&zoom=16&size=200x200&maptype=roadmap&key=" + GOOGLE_API_KEY
        self.locationImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
