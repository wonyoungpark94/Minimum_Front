//
//  ViewController.swift
//  chartTest
//
//  Created by kaist on 26/02/2021.
//  Copyright © 2021 KAISThelloWorldyy. All rights reserved.
//
import Charts
import UIKit
import QuartzCore

class ChartViewController: UIViewController, ChartViewDelegate {

 
    @IBOutlet weak var period: UILabel!
    
    @IBOutlet weak var weightVariation: UILabel!
    
    @IBOutlet weak var gainOrLose: UILabel!
    
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DayChangeButton(_ sender: UISegmentedControl) {
           switch sender.selectedSegmentIndex{
           case 0:
            let category: String = "Day"  // 날짜 분별을 위한 카테고리
            let yvaluesDay = DatasetEntries(category: category)
            setData(dataset: yvaluesDay, category: days)
            BottomDisplay(weightList: yvaluesDay)
           case 1:
            let category: String = "Week"  // 날짜 분별을 위한 카테고리
            let yvaluesWeek = DatasetEntries(category: category)
            setData(dataset: yvaluesWeek, category: weeks)
            BottomDisplay(weightList: yvaluesWeek)
           case 2:
            let category: String = "Month"  // 날짜 분별을 위한 카테고리
            let yvaluesMonth = DatasetEntries(category: category)
            setData(dataset: yvaluesMonth, category: months)
            BottomDisplay(weightList: yvaluesMonth)
           default:
            let category: String = "Day"  // 날짜 분별을 위한 카테고리
            let yvalues = DatasetEntries(category: category)
            setData(dataset: yvalues, category: days)
            BottomDisplay(weightList: yvalues)
            break
            }
    }
    var notes: [Note] = []
    var sortedNotes: [Note] = []
    
    var daysDic:[Int:Double] = [:]
    
