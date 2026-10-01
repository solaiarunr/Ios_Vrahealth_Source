//
//  DoctorAboutTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 20/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class DoctorAboutTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    var item_description = ""
    var refreshTable: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.aboutLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
    }
    func loadData(_ doctorData: DoctorResultModel, index: Int,title: [String]) {
        if title[index] == "about_doctor" {
            self.aboutLabel.isUserInteractionEnabled = true
            self.item_description = doctorData.bioDescription.html2String
            self.aboutLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.descTapAct(_:))))
//            self.aboutLabel.text = doctorData.bioDescription.html2String
            self.loadItemDescription()
        }
        else {
            self.aboutLabel.isUserInteractionEnabled = false
            self.aboutLabel.numberOfLines = 0
            self.aboutLabel.attributedText = NSMutableAttributedString.getAttributedString(fromString: "")
            self.aboutLabel.text = doctorData.skills.html2String
        }
    }
    @objc func descTapAct(_ gesture: UITapGestureRecognizer) {
        self.aboutLabel.tag = self.aboutLabel.tag == 0 ? 1 : 0
        self.loadItemDescription()
        self.refreshTable!()
    }
    func loadItemDescription() {
        if self.item_description.count > 150 {
            let desc = self.item_description.prefix(150)
            var text = ""
            var readText = ""
            if self.aboutLabel.tag == 0 {
                self.aboutLabel.text = String(desc)
                text = "\u{200E}\(String(desc)) \(getLanguage["read_more"] ?? "")"
                readText = "\(getLanguage["read_more"] ?? "")"
            }
            else {
                self.aboutLabel.text = self.item_description
                text = "\u{200E}\(self.item_description) \(getLanguage["read_less"] ?? "")"
                readText = "\(getLanguage["read_less"] ?? "")"
            }
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
            attributedText.apply(color: UIColor(named: "AppColor") ?? .white, subString: readText)
            self.aboutLabel.attributedText = attributedText
        }
        else {
            self.aboutLabel.text = self.item_description
        }
        self.layoutIfNeeded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         // Configure the view for the selected state
    }
}
extension NSMutableAttributedString {
    func setColorForText(_ textToFind: String?, with color: UIColor) {
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
    func setColorWithFont(_ textToFind: String?, with color: UIColor, font: UIFont) {
        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
            addAttribute(NSAttributedString.Key.font, value: font, range: range!)
        }
    }
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
    func apply(color: UIColor, subString: String) {
      
      if let range = self.string.range(of: subString) {
        self.apply(color: color, onRange: NSRange(range, in:self.string))
      }
    }
    
    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
      self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                         range: onRange)
    }
    
}
