//
//  BookingTableViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol bookingDelegate  {
    func bookingAct(_ selectedTime: BookingSlotSubModel)
}
class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedSlot: BookingSlotSubModel?
    var delegate: bookingDelegate?
    var slotArray = [BookingSlotSubModel]()
    var newbookedTime = [String]()
    var rescheduled_time = [String]()
    var accepted_bookings = [String]()
    var viewModel = DoctorViewModel()
    var booking_type = ""
    var selectedDate: Int?
    var doctorData: DoctorResultModel?
    var bookedTime = [String]()
    
    var acceptpoint:[AcceptedTimeModel] = [AcceptedTimeModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BookingTimeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingTimeCollectionViewCell")
    }
    func loadData(_ index: BookingSlotSubModel?, slots: [BookingSlotSubModel]) {
        self.selectedSlot = index
        self.slotArray = slots
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    func loadData() {
        
        var dateVal = (self.selectedDate ?? 0)
        if dateVal == 0 {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            let date = Calendar.current.date(from: components)
            dateVal = Int(date?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        }
        self.viewModel.getSlotData(user_id: UserDefaultModule.shared.getLoginData().userId, doctor_id: "\(self.doctorData?.doctorId ?? "")", type: booking_type, date: dateVal, onSuccess: { (success) in
            if self.viewModel.bookingSlotModel?.status ?? false {
                if let slot = self.viewModel.bookingSlotModel?.result.bookedTime{
                    for val in slot{
                        self.bookedTime.append(val.time)
                    }
                }
            }
        }) { (failure) in
        }
    }
}
extension BookingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.slotArray.count
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        self.layoutIfNeeded()
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        if self.slotArray.count > 0 {
            if contentSize.height > 35 {
                return CGSize(width: contentSize.width, height: contentSize.height+20) // 20 is the margin of the collectinview with top and bottom
            }
            else {
                return CGSize(width: contentSize.width, height: 55) // 20 is the margin of the collectinview with top and bottom
            }
        }
        else {
            return CGSize(width: contentSize.width, height: 0) // 20 is the margin of the collectinview with top and bottom
        }
        // 20 is the margin of the collectinview with top and bottom
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingTimeCollectionViewCell", for: indexPath) as! BookingTimeCollectionViewCell
        if self.slotArray.count > indexPath.row {
            cell.timeLabel.text = self.slotArray[indexPath.row].startTime
            cell.timeLabel.textColor = UIColor(named: "AppColor")
            cell.timeLabel.backgroundColor = UIColor(named: "appbg")
            cell.timeLabel.setBorder(UIColor(named: "AppColor")!)
            if self.newbookedTime.count > 0{
                for i in self.newbookedTime{
                    if i == self.slotArray[indexPath.row].startTime{
                        cell.timeLabel.textColor = UIColor(named: "red")
                        cell.timeLabel.setBorder(UIColor(named: "red")!)
                    }
                }
            }
            if self.rescheduled_time.count > 0{
                for i in self.rescheduled_time{
                    if i == self.slotArray[indexPath.row].startTime{
                        cell.timeLabel.textColor = UIColor(named: "AppColor")
                        cell.timeLabel.setBorder(UIColor(named: "Yellow")!)
                    }
                }
            }
            if self.accepted_bookings.count > 0{
                for i in self.accepted_bookings{
                    if i == self.slotArray[indexPath.row].startTime{
                        cell.timeLabel.setBorder(UIColor(named: "red")!)
                        cell.timeLabel.textColor = UIColor(named: "white")
                        cell.timeLabel.backgroundColor = .red
                    }
                }
            }
            
            
            
            if let slotVal = self.selectedSlot  {
                if (slotVal.startTime ?? "") == (self.slotArray[indexPath.row].startTime ?? "") {
                    cell.timeLabel.backgroundColor = UIColor(named: "AppColor")
                    cell.timeLabel.textColor = UIColor(named: "White")
                    for i in self.newbookedTime{
                        if i == self.slotArray[indexPath.row].startTime{
                            cell.timeLabel.textColor = UIColor(named: "red")
                            cell.timeLabel.setBorder(UIColor(named: "red")!)
                            cell.timeLabel.backgroundColor = UIColor(named: "appbg")
                        }
                    }
                    for i in self.rescheduled_time{
                        if i == self.slotArray[indexPath.row].startTime{
                            cell.timeLabel.textColor = UIColor(named: "AppColor")
                            cell.timeLabel.setBorder(UIColor(named: "Yellow")!)
                            cell.timeLabel.backgroundColor = UIColor(named: "appbg")
                        }
                    }
                    for i in self.accepted_bookings{
                        if i == self.slotArray[indexPath.row].startTime{
                            cell.timeLabel.textColor = UIColor(named: "White")
                            cell.timeLabel.setBorder(UIColor(named: "red")!)
                            cell.timeLabel.backgroundColor = .red
                        }
                    }
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.slotArray.count > 0 {
            return CGSize(width: (self.collectionView.frame.width-15)/4, height: 35)
        }
        else {
            return CGSize(width: (self.collectionView.frame.width-15)/4, height: 0)
        }
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.selectedSlot = self.slotArray[indexPath.row]
            if let slot = self.selectedSlot {
                self.delegate?.bookingAct(slot)
            }
            
            if self.accepted_bookings.count > 0{
                for i in self.accepted_bookings{
                    if i == self.slotArray[indexPath.row].startTime{
                        let alert = UIAlertController(title: nil, message: getLanguage["slotbooked"] ?? "slotbooked", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
            
            
            if self.rescheduled_time.count > 0{
                for i in self.rescheduled_time{
                    if i == self.slotArray[indexPath.row].startTime{
                        
                        let alert = UIAlertController(title: nil, message: getLanguage["slotreshouled"] ?? "slotreshouled", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                        
                    }
                }
            }
            if self.newbookedTime.count > 0{
                for i in self.newbookedTime{
                    if i == self.slotArray[indexPath.row].startTime{
                        let alert = UIAlertController(title: nil, message: getLanguage["slotengage"] ?? "slotengage", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: getLanguage["OK"] ?? "", style: .cancel, handler: { (UIAlertAction) in
                            
                        }))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
                    }
                }
            }
        }
}
