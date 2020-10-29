import Foundation
import RxSwift

class UserDetailViewModel: BaseViewModel {
    
    let user : GitHubUser
    let userDetails = BehaviorSubject<GitHubUserDetail?>(value: nil)
    
    required init(user : GitHubUser) {
        self.user = user
    }
}
