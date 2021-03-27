//
//  ViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/02/25.
//

import UIKit

import Foundation
//import FSCalendar

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    
    let firstRecordDays = ["03월 01일, 2021"]
    let plusRecordDays = ["03월 02일, 2021"]
    let minusRecordDays = ["03월 03일, 2021"]
    let maintainRecordDays = ["03월 04일, 2021"]
    let noRecordDays = ["03월 05일, 2021"]
    let noTodayRecordDay = ["03월 24일, 2021"]
    
//    let data: [CalendarModel] = [CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "FirstRecord"),
//                                 CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "TodayNoRecord"),
//                                 CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "MinusRecord"),
//                                 CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "PlusRecord"),
//                                 CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "MaintainRecord"),
//                                 CalendarModel(image: #imageLiteral(resourceName: "calendarRecord"), dayOfMonth: "NoRecord")]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 20
        
//        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        
        setCellsView()
        setMonthView()
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView()
    {
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                totalSquares.append("")
            }
            else
            {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    // 셀에 숫자를 입혀주고, 기록에 따라 적당한 아이콘을 보여줌
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.label.text = totalSquares[indexPath.item]
        
        if (cell.dayOfMonth.text != "") {
            let day = CalendarHelper().itemMonth(date: selectedDate, day: Int(cell.dayOfMonth.text!)!)
            
            if (firstRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "first_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (minusRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "minus_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (plusRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "plus_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (maintainRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "maintain_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (noRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "no_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (noTodayRecordDay.contains(day)) {
                cell.image.image = UIImage(named: "today_no_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else {
                cell.dayOfMonth.isHidden = false
                cell.image.isHidden = true
                cell.label.isHidden = true
            }
        }
        else {
            cell.dayOfMonth.isHidden = true
            cell.image.isHidden = true
            cell.label.isHidden = true
        }
        
        return cell
    }
    
    // 기록이 있는 날짜 셀 선택 시, HistoryView로 이동
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
       
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.label.text = totalSquares[indexPath.item]
        
        if (cell.dayOfMonth.text != "") {
            let day = CalendarHelper().itemMonth(date: selectedDate, day: Int(cell.dayOfMonth.text!)!)
            
            if (firstRecordDays.contains(day) || minusRecordDays.contains(day) || plusRecordDays.contains(day) || maintainRecordDays.contains(day)) {
                
                if cell.isSelected {
                    collectionView.deselectItem(at: indexPath, animated: true)
                    let vcName = self.storyboard?.instantiateViewController(withIdentifier: "HistoryView")
                    vcName?.modalTransitionStyle = .coverVertical
                    self.present(vcName!, animated: true, completion: nil)
                    return false
               }
                else {
                    return true
               }
            }
        }
        
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
           return false
       }
        else {
           return true
        }
   }
    
    @IBAction func previousMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
}




