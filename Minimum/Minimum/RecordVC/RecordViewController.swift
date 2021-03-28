//
//  RecordViewController.swift
//  Minimum
//
//  Created by park wonyoung on 2021/02/25.
//

import UIKit

//data 테스트
struct TestData {
    var date : Date?
    var weight : Double?
    var memo : String?
    var image : UIImage?
}

//data 테스트
var data = TestData(date: nil, weight: nil, memo: nil, image: nil)
var dataArray = [TestData]()
var note = Note(date: Date(), weight: 0.0, memo: nil, imagePath: nil)
var noteArray = [Note]()

//Emoji.saveToFile(emojis: emojisCategorized)

class RecordViewController: UIViewController, UITextViewDelegate {
    
    //날짜//
    @IBOutlet weak var recordedDate: UIButton!
    @IBOutlet weak var selectDatePicker: UIDatePicker!
    
    //체중
    @IBOutlet weak var weightTextField: UITextField!
    
    
    //메모//
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var countCharacterLabel: UILabel!
    
    //사진//
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePhoto: UIButton!
    
    var arrayNum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //날짜//
        loadDate()
        
        //날짜//DatePicker 기본 설정
        selectDatePicker.datePickerMode = .date
        selectDatePicker.preferredDatePickerStyle = .wheels
        selectDatePicker.isHidden = true
        
        //메모//
        memoTextView.delegate = self
        
        //메모// placeholder
        memoTextView.text = "메모를 입력해주세요"
        memoTextView.textColor = .lightGray


    }
    
    //날짜// view load시 현재 날짜 자동 입력
    func loadDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let dateString = formatter.string(from: date)
        recordedDate.setTitle(dateString, for: .normal)
        
        //data
        data.date = date
        
        //저장용
        note.date = date
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
        
        let dateString = formatter.string(from: sender.date)
        recordedDate.setTitle(dateString, for: .normal)
        
        //data
        data.date = sender.date
    }
    
    //날짜// view 아무데나 누르면 pikcerView 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        selectDatePicker.isHidden = true
    }
    
    //메모// place holder 제거
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //메모// place holder 강제
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모를 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //메모// 글자 수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let limitLength = 60
        
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        
        countCharacterLabel.text = "\(str.count + 1) / 60"
        
        //data
        data.memo = str
        
        //저장용
        note.memo = str
        return newLength < limitLength
    }
    
    //사진// 버튼
    @IBAction func cameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    

    //Cancelbutton//
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //완료//
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        //data// 저장
        saveData()
        
        //화면 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveData() {
        
        //data// 몸무게
        if let recordedWeight = Double(weightTextField.text!) {
            data.weight = recordedWeight
            
            //저장용
            note.weight = recordedWeight
        } else { //몸무게 기록 없으면 alert
            showWeightInfoAlert()
        }
        
        
        data.memo = memoTextView.text
        
        //저장용
        note.memo = memoTextView.text
        
        if dataArray.count == 0 { //기록이 없으면 바로 data 추가
            dataArray.append(data)
            
            noteArray.append(note)
            
            Note.saveToFile(notes: [noteArray])
            
            print(dataArray)
        } else { //기록이 존재하면 날짜 같은 data update
            for recordedData in dataArray {
                            
                let formatter = DateFormatter()
                formatter.dateFormat = "MM월 dd일, 20YY"
                
                let tempData = formatter.string(from: recordedData.date!)
                let comparedData = formatter.string(from: data.date!)
                
                if tempData == comparedData {
                    print("동일한 날짜의 data가 이미 있습니다.")
                    
                    let tempArrayNum = arrayNum
                    print(tempArrayNum)
                    
                    dataArray[tempArrayNum].date = data.date
                    dataArray[tempArrayNum].weight = data.weight
                    dataArray[tempArrayNum].memo = data.memo
                    dataArray[tempArrayNum].image = data.image
                    
                    print(dataArray)
                    
                    noteArray.append(note)
                    print(">>>>>>>>")
                    print(">>>>>>>>")
                    print(noteArray)
                    
                    Note.saveToFile(notes: [noteArray])
                    
                } else {
                    print("새로운 날짜의 기록입니다.")
                    dataArray.append(data)
                    print(dataArray)
                    
                    noteArray.append(note)
                    print(">>>>>>>>")
                    print(">>>>>>>>")
                    print(noteArray)
                    
                    Note.saveToFile(notes: [noteArray])
                }
                
                arrayNum += 1
            }
        }
        
        
    }
    
    func showWeightInfoAlert() {
        let alert = UIAlertController(title: "체중 입력", message: "체중이 입력되지 않았습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
            print("tapped dismiss")
        }))
        
        present(alert, animated: true)
        
    }

    //사진 경로 저장
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"

        let filename = dateFormatter.string(from: Date()).appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            return String.init("/Documents/\(filename)")

        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
    }
    
    
    
    
   
    
    

}

//사진//
extension RecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        //imageView.image = image
        data.image = image
        
        print("----------")
        print(saveImageToDocumentDirectory(image))
        
//        imageView.image =
//        print(UIImage(contentsOfFile: "/Documents/20210328101417"))
        
        var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath)
        
        documentsPath.append("/20210328101726.jpg")
        imageView.image = UIImage(contentsOfFile: documentsPath)
        
        takePhoto.setTitle("", for: .normal)
    }
    
}
