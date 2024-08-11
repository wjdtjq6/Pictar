//
//  RealmModel.swift
//  Picha
//
//  Created by t2023-m0032 on 7/27/24.
//

import Foundation
import RealmSwift
//TODO: uiimage->data
class LikeList: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var date = Date()
    @Persisted var userImage: Data
    @Persisted var smallImage: Data
    @Persisted var userName: String
    @Persisted var createdDate: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var count: String
    @Persisted var downloadValue: Int
    @Persisted var isLike: Bool
    convenience init(id: String, date: Date, userImage: Data, smallImage: Data, userName: String, createdDate: String, width: Int, height: Int, count: String, downloadValue: Int, isLike: Bool) {
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
        self.isLike = isLike
        //self.date = Date()
    }
}
