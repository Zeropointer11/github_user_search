import UIKit
import RxSwift
import RxCocoa

/**
 Seach View Controller that use the UISarchCrontroller to search for GitHub Users by using the GitHub API
 */
class SearchViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    @IBOutlet private var tableView : UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        bindView()
    }

    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach GitHub User"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func bindView() {
        tableView.delegate = self
        
        searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest({ [weak self] query in
                
                return APIService.shared.searchUsers(with: query)
                    .catchError { [weak self] (error) -> Observable<GitHubUserResult> in
                        // catch api error here otherwise the bide will not receive the next results
                        if let lastResult = try? self?.viewModel.searchSource.value().map({ $0.model }) {
                            return Observable.just(GitHubUserResult(totalCount: lastResult.count,
                                                                    incompleteResults: false,
                                                                    items: lastResult))
                        }
                        else {
                            return Observable.just(GitHubUserResult.empty())
                        }
                    }
                
            })
            .map({ $0.items.map { SearchItemViewModel(model: $0) } })
            .bind(to: viewModel.searchSource)
            .disposed(by: disposeBag)
        
    
        viewModel.searchSource
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                (index, item: SearchItemViewModel, cell) in
                (cell as? SearchResultCell)?.viewModel = item
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe { [weak self] (note) in
                let userInfo = note.userInfo
                guard let self = self,
                      let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return
                    
                }
                let contentInset = UIEdgeInsets(top: 0.0,
                                                left: 0.0,
                                                bottom: keyboardFrame.height,
                                                right: 0.0)
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)

        NotificationCenter.default
            .rx.notification(UIResponder.keyboardDidHideNotification)
            .subscribe { [weak self] (note) in
                self?.tableView.setContentOffset(.zero, animated: true)
                self?.tableView.scrollIndicatorInsets = .zero
                
            } onError: { (error) in
                print(error)
            }
            .disposed(by: disposeBag)
    }

}

//MARK: - UITableViewDelegate
extension SearchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = viewModel.item(at: indexPath) else { return }
        performSegue(withIdentifier: "showUserDetail", sender: item.model)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserDetail",
           let detailViewController = segue.destination as? UserDetailViewController,
           let model = sender as? GitHubUser{
            detailViewController.viewModel = UserDetailViewModel(user: model)
        }
    }
}
