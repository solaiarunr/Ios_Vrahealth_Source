//
//  ImageCollectionCell.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    
    func configUI() {
        self.image.contentMode = .scaleAspectFill
    }
    
    func loadimage(image: UIImage?){
        self.image.image = image
    }

}
