//
//  DCprofileViewController.swift
//  Meetdoc
//
//  Created by HTS-MAC on 20/02/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class DCprofileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var DCprofilePageTableView: UITableView!
    @IBOutlet weak var bannerWholeView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var uesrImageview: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var profileListArray = NSMutableArray()
    var profileImageArray = NSMutableArray()
    var loginData = [UserLoginResultModel]()
    var getUserName = String()
    var getLastName = String()
    var getUserImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        self.loginData = [UserDefaultModule.shared.getLoginData()]
//        profileListArray = ["","view_edit_profile","notifications","setting","my_doctor","message","reviews","invite_friends","help","account_delete","logout"]
//        profileListArray = ["","view_edit_profile","notifications","my_doctor","message","setting","reviews","invite_friends","help","account_delete","logout"]
        profileListArray = ["","view_edit_profile","notifications","setting","help","account_delete","logout"]

//        profileImageArray = ["","profile","notification_icon","settings_icon","heart","message","Review","invite_icon","help_icon","account_deletion", "Logout"]
        profileImageArray = ["","profile","notification_icon","message","settings_icon","Review","help_icon","account_deletion", "Logout"]
        DCprofilePageTableView.register(UINib(nibName: "ProfileFirstCell", bundle: nil), forCellReuseIdentifier: "ProfileFirstCell")
        DCprofilePageTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
       // profileImageArray = ["","profile","notification_icon","settings_icon","Review","invite_icon","help_icon", "Logout"]
        
        self.userNameLabel.config(color: UIColor(named: "TitleColor") ?? .white, font: semiBold22, align: .left, text: "firstname")
        
        SDImageCache.shared.removeImage(forKey: loginData.first?.userImage ?? "", withCompletion: nil)
        self.uesrImageview.sd_setImage(with: URL(string: loginData.first?.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "placeholder"))
        self.DCprofilePageTableView.showsVerticalScrollIndicator = false
        self.configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.parent?.navigationItem.leftBarButtonItems = nil
        self.parent?.navigationItem.rightBarButtonItems = nil
        self.DCprofilePageTableView.reloadData()
        configUI()
    }
    func configUI() {
        self.bannerWholeView.isHidden = true
        if loginData.first != nil {
            let fristNameStr : String = loginData.first?.firstName ?? ""
            let lastName : String = loginData.first?.lastName ?? ""
            self.userNameLabel.text = "\(fristNameStr) \(lastName)"
            self.uesrImageview.sd_setImage(with: URL(string: loginData.first?.userImage ?? ""), placeholderImage:#imageLiteral(resourceName: "placeholder"))
            self.uesrImageview.layer.masksToBounds = true
        }
        if self.view.tag == 0 {
            profileListArray =
            ["","view_edit_profile","notifications","setting","help","account_delete","logout"]
//            ["","view_edit_profile","notifications","setting","my_doctor","message","reviews","invite_friends","help","account_delete","logout"]
        }
        else {
            profileListArray =
            ["","view_edit_profile","notifications","setting","help","account_delete","logout"]
//                ["","view_edit_profile","notifications","setting","my_doctor","message","reviews","invite_friends","help","account_delete","logout"]
        }
//        self.loadAddOns()
        self.loadData()
    }
    func deleteAccount(){
        ProfileViewModel().accountdeletion(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            var Model = ProfileViewModel().deletionModel
            Model = success
                let actionSheet = UIAlertController(title: nil, message: Model?.message, preferredStyle: .alert)
                actionSheet.setTitlet(font: fontRegular, color: .black)
                let logOut = UIAlertAction(title: (Utility().language().value(forKey: "OK") as? String ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                    if Model?.status == true{
                        UserDefaultModule().userLogout()
                    }
                })
                actionSheet.addAction(logOut)
                //                actionSheet.addAction(cancel)
                self.present(actionSheet, animated: true, completion: nil)
        }) { (failure) in
        }
    }
    func loadData() {
        ProfileViewModel().loadProfileData(userid: (UserDefaultModule.shared.getLoginData().userId ?? ""), onSuccess: { (success) in
            if success {
                self.DCprofilePageTableView.reloadData()
            }
        }) { (failure) in
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileListArray.count
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        let is_iPhoneX = UIScreen.main.bounds.size.height == 812.0
        if (is_iPhoneX){
            return 75
        }else{
            return 65
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileFirstCell") as! ProfileFirstCell
            cell.usernameLabel.text = "\(UserDefaultModule.shared.getLoginData().firstName ?? "") \(UserDefaultModule.shared.getLoginData().lastName ?? "")"
            
            cell.userImageView.sd_setImage(with: URL(string: UserDefaultModule.shared.getLoginData().userImage ?? ""), placeholderImage: #imageLiteral(resourceName: "doctorProfile"))
            cell.userImageView.setBorder(color: UIColor(named: "AppColor") ?? .white)
            cell.selectionStyle = .none
            return cell
        }
        else {
            let profileTableCell = tableView.dequeueReusableCell(withIdentifier:"ProfileCell", for: indexPath) as! ProfileCell
            profileTableCell.configureCellWithDetails(list_name: profileListArray[indexPath.row] as! String)
            if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                profileTableCell.nextIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            profileTableCell.selectionStyle = .none
            let yourImage: UIImage = UIImage(named: profileImageArray.object(at: indexPath.row) as! String)!
            profileTableCell.listIcon?.image = yourImage
            if (indexPath.row == (profileListArray.count - 1)) {
                profileTableCell.lineView.isHidden = true
                profileTableCell.nextIcon.isHidden = true
            }
            else {
                profileTableCell.lineView.isHidden = false
                profileTableCell.nextIcon.isHidden = false
            }
            return profileTableCell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 1 {
            let pageNaviObj = ProfilePage()
            pageNaviObj.delegate = self
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        if indexPath.row == 2
        {
            let pageNaviObj = NotificationPage()
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        else if indexPath.row == 3
        {
            let pageNaviObj = SettingsPage()
            pageNaviObj.titleLbltext = profileListArray[indexPath.row] as? String
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        /*
        else if indexPath.row == 3
        {
            let pageNaviObj = SavedListViewController()
        //    pageNaviObj.titleLbltext = profileListArray[indexPath.row] as? String
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        */
//        else if indexPath.row == 3{
//            let pageNaviObj = InboxViewController()
//     //       pageNaviObj.titleLbltext = profileListArray[indexPath.row] as? String
//            self.navigationController?.pushViewController(pageNaviObj, animated: true)
//        }
        //review
//        else if indexPath.row == 5{
//            let pageNaviObj = ReviewPage()
//            self.navigationController?.pushViewController(pageNaviObj, animated: true)
//        }
        /*
        else if indexPath.row == 7{
            let pageNaviObj = InviteFriends()
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }*/
         //help
        else if indexPath.row == 4
        {
            let pageNaviObj = HelpViewController()
            self.navigationController?.pushViewController(pageNaviObj, animated: true)
        }
        else if indexPath.row == 5
        {
            let actionSheet = UIAlertController(title: nil, message: Utility().language().value(forKey: "delete_account") as? String ?? "delete_account", preferredStyle: .alert)
            actionSheet.setTitlet(font: fontRegular, color: .black)
            let logOut = UIAlertAction(title: (Utility().language().value(forKey: "OK") as? String ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                self.deleteAccount()
            })
            let cancel = UIAlertAction(title: (Utility().language().value(forKey: "cancel") as? String ?? "cancel").capitalized, style: .default, handler: { (action) -> Void in
            })
            actionSheet.addAction(logOut)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
        else if indexPath.row == 6
        {
            let actionSheet = UIAlertController(title: nil, message: Utility().language().value(forKey: "logout_title") as? String ?? "logout_title", preferredStyle: .alert)
            actionSheet.setTitlet(font: fontRegular, color: .black)
            let logOut = UIAlertAction(title: (Utility().language().value(forKey: "OK") as? String ?? "OK").capitalized, style: .default, handler: { (action) -> Void in
                UserDefaultModule().userLogout()
            })
            let cancel = UIAlertAction(title: (Utility().language().value(forKey: "cancel") as? String ?? "cancel").capitalized, style: .default, handler: { (action) -> Void in
            })
            actionSheet.addAction(logOut)
            actionSheet.addAction(cancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}
extension DCprofileViewController: userData{
    func addUserName(name: String, lastName: String, userImage: UIImage) {
        self.getUserName =  "\(name) \(lastName)"
        self.getUserImage = userImage
    }
    
}

