//
//  DatePickerData.swift
//  Meetdoc
//
//  Created by Hitasoft on 25/10/20.
//  Copyright © 2020 BTMani. All rights reserved.
//

import Foundation


class DatePickerData{
    static let shared = DatePickerData()
    var initialNumberOfMonths = 60
    
    var months: [Date]!
    var days: [(days: Int, prepend: Int, append: Int)]!
    var today: Date!
    var DayArray = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
    let dateFormatter = DateFormatter()
    var calendar: Calendar {
        return Utility.calendar
    }
    
    // Booking Selected Date
    var selectedDateArr = [Int]()
    let bookingArray = [["5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM"], ["12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM"], ["6 PM", "7 PM", "8 PM", "9 PM"], ["10 PM", "11 PM", "12 AM", "1 AM", "2 AM", "3 AM", "4 AM"]]

    func initDates() {
        today = Date()
        self.DayArray = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

//        print("TodayDate\(today)")
        let month = calendar.component(.month, from: today)
//        print("datepickermonth\(month)")
        let year = calendar.component(.year, from: today)
//        print("datepicker year\(year)")
        let dateComp = DateComponents(year: year, month: month, day: 1)
//        print("datepicker dateComp\(dateComp)")
        var curMonth = calendar.date(from: dateComp)
//        print("datepicker curMonth\(String(describing: curMonth))")
        
        months = [Date]()
        days = [(days: Int, prepend: Int, append: Int)]()
        
        
        
        for _ in 0..<initialNumberOfMonths {
            months.append(curMonth!)
            let numOfDays = calendar.range(of: .day, in: .month, for: curMonth!)!.count
//            print("numOfDays\(numOfDays)")
           
//            print("startofMonth\(curMonth!.startOfMonth())")
//            print("endofMonth\(curMonth!.endOfMonth())")
            
            let firstWeekDay = calendar.component(.weekday, from: curMonth!.startOfMonth())

            let lastWeekDay = calendar.component(.weekday, from: curMonth!.endOfMonth())
            print("firstWeekDay -->\(firstWeekDay)")
            print("lastWeekDay -->\(lastWeekDay)")
            
            days.append((days: numOfDays, prepend: firstWeekDay - 1, append: 7 - lastWeekDay))
            print("daysvalue -->\(days)")
            curMonth = calendar.date(byAdding: .month, value: 1, to: curMonth!)
            
          
            
//            print("curMonth\(curMonth)")
//            print("daysvalue\(days)")
        }
       
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Utility.calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    func startOfMonth() -> Date {
        var startofMonth = Utility.calendar.date(from: Utility.calendar.dateComponents([.year, .month], from: Utility.calendar.startOfDay(for: self)))!
//        print("startOfDay -- >\(Utility.calendar.startOfDay(for: self))")
//        let firstWeekDay123 = Utility.calendar.component(.weekday, from: startofMonth)
//        let firstweek098 = Utility.calendar.component(.weekdayOrdinal, from: Utility.calendar.startOfDay(for: self))
//        print("firstweek098 --> \(firstweek098)")
//        print("firstWeekDay123 -->\(firstWeekDay123)")
//       let islastdayofpre = startofMonth.dayBefore
//        print("\(islastdayofpre)")
        return startofMonth
    }
    func endOfMonth() -> Date {
//        print("EOM -->\(Utility.calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!)")
        return Utility.calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Utility.calendar.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Utility.calendar.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Utility.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Utility.calendar.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
