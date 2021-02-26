//
//  Date+Extension.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/26.
//

import Foundation
import CalculateCalendarLogic

extension Date {
    
    //日付情報をフォーマットを整えて返す
    func dateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    //曜日判定(日曜日:1/土曜日:7)
    func judgeWeekday() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekday, from: self)
    }
    
    //祝日かどうかを判定
    func judgeHoliday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let holiday = CalculateCalendarLogic()
        let judgeHoliday = holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        return judgeHoliday
    }
    
    func dayInt() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let year = "\(calendar.component(.year, from: self))"
        let month = calendar.component(.month, from: self)
        let date = calendar.component(.day, from: self)
        let monthString = String(format: "%02d", month)
        let dateString = String(format: "%02d", date)
        return Int(year + monthString + dateString)!
    }
    
    func returnActiveColor(color: UIColor, offColor: UIColor) -> UIColor {
        if self.dayInt() < Date().dayInt(){
            return offColor
        }
        return color
    }
}
