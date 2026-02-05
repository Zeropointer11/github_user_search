import UIKit

class SearchItemViewModel : BaseViewModel {
    
    let model : GitHubUser
    private static let cachedPlaceholderImage = UIImage(named: "uer_placeholder")

    var placeholderImage: UIImage? {
        return SearchItemViewModel.cachedPlaceholderImage
    }
    
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
