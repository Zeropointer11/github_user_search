import UIKit

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
