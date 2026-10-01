//
//  FullImageViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    var selectedIndex = 0
    var imageModel = [ImageResultModel]()
    var isFromCertificate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicatorView)
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: getLanguage["photos"] ?? "photos", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.collectionView.register(UINib(nibName: "ImageUploadCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageUploadCollectionCell")
        Utility.shared.startAnimation(viewController: self)
        if self.imageModel.count > selectedIndex {
            var img_url = (self.imageModel[selectedIndex].image ?? "")
            if !(img_url.contains("http")) {
                img_url = "\(webURL)\(img_url)"
            }
            self.profileImageView.sd_setImage(with: URL(string: img_url)) { (image, error, cache, url) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
        else if self.imageModel.count > 0 {
            var img_url = (self.imageModel[0].image ?? "")
            if !(img_url.contains("http")) {
                img_url = "\(webURL)\(img_url)"
            }
            self.profileImageView.sd_setImage(with: URL(string: img_url)) { (image, error, cache, url) in
                Utility.shared.stopAnimation(viewController: self)
            }
        }
        if isFromCertificate {
            self.collectionView.isHidden = true
        }
        self.profileImageView.contentMode = .scaleAspectFit
    }
    @objc func barButtonAction(_ notification: Notification) {
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension FullImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFromCertificate ? 0 : self.imageModel.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.height, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageUploadCollectionCell", for: indexPath) as! ImageUploadCollectionCell
        if !isFromCertificate {
            cell.imageViewUpload.sd_setImage(with: URL(string: (self.imageModel[indexPath.row].image ?? "")), completed: nil)
            cell.imageViewUpload.contentMode = .scaleAspectFill
        }
        cell.closeBtn.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Utility.shared.startAnimation(viewController: self)
        self.profileImageView.sd_setImage(with: URL(string: (self.imageModel[indexPath.item].image ?? ""))) { (image, error, cache, url) in
            Utility.shared.stopAnimation(viewController: self)
        }
    }

}
