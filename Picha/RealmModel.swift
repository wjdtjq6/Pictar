//
//  RealmModel.swift
//  Picha
//
//  Created by t2023-m0032 on 7/27/24.
//

import Foundation
import RealmSwift
//realm에 무슨 데이터를 넣을까?:
class LikeList: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date = Date()
    @Persisted var userImage: String
    @Persisted var smallImage: String
    @Persisted var userName: String
    @Persisted var createdDate: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var count: Int
    @Persisted var downloadValue: Int
    convenience init(id: String, date: Date, userImage: String, smallImage: String, userName: String, createdDate: String, width: Int, height: Int, count: Int, downloadValue: Int) {
        self.init()
        self.id = id
        self.userImage = userImage
        self.smallImage = smallImage
        self.userName = userName
        self.createdDate = createdDate
        self.width = width
        self.height = height
        self.count = count
        self.downloadValue = downloadValue
        //self.date = Date()
    }
}
