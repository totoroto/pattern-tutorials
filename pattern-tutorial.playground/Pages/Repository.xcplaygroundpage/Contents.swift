import Foundation

struct User: Codable {
    let login: String?
    let url: String?
    let avatar_url : String?
}

struct DomainUser { // Domain Object
    let name: String?
    let url: String?
    let thumbnailUrl: String?
}

class UserApiService {
    let url = URL(string: "https://api.github.com/users/totoroto")!
    
    func fetchUserInfo(completionHandler: @escaping (DomainUser?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error != nil else { return }
            guard let data else { return }
            guard let user = try? JSONSerialization.jsonObject(with: data) as? User else { return }
            
            let domainUser = DomainUser(name: user.login,
                                        url: user.url,
                                        thumbnailUrl: user.avatar_url)
            /*
             UserDTO의 내부 구성(response)이 달라져도
             Presenter 영역(ViewController or ViewModel) 수정이 필요 없이
             Domain Object 생성 하는 부분만 바꾸면 됩니다.
            */
            completionHandler(domainUser)
        }.resume()
    }
}
