import UIKit

extension Note {
    enum Keys: String {
        case uid, title, content, importance, color, date
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json[Keys.uid.rawValue] as? String,
            let title = json[Keys.title.rawValue] as? String,
            let content = json[Keys.content.rawValue] as? String
            else {
                return nil
        }
        
        var importance = Importance.mid
        if let importanceRaw = json[Keys.importance.rawValue] as? String,
            let importanceSafe = Importance(rawValue: importanceRaw) {
            importance = importanceSafe
        }
        
        var color: UIColor? = nil
        if let colorString = json[Keys.color.rawValue] as? String {
            color = UIColor(hex: colorString)
        }
        
        var date: Date? = nil
        if let dateTimestamp = json[Keys.date.rawValue] as? Double {
            date = Date(timeIntervalSince1970: TimeInterval(dateTimestamp))
        }
        
        return Note(
            title: title,
            content: content,
            importance: importance,
            uid: uid,
            color: color,
            selfDestructionDate: date
        )
    }
    
    var json: [String: Any] {
        var result: [String: Any] = [
            Keys.uid.rawValue: uid,
            Keys.title.rawValue: title,
            Keys.content.rawValue: content
        ]
        
        if importance != .mid {
            result[Keys.importance.rawValue] = importance.rawValue
        }
        
        if color.hex != UIColor.white.hex {
            result[Keys.color.rawValue] = color.hex
        }
        
        if let date = selfDestructionDate {
            result[Keys.date.rawValue] = Double(date.timeIntervalSince1970)
        }
        
        return result
    }
}

// Mark: - UIColor serialize to string with format "#FF00FFFF" and back
extension UIColor {
    public convenience init?(hex: String) {
        guard hex.hasPrefix("#") else {
            return nil
        }
        
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                let a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
    
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: Int = (Int)(a * 255) |
            (Int)(r * 255) << 24 |
            (Int)(g * 255) << 16 |
            (Int)(b * 255) << 8
        
        return String(format: "#%08x", rgba).uppercased()
    }
}
