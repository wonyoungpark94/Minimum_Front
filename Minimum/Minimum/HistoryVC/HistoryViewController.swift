//
//  HistoryViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/02/25.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let element = ["1", "2", "3", "4"]
    
    struct CellData {
        var date : String?
        var weight : String?
        var memo : String?
        var image : UIImage?
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //더미데이터 test
    let dataList = [
        CellData(date: "2021년 1월 21일 오전 10시 17분", weight: "1일 전과 비교해서 +0.2kg", memo: "어제 고은이랑 떡볶이를 먹었다. 내가 미쳤지", image: nil),
        CellData(date: "2021년 1월 20일 오전 10시 01분", weight: "1일 전과 비교해서 -0.3kg", memo: "야식을 안 먹고 잤더니 몸이 가볍네", image: nil),
        CellData(date: "2021년 1월 19일 오전 09시 52분", weight: "1일 전과 비교해서 -0.2kg", memo: "어제 운동 빡시게 함!!!", image: nil),
        CellData(date: "2021년 1월 18일 오전 10시 02분", weight: "2일 전과 비교해서 -0.0kg", memo: "며칠 째 그대로네", image: nil),
        CellData(date: "2021년 1월 16일 오전 09시 52분", weight: "1일 전과 비교해서 -0.0kg", memo: "운동하고나서 찜닭먹었더니 ㅜㅜ", image: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        cell.dateLabel.text = dataList[indexPath.row].date
        cell.weightLabel.text = dataList[indexPath.row].weight
        cell.memoLabel.text = dataList[indexPath.row].memo
        
        return cell
    }

}
