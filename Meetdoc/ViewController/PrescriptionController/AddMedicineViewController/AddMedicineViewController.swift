//
//  AddMedicineViewController.swift
//  Meetdoc
//
//  Created by Sivakumar's MacBook Pro on 08/08/23.
//  Copyright © 2023 BTMani. All rights reserved.
//

import UIKit

class AddMedicineViewController: UIViewController {
    
    
    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var componentTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.configUI()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    func configUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.barButtonAction(_:)), name: Notification.Name("BarButtonAction"), object: self)
        self.navigationController?.NavigationBarWithBackButtonAndTitle(title: Utility().language().value(forKey: "add_medicine") as? String ?? "", fColor: "White", fontName: fontRegular18, imageName: "left_arrow", isLeft: true, vc: self, transparantView: false)
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

}
