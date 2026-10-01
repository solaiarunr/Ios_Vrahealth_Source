//
//  ExploreCollectionViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 12/02/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import GoogleMobileAds

class ExploreCollectionViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!

    var viewModel = ExploreViewModel()
    var searchArr = [locationData]()
    var getSpeciality = NSMutableArray()
    let child = SpinnerViewController()
    var isFound = true
    var offset = 0
    var collectionViewTitle = ["","","recent_searches","recently_viewed","Traverse_world","popular_destinations","featured","home_around_world","invite_friends"]
    var refreshControl = UIRefreshControl()
    var specialitiesArray = [SpecialityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        AppDelegate().loadAdminData()
        AppDelegate().callinit()        //MARK: Zego check
        Utility().startAnimation(viewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setStatusBarBackgroundColors(color: UIColor(named: "AppColor")!)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.configUI()
        self.loadAdminData()
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
    }
    func loadAdminData() {
        DispatchQueue.main.async {
            SettingViewModel().getAdminData(user_id: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            }) { (failure) in
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    /*
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 15.0, *) {
            return .darkContent
        } else {
            return .lightContent
        }
    }
    */
    @objc override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func configUI() {
        self.bannerView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.view.addSubview(indicatorView)
        self.searchButton.setImage(#imageLiteral(resourceName: "searchicon"), for: .normal)
        self.searchButton.tintColor = UIColor(named: "primary_text") ?? .white
        self.locationButton.config(color: UIColor(named: "searchColor") ?? .white, font: regularFont, align: .leading, title: "search")
        self.searchArr = UserDefaultModule.shared.getLocationSearch()
        self.shadowForView()
        self.collectionView.register(UINib(nibName: "ExploreListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreListCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ExploreFooterCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ExploreFooterCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ExploreHeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ExploreHeaderCollectionViewCell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
        self.refreshControl.endRefreshing()
        self.shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        self.shadowView.layer.shadowOpacity = 1
        self.shadowView.layer.shadowOffset = CGSize.zero
        self.shadowView.layer.shadowRadius = 2
//        self.loadAddOns()
        self.loadData()
    }
    @objc func refresh(_ sender:AnyObject) {
        self.isFound = true
        self.offset = 0
        self.loadData()
    }
    
    func shadowForView() {
        shadowView.layer.cornerRadius = self.shadowView.frame.height/2
    }
    
    func loadData() {
        self.viewModel.getHomeData(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? "1"), offset: "\(offset)", limit: "20", onSuccess: { (success) in
            print(success)
            if self.viewModel.exploreData?.status ?? false {
                if self.offset == 0 {
                    self.specialitiesArray.removeAll()
                }
                if (self.viewModel.exploreData?.specialities.count ?? 0) > 0 {
                    for spz in (self.viewModel.exploreData?.specialities ?? [SpecialityModel]()) {
                        if !(self.specialitiesArray.contains(where: {$0.specialityId == spz.specialityId})) {
                            self.specialitiesArray.append(spz)
                        }
                    }
                    // self.specialitiesArray += self.viewModel.exploreData?.specialities ?? [SpecialityModel]()

                }
                else {
                    self.isFound = false
                }
            }
            else {
                self.isFound = false
            }
            self.refreshControl.endRefreshing()
            self.loaderView.isHidden = true
            self.loaderView.stopAnimating()
            self.collectionView.reloadData()
            Utility().stopAnimation(viewController: self)
        }) { (failure) in
            Utility().stopAnimation(viewController: self)
        }
    }
    
    @IBAction func searchButtonAct(_ sender: UIButton) {
        let pageObj = FilterDetailsViewController()
        pageObj.selectedTitle = ""
        pageObj.viewType = "search"
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
extension ExploreCollectionViewController: Select_Specialities {
    func addSpecialities(_ specialities: [LanguageModel]) {
        
    }
}
extension ExploreCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if specialitiesArray.count > 0 {
            return (specialitiesArray[section].doctors.count)
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ExploreHeaderCollectionViewCell", for: indexPath) as! ExploreHeaderCollectionViewCell

            if self.specialitiesArray.count > 0 {
                cell.loadData(self.specialitiesArray[indexPath.section])
                let res1 = self.specialitiesArray[indexPath.section]
                cell.titleLabel.text = res1.specialityName
                cell.showAllBtn.tag = indexPath.section
                cell.showAllBtn.addTarget(self, action: #selector(self.showAllButtonAct(_:)), for: .touchUpInside)
            }
            return cell
        }
        
        else if kind == UICollectionView.elementKindSectionFooter{
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ExploreFooterCollectionViewCell", for: indexPath) as! ExploreFooterCollectionViewCell
            if self.specialitiesArray.count > 0 {
                cell.showAllButton.tag = indexPath.section
                cell.showAllButton.addTarget(self, action: #selector(self.showAllButtonAct(_:)), for: .touchUpInside)
                cell.loadData("\(self.specialitiesArray[indexPath.section].totalListcount ?? "0")")
            }
            return cell
             
        }
         
        else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ExploreHeaderCollectionViewCell", for: indexPath) as! ExploreHeaderCollectionViewCell

            if self.specialitiesArray.count > 0 {
                cell.loadData(self.specialitiesArray[indexPath.section])
                let res1 = self.specialitiesArray[indexPath.section]
                cell.titleLabel.text = res1.specialityName
            }
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.specialitiesArray.count
    }
    @objc func dateButtonAct(_ sender: UIButton) {
        //        let pageObj = DatePickerViewController()
        //        pageObj.delegate = self
        //        pageObj.isFormBooking = 2
        //        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreListCollectionViewCell", for: indexPath) as! ExploreListCollectionViewCell
        cell.loadRecentData(specialitiesArray[indexPath.section].doctors[indexPath.row], type: self.specialitiesArray[indexPath.section].specialityName)
        cell.likeButton.tag = Int(specialitiesArray[indexPath.section].doctors[indexPath.row].doctorId) ?? 0
        cell.likeButton.addTarget(self, action: #selector(self.likeButtonAct(_:)), for: .touchUpInside)
        if indexPath.section == (self.specialitiesArray.count - 1) && self.isFound == true {
            self.offset = self.specialitiesArray.count
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
            self.isFound = false
            self.loadData()
        }
        cell.layoutIfNeeded()
        return cell
    }
    @objc func likeButtonAct(_ sender: UIButton) {
        if ((UserDefaultModule.shared.getCurrentUserID() as String? ?? "") != ""){
            if (sender.imageView?.image ?? #imageLiteral(resourceName: "heart")) == #imageLiteral(resourceName: "HomeLike") {
                sender.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            }
            else {
                sender.setImage(#imageLiteral(resourceName: "HomeLike"), for: .normal)
            }
            self.viewModel.likeAct(user_id: UserDefaultModule.shared.getLoginData().userId ?? "", doctor_id: "\(sender.tag)", onSuccess: { (success) in
            }) { (failure) in
            }
        }else{
            let pageVc = UserSigninViewController()
            self.navigationController?.pushViewController(pageVc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageObj = DoctorDetailsViewController()
        pageObj.doctorID = self.specialitiesArray[indexPath.section].doctors[indexPath.row].doctorId ?? ""
        pageObj.type = self.specialitiesArray[indexPath.section].specialityName ?? ""
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            if indexPath?.section != 0 {
                self.dividerView.isHidden = true
            }
        }
    }
    @objc func showAllButtonAct(_ sender: UIButton) {
        let pageObj = FilterDetailsViewController()
        pageObj.isFromSpecialist = true
        pageObj.viewType = "seeall"
        pageObj.specialities = LanguageModel(id: Int(self.specialitiesArray[sender.tag].specialityId ?? "") ?? 0, name: (self.specialitiesArray[sender.tag].specialityName ?? ""))
        
        self.navigationController?.pushViewController(pageObj, animated: true)
    }
}
extension ExploreCollectionViewController: popularDestinationDelegate {
    func cellTaped(_ indexPath: IndexPath) {
        let pageObj = FilterDetailsViewController()
        //         if let res = self.viewModel.exploreData?.result {
        //             pageObj.selectedTitle = res.popularDestination[indexPath.row].countryName
        //             pageObj.filterStruct = FilterData(user_id: "\((UserDefaultModule().getCurrentUserID()!))", search_key:  res.popularDestination[indexPath.row].countryName, searchtype:"search", country_id: "")
        //         }
        addChild(pageObj)
        pageObj.view.frame = self.view.bounds
        view.addSubview(pageObj.view)
        pageObj.didMove(toParent: self)
    }
}
extension ExploreCollectionViewController: searchFilterDelegate {
    
    func searchFilterAct(filterStruct: FilterData, title: String) {
        self.navigationController?.popViewController(animated: false)
        let pageObj = FilterDetailsViewController()
        pageObj.selectedTitle = title
        pageObj.filterStruct = filterStruct
        addChild(pageObj)
        pageObj.view.frame = self.view.bounds
        view.addSubview(pageObj.view)
        pageObj.didMove(toParent: self)
    }
    
    func filterViewData(_ filterStruct: FilterData, dateFilter: String){
        self.navigationController?.popViewController(animated: false)
        let pageObj = FilterDetailsViewController()
        pageObj.selectedTitle = Utility().language().value(forKey: "anywhere") as? String ?? ""
        pageObj.dateFilter = dateFilter
        pageObj.filterStruct = filterStruct
        addChild(pageObj)
        pageObj.view.frame = self.view.bounds
        view.addSubview(pageObj.view)
        pageObj.didMove(toParent: self)
    }
}
extension UIViewController {
func setStatusBarBackgroundColors(color: UIColor) {
        let sharedApplication = UIApplication.shared
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = color
            sharedApplication.delegate?.window??.addSubview(statusBar)
        }
        else {
            guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
            statusBar.backgroundColor = color
        }
    }
}
/*
extension ExploreCollectionViewController: GADBannerViewDelegate {
    func loadAddOns() {
        bannerView.isHidden = true
        if IS_GOOGLE_ADSENSE {
            bannerView.isHidden = false
            bannerView.adUnitID = BANNNER_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}
*/
