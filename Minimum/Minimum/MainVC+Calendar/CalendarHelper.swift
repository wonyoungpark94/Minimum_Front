import Foundation
import UIKit

class CalendarHelper
{
    let calendar = Calendar.current
    
    func dateToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일, 20YY"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(dateString: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일, 20YY"
        return dateFormatter.date(from: dateString)!
    }
    
    func plusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(date: Date) -> Date
    {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func itemsMonth(date: Date) -> Array<String>
    {
        var days = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일, 20YY"
        
        let monthRange = calendar.range(of: .day, in: .month, for: date)!
        let totalDays = monthRange.count
        
        let components = calendar.dateComponents([.day], from: date)
        let selectedDay = components.day!
        
        for i in 1..<selectedDay
        {
            let tempDate = calendar.date(byAdding: .day, value: -i, to: date)!
            days.append(dateFormatter.string(from: tempDate))
        }
        
        for i in 0..<totalDays - selectedDay + 1
        {
            let tempDate = calendar.date(byAdding: .day, value: i, to: date)!
            days.append(dateFormatter.string(from: tempDate))
        }
        
        return days
    }
    
    func itemMonth(date: Date, day: Int) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일, 20YY"
        
        let components = calendar.dateComponents([.day], from: date)
        let selectedDay = components.day!
        
        let gap = selectedDay - day
        let tempDate = calendar.date(byAdding: .day, value: -gap, to: date)!
        
        return dateFormatter.string(from: tempDate)
    
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int
    {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int
    {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(date: Date) -> Date
    {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int
    {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
}
