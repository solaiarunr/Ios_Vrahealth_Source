//
//  PopularListCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
//import GooglePlacePicker

class PopularListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customUI()
        // Initialization code
    }
    func customUI() {
        self.listImageView.contentMode = .scaleAspectFill
        self.locationLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: fontRegular12, align: .left, text: "reviews")
        self.listImageView.layer.cornerRadius = 2
        self.listImageView.clipsToBounds = true

    }
    func loadData(_ result: PopularDestination) {
        self.listImageView.sd_setImage(with: URL(string: result.image), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        self.locationLabel.text = result.countryName
        self.heightConst.constant = 200
    }
    func loadSearchData(_ result: String) {
        self.locationLabel.text = result
        self.reverseGeoCoding(location: result)
        self.heightConst.constant = 100
    }
    func reverseGeoCoding(location: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let _ = placemarks.first?.location
            else {
                // handle no location found
                return
            }
            let url = "https://maps.googleapis.com/maps/api/staticmap?center=" + "\(placemarks.first?.location?.coordinate.latitude ?? 0),\(placemarks.first?.location?.coordinate.longitude ?? 0)" + "&zoom=16&size=200x200&maptype=roadmap&key=" + GOOGLE_API_KEY
            self.listImageView.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
    }
}
