//
//  StripeProofTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 10/04/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

class StripeProofTableViewCell: UITableViewCell {

    @IBOutlet weak var image2Label: UILabel!
    @IBOutlet weak var image1Label: UILabel!
    @IBOutlet weak var doc2ProofName: UILabel!
    @IBOutlet weak var doc1ProofName: UILabel!
    @IBOutlet weak var doc2TitleLabel: UILabel!
    @IBOutlet weak var doc1TitleLabel: UILabel!
    @IBOutlet weak var doc2ProofView: UIView!
    @IBOutlet weak var Doc1ProofView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.Doc1ProofView.isUserInteractionEnabled = true
        self.doc2ProofView.isUserInteractionEnabled = true
        self.Doc1ProofView.cornerViewMiniumRadius()
        self.doc2ProofView.cornerViewMiniumRadius()
        self.doc1ProofName.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular13, align: .center, text: "choose_file")
        self.doc2ProofName.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular13, align: .center, text: "choose_file")
        self.image1Label.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular13, align: .center, text: "no_file_selected")
        self.image2Label.config(color: UIColor(named: "SubTitleColor") ?? .white, font: fontRegular13, align: .center, text: "no_file_selected")

    }
    func loadData(index: Int, docDict: [String: String], documentstatus: String) {
        self.image1Label.text = (Utility().language().value(forKey: "no_file_selected") as? String ?? "")
        self.image2Label.text = (Utility().language().value(forKey: "no_file_selected") as? String ?? "")
        if index == 0 {
            self.doc1TitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "identity_front")
            self.doc2TitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "identity_back")
            self.Doc1ProofView.tag = 0
            self.doc2ProofView.tag = 1
            
            if docDict["idfrontfile"] != "" {
                self.image1Label.text = docDict["idfrontfile"]
            }
            if docDict["idbackfile"] != "" {
                self.image2Label.text = docDict["idbackfile"]
            }
         }
        else {
           self.doc1TitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "address_front")
            self.doc2TitleLabel.config(color: UIColor(named: "SubTitleColor") ?? .white, font: regular14, align: .left, text: "address_back")
            self.Doc1ProofView.tag = 2
            self.doc2ProofView.tag = 3
            
            if docDict["addrfrontfile"] != "" {
                self.image1Label.text = docDict["addrfrontfile"]
            }
            if docDict["addrbackfile"] != "" {
                self.image2Label.text = docDict["addrbackfile"]
            }
        }
        if documentstatus != "" {
            self.Doc1ProofView.isHidden = true
            self.doc2ProofView.isHidden = true
            self.image1Label.config(color: UIColor(named: "status_color") ?? .white, font: fontRegular13, align: .center, text: documentstatus)
            self.image2Label.config(color: UIColor(named: "status_color") ?? .white, font: fontRegular13, align: .center, text: documentstatus)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
