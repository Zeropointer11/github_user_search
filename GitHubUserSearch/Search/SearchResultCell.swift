import UIKit
import AlamofireImage

/**
 Custom TableViewCell for the Search Result that shows the Avatar of the User and the Username
 */
class SearchResultCell: UITableViewCell {

    @IBOutlet private var userImageView : UIImageView!
    @IBOutlet private var userName : UILabel!
    
    var viewModel : SearchItemViewModel? {
        didSet {
            setupView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        userImageView?.image = UIImage(named: "uer_placeholder")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        userImageView?.image = UIImage(named: "uer_placeholder")
    }
    
    override func prepareForReuse() {
        userImageView?.image = UIImage(named: "uer_placeholder")
        userName?.text = nil
    }
    
    
    private func setupView() {
        guard let viewModel = self.viewModel else {
            return
        }
        userImageView?.image = viewModel.placeholderImage
        userName.text = viewModel.userName
        if let avatarURL = viewModel.avatarURL {
            userImageView?.af.setImage(withURLRequest: URLRequest(url: avatarURL),
                                       placeholderImage: viewModel.placeholderImage)
        }
    }
}
