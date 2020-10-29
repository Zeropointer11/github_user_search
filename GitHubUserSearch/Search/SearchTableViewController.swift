import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared()
    
    @IBOutlet private var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        bindView()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach GitHub User"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    private func bindView() {
        searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[GitHubUser]> in
                return self.apiService.searchUsers(with: query)
                    .catchErrorJustReturn([])
            }
            .map { $0.items }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) {
                (index, item: GitHubUse, cell) in
                cell.textLabel?.text = item.login
            }
            .disposed(by: disposeBag)
    }

}

extension SearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
