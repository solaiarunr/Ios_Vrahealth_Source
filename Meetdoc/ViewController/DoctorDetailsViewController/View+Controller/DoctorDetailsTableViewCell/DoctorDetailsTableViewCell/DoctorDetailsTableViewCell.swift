//
//  DoctorDetailsTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol imageDelegate {
    func selectImageAct(_ selectedIndex: Int)
}

class DoctorDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectiionViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: imageDelegate?
    
    var detailsData = [String]()
    var isImageModel = false
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.shadowView.elevationEffect()
    }
    func configUI() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DoctorDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DoctorDetailsCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ImageUploadCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageUploadCollectionCell")
        self.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    func loadData(_ doctorData: DoctorResultModel, index: Int, title: [String]) {
        self.isImageModel  = false
        self.index = index
        if title[index] == "insurance_plan" {
            self.detailsData = doctorData.insurancelist.map({"\($0.name ?? "0")"})
        }
        else if title[index] == "specialities" {
            self.detailsData = doctorData.speciality.map({"\($0.name ?? "0")"})
        }
        else if title[index] == "gender" {
            self.detailsData = [doctorData.gender]
        }
        else if title[index] == "languages" {
            self.detailsData = doctorData.languages
        }
        else if title[index] == "qualification" {
            self.detailsData = [doctorData.qualification]
        }
        else if title[index] == "new_Institute" {
            self.detailsData = [doctorData.Institute]
        }
        else if title[index] == "new_register_number" {
            self.detailsData = [doctorData.registerNumber]
        }
        else if title[index] == "photos" {
            self.shadowView.layer.borderColor = UIColor.clear.cgColor
            self.isImageModel  = true
            self.detailsData = doctorData.portfolioImages.map({"\($0.image ?? "0")"})
        }
        self.layoutIfNeeded()
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
    
    func loadHospitalData(_ hospitalData: HospitalResultDetailsModel, index: Int) {
        self.isImageModel  = false
        if index == 2 {
            self.detailsData = hospitalData.insurance.map({"\($0.name ?? "0")"})
        }
        else if index == 3 {
            self.detailsData = hospitalData.speciality.map({"\($0.name ?? "0")"})
        }
        self.layoutIfNeeded()
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension DoctorDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isImageModel {
            if detailsData.count > 4 {
                return 4
            }
            return self.detailsData.count
        }
        return detailsData.count
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.collectionView.layoutIfNeeded()
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        if isImageModel {
            return CGSize(width: (self.collectionView.frame.width/4)+40, height: (self.collectionView.frame.width/4)+40)
        }
        else {
            return CGSize(width: contentSize.width+40, height: contentSize.height + 40) // 20 is the margin of the collectinview with top and bottom
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isImageModel {
            return CGSize(width: self.collectionView.frame.width/4, height: self.collectionView.frame.width/4)
        }
        else {
            var height = CGFloat(30)
            var width = (self.collectionView.frame.width/2-10)
            if index == 4 || index == 5 || index == 7 || index == 8 {
                width = self.collectionView.frame.width
            }
            height = self.getHeight(width, text: (getLanguage[detailsData[indexPath.row]] ?? detailsData[indexPath.row]))
            return CGSize(width: width, height: height)
        }
    }
    func getHeight(_ width: CGFloat, text: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !isImageModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorDetailsCollectionViewCell", for: indexPath) as! DoctorDetailsCollectionViewCell
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.text = getLanguage[detailsData[indexPath.row]] ?? detailsData[indexPath.row]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUploadCollectionCell", for: indexPath) as! ImageUploadCollectionCell
            cell.closeBtn.isHidden = true
            if indexPath.row == 3 && self.detailsData.count > 3 {
                cell.imageViewUpload.isHidden = true
                cell.countLabel.isHidden = false
                cell.countLabel.text = "\(self.detailsData.count - 3)+ \(getLanguage["more_photos"] ?? "more_photos")"
            }
            else {
                cell.countLabel.isHidden = true
                cell.imageViewUpload.isHidden = false
                  if !detailsData[indexPath.row].contains(webURL) {
                    cell.imageViewUpload.sd_setImage(with: URL(string: "\(webURL)\(self.detailsData[indexPath.row])")) { (image, error, cache, url) in
                        if error != nil {
                            cell.imageViewUpload.image = #imageLiteral(resourceName: "sheeticon")
                        }
                    }
                }
                else {
                    cell.imageViewUpload.sd_setImage(with: URL(string: self.detailsData[indexPath.row])) { (image, error, cache, url) in
                        if error != nil {
                            cell.imageViewUpload.image = #imageLiteral(resourceName: "sheeticon")
                        }
                    }
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isImageModel {
            delegate?.selectImageAct(indexPath.item == 3 ? 0 : indexPath.item)
        }
    }
}

