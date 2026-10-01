//
//  HSTextView+UITextView.swift
//  Hiddy
//
//  Created by APPLE on 06/08/18.
//  Copyright © 2018 HITASOFT. All rights reserved.
//

import Foundation
import UIKit

extension UITextView{
    //MARK: configure label
    public func config(color:UIColor? ,font:UIFont?, align:NSTextAlignment, text:String, setBorder: Bool = false){
        self.textColor = color
        self.textAlignment = align
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            if align == .left {
                self.textAlignment = .right
            }
            else if align == .right {
                self.textAlignment = .left
            }
        }
//        self.toolbarPlaceholder = Utility().language().value(forKey: text) as? String
        self.text = Utility().language().value(forKey: text) as? String ?? ""
        self.font = font ?? UIFont.systemFont(ofSize: 14)
        if setBorder {
            self.setTextViewBorder()
        }
    }
    func setTextViewBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = (UIColor(named: "BorderColor") ?? .white).cgColor
    }
    //MARK: check textfield is empty
    func isEmpty() -> Bool {
        if  (self.text! == "") || (self.text! == "NULL") || (self.text! == "(null)")  || (self.text! == "<null>") || (self.text! == "Json Error") || (self.text! == "0") || (self.text!.isEmpty) ||  self.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
   

}
