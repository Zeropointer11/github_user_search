import XCTest
@testable import GitHubUserSearch
import RxSwift
import RxBlocking

class GitHubUserSearchTests: XCTestCase {
    
    private let mockedAdapter = MockedApiServiceAdapter()
    private let apiAdapter = APIServiceAdapter()
    private let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func checkSingleResultZeropointer(result : GitHubUserResult) {
        XCTAssertTrue(result.totalCount == 1)
        XCTAssertFalse(result.incompleteResults, "result is not complete")
        XCTAssertTrue(result.totalCount == result.items.count, "not the same count")
        result.items.forEach { (item) in
            XCTAssertEqual(item.login, "Zeropointer11")
            XCTAssertEqual(item.id, 3930333)
            XCTAssertEqual(item.nodeID, "MDQ6VXNlcjM5MzAzMzM=")
            XCTAssertEqual(item.avatarURL, "https://avatars2.githubusercontent.com/u/3930333?v=4")
            XCTAssertEqual(item.url, "https://api.github.com/users/Zeropointer11")
            XCTAssertEqual(item.htmlURL, "https://github.com/Zeropointer11")
            XCTAssertEqual(item.followersURL, "https://api.github.com/users/Zeropointer11/followers")
            XCTAssertEqual(item.followingURL, "https://api.github.com/users/Zeropointer11/following{/other_user}")
            XCTAssertEqual(item.gistsURL, "https://api.github.com/users/Zeropointer11/gists{/gist_id}")
            XCTAssertEqual(item.starredURL, "https://api.github.com/users/Zeropointer11/starred{/owner}{/repo}")
            XCTAssertEqual(item.subscriptionsURL, "https://api.github.com/users/Zeropointer11/subscriptions")
            XCTAssertEqual(item.organizationsURL, "https://api.github.com/users/Zeropointer11/orgs")
            XCTAssertEqual(item.reposURL, "https://api.github.com/users/Zeropointer11/repos")
            XCTAssertEqual(item.eventsURL, "https://api.github.com/users/Zeropointer11/events{/privacy}")
            XCTAssertEqual(item.receivedEventsURL, "https://api.github.com/users/Zeropointer11/received_events")
            XCTAssertEqual(item.type, "User")
            XCTAssertEqual(item.siteAdmin, false)
            XCTAssertEqual(item.score, 1)
        }
    }
    
