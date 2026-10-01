//
//  PopularCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 13/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
protocol popularDestinationDelegate:class {
    func cellTaped(_ indexPath:IndexPath)
}
class PopularCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var popularcollectionView: UICollectionView!
    weak var delegate:popularDestinationDelegate?
    var destinationArr = [PopularDestination]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customUI()
        // Initialization code
    }
    func customUI() {
        self.popularcollectionView.delegate = self
        self.popularcollectionView.dataSource = self
        self.popularcollectionView.register(UINib(nibName: "PopularListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PopularListCollectionViewCell")
    }
    func loadData(_ result: [PopularDestination]) {
        self.destinationArr = result
        self.popularcollectionView.reloadData()
    }
}
extension PopularCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.destinationArr.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - (3 * 10))/2.1, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularListCollectionViewCell", for: indexPath) as! PopularListCollectionViewCell
        cell.loadData(self.destinationArr[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cellTaped(indexPath)
    }
    
}
