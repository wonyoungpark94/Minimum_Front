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
    
//    var firstRecordDays = ["03월 01일, 2021"]
//    var plusRecordDays = ["03월 02일, 2021"]
//    var minusRecordDays = ["03월 03일, 2021"]
//    var maintainRecordDays = ["03월 04일, 2021"]
//    var noRecordDays = ["03월 05일, 2021"]
//    var noTodayRecordDay = ["03월 24일, 2021"]
    
    var firstRecordDays = [""]
    var plusRecordDays = [""]
    var minusRecordDays = [""]
    var maintainRecordDays = [""]
    var noRecordDays = [""]
    var noTodayRecordDay = [""]
    
    //data 받아오기
    var notes: [Note] = []
    var sortedNotes: [Note] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadData()
        sortData()
        uploadCalendarIcon()
        uploadTodayIcon()
        
        let count = notes.count

        for i in 0..<count {
            print("\(sortedNotes[i].date), \(sortedNotes[i].weight), \(sortedNotes[i].memo), \(sortedNotes[i].imagePath) \n")
        }
        
        //상단 뷰 r값
        mainView.layer.cornerRadius = 20
        
        //collectionview 셋팅
        collectionView.register(UINib.init(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        setCellsView()
        setMonthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        sortData()
        uploadCalendarIcon()
        uploadTodayIcon()
        setCellsView()
        setMonthView()
    }
    
    //data 가져오기
    func loadData(){
        let loadedNoteFile = Note.loadFromFile()
        
        if loadedNoteFile.count > 0 { //data가 저장되어 있으면
            notes = loadedNoteFile[0]
            print(notes)
            print("저장된 데이터가 있어서 데이터를 불러옵니다.")
            print("----------")
        } else { //data가 하나도 없으면 sample data를 읽어와라
            notes = Note.loadSampleNotes()
            print(notes)
            print("더미데이터입니다.")
            print("----------")
        }
    }
    
    //date 기준으로 재정렬
    func sortData(){
        sortedNotes = notes.sorted { (first, second) -> Bool in
            return first.date < second.date
        }
    }
    
    func uploadCalendarIcon(){
        let count = sortedNotes.count
        let countMinusOne = count - 1
        
        //formmatting
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "MM월 dd일, 20YY"

        for i in 0..<countMinusOne {
            firstRecordDays = [formatter.string(from: sortedNotes[0].date)]
            if sortedNotes[i].weight < sortedNotes[i+1].weight {
                plusRecordDays.append(formatter.string(from: sortedNotes[i+1].date))
            } else if sortedNotes[i].weight > sortedNotes[i+1].weight {
                minusRecordDays.append(formatter.string(from: sortedNotes[i+1].date))
            } else {
                maintainRecordDays.append(formatter.string(from: sortedNotes[i+1].date))
            }
        }
    }
    
    func uploadTodayIcon(){
        let today = Date()
        let formatter = DateFormatter()
        var sameData = false
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        for i in 0..<sortedNotes.count{
            if today == sortedNotes[i].date {
                sameData = true
            }
        }
        
        if sameData == false {
            noTodayRecordDay = [formatter.string(from: today)]
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.label.text = totalSquares[indexPath.item]
        
        if (cell.dayOfMonth.text != "") {
            let day = CalendarHelper().itemMonth(date: selectedDate, day: Int(cell.dayOfMonth.text!)!)
//            print(day)
            
            if (firstRecordDays.contains(day)) {
                cell.image.image = UIImage(named: "first_record.png")
                cell.dayOfMonth.isHidden = true
                cell.image.isHidden = false
                cell.label.isHidden = false
            }
            else if (minusRecordDays.contains(day)) {
//                cell.layer.backgroundColor = UIColor.blue.cgColor
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




