//
//  ImageUploadCollectionCell.swift
//  Meetdoc
//
//  Created by Arun Andiselvam on 02/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class ImageUploadCollectionCell: UICollectionViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageViewUpload: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countLabel.isHidden = true
        self.countLabel.config(color: UIColor(named: "TitleColor"), font: smallFont, align: .center, text: "")
        self.countLabel.numberOfLines = 0
        self.imageViewUpload.layer.cornerRadius = 5
        // Initialization code
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
    }
    func loadData(_ image: UIImage) {
        self.imageViewUpload.image = image
    }
    func loadFromURL(_ imageString: String) {
        self.imageViewUpload.sd_setImage(with: URL(string: imageString), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
}
