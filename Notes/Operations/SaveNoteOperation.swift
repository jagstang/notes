import Foundation

class SaveNoteOperation: AsyncOperation {
    
    private let saveToDb: SaveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(
        note: Note,
        notebook: Notebook,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue,
        token: String,
        gistId: String?
    ) {
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue
    
        super.init()
        
        saveToDb.completionBlock = { [unowned self] in
            guard let gistId = gistId else {
                self.finish()
                return
            }
            let saveToBackend = SaveNotesBackendOperation(token: token, gistId: gistId, notes: notebook.getList())
            saveToBackend.completionBlock = { [unowned self] in
                switch saveToBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(saveToDb)
    }
}