    //월화수목금토일
    var yValues: [ChartDataEntry] = [
//         ChartDataEntry(x:0, y: 1),
//         ChartDataEntry(x:1, y: -0.9),
//         ChartDataEntry(x:2, y: -0.5),
//         ChartDataEntry(x:3, y: 0.3),
//         ChartDataEntry(x:4, y: 0.2),
//         ChartDataEntry(x:5, y: -0.1),
//         ChartDataEntry(x:6, y: -0.1),
     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        sortData()
        daysData()
        
        view.backgroundColor = #colorLiteral(red: 0.2045887411, green: 0.4775372744, blue: 0.942905724, alpha: 1)
        // Do any additional setup after loading the view.
        setData(dataset: yValues, category: days)
        lineChartView.delegate = self
        // summary view corner setting
        summaryView.layer.cornerRadius = 20;
        summaryView.backgroundColor = #colorLiteral(red: 0.9287869334, green: 0.9446232915, blue: 0.9777924418, alpha: 1)
        
        // Bottom display
        BottomDisplay(weightList: yValues)
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
    
    //segment : day
    func daysData(){
        let today = Date()
        let yesterDay = today.addingTimeInterval(-86400)
        let twoDaysAgo = today.addingTimeInterval(-86400 * 2)
        let threeDaysAgo = today.addingTimeInterval(-86400 * 3)
        let fourDaysAgo = today.addingTimeInterval(-86400 * 4)
        let fiveDaysAgo = today.addingTimeInterval(-86400 * 5)
        let sixDaysAgo = today.addingTimeInterval(-86400 * 6)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let days = [
            formatter.string(from: today),
            formatter.string(from: yesterDay),
            formatter.string(from: twoDaysAgo),
            formatter.string(from: threeDaysAgo),
            formatter.string(from: fourDaysAgo),
            formatter.string(from: fiveDaysAgo),
            formatter.string(from: sixDaysAgo)
        ]
        
        let count = sortedNotes.count
        
        //일주일 이내 data와 같은게 있다면 daysDic에 집어넣어라
        for i in 0..<count{
            if formatter.string(from: sortedNotes[i].date) == days[0]{
                daysDic[0] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[1] {
                daysDic[1] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[2] {
                daysDic[2] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[3] {
                daysDic[3] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[4] {
                daysDic[4] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[5] {
                daysDic[5] = sortedNotes[i].weight
            } else if formatter.string(from: sortedNotes[i].date) == days[6] {
                daysDic[6] = sortedNotes[i].weight
            }
        }
        print(daysDic) // 값만 받아옴
        
        
        let sorteddaysDicKeys = Array(daysDic.keys).sorted(by: >)
        print(sorteddaysDicKeys) //daysDic key값 내림차순 정렬
        print("----------")
        
        var sorteddaysDicValues = Array(daysDic.values).sorted(by: >) //갯수 맞게 array 생성
        
        sorteddaysDicValues[0] = Double(0)
        
        for i in 1..<sorteddaysDicKeys.count{
            sorteddaysDicValues[i] = daysDic[4 - i]! - daysDic[5 - i]! //sorteddaysDicKeys에 맞게 값 뿌려주기
        }
        print("----------")
        print(sorteddaysDicValues)
        
        
        for i in 0..<sorteddaysDicKeys.count {
            yValues.append(ChartDataEntry(x:Double(6 - sorteddaysDicKeys[i]), y: sorteddaysDicValues[i]))
        }
        
        print(yValues)
    }

    // x 축 날짜로 변환
    let days = ["6일 전","5일 전","4일 전","3일 전","2일 전","1일 전","오늘"]
    //화 목이 없으면 없애는 방식으로.
    
    let weeks = ["6주 전","5주 전","4주 전","3주 전","2주 전","1주 전","이번 주"]
    let months = ["6달 전","5달 전","4달 전","3달 전","2달 전","1달 전","이번 달"]
    // 기본 더미 데이터
    
    
    
    // 세트를 만들고 라인을 만드는 곳임.
    func setData(dataset: [ChartDataEntry], category: Array<Any>){
        // Line 관리
        let set1 = LineChartDataSet(entries: dataset, label: "Weights")
        set1.drawCirclesEnabled = true  // 값들을 원으로 표시
        set1.mode = .linear   //꺽은선그래프로 할 건지, 어떻게 할 것인지
        set1.lineWidth = 3
        set1.setColor(.white)
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.drawHorizontalHighlightIndicatorEnabled = false
        // line chart  에 설정을 넣는 곳이다.
        
        let data = LineChartData(dataSet: set1)
        // 값 위 색
        data.setValueTextColor(.white)
        // 값 표시 여부
        lineChartView.backgroundColor = #colorLiteral(red: 0.2045887411, green: 0.4775372744, blue: 0.942905724, alpha: 1)
        lineChartView.fitScreen()
            
        lineChartView.rightAxis.enabled = false
        
        data.setDrawValues(false)
        let yAxis = lineChartView.leftAxis
        ChartYaxis(yAxis: yAxis)        // y축 설정
        let xAxis = lineChartView.xAxis
        ChartXaxis(xAxis: xAxis, xAxisFormat: category)        // x축 설정
        let Legend = lineChartView.legend
        ChartLegend(legend: Legend)     // legend설정
        lineChartView.data = data
        //        chartView.animate(yAxisDuration: 1)
    }
    
    func ChartYaxis(yAxis: YAxis){
          yAxis.labelFont = .boldSystemFont(ofSize: 12)
          yAxis.setLabelCount(6, force: false)
          yAxis.labelTextColor = .white
          yAxis.axisLineColor = .white
          yAxis.labelPosition = .outsideChart
          yAxis.drawGridLinesEnabled = false
      }
    func ChartXaxis(xAxis: XAxis, xAxisFormat: Array<Any>){
          xAxis.labelPosition = .bottom
          xAxis.labelFont = .boldSystemFont(ofSize: 12)
          xAxis.setLabelCount(7, force: true)
          xAxis.labelTextColor = .white
          xAxis.axisLineColor = .white
          xAxis.labelCount =  5
          xAxis.axisMinimum = 0
          xAxis.drawGridLinesEnabled = false

          //            // 날짜 변환

          xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisFormat as! [String])
      }
    
    func ChartLegend(legend: Legend){
          legend.textColor = .white
          legend.horizontalAlignment = .right
          legend.verticalAlignment = .top
          legend.yOffset = 30
          legend.drawInside = true
        
      }
      
//
    func BottomDisplay(weightList: [ChartDataEntry]) -> Void{
        // 데이터 길이가 최소 2개 이상이여야 bottom display  에 표기 가능
        let dataLength = weightList.count
        // 2개 이상의 데이터에서
        if (dataLength>1){
            let firstWeight = weightList.first?.y
            let lastWeight = weightList.last?.y
            let variationWeight = round((lastWeight!-firstWeight!) * 10) / 10 //소숫점 자리수 표현
            weightVariation.text = String(variationWeight)+"kg"
            
            if (firstWeight!<lastWeight!){
                gainOrLose.text = "살 쪘어요"
                weightVariation.textColor = .systemRed
            }
            else if (firstWeight!==lastWeight!){
                gainOrLose.text = "변화가 없어요"
                weightVariation.textColor = .systemGray
            }
            else {
                gainOrLose.text = "살이 빠졌어요"
                weightVariation.textColor = .systemBlue
                }
            }

        else  {
            weightVariation.text = "0kg"
            weightVariation.textColor = .green
            gainOrLose.text = "내일 한번 더 무게를 측정해 주세요"

        }

    }
//
    // 차트를 일/주/달 에 따라서 다른 데이터를 가져온다는 의미를 가진 함수
    
     func DatasetEntries (category: String)-> [ChartDataEntry]{
            if (category == "Day"){
//                let yValues: [ChartDataEntry] = [
//                    ChartDataEntry(x:0, y: -0.8),
//                    ChartDataEntry(x:1, y: 0),
//                    ChartDataEntry(x:2, y: -0.5),
//                    ChartDataEntry(x:3, y: 0.3),
//                    ChartDataEntry(x:4, y: 0.2),
//                    ChartDataEntry(x:5, y: -0.1),
//                    ChartDataEntry(x:6, y: -1),
//                ]
                daysData()
            return yValues
            }
            else if (category == "Week"){
                let yValues: [ChartDataEntry] = [
                    ChartDataEntry(x:0, y: 0),
                    ChartDataEntry(x:1, y: 2),
                    ChartDataEntry(x:2, y: 2),
                    ChartDataEntry(x:3, y: 1),
                    ChartDataEntry(x:4, y: -4),
                    ChartDataEntry(x:5, y: -3),
                    ChartDataEntry(x:6, y: 4),
                ]
            return yValues
            }
            else if (category == "Month") {
                let yValues: [ChartDataEntry] = [
                    ChartDataEntry(x:0, y: -3),
                    ChartDataEntry(x:1, y: -4),
                    ChartDataEntry(x:2, y: -1),
                    ChartDataEntry(x:3, y: 0),
                    ChartDataEntry(x:4, y: 2),
                    ChartDataEntry(x:5, y: 2),
                    ChartDataEntry(x:6, y: 3),
                ]
            return yValues
            }
            else {
        return yValues
        }
    }
}

