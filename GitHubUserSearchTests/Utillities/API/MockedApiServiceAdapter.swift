import Foundation
import RxSwift

class MockedApiServiceAdapter : APIInterface {
    
    enum MockedApiError : Error {
        case fileNotFound
    }
    
    private let bundle = Bundle(for: MockedApiServiceAdapter.self)
    private let decoder = JSONDecoder()
    
    func setup() {
        
        decoder.dateDecodingStrategy = .iso8601
        
    }
    
    private func request<T : Decodable>(resourceName : String,
                                        fileExt : String = "json") -> Observable<T> {
        return Observable.create { [weak self] (observer) -> Disposable in
            do {
                guard let self = self else { throw APIErrors.selfMissing }
                
                guard let path = self.bundle.url(forResource: resourceName,
                                                 withExtension: fileExt) else {
                    throw MockedApiError.fileNotFound
                }
                
                let data = try Data(contentsOf: path)
                let result = try self.decoder.decode(T.self, from: data)
                observer.onNext(result)
                observer.onCompleted()
            }
            catch {
                observer.onError(error)
            }
            return Disposables.create()
            
        }
    }
    
    func searchUsers(with name: String) -> Observable<GitHubUserResult> {
        return request(resourceName: "test_search_\(name)")
    }
    
    func userDetails(with userName: String) -> Observable<GitHubUserDetail> {
        request(resourceName: "test_users_\(userName)")
    }
    
}
