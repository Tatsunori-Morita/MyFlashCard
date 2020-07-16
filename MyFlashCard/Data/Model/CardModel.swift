//
//  CardModel.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

class CardModel: Object, NSCopying {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var book_id: String?
    @objc dynamic var front: String?
    @objc dynamic var back: String?
    @objc dynamic var comment: String?
    @objc dynamic var isCheck: Bool = false
    @objc dynamic var isBookmark: Bool = false
    @objc dynamic var deleted_at: Date?
    @objc dynamic var created_at: Date?
    @objc dynamic var updated_at: Date?
    var book = LinkingObjects(fromType: BookModel.self, property: "cards")

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let model = CardModel()
        model.id = id
        model.book_id = book_id
        model.front = front
        model.back = back
        model.comment = comment
        model.isCheck = isCheck
        model.isBookmark = isBookmark
        model.deleted_at = deleted_at
        model.created_at = created_at
        model.updated_at = updated_at
        return model
    }
}

