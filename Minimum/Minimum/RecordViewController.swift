//
//  RecordViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/02/25.
//

import UIKit

class RecordViewController: UIViewController, UITextFieldDelegate {
    
    //날짜//
    @IBOutlet weak var recordedDate: UIButton!
    @IBOutlet weak var selectDatePicker: UIDatePicker!
    
    
    //메모//
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var countCharacterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //날짜//
        loadDate()
        
        //날짜//DatePicker 기본 설정
        selectDatePicker.datePickerMode = .date
        selectDatePicker.preferredDatePickerStyle = .wheels
        selectDatePicker.isHidden = true
        
        //메모//
        memoTextField.delegate = self
        
        
    }
    
    //날짜// view load시 현재 날짜 자동 입력
    func loadDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let dateString = formatter.string(from: date)
        recordedDate.setTitle(dateString, for: .normal)
    }
    
    //날짜// 클릭 시 하단에서 pickerView 보이기&숨기기
    @IBAction func showDateButton(_ sender: Any) {
        if selectDatePicker.isHidden == false {
            selectDatePicker.isHidden = true
        } else {
            selectDatePicker.isHidden = false
         }
    }

    //날짜// datePicekr 조정하면 String 바꾸기
    @IBAction func selectDateAction(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let dataString = formatter.string(from: sender.date)
        recordedDate.setTitle(dataString, for: .normal)
    }
    
    //날짜// view 아무데나 누르면 pikcerView 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        selectDatePicker.isHidden = true
    }
    
    //메모// 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 60
        
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
        
            //print(text.count)
            countCharacterLabel.text = "\(text.count + 1) / 60"
        
            return newLength < limitLength
    }
    
    
    
    
    

    //완료//
    @IBAction func completeButtonTapped(_ sender: Any) {
        print("완료 버튼이 눌렸습니다.")
        
        //화면 이동
        self.navigationController?.popViewController(animated: true)
        
        //data 저장
    }

}
