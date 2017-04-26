import GoogleyEyesCore
import SwiftyJSON

public class DiscoveryFetcher: GoogleServiceFetcher {
    public let apiNameInURL = "discovery"
    public let apiVersionString = "v1"
    
    public var userIP: String?
    public var quotaUser: String?
    public var prettyPrint: Bool = true
    public var fields: String?
    
    public required init() {
        
    }
    
    func encodeStandardQueryParams() -> [String: String] {
        var dict: [String: String] = [:]
        if let userIp = userIP {
            dict["userIp"] = userIp
        }
        if let quotaUser = quotaUser {
            dict["quotaUser"] = quotaUser
        }
        if !prettyPrint {
            dict["prettyPrint"] = JSON(prettyPrint).stringValue
        }
        if let fields = fields {
            dict["fields"] = fields
        }
        return dict
    }
}

public class APIsFetcher: DiscoveryFetcher {
    public var name: String?
    public var preferred: Bool = false
    
    public func listAPIs(completion: @escaping (Result<DirectoryList>) -> ()) {
        var queryParams = encodeStandardQueryParams()
        if let name = name {
            queryParams["name"] = name
        }
        if preferred {
            queryParams["preferred"] = JSON(preferred).stringValue
        }
        
        let request = APIRequest(method: .get, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "/apis", queryParams: queryParams)
        let networkFetcher = NetworkFetcher(request: request)
        networkFetcher.execute { (result) in
            switch result {
            case .success(let json):
                completion(.success(DirectoryList(json: json)))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    public func getDiscoveryDocument(forAPIName api: String, version: String, completion: @escaping (Result<DiscoveryDocument>) -> ()) {
        let queryParams = encodeStandardQueryParams()
        let request = APIRequest(method: .get, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "/apis/\(api)/\(version)/rest", queryParams: queryParams)
        let networkFetcher = NetworkFetcher(request: request)
        networkFetcher.execute { (result) in
            switch result {
            case .success(let json):
                completion(.success(DiscoveryDocument(json: json)))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
