import UIKit

enum Importance: String {
    case low, mid, high
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let importance: Importance
    let color: UIColor
    let selfDestructionDate: Date?
    
    init(
        title: String,
        content: String,
        importance: Importance,
        uid: String? = nil,
        color: UIColor? = nil,
        selfDestructionDate: Date? = nil
    ) {
        self.title = title
        self.content = content
        self.importance = importance
        self.uid = uid ?? UUID().uuidString
        self.color = color ?? .white
        self.selfDestructionDate = selfDestructionDate
    }
}
