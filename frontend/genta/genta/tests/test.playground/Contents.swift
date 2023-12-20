import UIKit

let endPoint = "http://localhost:8080/api/v1/users"

func loginTest(loginData: [String: Any]) async throws -> [String: Any]{
   print("Attempting to login")
    guard let jsonData = try? JSONSerialization.data(withJSONObject: loginData) else {
         // Handle JSON serialization error converting json failed
        print("error converting loginData to JSON")
        return ["err" : true, "msg" : "Server error try again later"]
     }
    guard let url = URL(string: "\(endPoint)/login") else{
//            error creating url
        print("error creating url")
       return ["err" : true, "msg" : "Server error try again later"]
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
            guard let data = data, error == nil else {
                // Handle network error
//                print("got error from server", error)
                return
            }
            
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                print(user)
            } catch(let error){
                print("Error converting recieved user data JSON to user Struct:")
                print(error)
            }
    }
    return ["err" : true, "msg" : "Unable to sign in."]
}

let data  = ["email" : "fdf@gmail.com", "password" : "adfaffdfd"]
Task{
    try await
    loginTest(loginData: data)
}
