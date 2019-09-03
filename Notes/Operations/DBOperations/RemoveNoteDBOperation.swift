import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    
    init(note: Note, notebook: Notebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        notebook.save()
        finish()
    }
}
