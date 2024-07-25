//
//  UnsplashAPI.swift
//  Picha
//
//  Created by t2023-m0032 on 7/24/24.
//

import Foundation
import Alamofire

struct Photos: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: Urls
    let likes: Int
    let user: User
}
struct Urls: Decodable {
    let raw: String
    let small: String
}
struct User: Decodable {
    let name: String
    let profile_image: Medium
}
struct Medium: Decodable {
    let medium: String
}

class UnsplashAPI {
    static let shared = UnsplashAPI()
    private init() {}
    
    //var list = [Photos]()
    
    func photos<T: Decodable>(api: UnsplashRequest,model: T.Type, completionHandler: @escaping (T?) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            print(response.response?.statusCode ?? 0)
            switch response.result {
            case .success(let value):
                completionHandler(value)
                //self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
