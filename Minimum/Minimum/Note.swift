
import Foundation

// Note Class:
class Note: Codable {
    var date: Date
    var weight: Double
    var memo: String?
    var imagePath: String?
   
    
    init(date: Date, weight: Double, memo: String?, imagePath: String?) {
        self.date = date
        self.weight = weight
        self.memo = memo
        self.imagePath = imagePath
    }
    
    // creation of file to save:
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = documentDirectory.appendingPathComponent("notes").appendingPathExtension("plist")
    
    // save file method:
    static func saveToFile(notes: [[Note]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedNotes = try? propertyListEncoder.encode(notes)
        try? encodedNotes?.write(to: Note.archiveURL, options: .noFileProtection)
        print("save to: ", Note.archiveURL)
    }
    
    // load file method:
    static func loadFromFile() -> [[Note]] {
        let propertyListDecoder = PropertyListDecoder()
        var noteArray: [[Note]] = []
        
        if let retrievedNoteData = try? Data(contentsOf: Note.archiveURL),
           let decodedNotes = try?
            propertyListDecoder.decode(Array<[Note]>.self, from: retrievedNoteData) {
            noteArray = decodedNotes
            print("load from: ", Note.archiveURL)
        }
        return noteArray
    }
    
    
    // note sample list:
    static func loadSampleNotes() -> [Note] {
        
        //sample data Date형식으로 변환 및 default에 저장
        let dateString:[String] = ["2021-03-01 15:05:40", "2021-03-02 15:05:40", "2021-03-03 15:05:40", "2021-03-04 15:05:40", "2021-03-05 15:05:40", "2021-03-06 15:05:40", "2021-03-07 15:05:40", "2021-03-08 15:05:40", "2021-03-09 15:05:40", "2021-03-10 15:05:40"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        let date0:Date = dateFormatter.date(from: dateString[0])!
        let date1:Date = dateFormatter.date(from: dateString[1])!
        let date2:Date = dateFormatter.date(from: dateString[2])!
        let date3:Date = dateFormatter.date(from: dateString[3])!
        let date4:Date = dateFormatter.date(from: dateString[4])!
        let date5:Date = dateFormatter.date(from: dateString[5])!
        let date6:Date = dateFormatter.date(from: dateString[6])!
        let date7:Date = dateFormatter.date(from: dateString[7])!
        let date8:Date = dateFormatter.date(from: dateString[8])!
        let date9:Date = dateFormatter.date(from: dateString[9])!

        return [
            Note(date: date0, weight: 55.5, memo: nil, imagePath: nil),
            Note(date: date1, weight: 55.5, memo: nil, imagePath: nil),
            Note(date: date2, weight: 54.5, memo: nil, imagePath: nil),
            Note(date: date3, weight: 53.5, memo: nil, imagePath: nil),
            Note(date: date4, weight: 53.5, memo: nil, imagePath: nil),
            Note(date: date5, weight: 52.5, memo: nil, imagePath: nil),
            Note(date: date6, weight: 53.5, memo: nil, imagePath: nil),
            Note(date: date7, weight: 52.5, memo: nil, imagePath: nil),
            Note(date: date8, weight: 51.5, memo: nil, imagePath: nil),
            Note(date: date9, weight: 50.5, memo: nil, imagePath: nil)
        ]
    }
}
