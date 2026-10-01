//
//  DashboardCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 14/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dashboardLabel: UILabel!
    @IBOutlet weak var dashboardImageView: UIImageView!
 //   var imageArray = [#imageLiteral(resourceName: "message1"), #imageLiteral(resourceName: "review"), #imageLiteral(resourceName: "booking"), #imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "message-verifi"), #imageLiteral(resourceName: "mobile-verifi")]
    var imageArray = [UIImage]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        
        // Initialization code
    }

    func configUI() {
        if UserDefaultModule.shared.getLoginData().type == "doctor"{
            self.imageArray = [#imageLiteral(resourceName: "message1"), #imageLiteral(resourceName: "dollar"), #imageLiteral(resourceName: "booking"), #imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "add_friend")]
        }else{
            self.imageArray = [#imageLiteral(resourceName: "message1"), #imageLiteral(resourceName: "review"), #imageLiteral(resourceName: "booking"), #imageLiteral(resourceName: "notification"),#imageLiteral(resourceName: "add_friend"), #imageLiteral(resourceName: "mydoctor")]
        }
        self.shadowView.layer.cornerRadius = 5
        self.shadowView.elevationEffect()
        self.dashboardImageView.layer.cornerRadius = 5
        self.dashboardImageView.clipsToBounds = true
        self.dashboardLabel.config(color: UIColor(named: "TitleColor"), font: regular14, align: .center, text: "")
    }
    func loadData(_ index: IndexPath) {
        self.dashboardImageView.image = imageArray[index.row] as! UIImage
    }
    override func layoutIfNeeded() {
        self.shadowView.elevationEffect()
    }
}
