import Foundation

// MARK: - GitHubUserDetail
struct GitHubUserDetail: Codable, Equatable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL, followersURL: String
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: String
    let eventsURL: String
    let receivedEventsURL: String
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String?
    let blog, location: String
    let email, hireable, bio, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int
    let createdAt, updatedAt: Date
    
    static func empty() -> GitHubUserDetail {
        return GitHubUserDetail(login: "", id: -1, nodeID: "", avatarURL: "",
                                gravatarID: "", url: "", htmlURL: "",
                                followersURL: "", followingURL: "", gistsURL: "",
                                starredURL: "", subscriptionsURL: "",
                                organizationsURL: "", reposURL: "", eventsURL: "",
                                receivedEventsURL: "", type: "", siteAdmin: false,
                                name: "", company: nil, blog: "", location: "",
                                email: nil, hireable: nil, bio: nil,
                                twitterUsername: nil, publicRepos: -1,
                                publicGists: -1, followers: -1, following: -1,
                                createdAt: Date(timeIntervalSince1970: 0),
                                updatedAt: Date(timeIntervalSince1970: 0))
    }

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case name, company, blog, location, email, hireable, bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    /**
     compare two GitHubUserDetails ignore the updatedAt 
     */
    static func ==(lhs : GitHubUserDetail, rhs : GitHubUserDetail) -> Bool {
        guard
            lhs.login == rhs.login,
            lhs.id == rhs.id,
            lhs.nodeID == rhs.nodeID,
            lhs.avatarURL == rhs.avatarURL,
            lhs.gravatarID == rhs.gravatarID,
            lhs.url == rhs.url,
            lhs.htmlURL == rhs.htmlURL,
            lhs.followersURL == rhs.followersURL,
            lhs.followingURL == rhs.followingURL,
            lhs.gistsURL == rhs.gistsURL,
            lhs.starredURL == rhs.starredURL,
            lhs.subscriptionsURL == rhs.subscriptionsURL,
            lhs.organizationsURL == rhs.organizationsURL,
            lhs.reposURL == rhs.reposURL,
            lhs.eventsURL == rhs.eventsURL,
            lhs.receivedEventsURL == rhs.receivedEventsURL,
            lhs.type == rhs.type,
            lhs.siteAdmin == rhs.siteAdmin,
            lhs.name == rhs.name,
            lhs.company == rhs.company,
            lhs.blog == rhs.blog,
            lhs.location == rhs.location,
            lhs.email == rhs.email,
            lhs.hireable == rhs.hireable,
            lhs.bio == rhs.bio,
            lhs.twitterUsername == rhs.twitterUsername,
            lhs.publicRepos == rhs.publicRepos,
            lhs.publicGists == rhs.publicGists,
            lhs.followers == rhs.followers,
            lhs.following == rhs.following,
            lhs.createdAt == rhs.createdAt
        else {
            return false
        }
        return true
    }
}
