import Foundation

class BaseDBOperation: AsyncOperation {
    let notebook: Notebook
    
    init(notebook: Notebook) {
        self.notebook = notebook
        super.init()
    }
}
