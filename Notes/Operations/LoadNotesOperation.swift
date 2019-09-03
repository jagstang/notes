import Foundation

class LoadNotesOperation: AsyncOperation {
    
    private let initBackend: InitBackendOperation
    private let loadFromBackend: LoadNotesBackendOperation
    private let backendQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    public var gistId: String?
    
    init(
        notebook: Notebook,
        backendQueue: OperationQueue,
        dbQueue: OperationQueue,
        token: String
    ) {
        initBackend = InitBackendOperation(token: token)
        loadFromBackend = LoadNotesBackendOperation(token: token)
        self.backendQueue = backendQueue
        
        super.init()
        
        initBackend.completionBlock = { [unowned self] in
            self.loadFromBackend.gistId = self.initBackend.gistId
            self.gistId = self.initBackend.gistId
            backendQueue.addOperation(self.loadFromBackend)
        }
        
        loadFromBackend.completionBlock = { [unowned self] in
            guard let result = self.loadFromBackend.result else {
                self.finish()
                return
            }
            
            switch result {
            case .failure:
                let loadFromDB = LoadNotesDBOperation(notebook: notebook)
                loadFromDB.completionBlock = { [unowned self] in
                    self.result = true
                    self.finish()
                }
                dbQueue.addOperation(loadFromDB)
            case .success(let notes):
                notebook.update(by: notes)
                let saveToDB = SaveNoteDBOperation(notebook: notebook)
                saveToDB.completionBlock = { [unowned self] in
                    self.result = true
                    self.finish()
                }
                dbQueue.addOperation(saveToDB)
            }
        }
    }
    
    override func main() {
        backendQueue.addOperation(initBackend)
    }
}
