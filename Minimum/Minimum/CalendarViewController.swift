//
//  CalendarViewController.swift
//  Minimum
//
//  Created by kkh on 2021/03/10.
//

import UIKit

import Foundation
import FSCalendar


class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet fileprivate weak var calendar: FSCalendar!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let fillSelectionColors = ["2021/03/08": UIColor.green, "2021/03/06": UIColor.purple, "2021/03/17": UIColor.gray, "2021/03/21": UIColor.cyan, "2021/04/08": UIColor.green, "2021/04/06": UIColor.purple, "2021/04/17": UIColor.gray, "2021/04/21": UIColor.cyan, "2021/05/08": UIColor.green, "2021/05/06": UIColor.purple, "2021/05/17": UIColor.gray, "2021/05/21": UIColor.cyan]

    
    let fillDefaultColors = ["2021/03/08": UIColor.purple, "2021/03/06": UIColor.green, "2021/03/18": UIColor.cyan, "2021/03/22": UIColor.yellow, "2021/04/08": UIColor.purple, "2021/04/06": UIColor.green, "2021/04/18": UIColor.cyan, "2021/04/22": UIColor.yellow, "2021/05/08": UIColor.purple, "2021/05/06": UIColor.green, "2021/05/18": UIColor.cyan, "2021/05/22": UIColor.magenta]
    
    let borderDefaultColors = ["2021/03/08": UIColor.brown, "2021/03/17": UIColor.magenta, "2021/03/21": UIColor.cyan, "2021/03/25": UIColor.black, "2021/04/08": UIColor.brown, "2021/04/17": UIColor.magenta, "2021/04/21": UIColor.cyan, "2021/04/25": UIColor.black, "2021/05/08": UIColor.brown, "2021/05/17": UIColor.magenta, "2021/05/21": UIColor.purple, "2021/05/25": UIColor.black]

    let borderSelectionColors = ["2021/03/08": UIColor.red, "2021/03/17": UIColor.purple, "2021/03/21": UIColor.cyan, "2021/03/25": UIColor.magenta, "2021/04/08": UIColor.red, "2021/04/17": UIColor.purple, "2021/04/21": UIColor.cyan, "2021/04/25": UIColor.purple, "2021/05/08": UIColor.red, "2021/05/17": UIColor.purple, "2021/05/21": UIColor.cyan, "2021/05/25": UIColor.magenta]
    
    var datesWithEvent = ["2021-03-03", "2021-03-06", "2021-03-05", "2021-03-25"]
    var datesWithMultipleEvents = ["2021-03-08", "2021-03-16", "2021-03-20", "2021-03-28"]
    
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 450 : 300
        let calendar = FSCalendar(frame: CGRect(x:0, y:64, width:self.view.bounds.size.width, height:height))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        self.view.addSubview(calendar)
        self.calendar = calendar
        calendar.select(self.dateFormatter1.date(from: "2021/03/10"))
        let todayItem = UIBarButtonItem(title: "TODAY", style: .plain, target: self, action: #selector(self.todayItemClicked(sender:)))
        self.navigationItem.rightBarButtonItem = todayItem
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
    }
    
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillSelectionColors[key] {
            return color
        }
        return appearance.selectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderSelectionColors[key] {
            return color
        }
        return appearance.borderSelectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        if [8, 17, 21, 25].contains((self.gregorian.component(.day, from: date))) {
            return 0.0
        }
        return 1.0
    }
    
}