    func testMockedSearch() {
        let expectation = XCTestExpectation(description: "test mocked search")
        APIService.shared
            .setAdapter(newAdapter: mockedAdapter)
            .searchUsers(with: "zero")
            .subscribe {  [weak self] (result) in
                self?.checkSingleResultZeropointer(result: result)
            
            } onError: { (error) in
                XCTFail("Failed with: \(error)")
            } onCompleted: {
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testOnlineSearch() {
        let expectation = XCTestExpectation(description: "test online search")
        APIService.shared
            .setAdapter(newAdapter: apiAdapter)
            .searchUsers(with: "zeropointer11")
            .subscribe {  [weak self] (result) in
                self?.checkSingleResultZeropointer(result: result)
            
            } onError: { (error) in
                XCTFail("Failed with: \(error)")
            } onCompleted: {
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 80.0)
    }
    
    func testMockedEqualOnline() {
        do {
            guard let mocked = try APIService.shared
                    .setAdapter(newAdapter: mockedAdapter)
                    .searchUsers(with: "zero")
                    .toBlocking(timeout: 10)
                    .first() else {
                XCTFail("Failed to get Mocked Result")
                return
            }
            
            checkSingleResultZeropointer(result: mocked)
            
            guard let online = try APIService.shared
                    .setAdapter(newAdapter: apiAdapter)
                    .searchUsers(with: "zeropointer11")
                    .toBlocking(timeout: 80).first() else {
                XCTFail("Failed to get Online Result")
                return
            }
            checkSingleResultZeropointer(result: online)
            
            XCTAssertEqual(mocked, online, "mocked and online result not are not the same")
        } catch  {
            XCTFail("Failed \(error)")
        }
        
    }
    
    private func checkUserDetails(userDetails : GitHubUserDetail) {
        XCTAssertEqual(userDetails.login, "Zeropointer11")
        XCTAssertEqual(userDetails.id, 3930333)
        XCTAssertEqual(userDetails.nodeID, "MDQ6VXNlcjM5MzAzMzM=")
        XCTAssertEqual(userDetails.avatarURL, "https://avatars2.githubusercontent.com/u/3930333?v=4")
        XCTAssertEqual(userDetails.url, "https://api.github.com/users/Zeropointer11")
        XCTAssertEqual(userDetails.htmlURL, "https://github.com/Zeropointer11")
        XCTAssertEqual(userDetails.followersURL, "https://api.github.com/users/Zeropointer11/followers")
        XCTAssertEqual(userDetails.followingURL, "https://api.github.com/users/Zeropointer11/following{/other_user}")
        XCTAssertEqual(userDetails.gistsURL, "https://api.github.com/users/Zeropointer11/gists{/gist_id}")
        XCTAssertEqual(userDetails.starredURL, "https://api.github.com/users/Zeropointer11/starred{/owner}{/repo}")
        XCTAssertEqual(userDetails.subscriptionsURL, "https://api.github.com/users/Zeropointer11/subscriptions")
        XCTAssertEqual(userDetails.organizationsURL, "https://api.github.com/users/Zeropointer11/orgs")
        XCTAssertEqual(userDetails.reposURL, "https://api.github.com/users/Zeropointer11/repos")
        XCTAssertEqual(userDetails.eventsURL, "https://api.github.com/users/Zeropointer11/events{/privacy}")
        XCTAssertEqual(userDetails.receivedEventsURL, "https://api.github.com/users/Zeropointer11/received_events")
        XCTAssertEqual(userDetails.type, "User")
        XCTAssertEqual(userDetails.siteAdmin, false)
        XCTAssertEqual(userDetails.name, "Patrick Singer")
        XCTAssertNil(userDetails.company)
        XCTAssertEqual(userDetails.blog, "")
        XCTAssertEqual(userDetails.location, "Austria")
        XCTAssertNil(userDetails.email)
        XCTAssertNil(userDetails.hireable)
        XCTAssertNil(userDetails.bio)
        XCTAssertNil(userDetails.twitterUsername)
        XCTAssertEqual(userDetails.publicRepos, 12)
        XCTAssertEqual(userDetails.publicGists, 0)
        XCTAssertEqual(userDetails.followers, 1)
        XCTAssertEqual(userDetails.following, 8)
        
        let isoFormater = ISO8601DateFormatter()
        XCTAssertEqual(userDetails.createdAt,
                       isoFormater.date(from: "2013-03-21T11:00:44Z"))
    }
    
    func testMockedUserDetails() {
        let expectation = XCTestExpectation(description: "test mocked user details")
        APIService.shared
            .setAdapter(newAdapter: mockedAdapter)
            .userDetails(with: "Zeropointer11")
            .subscribe {  [weak self] (result) in
                self?.checkUserDetails(userDetails: result)
            } onError: { (error) in
                XCTFail("Failed with: \(error)")
            } onCompleted: {
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
        
    func testOnlineUserDetails() {
        let expectation = XCTestExpectation(description: "test online user details")
        APIService.shared
            .setAdapter(newAdapter: apiAdapter)
            .userDetails(with: "Zeropointer11")
            .subscribe {  [weak self] (result) in
                self?.checkUserDetails(userDetails: result)
            } onError: { (error) in
                XCTFail("Failed with: \(error)")
            } onCompleted: {
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 80.0)
    }
    
    func testMockedEqualsOnlineUserDetails() {
        do {
            guard let mocked = try APIService.shared
                    .setAdapter(newAdapter: mockedAdapter)
                    .userDetails(with: "Zeropointer11")
                    .toBlocking(timeout: 10)
                    .first() else {
                XCTFail("Failed to get Mocked Result")
                return
            }
            checkUserDetails(userDetails: mocked)
            
            guard let online = try APIService.shared
                    .setAdapter(newAdapter: apiAdapter)
                    .userDetails(with: "Zeropointer11")
                    .toBlocking(timeout: 80).first() else {
                XCTFail("Failed to get Online Result")
                return
            }
            checkUserDetails(userDetails: online)
            
            XCTAssertEqual(mocked, online, "mocked and online result not are not the same")
        } catch  {
            XCTFail("Failed \(error)")
        }
    }
    
}
