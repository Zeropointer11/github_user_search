import UIKit
import RxSwift
import RxCocoa
import SafariServices

/**
 User Detail Controller that shows the Avatar, UserrName, Follower and some more Informations of the User.
 */
class UserDetailViewController: UIViewController {
    
    @IBOutlet private var userImage : UIImageView?
    @IBOutlet private var lblName : UILabel?
    @IBOutlet private var lblUserName : UILabel?
    @IBOutlet private var lblFollower : UILabel?
    @IBOutlet private var lblFollowing : UILabel?
    @IBOutlet private var lblLocation : UILabel?
    @IBOutlet private var lblEmail : UILabel?
    @IBOutlet private var btnWebsite : UIButton?
    
    var viewModel : UserDetailViewModel? = nil{
        didSet {
            bindViewModel()
        }
    }
    private var disposeBag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard isViewLoaded, let viewModel = self.viewModel else {
            return
        }
        self.title = viewModel.user.login
        disposeBag = DisposeBag()
        APIService.shared
            .userDetails(with: viewModel.user.login)
            .catchErrorJustReturn(.empty()) // Catch error with an empty result do here you can add an Error handling
            .bind(to: viewModel.userDetails)
            .disposed(by: disposeBag)
        
        
        viewModel.userDetails
            .subscribe { [weak self] (details) in
                self?.setupView(with: details)
            } onError: { (error) in
                
            }
            .disposed(by: disposeBag)
        
        btnWebsite?.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in
                guard let urlString = (try? self?.viewModel?.userDetails.value())?.htmlURL,
                let url = URL(string: urlString)
                else {
                    return
                }
                let config = SFSafariViewController.Configuration()
                config.barCollapsingEnabled = false
                let safari = SFSafariViewController(url: url,
                                                    configuration: config)
                
                self?.showDetailViewController(safari, sender: nil)
            })
            .disposed(by: disposeBag)

    }
    
    private func setupView(with user : GitHubUserDetail?) {
        guard let details = user else {
            return
        }
        if let url = URL(string: details.avatarURL) {
            userImage?.af.setImage(withURL: url)
        }
        lblName?.text = details.name
        lblUserName?.text = details.login
        lblFollower?.text = "\(details.followers)"
        lblFollowing?.text = "\(details.following)"
        lblLocation?.text = details.location
        lblEmail?.text = details.email
        
    }
}
