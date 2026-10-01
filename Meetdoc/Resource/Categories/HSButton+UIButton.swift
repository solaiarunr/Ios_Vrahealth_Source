//
//  HSButton+UIButton.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    public func config(color:UIColor?,font:UIFont?,align:UIControl.ContentHorizontalAlignment,title:String){
        self.setTitleColor(color, for: .normal)
        self.setTitle(Utility().language().value(forKey: title) as? String, for: .normal)
        self.contentHorizontalAlignment = align
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            if align == .left {
                self.contentHorizontalAlignment = .right
            }
            else if align == .right {
                self.contentHorizontalAlignment = .left
            }
        }
        self.titleLabel?.font = font
    }
    func cornerRoundRadius() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
    func cornerMiniumRadius() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    func setBorder(_ color:UIColor = UIColor.black) {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 0.5
        self.layer.borderColor = color.cgColor //(UIColor(named: "BorderColor") ?? .white).cgColor
    }
    
    //MARK: shadow effect
    func floatingEffect(color: UIColor) {
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
    }
  
    func newEffect() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 2)
        self.layer.shadowRadius = 1.0;
        self.layer.shadowOpacity = 1;
    
    }
}
