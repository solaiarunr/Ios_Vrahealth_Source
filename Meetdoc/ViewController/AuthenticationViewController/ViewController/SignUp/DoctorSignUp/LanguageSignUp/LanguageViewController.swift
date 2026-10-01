 //
 //  LanguageSignUp.swift
 //  Meetdoc
 //
 //  Created by Arun Andiselvam on 23/09/20.
 //  Copyright © 2020 BTMani. All rights reserved.
 //

 import UIKit

 protocol Select_Language {
     func addLanguage(_ language: [LanguageModel])
 }
 class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {
     
     @IBOutlet weak var applyButton: UIButton!
     @IBOutlet weak var tableView: UITableView!
     
     var delegate: Select_Language?
     var viewModel = AuthenticationViewModel()
     var selectedArray = [LanguageModel]()
     var isFromFilter = false

     override func viewDidLoad() {
         super.viewDidLoad()

         self.view.addSubview(indicatorView)
         self.configUI()
     }
     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
     override func viewWillAppear(_ animated: Bool) {
         if Profile.currentProfile != nil {
             CallsApp.connect()
         }

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
         self.configUI()
         loadLangugae()
     }
    override func viewDidAppear(_ animated: Bool) {
    }
     override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)

         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
     }
     func loadLangugae(){
         Utility.shared.startAnimation(viewController: self)
         self.viewModel.getLangugageData(onSuccess: { (success) in
             self.tableView.reloadData()
             Utility.shared.stopAnimation(viewController: self)
         }) { (failure) in
             Utility.shared.stopAnimation(viewController: self)
         }
     }
     
     func configUI() {
         self.tableView.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectionTableViewCell")
         self.applyButton.config(color: UIColor(named: "White"), font: fontRegular16, align: .center, title: "apply")
         self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "languages_known") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
        self.navigationController?.updateTransparantBackGround(false, vc: self)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
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
     @IBAction func applyBtnTapped(_ sender: Any) {
        
        if self.selectedArray.count > 0 {
             self.delegate?.addLanguage(selectedArray)
             self.navigationController?.popViewController(animated: true)
         }
         else {
             let alert = UIAlertController(title: nil, message: getLanguage["choose_language"] ?? "choose_language", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "OK", style: .cancel, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
     }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.languageModel?.languages.count ??  0
      }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 70
     }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
         cell.selectionStyle = .none
 
        cell.titleLabel.text = self.viewModel.languageModel?.languages[indexPath.row].lname ?? ""
        for index in 0..<self.selectedArray.count {
            if self.selectedArray[index].lname == (self.viewModel.languageModel!.languages[indexPath.row].lname ?? "") {
                self.selectedArray[index].name = (self.viewModel.languageModel!.languages[indexPath.row].name ?? "")
            }
        }
        if self.selectedArray.contains(where: {$0.lname == (self.viewModel.languageModel!.languages[indexPath.row].lname ?? "")}) {
             cell.selectButton.setImage(#imageLiteral(resourceName: "Check_Sel"), for: .normal)
        }
           else {
              cell.selectButton.setImage(#imageLiteral(resourceName: "Check_UnSel"), for: .normal)
         }
         return cell
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedVal = self.viewModel.languageModel?.languages[indexPath.row] {
            if self.selectedArray.contains(where: {$0.lname == selectedVal.lname}) {
                self.selectedArray.removeAll(where: {$0.lname == selectedVal.lname})
             }
             else {
                 self.selectedArray.append(selectedVal)
             }
         }
        
         self.tableView.reloadData()
     }
 }
 extension Select_Language {
     func addLanguage(_ language: String){
     }
 }




