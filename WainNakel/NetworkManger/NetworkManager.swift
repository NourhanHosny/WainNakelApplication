import Alamofire
import Foundation
class NetworkManager {
    struct Configuration {
        var url: String
        var method: HTTPMethod
        
    }
    static var rawResponse: NSDictionary?
  
    static var headers: [String: String] {
        return ["Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"]
    }
    class func getResturant(configuration: Configuration, completion: @escaping (_ response: ResturantVM?) -> Void) {
        rawResponse = nil
    guard let gitUrl = URL(string: configuration.url) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
            , error) in
        guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Resturant.self, from: data)
                completion(ResturantVM(resturant: result))
            } catch _ {
                completion(nil)
            
    } }.resume()
}}

extension NetworkManager.Configuration {
    init(parameters: [String: Any]?, url: String, method: HTTPMethod) {
        self.url = url
        self.method = method
   }
}
