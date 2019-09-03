import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notes: [Note]
    var gistId: String
    
    init(token: String, gistId: String, notes: [Note]) {
        self.notes = notes
        self.gistId = gistId
        super.init(token: token)
    }
    
    override func main() {
        guard var request = createRequest(gistId: gistId) else {
            self.finishWithError()
            return
        }
        
        request.httpMethod = "PATCH"
        request.httpBody = createGistJson(id: gistId, content: getNotesAsJsonString())
        
        (URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            guard error == nil,
                let response = response as? HTTPURLResponse else  {
                
                self.finishWithError()
                return
            }
            switch response.statusCode {
            case 200..<300:
                self.result = .success
                self.finish()
            default:
                self.finishWithError()
            }
        }).resume()
    }
    
    private func finishWithError() {
        self.result = .failure(.unknown)
        self.finish()
    }
    
    private func getNotesAsJsonString() -> String? {
        var data: [[String: Any]] = []
        for note in notes {
            data.append(note.json)
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
            return String(data: jsonData, encoding: .utf8)
        }
        
        return nil
    }
}
