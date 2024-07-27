//
//  UnsplashRequest.swift
//  Picha
//
//  Created by t2023-m0032 on 7/25/24.
//

import Foundation
import Alamofire

enum UnsplashRequest {
    case photos(topicID: String)
    case search(query: String, page: Int, pre_page: Int,order_by:String/*, color: String*/)
    case photosStatistics(imageID: String)
    case photosRandom
    
    var baseUrl: String {
        return "https://api.unsplash.com/"
    }
    var endPoint: URL {
        switch self {
        case .photos(let topicID):
            return URL(string: baseUrl + "topics/\(topicID)/photos")!
        case .search:
            return URL(string: baseUrl + "search/photos")!
        case .photosStatistics(let imageID):
            return URL(string: baseUrl + "photos/\(imageID)/statistics")!
        case .photosRandom:
            return URL(string: baseUrl + "phoots/random")!
        }
    }
    var method: HTTPMethod {
        return .get
    }
    var parameter: Parameters {
        switch self {
        case .photos, .photosStatistics, .photosRandom:
            return ["client_id": APIKey.client_id]
        case .search(let query, let page, let pre_page,let order_by/*, let color*/):
            return ["client_id": APIKey.client_id,"query": query, "page": page, "per_page": 20, "order_by":order_by/*, "color": color*/]
        }
    }
}
