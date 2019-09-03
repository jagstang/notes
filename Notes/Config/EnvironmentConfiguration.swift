import Foundation

// Mark: - example of target switch usage, useless now
enum Environment: String {
    case staging, production
    
    var baseUrl: String {
        switch self {
        case .staging:
            return "https://staging-api.note.com"
        case .production:
            return "https://api.note.com"
        }
    }
    
    var token: String {
        switch self {
        case .staging:
            return "some_staging_token"
        case .production:
            return "some_production_token"
        }
    }
}


struct EnvironmentConfiguration {
    let environment: Environment
    
    init() {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String,
            configuration.range(of: "Staging") != nil {
                environment = .staging
        } else {
            environment = .production
        }
    }
}
