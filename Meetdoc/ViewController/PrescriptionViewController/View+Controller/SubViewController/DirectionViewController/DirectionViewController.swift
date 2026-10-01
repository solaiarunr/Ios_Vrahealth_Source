//
//  DirectionViewController.swift
//  Meetdoc
//
//  Created by Hitasoft on 03/12/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol DirectionDelegate {
    func directionAct(_ selectionDirection: [String], isFrequency: Bool)
}
class DirectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    
    var selectedArray = [String]()
    var delegate: DirectionDelegate?
    var isFrequency = false
    var titlestring = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        if Profile.currentProfile != nil {
            CallsApp.connect()
        }
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
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func configUI() {
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: (getLanguage[self.titlestring] ?? ""), fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)

        self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
        self.applyButton.config(color: UIColor(named: "White"), font: regularFont, align: .center, title: "apply")
        self.applyButton.isHidden = self.isFrequency
    }
    @IBAction func applyButtonAct(_ sender: UIButton) {
        if self.selectedArray.count > 0 {
            self.delegate?.directionAct(self.selectedArray, isFrequency: isFrequency)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension DirectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrequency {
            return frequencyArray.count
        }
        else {
            return directionArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        if isFrequency {
            cell.titleLabel.text = (getLanguage[frequencyArray[indexPath.row]] ?? frequencyArray[indexPath.row])
            if self.selectedArray.contains(where: {$0 == frequencyArray[indexPath.row]}) {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }
        else {
            cell.titleLabel.text = getLanguage[directionArray[indexPath.row]] ?? directionArray[indexPath.row]
            if self.selectedArray.contains(where: {$0 == directionArray[indexPath.row]}) {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
            }
            else {
                cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFrequency {
            self.selectedArray.removeAll()
            if !self.selectedArray.contains(frequencyArray[indexPath.row]) {
                self.selectedArray.append(frequencyArray[indexPath.row])
            }
            self.tableView.reloadData()
            self.delegate?.directionAct(self.selectedArray, isFrequency: isFrequency)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if !self.selectedArray.contains(directionArray[indexPath.row]) {
                self.selectedArray.append(directionArray[indexPath.row])
            }
            else {
                self.selectedArray.removeAll(where: {$0 == (directionArray[indexPath.row])})
            }
            self.tableView.reloadData()
        }
    }
    
}
