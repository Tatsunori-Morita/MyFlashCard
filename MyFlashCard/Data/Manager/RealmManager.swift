//
//  RealmManager.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    private var books: [BookModel] = []
    private var cardModels: [CardModel] = []
    static var isRealmUpdate = false
    static var isRefreshIndex = false
    
    static func update(cardModel: CardModel) {
        let model = CardModel()
        model.id = cardModel.id
        model.book_id = cardModel.book_id
        model.front = cardModel.front
        model.back = cardModel.back
        model.comment = cardModel.comment
        model.isCheck = cardModel.isCheck
        model.isBookmark = cardModel.isBookmark
        model.created_at = cardModel.created_at
        model.updated_at = Date()
        model.deleted_at = cardModel.deleted_at
        let rp: AnyRepository<CardModel> = AnyRepository(CardRealmRepository())
        rp.update(domains: [model])
    }
    
    static func update(bookModel: BookModel) {
        let rp: AnyRepository<BookModel> = AnyRepository(BookRealmRepository())
        let model = BookModel()
        model.id = bookModel.id
        model.order = bookModel.order
        model.title = bookModel.title
        model.note = bookModel.note
        model.isRepeat = bookModel.isRepeat
        model.isMute = bookModel.isMute
        model.rate = bookModel.rate
        model.postInterval = bookModel.postInterval
        model.preInterval = bookModel.preInterval
        model.bookmarkType = bookModel.bookmarkType
        model.learnType = bookModel.learnType
        model.sortType = bookModel.sortType
        model.displayOptionType = bookModel.displayOptionType
        model.readPlace = bookModel.readPlace
        model.frontTextPosition = bookModel.frontTextPosition
        model.backTextPosition = bookModel.backTextPosition
        model.commentTextPosition = bookModel.commentTextPosition
        model.frontTextSize = bookModel.frontTextSize
        model.backTextSize = bookModel.backTextSize
        model.commentTextSize = bookModel.commentTextSize
        model.isCommentOn = bookModel.isCommentOn
        model.created_at = bookModel.created_at
        model.updated_at = bookModel.updated_at
        model.deleted_at = bookModel.deleted_at
        model.cards = bookModel.cards
        rp.update(domains: [model])
    }
    
    mutating func loadBookModels(conditions: String, sortKey: String, asc: Bool) {
        let rp: AnyRepository<BookModel> = AnyRepository(BookRealmRepository())
        books = rp.select(conditions: conditions, sortKey: sortKey, asc: asc).map({$0})
    }
    
    mutating func loadCardModels(bookModel: BookModel) {
        let rp: AnyRepository<CardModel> = AnyRepository(CardRealmRepository())
        var conditions = "book_id == '" + bookModel.id + "'"
        if bookModel.bookmarkType == BookmarkType.only.rawValue {
            conditions += " AND isBookmark == true"
        } else if (bookModel.bookmarkType == BookmarkType.not.rawValue) {
            conditions += " AND isBookmark == false"
        }
        
        if bookModel.learnType == LearnType.completed.rawValue {
            conditions += " AND isCheck == true"
        } else if (bookModel.learnType == LearnType.incomplete.rawValue) {
            conditions += " AND isCheck == false"
        }
        
        var sortKey = "created_at"
        var asc = true
        switch bookModel.sortType {
        case SortType.custome.rawValue:
            sortKey = "id"
        case SortType.createdAtAsc.rawValue:
            sortKey = "created_at"
        case SortType.createdAtDec.rawValue:
            sortKey = "created_at"
            asc = false
        case SortType.titleAsc.rawValue:
            sortKey = "front"
        case SortType.titleDec.rawValue:
            sortKey = "front"
            asc = false
        default:
            sortKey = "created_at"
        }
        
        cardModels = rp.select(conditions: conditions, sortKey: sortKey, asc: asc).map({$0})
        
        if bookModel.sortType == SortType.shuffle.rawValue {
            for i in 0 ..< cardModels.count{
                let r = Int(arc4random_uniform(UInt32(cardModels.count)))
                cardModels.swapAt(i, r)
            }
        }
    }
    
    func bookModelsCount() -> Int {
        return books.count
    }
    
    func cardModelsCount() -> Int {
        return cardModels.count
    }
    
    func bookData(at index: Int) -> BookModel? {
        if books.count > index {
            return books[index]
        }
        return nil
    }
    
    func bookData(id: String) -> BookModel? {
        if books.count > 0 {
            return books.filter { $0.id == id }.first
        }
        return nil
    }
    
    func cardData(at index: Int) -> CardModel? {
        if cardModels.count > index {
            return cardModels[index]
        }
        return nil
    }
    
    func cardData() -> [CardModel]? {
        if cardModels.count > 0 {
            return cardModels
        }
        return nil
    }
}

