import Foundation
import RxSwift

protocol APIInterface {
    func setup()
    func searchUsers(with name : String) -> Observable<GitHubUserResult>
    func userDetails(with userName : String) -> Observable<GitHubUserDetail>
    
}

enum APIErrors : Error {
    case selfMissing
    case emptyResponse
    case failure(apiError : APIServiceError)
}

struct APIServiceError : Codable, Equatable {
    let message: String
    let documentationURL: String?

    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
    }
}

class APIService : APIInterface {
    
    static let shared = APIService()
    
    private var adapter : APIInterface
    
    private init() {
        adapter = APIServiceAdapter() // set default adapter
        setup()
    }
    
    func setAdapter(newAdapter : APIInterface) -> APIService {
        adapter = newAdapter
        setup()
        return self
    }
    
    func setup() {
        adapter.setup()
    }
    
    func searchUsers(with name: String) -> Observable<GitHubUserResult> {
        return adapter.searchUsers(with: name)
    }
    
    func userDetails(with userName: String) -> Observable<GitHubUserDetail> {
        return adapter.userDetails(with: userName)
    }
    
}
