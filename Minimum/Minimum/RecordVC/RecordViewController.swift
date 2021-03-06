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

var note = Note(date: Date(), weight: 0.0, memo: nil, imagePath: nil)
var notes: [Note] = []

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
    
    var defaultData = false
    var notesArrayNum = 0
    
    
    var sameDateData = false
    var sameArrayNum = 0
    var sameDay = ""
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //날짜//
        getDate()
        loadData()
        
        picker.delegate = self
        
        let count = notes.count
        let i = 0
        for i in 0..<count {
            print(notes[i].date)
            print(notes[i].weight)
        }
        
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
    
    //data 불러오기
    func loadData(){
        let loadedNoteFile = Note.loadFromFile()
        
        if loadedNoteFile.count > 0 { //data가 저장되어 있으면
            print("----------")
            print("저장된 데이터가 있어서 데이터를 불러옵니다.")
            notes = loadedNoteFile[0]
            print(notes)
            defaultData = false
        } else { //data가 하나도 없으면 sample data를 읽어와라
            notes = Note.loadSampleNotes()
            print("----------")
            print("더미데이터입니다.")
            print(notes)
            defaultData = true
        }
    }
    
    //날짜// view load시 현재 날짜 자동 입력
    func getDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let dateString = formatter.string(from: date)
        recordedDate.setTitle(dateString, for: .normal)
                
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
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "MM월 dd일, 20YY"
        
        let dateString = formatter.string(from: sender.date)
        recordedDate.setTitle(dateString, for: .normal)
        
        //저장용
        note.date = sender.date
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
                
        //저장용
        note.memo = str
        return newLength < limitLength
    }
    
    //사진// 버튼
    @IBAction func cameraButton(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)

        let alert =  UIAlertController(title: "눈바디 사진", message: "눈바디 이미지를 업로드 하기 위해 사진 선택 방식을 골라주세요.", preferredStyle: .actionSheet)


        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()

        }


        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in

        self.openCamera()

        }


        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)


        alert.addAction(library)

        alert.addAction(camera)

        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)


    }
    
    func openLibrary(){

      picker.sourceType = .photoLibrary

      present(picker, animated: false, completion: nil)

    }

    func openCamera(){

      picker.sourceType = .camera

      present(picker, animated: false, completion: nil)

    }
    
    
    

    //Cancelbutton//
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //완료//
    @IBAction func completeButtonTapped(_ sender: Any) {
        
        //data// 저장
        completeButton()
        
        //화면 이동
        self.navigationController?.popViewController(animated: true)
    }
    
    //완료// 버튼 눌리면 몸무게 입력 되어있는지 아닌지 봐야함.
    func completeButton() {
        //data// 몸무게
        if let recordedWeight = Double(weightTextField.text!) {
            //저장용
            note.weight = recordedWeight
            note.memo = memoTextView.text
            
            saveData()
        } else { //몸무게 기록 없으면 alert
            showWeightInfoAlert()
        }
    }
    
    func saveData(){
        
        //미래 날짜 입력 불가
        let today = Date()
        if note.date > today {
            futerDayInfoAlert()
            return
        }
        
        if defaultData == true { //기록이 없으면 default data 지우고 첫 data 추가
            notes.removeAll()
            notes.append(note)
            Note.saveToFile(notes: [notes])
            
            print("첫 기록입니다.")
            print(notes.count)
            
        } else { //기록이 존재하면 날짜 같은 data update
            for recordedData in notes {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier:"ko_KR")
                formatter.timeZone = TimeZone(abbreviation: "KST")
                formatter.dateFormat = "MM월 dd일, 20YY"
                let tempData = formatter.string(from: recordedData.date)
                let comparedData = formatter.string(from: note.date)
                
//                print("tempDate: \(tempData)")
//                print("comparedData: \(comparedData)")
//                print("----------")
//                print(tempData == comparedData)
                
                if(tempData == comparedData) {
                    sameArrayNum = notesArrayNum
                    sameDateData = true
                }
                notesArrayNum += 1
            }
            
            if sameDateData {
                notes[sameArrayNum].date = note.date
                notes[sameArrayNum].weight = note.weight
                notes[sameArrayNum].memo = note.memo
                notes[sameArrayNum].imagePath = note.imagePath

                Note.saveToFile(notes: [notes])

                
                print("동일한 날짜의 기록이 이미 있습니다. data가 업로드 됩니다.")
                //alert 창에 date 넘겨주기
                let sameDayFormatter = DateFormatter()
                sameDayFormatter.locale = Locale(identifier:"ko_KR")
                sameDayFormatter.timeZone = TimeZone(abbreviation: "KST")
                sameDayFormatter.dateFormat = "20YY년 MM월 dd일"
                sameDay = sameDayFormatter.string(from: note.date)
                
                
                print(notes.count)
                showSameRecordInfoAlert(sameDay: sameDay)

            } else {
                notes.append(note)
                Note.saveToFile(notes: [notes])
                print("새로운 날짜의 기록입니다.")
                print(notes.count)
            }
        }
    }
    
    //체중 미입력시 alert
    func showWeightInfoAlert() {
        let alert = UIAlertController(title: "체중 입력", message: "체중이 입력되지 않았습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
            print("tapped dismiss")
        }))
        
        present(alert, animated: true)
    }
    
    //미래 날짜 기록 alert
    func futerDayInfoAlert() {
        let alert = UIAlertController(title: "기록 날짜 오류", message: "오늘 이후의 데이터는 기록할 수 없습니다. \n 날짜를 다시 입력해주세요", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
            print("tapped dismiss")
        }))
        
        present(alert, animated: true)
    }
    
    //동일 날짜 기록 alert
    func showSameRecordInfoAlert(sameDay: String) {
        let alert = UIAlertController(title: sameDay, message: "동일한 날짜의 기록이 이미 있습니다. \n 최신 기록으로 업로드 됩니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { action in
            print("tapped dismiss")
            self.navigationController?.popViewController(animated: true)
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
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        
        //이미지 경로 저장
        print(image)
        
        note.imagePath = (saveImageToDocumentDirectory(image))

        print(note.imagePath)
        
        //경로 받아와서 이미지 뿌려주기
        
        takePhoto.setTitle("", for: .normal)
    }
    
}
