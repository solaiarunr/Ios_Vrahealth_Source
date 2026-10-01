//
//  ExploreFooterCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ExploreFooterCollectionViewCell: UICollectionReusableView {

    @IBOutlet weak var showAllButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customUI()
        // Initialization code
    }
    func customUI() {
        self.showAllButton.config(color: UIColor(named: "AppColor") ?? .white, font: headerFont, align: .center, title: "show_all")
        self.showAllButton.setBorder(UIColor(named: "HeaderColor") ?? .white)
    }
    func loadData(_ count: String) {
        let str = Utility().language().value(forKey: "show_all") as? String ?? ""
        self.showAllButton.setTitle("\(str) (\(count))", for: .normal)
    }
}
