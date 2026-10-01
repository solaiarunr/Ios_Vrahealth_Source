//
//  StripeCountryViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 21/01/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol StripeCountryDelegate {
    func selectedCountry(country: StripeCountry?)
}

class StripeCountryViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var stripeData: StripeClass?
    var selectedCountry: StripeCountry?
    var delegate: StripeCountryDelegate?
    var adminDict = NSMutableDictionary()
    var selectedLanguagee = [String]()
    var selectedTimeZone = ""
    var selectedCountryName = ""

    var isStripe = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkReachability()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)

        self.configUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    func configUI() {

        self.navigationController?.customRightBarButtonView(title: "", fColor: "TitleColor", fontName: fontRegular16, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        
        self.tableView.register(UINib(nibName: "StripeCountryCell", bundle: nil), forCellReuseIdentifier: "StripeCountryCell")
        
        if isStripe == 0 {
            if (self.stripeData?.result.countryCode != nil && self.stripeData?.result.countryCode != "") {
                self.selectedCountry = self.stripeData?.result.country.filter({$0.countryCode == self.stripeData?.result.countryCode}).first
            }
            self.doneButton.isHidden = true
        }
        self.doneButton.config(color: UIColor(named: "White") ?? .white, font: regularFont, align: .center, title: "save")
        self.doneButton.backgroundColor = UIColor(named: "AppColor") ?? .white
        self.doneButton.layer.cornerRadius = 3
        
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
    
    @IBAction func doneButtonAct(_ sender: UIButton) {
        Utility().startAnimation(viewController: self)
        var param = Parameters()
        if isStripe == 1 {
            param["languages"] = LanguageToJson() ?? ""
        }
        else {
            param["timezone_id"] = timeZoneToJson() ?? ""
        }
        CallParsingFunction().editProfileData1(param: param, onSuccess: { (response) in
            print(response)
            Utility().stopAnimation(viewController: self)

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            
        }
    }
    func LanguageToJson() -> String? {
        let languageArr = (self.adminDict.object(forKey: "languages") as! [Any])
        var jsonDict = [[String: String]]()
        if self.selectedLanguagee.count > 0 {
            for language in languageArr {
                let languagedict = language as! Dictionary<String, Any>
                
//                let eng = (languagedict["name"] as? String ?? "").lowercased()
//                if eng.contains("English".lowercased()) {
//                    jsonDict.append(["id":"\(languagedict["id"] as? Int ?? 0)","name":languagedict["name"] as? String ?? ""])
//                }
//                else
                if self.selectedLanguagee.contains(where: {$0 == (languagedict["name"] as? String ?? "")}) {
                    jsonDict.append(["id":"\(languagedict["id"] as? Int ?? 0)","name":languagedict["name"] as? String ?? ""])
                }
            }
        }
        let jsonData = try! JSONEncoder().encode(jsonDict)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        return jsonString
    }
    func timeZoneToJson() -> String? {
        let timeZoneArr = (self.adminDict.object(forKey: "time_zone") as! [Any])
        for timeZone in timeZoneArr {
            let zone = timeZone as! Dictionary<String, Any>
            if (zone["zone"] as? String ?? "") == self.selectedTimeZone {
                return "\(zone["id"] as? Int ?? 0)"
            }
        }
        return ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension StripeCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isStripe == 0 {
            return (self.stripeData?.result.country.count ?? 0)
        }
        else if isStripe == 1 {
            return (self.adminDict.object(forKey: "languages") as! [Any]).count
        }
        else if isStripe == 2 {
            return (self.adminDict.object(forKey: "time_zone") as! [Any]).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "StripeCountryCell") as! StripeCountryCell
        cell.selectButton.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        if isStripe == 0 {
            cell.configUI(countryList: self.stripeData?.result.country[indexPath.row])
            if self.selectedCountry != nil {
                let country = self.stripeData?.result.country[indexPath.row]
                if self.selectedCountry?.countryName == country?.countryName {
                    cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
                    cell.selectButton.tintColor = UIColor(named: "AppColor")
                }
            }
        }
        else if isStripe == 1 {
            let languageArr = (self.adminDict.object(forKey: "languages") as! [Any])
            let languagedict = languageArr[indexPath.row] as! Dictionary<String, Any>
            cell.countryLabel.text = languagedict["name"] as? String ?? ""
//            if indexPath.row == 0 {
//                cell.countryLabel.text = "English"
//                cell.selectButton.tag = 1
//                cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
//                cell.selectButton.tintColor = UIColor(named: "AppColor")
//            }
            if self.selectedLanguagee.count > 0 {
                if self.selectedLanguagee.contains(where: {$0 == (languagedict["name"] as? String ?? "")}) {
                    cell.selectButton.tag = 1
                    cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
                    cell.selectButton.tintColor = UIColor(named: "AppColor")
                }
                else {
                    cell.selectButton.tag = 0
                    cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                    cell.selectButton.tintColor = UIColor(named: "TitleColor")
                }
            }
            else {
                cell.selectButton.tag = 0
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                cell.selectButton.tintColor = UIColor(named: "TitleColor")
            }

        }
        else if isStripe == 2 {
            let languageArr = (self.adminDict.object(forKey: "time_zone") as! [Any])
            let languagedict = languageArr[indexPath.row] as! Dictionary<String, Any>
            cell.countryLabel.text = languagedict["zone"] as? String ?? ""
            if self.selectedTimeZone == cell.countryLabel.text! {
                cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
                cell.selectButton.tintColor = UIColor(named: "AppColor")
            }
            else {
                if self.selectedTimeZone == "" && indexPath.row == 0{
                    cell.countryLabel.text = languagedict["zone"] as? String ?? ""
                    cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
                    cell.selectButton.tintColor = UIColor(named: "AppColor")
                }
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                cell.selectButton.tintColor = UIColor(named: "TitleColor")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isStripe == 0 {
            self.delegate?.selectedCountry(country: self.stripeData?.result.country[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        else if isStripe == 1 {
            let cell = self.tableView.cellForRow(at: indexPath) as! StripeCountryCell
            let languageArr = (self.adminDict.object(forKey: "languages") as! [Any])
            let languagedict = languageArr[indexPath.row] as! Dictionary<String, Any>
            if cell.selectButton.tag == 0 {
                cell.selectButton.setImage(#imageLiteral(resourceName: "primary_checkbox"), for: .normal)
                cell.selectButton.tintColor = UIColor(named: "AppColor")
                cell.selectButton.tag = 1
                self.selectedLanguagee.append(cell.countryLabel.text!)
            }
            else  {
               cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
                cell.selectButton.tintColor = UIColor(named: "TitleColor")
                cell.selectButton.tag = 0
                self.selectedLanguagee.removeAll(where: {$0 == (cell.countryLabel.text!)})
            }
        }
        else if isStripe == 2 {
            let languageArr = (self.adminDict.object(forKey: "time_zone") as! [Any])
            let languagedict = languageArr[indexPath.row] as! Dictionary<String, Any>
            self.selectedTimeZone = languagedict["zone"] as? String ?? ""
            self.tableView.reloadData()
        }
    }
    
    
}

