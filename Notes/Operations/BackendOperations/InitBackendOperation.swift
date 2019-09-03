import Foundation

class InitBackendOperation: BaseBackendOperation {
    
    private(set) var gistId: String? 
    
    override func main() {
        guard let request = createRequest() else {
            finish()
            return
        }
        
        (URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard error == nil,
                let data = data else {
                print("Error: can't get a gist list")
                print(error ?? "unknown")
                self.finish()
                return
            }
            
            guard let gists = try? JSONDecoder().decode([Gist].self, from: data) else {
                print("Error: can't parse gist list")
                self.finish()
                return
            }
            
            for gist in gists {
                for (filename, _) in gist.files {
                    if filename == Config.GistApi.gistFilename.rawValue {
                        if let id = gist.id {
                            print("Loaded gistId: \(id)")
                            self.gistId = id
                            self.finish()
                            return
                        }
                    }
                }
            }
            
            guard var request = self.createRequest() else {
                self.finish()
                return
            }
            request.httpMethod = "POST"
            request.httpBody = self.createGistJson(id: nil, content: nil)
            
            (URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let self = self else { return }
                guard let data = data,
                    error == nil else {
                    print("Error: can't create new gist with DB file")
                    print(error ?? "unknown")
                    self.finish()
                    return
                }
                
                guard let gist = try? JSONDecoder().decode(Gist.self, from: data) else {
                    print("Error: can't parse gist create response")
                    print(data)
                    self.finish()
                    return
                }
                
                print("Created gist id: \((gist.id ?? "nil"))")
                self.gistId = gist.id
                self.finish()
            }).resume()
        }).resume()
    }
}
