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
    let urls: PhotosUrls
    let likes: Int
    let user: PhotosUser
}
struct PhotosUrls: Decodable {
    let raw: String
    let small: String
}
struct PhotosUser: Decodable {
    let name: String
    let profile_image: PhotosMedium
}
struct PhotosMedium: Decodable {
    let medium: String
}

struct Search: Decodable {
    let total_pages: Int
    var results: [SearchResults]//SearchViewController에서 pagenation의 .append(contentsOf: value!.results)때문에 var로 바꿈
}
struct SearchResults: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: SearchUrls
    let likes: Int
    let user: SearchUser
}
struct SearchUrls: Decodable {
    let raw: String
    let small: String
}
struct SearchUser: Decodable {
    let name: String
    let profile_image: SearchMedium
}
struct SearchMedium: Decodable {
    let medium: String
}

struct Statistics: Decodable {
    let id: String
    let downloads: Downloads
    let views: Views
}
struct Downloads: Decodable {
    let total: Int
}
struct Views: Decodable {
    let total: Int
}

class UnsplashAPI {
    static let shared = UnsplashAPI()
    private init() {}
        
    func photos<T: Decodable>(api: UnsplashRequest,model: T.Type, completionHandler: @escaping (T?) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
                //self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    func search<T: Decodable>(api: UnsplashRequest, model: T.Type, completionHandler: @escaping (T?) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    func photosStatistics<T: Decodable>(api: UnsplashRequest, model: T.Type, completionHandler: @escaping (T?) -> Void) {
        AF.request(api.endPoint, method: .get, parameters: api.parameter, encoding: URLEncoding(destination: .queryString)).responseDecodable(of: T.self) { response in
            print(response.response?.statusCode ?? 0)
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
