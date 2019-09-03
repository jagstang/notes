import Foundation

class FileNotebook: Notebook {
    
    private var notes: [Note] = []
    
    public func add(_ note: Note) {
        remove(with: note.uid)
        notes.append(note)
    }
    
    public func remove(with uid: String) {
        for (index, note) in notes.enumerated() {
            if note.uid == uid {
                notes.remove(at: index)
                return
            }
        }
    }
    
    public func update(by notes: [Note]) {
        self.notes = notes
    }
    
    public func getList() -> [Note] {
        return self.notes
    }
    
    public func save() {
        saveToFile()
    }
    
    public func load() {
        try? loadFromFile()
    }
    
    private func saveToFile() {
        guard let url = getFileUrl() else {
            return
        }
        
        do {
            var data: [[String: Any]] = []
            for note in notes {
                data.append(note.json)
            }
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
                let jsonString = String(data: jsonData, encoding: .utf8) {
                try jsonString.write(to: url, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print("Error: failed to save to file: \n\(error)" )
        }
    }
    
    private func loadFromFile() throws {
        guard let url = getFileUrl() else {
            return
        }
        
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            let data = Data(text.utf8)
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for json in jsonData {
                    if let note = Note.parse(json: json) {
                        notes.append(note)
                    }
                }
            }
        } catch let error as NSError {
            print("Error: failed to read file: \n\(error)" )
            throw error
        }
    }
    
    private func getFileUrl() -> URL? {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        if !filemanager.fileExists(atPath: dir.path) {
            do {
                try filemanager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: failed to create directory: \n\(error)" )
            }
        }
        
        return dir.appendingPathComponent("notes")
            .appendingPathExtension("json")
    }
}
