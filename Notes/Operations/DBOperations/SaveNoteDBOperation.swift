import Foundation

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note?
    
    init(note: Note, notebook: Notebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override init(notebook: Notebook) {
        self.note = nil
        super.init(notebook: notebook)
    }
    
    override func main() {
        if let note = self.note {
            notebook.add(note)
        }
        notebook.save()
        finish()
    }
}
