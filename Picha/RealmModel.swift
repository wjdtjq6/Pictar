//
//  RealmModel.swift
//  Picha
//
//  Created by t2023-m0032 on 7/27/24.
//

import Foundation
import RealmSwift
//realm에 무슨 데이터를 넣을까?:
class likeList: Object {
    @Persisted(primaryKey: true) var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}
/*
 struct SearchResults: Decodable {
     let id: String
     let created_at: String
     let width: Int
     let height: Int
     let urls: SearchUrls
     let likes: Int         //노필요
     let user: SearchUser
 }
 */
