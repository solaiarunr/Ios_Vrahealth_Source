//
//  DatePickerCollectionViewCell.swift
//  Meetdoc
//
//  Created by Hitasoft on 24/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import UIKit

protocol updateSelectedDateDelegate {
    func selectedDate(_ calenderData: [Int])
    func selectedBookingDate(_ selectedDate: Int, isSelect: Bool, type: String)
//    func check(_ status: Bool)
}
protocol selectedDateDelegate {
    func selectedDate(_ calenderData: [Int])
    func selectedBookingDate(_ selectedDate: Int, isSelect: Bool, type: String)
//    func check(_ status: Bool)
}
class DatePickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var days: [(days: Int, prepend: Int, append: Int)]!
    var selectedIndex = 0
    var isFromCalendar = false
    var calenderData: ActivateCalendarResultModel?
    var delegate: updateSelectedDateDelegate?
    var selectedBookingDate = 0
    var selectedDateIndex: IndexPath?
    var offDates = [Int]()
    var holidayArray = [String]()
    var viewModel = CalendarViewModel()
    var bookingdates = [Int]()
    var selected_dates = [Int]()
    var doctorType = ""
    var historyType = ""
    var today_select = ""
    var one_select = "false"
    var limit = 20
    var offset = 0
    var status = Bool()
    var viewModel1 = BookingHistoryViewModel()
    var ListData = [BookingHistoryResultModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
        // Initialization code
    }
    func configUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DateCollectionViewCell")
    }
    func loadData(_ section: Int, offDate: [Int]) {
        self.isFromCalendar = false
        self.selectedIndex = section
        self.collectionView.tag = section
        self.offDates = offDate
        self.collectionView.reloadData()
    }
    func loadCalendarData(_ section: Int, calenderData: ActivateCalendarResultModel?) {
        self.isFromCalendar = true
        self.collectionView.tag = section
        self.selectedIndex = section
        self.calenderData = calenderData
        self.collectionView.reloadData()
    }
    
}
extension DatePickerCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dateData = days[selectedIndex]
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            return CGSize(width: (self.collectionView.frame.width-70) / 7, height: 0)
        }
        let size = ((self.collectionView.frame.width-70) / 7)
        return CGSize(width: size, height: ((self.collectionView.frame.width-70) / 7))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days[selectedIndex].prepend + days[selectedIndex].days + days[selectedIndex].append
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
            configure(cell: cell, withIndexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        if self.isFromCalendar {
            return (cell.type.contains(.Date) && !cell.type.contains(.leaveDate))
        }
        else {
            return (cell.type.contains(.Date) && !cell.type.contains(.Disabled) && !cell.type.contains(.leaveDate))
        }
        
    }
    func configure(cell: DateCollectionViewCell, withIndexPath indexPath: IndexPath) {
            let dateData = days[selectedIndex]
            let month = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.months[selectedIndex])
            let year = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.months[indexPath.section])
            cell.type = []
            if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
                cell.dateLabel.text = ""
                cell.type = [.Empty]
            } else {
                let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
                let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
                let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
                let curDay = indexPath.item - dateData.prepend + 1
                let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
                cell.dateLabel.text = String(curDay)
                cell.dateLabel.textColor = isPastDate ? (UIColor(named: "fifth_text") ?? .white) : (UIColor(named: "primary_text") ?? .white)
                cell.type = isPastDate ? [.PastDate] : [.Date]
                if todayDay == curDay, todayMonth == month, todayYear == year  {
                    //cell.type.insert(.Selected)
                    cell.type.insert(.Today)
                    
                  
                    
                }
            }
            if self.isFromCalendar {
                
                let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
                let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
                let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
                let curDay = indexPath.item - dateData.prepend + 1
                
                if isBlockedDate(indexPath: indexPath) {
                    if todayDay == curDay, todayMonth == month, todayYear == year  {
                        //cell.type.insert(.Selected)
                        cell.type.insert(.Today)
                        
                    } else {
                        cell.type.insert(.Disabled)
                    }
                    
                }
                if isBookedDate(indexPath: indexPath) && !cell.type.contains(.PastDate){
                    if todayDay == curDay, todayMonth == month, todayYear == year  {
                        
                        cell.type.insert(.Selected)
                     //   cell.type.insert(.Today)
                        self.selectedDateIndex = indexPath
                        let dateComp = DateComponents(year: year, month: month, day: todayDay)
                        let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                        self.offDates.append(Int(selectedDate.timeIntervalSince1970))
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        print("selecteddatea",self.selectedBookingDate)
                        print("selecteddatea",self.offDates)
                        delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "")
                        delegate?.selectedDate(self.offDates)
                        
                    } else {
                        cell.type.insert(.Booked)
                    }
                    
                }
                if isWeekDay(indexPath: indexPath) {
                    cell.type = []
                    cell.type.insert(.leaveDate)
                }
            }
            else {
                let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
                
                let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
                let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
                
                let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
                let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                if cell.type.contains(.Today) && !isBlockedDate(indexPath: indexPath) && !isWeekDay(indexPath: indexPath){
                    if selectedBookingDate == 0 || selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)){
                        cell.type.insert(.Selected)
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                        self.selectedDateIndex = indexPath
                    }
                    else {
                        let order = Utility.calendar.compare(Date(timeIntervalSince1970: Double(selectedBookingDate)), to: selectedDate, toGranularity: .day)
                        switch order {
                        case .orderedSame:
                            cell.type.insert(.Selected)
                            selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                            delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                            self.selectedDateIndex = indexPath
                        case .orderedAscending:
                            print("Ascending")
                        case .orderedDescending:
                            print("Desending")
                        }
                    }
                }
                else {
                    if selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)) {
                        cell.type.insert(.Selected)
                    }
                    else {
                        
                    }
                }
                if isBlockedDate(indexPath: indexPath) {
                    cell.type.remove(.Selected)
                    cell.type.insert(.Disabled)
                }
                if isWeekDay(indexPath: indexPath) {
                    cell.type = []
                    cell.type.insert(.leaveDate)
                }
            }
            cell.configureCell()
        }
    
    func configure3(cell: DateCollectionViewCell, withIndexPath indexPath: IndexPath) {
        let dateData = days[selectedIndex]
        let month = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.months[selectedIndex])
        let year = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.months[indexPath.section])
        cell.type = []
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            cell.dateLabel.text = ""
            cell.type = [.Empty]
        } else {
            let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
            let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
            let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
            let curDay = indexPath.item - dateData.prepend + 1
            let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
            cell.dateLabel.text = String(curDay)
            cell.dateLabel.textColor = isPastDate ? (UIColor(named: "fifth_text") ?? .white) : (UIColor(named: "primary_text") ?? .white)
            cell.type = isPastDate ? [.PastDate] : [.Date]
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                cell.type.insert(.Selected)
                cell.type.insert(.Today)
                
                let dateComp = DateComponents(year: year, month: month, day: todayDay)
                let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                self.offDates.append(Int(selectedDate.timeIntervalSince1970))
                selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                print("selecteddatea",self.selectedBookingDate)
                print("selecteddatea",self.offDates)
                delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                delegate?.selectedDate(self.offDates)
                
            }
        }
        if self.isFromCalendar {
            if isBlockedDate(indexPath: indexPath) {
                cell.type.insert(.Disabled)
            }
            if isBookedDate(indexPath: indexPath) && !cell.type.contains(.PastDate){
                cell.type.insert(.Booked)
            }
            if isWeekDay(indexPath: indexPath) {
                cell.type = []
                cell.type.insert(.leaveDate)
            }
        }
        else {
            let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
            
            let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
            let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
            
            let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
            let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
            if cell.type.contains(.Today) && !isBlockedDate(indexPath: indexPath) && !isWeekDay(indexPath: indexPath){
                if selectedBookingDate == 0 || selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)){
                    cell.type.insert(.Selected)
                    selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                    delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                    self.selectedDateIndex = indexPath
                }
                else {
                    let order = Utility.calendar.compare(Date(timeIntervalSince1970: Double(selectedBookingDate)), to: selectedDate, toGranularity: .day)
                    switch order {
                    case .orderedSame:
                        cell.type.insert(.Selected)
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                        self.selectedDateIndex = indexPath
                    case .orderedAscending:
                        print("Ascending")
                    case .orderedDescending:
                        print("Desending")
                    }
                }
            }
            else {
                if selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)) {
                    cell.type.insert(.Selected)
                }
                else {
                    
                }
            }
            if isBlockedDate(indexPath: indexPath) {
                cell.type.remove(.Selected)
                cell.type.insert(.Disabled)
            }
            if isWeekDay(indexPath: indexPath) {
                cell.type = []
                cell.type.insert(.leaveDate)
            }
        }
        cell.configureCell()
    }
    func configure2(cell: DateCollectionViewCell, withIndexPath indexPath: IndexPath) {
        let dateData = days[selectedIndex]
        let month = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.months[selectedIndex])
        let year = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.months[indexPath.section])
        cell.type = []
        
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            cell.dateLabel.text = ""
            cell.type = [.Empty]
        } else {
            let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
            let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
            let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
            let curDay = indexPath.item - dateData.prepend + 1
            let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
            cell.dateLabel.text = String(curDay)
            cell.dateLabel.textColor = isPastDate ? (UIColor(named: "fifth_text") ?? .white) : (UIColor(named: "primary_text") ?? .white)
            cell.type = isPastDate ? [.PastDate] : [.Date]
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                
               // cell.type.insert(.Selected)
               
//                print("selecteddatea")
//                let dateComp = DateComponents(year: year, month: month, day: todayDay)
//                let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
//                self.offDates.append(Int(selectedDate.timeIntervalSince1970))
//                print(self.offDates)
////                self.firsttime = "true"
//                delegate?.selectedDate(self.offDates)
//                
            }
        }
        
        if self.isFromCalendar {
            let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
            let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
            let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
            let curDay = indexPath.item - dateData.prepend + 1
         
                if isBlockedDate(indexPath: indexPath) {
                    cell.type.insert(.Disabled)
                    
                }
                if isselectedDate(indexPath: indexPath) {
                    cell.type.insert(.Selected)
                }
                if isBookedDate(indexPath: indexPath) && !cell.type.contains(.PastDate){
                    if todayDay == curDay, todayMonth == month, todayYear == year  {
                        cell.type.insert(.Today)
                        cell.type.insert(.Selected)
                        
                        let dateComp = DateComponents(year: year, month: month, day: todayDay)
                        let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                        self.offDates.append(Int(selectedDate.timeIntervalSince1970))
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        print("selecteddatea",self.selectedBookingDate)
                        print("selecteddatea",self.offDates)
                        delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                        delegate?.selectedDate(self.offDates)
                    }else {
                        cell.type.insert(.Booked)
                    }
                }
                
                
                if isWeekDay(indexPath: indexPath) {
                    cell.type = []
                    cell.type.insert(.leaveDate)
                }
                if TodayDate(indexPath: indexPath){
                    cell.type.insert(.Today)
                }
            
        }
        else {
            
            let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
            let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
            let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
            let curDay = indexPath.item - dateData.prepend + 1
            
            let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
            
            let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
            let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
            
            let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
            let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
            if today_select == "true" {
                self.today_select = ""
                if todayDay == curDay, todayMonth == month, todayYear == year  {
                    cell.type.remove(.Selected)
                    cell.type.insert(.Today)
                }
            } else {
                if cell.type.contains(.Today) && !isBlockedDate(indexPath: indexPath) && !isWeekDay(indexPath: indexPath){
                    if selectedBookingDate == 0 || selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)){
                        cell.type.insert(.Selected)
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                        self.selectedDateIndex = indexPath
                    }
                    else {
                        let order = Utility.calendar.compare(Date(timeIntervalSince1970: Double(selectedBookingDate)), to: selectedDate, toGranularity: .day)
                        switch order {
                        case .orderedSame:
                            cell.type.insert(.Selected)
                            selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                            delegate?.selectedBookingDate(                selectedBookingDate, isSelect: false, type: "")
                            self.selectedDateIndex = indexPath
                        case .orderedAscending:
                            print("Ascending")
                        case .orderedDescending:
                            print("Desending")
                        }
                    }
                }
                else {
                    if selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)) {
                        
                        cell.type.insert(.Selected)
                        
                    }
                    else {
                        
                    }
                }
                
                if isBlockedDate(indexPath: indexPath) {
                    
                    if todayDay == curDay, todayMonth == month, todayYear == year  {
                        
                        if one_select == "false" {
                            self.one_select = "true"
                            cell.type.insert(.Selected)
                            cell.type.insert(.Today)
                            let dateComp = DateComponents(year: year, month: month, day: todayDay)
                            let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                            self.offDates.append(Int(selectedDate.timeIntervalSince1970))
                            selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                            print("selecteddatea",self.selectedBookingDate)
                            print("selecteddatea",self.offDates)
                            delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                        }
                        
                    } else {
                        cell.type.remove(.Selected)
                        cell.type.insert(.Disabled)
                    }
                    
                }
                if isWeekDay(indexPath: indexPath) {
                    cell.type = []
                    cell.type.insert(.leaveDate)
                }
                if TodayDate(indexPath: indexPath){
                    cell.type.insert(.Today)
                }
                
            }
        }
        
        

        cell.configureCell()
    }
    func configure1(cell: DateCollectionViewCell, withIndexPath indexPath: IndexPath) {
        let dateData = days[selectedIndex]
        let month = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.months[selectedIndex])
        let year = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.months[indexPath.section])
        cell.type = [.Empty]
        if indexPath.item < dateData.prepend || indexPath.item >= (dateData.prepend + dateData.days) {
            cell.dateLabel.text = ""
            cell.type = [.Empty]
        } else {
            let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
            let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
            let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
            let curDay = indexPath.item - dateData.prepend + 1
            let isPastDate = year == todayYear && month == todayMonth && curDay < todayDay
            cell.dateLabel.text = String(curDay)
            cell.dateLabel.textColor = isPastDate ? (UIColor(named: "fifth_text") ?? .white) : (UIColor(named: "primary_text") ?? .white)
            cell.type = isPastDate ? [.PastDate] : [.Date]
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                cell.type.insert(.Today)
            }
        }
        
        if self.isFromCalendar {
            if isBlockedDate(indexPath: indexPath) {
                cell.type.insert(.Disabled)
            }
            if isBookedDate(indexPath: indexPath) && !cell.type.contains(.PastDate){
                cell.type.insert(.Booked)
            }
            if isWeekDay(indexPath: indexPath) {
                cell.type = []
                cell.type.insert(.leaveDate)
            }
        }
        else {
            let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
            
            let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
            let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
            
            let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text ?? ""))
            let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
            if cell.type.contains(.Today) && !isBlockedDate(indexPath: indexPath) && !isWeekDay(indexPath: indexPath){
                if selectedBookingDate == 0 || selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)){
                    cell.type.insert(.Selected)
                    selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                    delegate?.selectedBookingDate(selectedBookingDate, isSelect: false, type: "")
                    self.selectedDateIndex = indexPath
                }
                else {
                    let order = Utility.calendar.compare(Date(timeIntervalSince1970: Double(selectedBookingDate)), to: selectedDate, toGranularity: .day)
                    switch order {
                    case .orderedSame:
                        cell.type.insert(.Selected)
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                        delegate?.selectedBookingDate(                selectedBookingDate, isSelect: false, type: "")
                        self.selectedDateIndex = indexPath
                    case .orderedAscending:
                        print("Ascending")
                    case .orderedDescending:
                        print("Desending")
                    }
                }
            }
            else {
                if selectedBookingDate == (Int(selectedDate.timeIntervalSince1970)) {
                    cell.type.insert(.Selected)
                }
                else {
                    
                }
            }
            if isBlockedDate(indexPath: indexPath) {
                cell.type.remove(.Selected)
                cell.type.insert(.Disabled)
            }
            if isWeekDay(indexPath: indexPath) {
                cell.type = []
                cell.type.insert(.leaveDate)
            }
        }
        
        

        cell.configureCell()
    }
    func isWeekDay(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        for day in self.holidayArray {
            let weekDayIndex = Utility.calendar.component(.weekday, from: currentDate)
            let weekDay = DatePickerData.shared.dateFormatter.weekdaySymbols[weekDayIndex-1]
            print("weekDay\(weekDay), day\(day)")
            if (weekDay.lowercased() == day.lowercased()) {
                return true
            }
        }
        return false
    }
    func isBlockedDate(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        if self.isFromCalendar {
            if self.calenderData != nil {
                for avl in (self.calenderData?.offdate ?? [Int]()) {
                    let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                    if (currentDate == startAvlDate) {
                        return true
                    }
                }
            }
        }
        else {
            for avl in self.offDates {
                let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                if (currentDate == startAvlDate) {
                    return true
                }
            }
        }
        return false
    }
    func isBookedDate(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        
        let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
        let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
        let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
        
        
        if self.isFromCalendar {
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                return true
            }
            if self.calenderData != nil {
                
                for avl in (self.calenderData?.booked_dates ?? [Int]()) {
                    let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                    if (currentDate == startAvlDate) {
                        return true
                    }
                }
            }
            
            
            
        }
        else {
            
        }
        return false
    }
    func TodayDate(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        
        let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
        let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
        let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
        
        
        if self.isFromCalendar {
        
            if todayDay == curDay, todayMonth == month, todayYear == year  {
                return true
            }
            
        }
         else {
//             if todayDay == curDay, todayMonth == month, todayYear == year  {
//                 return true
//             }
             
        }
        return false
    }
    func isselectedDate(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        
        let todayYear = DatePickerData.shared.calendar.component(.year, from: DatePickerData.shared.today)
        let todayMonth = DatePickerData.shared.calendar.component(.month, from: DatePickerData.shared.today)
        let todayDay = DatePickerData.shared.calendar.component(.day, from: DatePickerData.shared.today)
        
        
        if self.isFromCalendar {
           
            if self.calenderData != nil {
                
                for avl in (self.selected_dates) {
                    let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                    if (currentDate == startAvlDate) {
                        return true
                    }
                }
            }
            
            
        }
        else {
            
        }
        return false
    }
    func isBookedDate1(indexPath: IndexPath) -> Bool {
        let selectedMonth = DatePickerData.shared.months[selectedIndex]
        let dateData = DatePickerData.shared.days[selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        let curDay = indexPath.item - dateData.prepend + 1
        
        let dateComp = DateComponents(year: year, month: month, day: Int(curDay))
        let currentDate = DatePickerData.shared.calendar.date(from: dateComp)!
        
        if self.isFromCalendar {
            if self.calenderData != nil {
                for avl in (self.calenderData?.booked_dates ?? [Int]()) {
                    let startAvlDate = Date(timeIntervalSince1970: Double(avl))
                    if (currentDate == startAvlDate) {
                        return true
                    }
                }
            }
        }
        else {
            
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("Type",UserDefaultModule.shared.getLoginData().type)
            if UserDefaultModule.shared.getLoginData().type == "doctor" {
                let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
                let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
                
                let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
                let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
                
                let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
                let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                print("SELECTEDDATE:\(selectedDate)")
                
                if isFromCalendar {
                    if self.offDates.contains(Int(selectedDate.timeIntervalSince1970)){
                        cell.type.remove([.Selected])
                        
                        self.offDates.removeAll(where: {$0 == Int(selectedDate.timeIntervalSince1970)})
                    }
                    else {
                        
                        cell.type.insert(.Selected)
//                        self.selected_dates.append(Int(selectedDate.timeIntervalSince1970))
//                        print("selecteddatea",self.selected_dates)
                        self.offDates.append(Int(selectedDate.timeIntervalSince1970))
                    }
                    self.selected_dates = self.offDates
                    print("self.offDates",self.offDates)
                    print("self.offDates",self.selected_dates)
                    delegate?.selectedDate(self.offDates)
                    print("indexPath",indexPath)
                    selectedDateIndex = indexPath
                   
                    selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                    delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                }
                else {
                    if selectedBookingDate == Int(selectedDate.timeIntervalSince1970) {
                        cell.type.remove([.Selected])
                        selectedBookingDate = 0
                    }
                    else {
                        if selectedDateIndex != nil, let prevStartCell = collectionView.cellForItem(at: selectedDateIndex!) as? DateCollectionViewCell {
                            prevStartCell.type.remove(.Selected)
                            prevStartCell.configureCell()
                            collectionView.deselectItem(at: selectedDateIndex!,  animated: false)
                        }
                        selectedDateIndex = indexPath
                        cell.type.insert(.Selected)
                        selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                    }
                    delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                }
                cell.configureCell()
                updateSelectedUI()
            } else {
           let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
                 
                    let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
                    
                    let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
                    let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
                    
                    let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
                    let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
                    print("SELECTEDDATE:\(selectedDate)")
                self.one_select = "true"
                    self.today_select = "true"
                    if selectedDateIndex != nil, let prevStartCell = collectionView.cellForItem(at: selectedDateIndex!) as? DateCollectionViewCell {
                        prevStartCell.type.remove(.Selected)
                        
                        prevStartCell.configureCell()
                        collectionView.deselectItem(at: selectedDateIndex!,  animated: false)
                    }
                updateSelectedUI()
                    
                    selectedDateIndex = indexPath
                    cell.type.insert(.Selected)
                    selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
                    
                delegate?.selectedBookingDate(selectedBookingDate, isSelect: true, type: "clicked")
                    cell.configureCell()
                }
                
           
    //        self.loadData()
    //        for val in bookingdates{
    //            for ofdate in offDates{
    //            if val == ofdate{
    //                for state in self.viewModel1.historyModel?.result ?? []{
    //                    if state.orderstatus == "paid"{
    //                        self.status = true
    //                    }
    //                    break
    //                }
    //            }
    //            }
    //        }
            
        }
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        let selectedMonth = DatePickerData.shared.months[self.selectedIndex]
        
        let year = DatePickerData.shared.calendar.component(.year, from: selectedMonth)
        let month = DatePickerData.shared.calendar.component(.month, from: selectedMonth)
        
        let dateComp = DateComponents(year: year, month: month, day: Int(cell.dateLabel.text!))
        let selectedDate = DatePickerData.shared.calendar.date(from: dateComp)!
        print("SELECTEDDATE:\(selectedDate)")
        if isFromCalendar {
            if self.offDates.contains(Int(selectedDate.timeIntervalSince1970)){
                cell.type.remove([.Selected])
                self.offDates.removeAll(where: {$0 == Int(selectedDate.timeIntervalSince1970)})
            }
            else {
                cell.type.insert(.Selected)
                self.offDates.append(Int(selectedDate.timeIntervalSince1970))
            }
            delegate?.selectedDate(self.offDates)
        }
        else {
            if selectedBookingDate == Int(selectedDate.timeIntervalSince1970) {
                cell.type.remove([.Selected])
                selectedBookingDate = 0
            }
            else {
                if selectedDateIndex != nil, let prevStartCell = collectionView.cellForItem(at: selectedDateIndex!) as? DateCollectionViewCell {
                    prevStartCell.type.remove(.Selected)
                    prevStartCell.configureCell()
                    collectionView.deselectItem(at: selectedDateIndex!,  animated: false)
                }
                selectedDateIndex = indexPath
                cell.type.insert(.Selected)
                selectedBookingDate = (Int(selectedDate.timeIntervalSince1970))
            }
            delegate?.selectedBookingDate(selectedBookingDate, isSelect: true)
        }
        
        cell.configureCell()
        updateSelectedUI()
//        self.loadData()
//        for val in bookingdates{
//            for ofdate in offDates{
//            if val == ofdate{
//                for state in self.viewModel1.historyModel?.result ?? []{
//                    if state.orderstatus == "paid"{
//                        self.status = true
//                    }
//                    break
//                }
//            }
//            }
//        }
        
    }*/
    func updateSelectedUI() {
        
    }
    func loadData() {
        if (UserDefaultModule.shared.getLoginData().type ?? "").lowercased() == "doctor" {
            self.doctorType = "doctor"
        }
        else {
            self.doctorType = "user"
        }
        self.viewModel1.viewList(user_id: (UserDefaultModule().getCurrentUserID() as String? ?? ""),type: self.doctorType, date: 0,booking_type: historyType, offset: "\(offset)", limit: "\(limit)", onSuccess: { (success) in
            print(success)
                    if self.historyType == "current" {
                        if self.offset == 0 {
                            self.ListData.removeAll()
                        }
                        self.ListData += self.viewModel1.historyModel!.result
                    }
                }) { (failure) in
            print(failure)
        }
    }
}

extension DatePickerCollectionViewCell : updateSelectedDateDelegate {
    
    func selectedDate(_ calenderData: [Int]) {
        self.selected_dates = calenderData
        print("calenderdatea",calenderData)
    }
    
    func selectedBookingDate(_ selectedDate: Int, isSelect: Bool,type: String) {
        print("selectedDate selectedDate selectedDate")
        print(selectedDate)
    }
    
    
}
