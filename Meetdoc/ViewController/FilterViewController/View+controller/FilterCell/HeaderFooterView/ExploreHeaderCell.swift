//
//  ExploreHeaderCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 27/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ExploreHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.searchButton.setImage(#imageLiteral(resourceName: "left_arrow"), for: .normal)
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            searchButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        self.searchButton.tintColor = UIColor(named: "primary_text") ?? .white
        self.locationButton.config(color: UIColor(named: "primary_text") ?? .white, font: regularFont, align: .leading, title: "search")
        self.shadowForView()
    }
    func shadowForView() {
        shadowView.layer.cornerRadius = 3
        shadowView.layer.shadowColor = (UIColor(named: "fifth_text") ?? .white).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.3
    }
}
