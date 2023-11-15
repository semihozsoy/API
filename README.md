# API

# Usage
First we should implement endpoint related things.
```swift
enum MoviesEndpoint {
    case topRated
    case movieDetail(id: Int)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .topRated, .movieDetail:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        let accessToken = "insert your access token here -> https://www.themoviedb.org/settings/api"
        switch self {
        case .topRated, .movieDetail:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .topRated, .movieDetail:
            return nil
        }
    }
}
```
```swift
import API
extension ViewController: HTTPClient {
    
    func getAllMovies() {
        sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: Movies.self) { [weak self] result in
            switch result {
            case let .success(response):
                break
            case let .failure(error):
                break
            }
        }
    }
}
```

