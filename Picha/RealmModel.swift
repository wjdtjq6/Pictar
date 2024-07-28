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
    convenience init(id: String, date: Date) {
        self.init()
        self.id = id
        //self.date = Date()
    }
}
