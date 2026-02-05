import UIKit

class SearchItemViewModel : BaseViewModel {
    
    let model : GitHubUser
    let placeholderImage =  UIImage(named: "uer_placeholder")
    
    let avatarURL : URL?

    required init(model : GitHubUser) {
        self.model = model
        self.avatarURL = URL(string: model.avatarURL)
    }
    
    var userName : String {
        get {
            return model.login
        }
    }
    
        
}
