import UIKit

class SearchItemViewModel : BaseViewModel {
    
    let model : GitHubUser
    private static let cachedPlaceholderImage = UIImage(named: "uer_placeholder")

    var placeholderImage: UIImage? {
        return SearchItemViewModel.cachedPlaceholderImage
    }
    
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
