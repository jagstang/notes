import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    var result: LoadNotesBackendResult?
    var gistId: String?
    
    override func main() {
        guard let gistId = gistId,
            let request = createRequest(gistId: gistId) else {
                self.finishWithError("can't create gist request")
            return
        }
        
        (URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard error == nil,
                let data = data else {
                    self.finishWithError("can't get a gist", error: error)
                    return
            }
            guard let gist = try? JSONDecoder().decode(Gist.self, from: data) else {
                self.finishWithError("can't parse gist")
                return
            }
            guard let file = gist.files[Config.GistApi.gistFilename.rawValue] else {
                self.finishWithError("can't find file in gist")
                return
            }
            guard let content = file.content else {
                self.finishWithError("empty content in gist file")
                return
            }
            guard let contentData = content.data(using: .utf8),
                let jsonData = try? JSONSerialization.jsonObject(with: contentData, options: []) as? [[String: Any]] else {
                self.finishWithError()
                return
            }
            
            var notes = [Note]()
            for json in jsonData {
                if let note = Note.parse(json: json) {
                    notes.append(note)
                }
            }
            self.result = .success(notes)
            self.finish()
        }).resume()
    }
    
    private func finishWithError(_ message: String? = nil, error: Error? = nil) {
        if let message = message {
            print(message)
        }
        if let error = error {
            print("Error: \(error)")
        }
        self.result = .failure(.unknown)
        self.finish()
    }
}
