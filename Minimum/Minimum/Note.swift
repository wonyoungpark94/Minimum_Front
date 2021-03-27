
import Foundation

// Emoji Categories:
//enum noteCategory: String {
//    case Smileys = "Smileys"
//    case People = "People"
//    case Animals = "Animals"
//    case Nature = "Nature"
//    case Food = "Food"
//    case Objects = "Objects"
//    case Symbols = "Symbols"
//}

// Emoji Class:
class Note: Codable {
    var date: Date
    var weight: Double?
    var memo: String?
    
//    var symbol: String
//    var name: String
//    var description: String
//    var usage: String
//    var category: String
    
//    init(symbol: String, name: String, description: String, usage: String, category: String) {
//        self.symbol = symbol
//        self.name = name
//        self.description = description
//        self.usage = usage
//        self.category = category
//    }
    
    init(date: Date, weight: Double?, memo: String?) {
        self.date = date
        self.weight = weight
        self.memo = memo
    }
    
    // creation of file to save:
    static var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = documentDirectory.appendingPathComponent("notes").appendingPathExtension("plist")
    
    // save file method:
    static func saveToFile(notes: [[Note]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmojis = try? propertyListEncoder.encode(notes)
        try? encodedEmojis?.write(to: Note.archiveURL, options: .noFileProtection)
        print("save to: ", Note.archiveURL)
    }
    
    // load file method:
    static func loadFromFile() -> [[Note]] {
        let propertyListDecoder = PropertyListDecoder()
        var emojiArray: [[Note]] = []
        
        if let retrievedEmojiData = try? Data(contentsOf: Note.archiveURL),
           let decodedEmojis = try?
            propertyListDecoder.decode(Array<[Note]>.self, from: retrievedEmojiData) {
            emojiArray = decodedEmojis
            print("load from: ", Note.archiveURL)
        }
        return emojiArray
    }
    
    
    // emoji sample list:
    static func loadSampleNotes() -> [Note] {
        return [
            Note(date: Date(), weight: 55.5, memo: ""),
            Note(date: Date(), weight: 55.5, memo: ""),
            Note(date: Date(), weight: 55.5, memo: "")
        ]
    }
}
