//
//  HistoryViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/02/25.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct CellData {
        var date : String?
        var comparedDay : String?
        var comparedWeight : String?
        var cellWeight : Double?
        var memo : String?
        var imagePath : String?
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //더미데이터 test
    var dataList = [CellData]()
    
    //data 받아오기
    var notes: [Note] = []
    var sortedNotes: [Note] = []
    
    var cellImagePath : String?
    var cellDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        sortData()
        getData()
//        print(sortedNotes[0].date)
//        print(sortedNotes[1].date)
//        print(sortedNotes[2].date)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //data 불러오기
    func loadData(){
        let loadedNoteFile = Note.loadFromFile()
        
        if loadedNoteFile.count > 0 { //data가 저장되어 있으면
            print("----------")
            print("저장된 데이터가 있어서 데이터를 불러옵니다.")
            notes = loadedNoteFile[0]
            print(notes)
        } else { //data가 하나도 없으면 sample data를 읽어와라
            notes = Note.loadSampleNotes()
            print("----------")
            print("더미데이터입니다.")
            print(notes)
        }
    }
    
    func sortData(){
        sortedNotes = notes.sorted { (first, second) -> Bool in
            //최근께 위로
            return first.date > second.date
        }
    }
    
    func getData(){
        for i in 0..<sortedNotes.count {
            let rawDate = sortedNotes[i].date
            let rawWeight = sortedNotes[i].weight
            var memo = sortedNotes[i].memo
            
            if memo == "메모를 입력해주세요" {
                memo = ""
            }
            print(rawDate)
            
            
            let imagePath = sortedNotes[i].imagePath
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier:"ko_KR")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            formatter.dateFormat = "20YY년 MM월 dd일 hh시 mm분"
            
            //date
            let date = formatter.string(from: rawDate)
            
            if i == sortedNotes.count - 1 { //마지막 data
                let comparedDay = "첫 기록입니다."
                let comparedWeight = "0.0kg"
                let cellWeight = 0.0
                let cellData = CellData(date: date, comparedDay: comparedDay, comparedWeight: comparedWeight, cellWeight: cellWeight, memo: memo, imagePath: imagePath)
                dataList.append(cellData)
            } else {
                let diffComponents = Calendar.current.dateComponents([.day], from: sortedNotes[i+1].date, to: sortedNotes[i].date)
                let hours = diffComponents.day
//                print(hours)
//                print(hours!/24)
//                let days = hours!/24
                
                let comparedDay = "이전 기록보다"

                let roundComparedWeight = round((sortedNotes[i].weight - sortedNotes[i + 1].weight) * 10) / 10 //소숫점 자리수 표현
                let comparedWeight = String(roundComparedWeight)+"kg"
                
                
                //let comparedWeight = "\(sortedNotes[i].weight - sortedNotes[i + 1].weight) kg"
                let cellWeight = sortedNotes[i].weight - sortedNotes[i + 1].weight
                
                let cellData = CellData(date: date, comparedDay: comparedDay, comparedWeight: comparedWeight, cellWeight: cellWeight, memo: memo, imagePath: imagePath)
                dataList.append(cellData)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        //cell에 data 뿌려주기
        cell.dateLabel.text = dataList[indexPath.row].date
        cell.changedDaysLabel.text = dataList[indexPath.row].comparedDay
        cell.changedWeightLabel.text = dataList[indexPath.row].comparedWeight
        cell.memoLabel.text = dataList[indexPath.row].memo
        
        //imagePath 없으면 이미지 버튼 없애기
        
        print("imagePath")
        print(dataList[indexPath.row].imagePath)
        
        if dataList[indexPath.row].imagePath != nil {
            cell.galleryOutlet.isHidden = false
        } else {
            cell.galleryOutlet.isHidden = true
        }
        
        //cell minus인지, plus인지에 따라 컬러 다르게
        if dataList[indexPath.row].cellWeight! < 0 {
            cell.changedWeightLabel.textColor = .systemBlue
        } else if dataList[indexPath.row].cellWeight! > 0 {
            cell.changedWeightLabel.textColor = .systemRed
        } else {
            cell.changedWeightLabel.textColor = .systemGray
        }
        
        //
        cell.vc = self
                
        return cell
    }
    
    //이미지 보여주기
    func showImage( cell: UITableViewCell ) {
        var indexPath = tableView.indexPath(for: cell)
        // do whatever you want!
        
        let date = dataList[indexPath!.row].date
        for i in 0..<notes.count {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier:"ko_KR")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            formatter.dateFormat = "20YY년 MM월 dd일 hh시 mm분"

            //print(i)

            //date
            let notesDate = formatter.string(from: notes[i].date)

            if date == notesDate {
                cellDate = date
                cellImagePath = notes[i].imagePath
            }
        }
    
        performSegue(withIdentifier: "showImage", sender: self)
        
        //print(indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showImage") {
            let vc = segue.destination as! ShowImageViewController
            vc.imagePath = cellImagePath
            vc.date = cellDate
        }
    }
    
//    //해당하는 data 지우기
//    func deleteCellData( cell: UITableViewCell ) {
//        let indexPath = tableView.indexPath(for: cell)
//
//        let date = dataList[indexPath!.row].date
//
//        for i in 0..<notes.count {
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier:"ko_KR")
//            formatter.timeZone = TimeZone(abbreviation: "KST")
//            formatter.dateFormat = "20YY년 MM월 dd일 hh시 mm분"
//
//            print(i)
//
//            //date
//            let notesDate = formatter.string(from: notes[i].date)
//
//            if date == notesDate {
//                print(i)
//                notes.remove(at: i)
//                Note.saveToFile(notes: [notes])
//                deleteAlert(date: date!)
//            }
//        }
//
//            loadData()
////        tableView.reloadData()
//    }
//
//    func deleteAlert(date: String) {
//        let alert = UIAlertController(title: "데이터 삭제", message: "\(date)의 기록이 삭제됩니다.", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
//            print("tapped dismiss")
//        }))
//
//        present(alert, animated: true)
//    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
