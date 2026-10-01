//
//  ChangeThemeViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 05/02/21.
//  Copyright © 2021 BTMani. All rights reserved.
//

import UIKit

class ChangeThemeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var themeArray = ["dark", "light", "system_default"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (getLanguage["change_theme"] ?? "change_theme"), fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
         self.tableView.register(UINib(nibName: "ProfileTabelCell", bundle: nil), forCellReuseIdentifier: "ProfileTabelCell")
    }
    @objc func barButtonAction(_ notification: Notification) {
        print(notification)
        if let isLeft = notification.userInfo?["isLeft"] as? Int {
            print(isLeft)
            if isLeft == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension ChangeThemeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themeArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTabelCell") as! ProfileTabelCell
        cell.listName.config(color: UIColor(named: "TitleColor") ?? .white, font: regularFont, align: .left, text: "")
        cell.listIcon.isHidden = false
        cell.detailLabel.isHidden = true
        cell.listIcon.image = #imageLiteral(resourceName: "Check_UnSel")
        cell.listIcon.tag = 0
        cell.listName.text = (getLanguage[themeArray[indexPath.row]] ?? themeArray[indexPath.row])
        let theme = UserDefaultModule.shared.getAppTheme()
        if  theme.lowercased() == themeArray[indexPath.row]{
            cell.listIcon.image = #imageLiteral(resourceName: "Check_Sel")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaultModule.shared.setAppTheme(language: themeArray[indexPath.row])
        self.appDelegate.changeTheme()
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
