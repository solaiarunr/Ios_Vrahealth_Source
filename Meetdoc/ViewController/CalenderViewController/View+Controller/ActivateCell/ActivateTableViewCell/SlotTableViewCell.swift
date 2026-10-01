//
//  SlotTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 23/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol slotDelegate {
    func slotTimerAct(_ isFromTime: Bool, index: Int, time: String)
    func showError(_ isFromTime: Bool)
}

class SlotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookingType: UIStackView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var slotTitleLabel: UILabel!
    @IBOutlet weak var fromTimeTextField: UITextField!
    @IBOutlet weak var toTimeTextField: UITextField!
    @IBOutlet weak var directOptionButton: UIButton!
    @IBOutlet weak var directTitleButton: UIButton!
    @IBOutlet weak var videoOptionButton: UIButton!
    @IBOutlet weak var videoTitleButton: UIButton!
    var delegate: slotDelegate?
    var currentCellIndex = 0
    var slotArray = [SlotModel]()
    let datePickerView = UIPickerView()
    let datePickerView1 = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    
    func configUI() {
        self.slotTitleLabel.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, text: "")
        self.fromTimeTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "from_time", Font: regular14, setBorder: true)
        self.fromTimeTextField.delegate = self
        self.toTimeTextField.delegate = self
        self.toTimeTextField.config(color: UIColor(named: "TitleColor"), align: .left, placeHolder: "to_time", Font: regular14, setBorder: true)
        self.directTitleButton.config(color: UIColor(named: "SubTitleColor"), font: regular14, align: .left, title: "direct_booking")
        self.videoTitleButton.config(color: UIColor(named: "AppColor"), font: regular14, align: .left, title: "video_booking")
        self.fromTimeTextField.delegate = self
        self.toTimeTextField.delegate = self
        datePickerView.delegate = self
        datePickerView.contentMode = .center
        datePickerView1.contentMode = .center
        datePickerView1.delegate = self
    }
    func loadData(_ slotModel: SlotModel, index: Int) {
        self.slotTitleLabel.text = "\(getLanguage["slot_new"] ?? "slot_new") \(index+1)"
        
        self.currentCellIndex = index
        datePickerView.tag = 0
        self.fromTimeTextField.inputView = datePickerView
        self.fromTimeTextField.text = slotModel.slotFromTime
        self.toTimeTextField.text = slotModel.slotToTime
        self.currentCellIndex = index
        datePickerView1.tag = 1
        self.toTimeTextField.inputView = datePickerView1
        self.fromTimeTextField.tag = index
        self.toTimeTextField.tag = index
        self.videoOptionButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        self.directOptionButton.setImage(#imageLiteral(resourceName: "radio_UnSel"), for: .normal)
        self.videoTitleButton.setTitleColor(UIColor(named: "AppColor"), for: .normal)
        self.directTitleButton.setTitleColor(UIColor(named: "SubTitleColor"), for: .normal)
//        self.bookingType.isHidden = true
        if slotModel.type == "directvisit" {
            self.directTitleButton.setTitleColor(UIColor(named: "AppColor"), for: .normal)
            self.directOptionButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        }
        else if slotModel.type == "videovisit" {
            self.videoTitleButton.setTitleColor(UIColor(named: "AppColor"), for: .normal)
            self.videoOptionButton.setImage(#imageLiteral(resourceName: "radio_Sel"), for: .normal)
        }
        
        
        
//        self.datePickerView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        self.datePickerView1.transform = CGAffineTransform(scaleX: -1, y: 1)
//        for view in self.fromTimeTextField.subviews {
//            view.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
    }
    func checkAvailability(_ hours: Int, mins: Int, isToTime: Bool) -> Bool {
        let currentDate = Calendar.current.date(bySettingHour: hours , minute: mins, second: 0, of: Date())!
        for slots in 0..<slotArray.count {
            let slotArr = slotArray[slots].slotFromTime.components(separatedBy: ":")
            let slotToTime = slotArray[slots].slotToTime.components(separatedBy: ":")
            
            if slotArr.count > 1 {
                let fromDate = Calendar.current.date(bySettingHour: Int(slotArr.first ?? "0") ?? 0, minute: Int(slotArr.last ?? "0") ?? 0, second: 0, of: Date())!
                let toDate = Calendar.current.date(bySettingHour: Int(slotToTime.first ?? "0") ?? 0, minute: Int(slotToTime.last ?? "0") ?? 0, second: 0, of: Date())!
                if isToTime {
                    let currentFromArr = self.fromTimeTextField.text?.components(separatedBy: ":") ?? [String]()
                        let currentFromDate = Calendar.current.date(bySettingHour: Int(currentFromArr.first ?? "0") ?? 0, minute: Int(currentFromArr.last ?? "0") ?? 0, second: 0, of: Date())!
                    let differ = Calendar.current.dateComponents([.hour, .minute], from: currentFromDate, to: currentDate)
                    if (differ.hour ?? 0) < 1 {
                        return false
                    }
                    if slots != currentCellIndex {
                        if (currentFromDate < fromDate && currentDate <= fromDate) || (currentFromDate >= toDate && currentDate > toDate){
                            print("valid")
                        }
                        else {
                            return false
                        }
                    }
                }
                else {
                    if !(currentDate < fromDate || currentDate >= toDate) {
                        return false
                    }
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == fromTimeTextField {
            var selectedHours = self.datePickerView.selectedRow(inComponent: 0)
            var selectedMins = (self.datePickerView.selectedRow(inComponent: 1) * 5)
            if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                selectedMins = (self.datePickerView.selectedRow(inComponent: 0) * 5)
                selectedHours = self.datePickerView.selectedRow(inComponent: 1)
            }
            // Remove current slot Array Values
            if slotArray.count > currentCellIndex {
                self.slotArray[currentCellIndex].slotFromTime = ""
            }
            if checkAvailability(selectedHours, mins: selectedMins, isToTime: false) {
                self.fromTimeTextField.text = String(format:"%02i:%02i", selectedHours, selectedMins)
                delegate?.slotTimerAct(true, index: self.fromTimeTextField.tag, time: self.fromTimeTextField.text!)
                self.toTimeTextField.text = ""
            }
            else {
                delegate?.showError(true)
            }
        }
        else {
            var selectedHours = self.datePickerView1.selectedRow(inComponent: 0)
            var selectedMins = (self.datePickerView1.selectedRow(inComponent: 1) * 5)
            if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
                selectedMins = (self.datePickerView1.selectedRow(inComponent: 0) * 5)
                selectedHours = self.datePickerView1.selectedRow(inComponent: 1)
            }
            if slotArray.count > currentCellIndex {
                self.slotArray[currentCellIndex].slotToTime = ""
            }
            if checkAvailability(selectedHours, mins: selectedMins, isToTime: true) {
                self.toTimeTextField.text = String(format:"%02i:%02i", selectedHours, selectedMins)
                //"\(components.hour ?? 0):\(mins)"
                delegate?.slotTimerAct(false, index: self.toTimeTextField.tag, time: self.toTimeTextField.text!)
            }
            else {
                delegate?.showError(true)
            }
        }
    }
    @objc func datePickerAct(_ sender: UIDatePicker) {
        let date = sender.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        if sender.tag == 0 {
            // Remove current slot Array Values
            if slotArray.count > currentCellIndex {
                self.slotArray[currentCellIndex].slotFromTime = ""
            }
            if checkAvailability((components.hour ?? 0), mins: (components.minute ?? 0), isToTime: false) {
                self.fromTimeTextField.text = "\(components.hour ?? 0):\(components.minute ?? 0)"
                delegate?.slotTimerAct(true, index: self.fromTimeTextField.tag, time: self.fromTimeTextField.text!)
                self.toTimeTextField.text = ""
            }
            else {
                delegate?.showError(true)
            }
        }
        else {
            if slotArray.count > currentCellIndex {
                self.slotArray[currentCellIndex].slotToTime = ""
            }
            if checkAvailability((components.hour ?? 0), mins: (components.minute ?? 0), isToTime: false) {
                self.toTimeTextField.text = "\(components.hour ?? 0):\(components.minute ?? 0)"
                delegate?.slotTimerAct(false, index: self.toTimeTextField.tag, time: self.toTimeTextField.text!)
            }
            else {
                delegate?.showError(true)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension SlotTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}
extension SlotTableViewCell: UIPickerViewAccessibilityDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            if component == 1 {
                return 24
            }
            return 12
        }
        else {
            if component == 0 {
                return 24
            }
            return 12
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if UserDefaultModule.shared.getAppLanguage().capitalized == "Arabic" {
            if component == 1 {
                return row < 10 ? "0\(row)" : "\(row)"
            }
            else {
                return (row*5) < 10 ? "0\((row)*5)" :  "\((row)*5)"
            }
        }
        else {
            if component == 0 {
                return row < 10 ? "0\(row)" : "\(row)"
            }
            else {
                return (row*5) < 10 ? "0\((row)*5)" :  "\((row)*5)"
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
}

