import Foundation

enum NetworkError {
    case unreachable
    case unknown
}

struct Gist: Codable {
    let files: [String: GistFile]
    let description: String
    let `public`: Bool
    let id: String?
}

struct GistFile: Codable {
    let content: String?
}

class BaseBackendOperation: AsyncOperation {
    
    let token: String
    
    init(token: String) {
        self.token = token
        super.init()
    }
    
    func createRequest(gistId: String? = nil) -> URLRequest? {
        var urlString = Config.GistApi.Url.gist.rawValue
        if let id = gistId {
            urlString = "\(urlString)/\(id)"
        }
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func createGistJson(id: String?, content: String?) -> Data? {
        let encoder = JSONEncoder()
        let gist = Gist(
            files: [
                Config.GistApi.gistFilename.rawValue: GistFile(
                    content: content ?? "[]"
                )
            ],
            description: "Notes DB file",
            public: false,
            id: id
        )
        
        return try? encoder.encode(gist)
    }

}
