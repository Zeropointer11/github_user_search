import Foundation
import RxSwift
import Alamofire

class APIServiceAdapter: APIInterface {
    
    private let session = Session.default
    private let baseURL : String = "https://api.github.com"
    private let decoder = IsoDateDecoder()
    
    func setup() {
        
    }
    
    private func request<T : Decodable>(urlString : String) -> Observable<T> {
        return Observable.create { [weak self] (observer) -> Disposable in
            
            do {
                guard let self = self else { throw APIErrors.selfMissing }
                self.session.request(urlString)
                    .validate(statusCode: 200 ..< 300)
                    .validate(contentType: ["application/json"])
                    .responseDecodable(of: T.self, decoder: self.decoder) { (response) in
                        switch response.result {
                        case .success(let result):
                            observer.onNext(result)
                            observer.onCompleted()
                        case .failure(let error):                            
                            if let data = response.data,
                               let apiError = try? self.decoder.decode(APIServiceError.self, from: data) {
                                observer.onError(APIErrors.failure(apiError: apiError))
                            }
                            else {
                                observer.onError(error)
                            }
                        }
                    }
                
            }
            catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
    
    func searchUsers(with name: String) -> Observable<GitHubUserResult> {
        if name.isEmpty {
            return Observable.just(GitHubUserResult.empty())
        }
        else {
            return request(urlString: "\(self.baseURL)/search/users?q=\(name)")
        }
    }
    
    func userDetails(with userName: String) -> Observable<GitHubUserDetail> {
        if userName.isEmpty {
            return Observable.error(APIErrors.emptyResponse)
        }
        else {
            return request(urlString: "\(self.baseURL)/users/\(userName)")
        }
    }
    
}

private class IsoDateDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}
