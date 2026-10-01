//
//  dateStickyCell.swift
//  Hiddy
//
//  Created by APPLE on 25/07/18.
//  Copyright © 2018 HITASOFT. All rights reserved.
//

import UIKit

class UploadFileTableViewCell: UITableViewCell {

    @IBOutlet var contentLbl: UILabel!
    @IBOutlet var fullView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.fullView.cornerViewRadius()
       // self.fullView.backgroundColor =  UIColor(named: "HeaderColor")
        self.contentLbl.config(color: UIColor.white, font: regular14, align: .left, text: "")
        //self.contentLbl.text = "Muthukumar uploaded files"
    }

    func loadData(_ chatData: ChatResultModel) {
        
        if chatData.chatType == "chatcasefile"{
            
            let userID = "\((UserDefaultModule().getCurrentUserID() ?? ""))"
            if userID == "\(chatData.userId ?? 0)"{
               // self.contentLbl.text = chatData.message
                self.contentLbl.text = getLanguage["You uploaded files"]
            }else{
                
                let value = getLanguage["uploaded files"] ?? "Uploaded files"
                let fullName : String = chatData.message
                let fullNameArr : [String] = fullName.components(separatedBy: " ")
                let firstName : String = fullNameArr[0]

                self.contentLbl.text = firstName + " " + value
                //self.contentLbl.text = chatData.message
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
