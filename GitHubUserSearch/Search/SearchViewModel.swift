import UIKit
import RxSwift

class SearchViewModel: BaseViewModel {
    let searchSource = BehaviorSubject(value: [SearchItemViewModel]())
    
    var selectedItem : SearchItemViewModel?
    
    
    func item(at indexPath : IndexPath) -> SearchItemViewModel? {
        let source = try? searchSource.value()
        return source?.item(at: indexPath.row)
    }
    
    @discardableResult func selectItem(at indexPath : IndexPath) -> Bool {
        selectedItem = item(at: indexPath)
        return selectedItem != nil
    }

}

class SearchItemViewModel : BaseViewModel {
    
    let model : GitHubUser
    let placeholderImage =  UIImage(named: "uer_placeholder")
    
    required init(model : GitHubUser) {
        self.model = model
    }
    
    var userName : String {
        get {
            return model.login
        }
    }
    
    var avatarURL : URL? {
        get {
            return URL(string: model.avatarURL)
        }
    }
    
        
}
