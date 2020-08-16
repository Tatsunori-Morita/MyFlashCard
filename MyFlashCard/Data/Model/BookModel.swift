//
//  BookModel.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

class BookModel: Object, NSCopying {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var note: String?
    @objc dynamic var isRepeat: Bool = false // リピート
    @objc dynamic var isMute: Bool = false // ミュート
    @objc dynamic var rate: Float = 0.5 // 読み上げスピード
    @objc dynamic var postInterval: Float = 0.5 // 開始読み上げ時間
    @objc dynamic var preInterval: Float = 0.5 // 読み上げ後のインターバル時間
    @objc dynamic var bookmarkType: Int = BookmarkType.none.rawValue // ブックマーク
    @objc dynamic var learnType: Int = LearnType.none.rawValue // 暗記
    @objc dynamic var sortType: Int = SortType.custome.rawValue // ソート
    @objc dynamic var displayOptionType: Int = DisplayOptionType.front.rawValue // 表示オプション
    @objc dynamic var readPlace: Int = ReadType.both.rawValue // 読み上げ位置
    @objc dynamic var frontTextPosition: Int = TextPosition.left.rawValue // 表面のテキスト表示位置
    @objc dynamic var backTextPosition: Int = TextPosition.left.rawValue // 裏面のテキスト表示位置
    @objc dynamic var commentTextPosition: Int = TextPosition.left.rawValue // コメントのテキスト表示位置
    @objc dynamic var frontTextSize: Int = TextSize.medium.rawValue // 表面のテキストサイズ
    @objc dynamic var backTextSize: Int = TextSize.medium.rawValue // 裏面のテキストサイズ
    @objc dynamic var commentTextSize: Int = TextSize.medium.rawValue // コメントのテキストサイズ
    @objc dynamic var isCommentOn: Bool = false // コメントの表示・非表示
    @objc dynamic var deleted_at: Date?
    @objc dynamic var created_at: Date?
    @objc dynamic var updated_at: Date?
    var cards = List<CardModel>()
    
    enum Speed: Float {
        case level1 = 0.1
        case level2 = 0.25
        case level3 = 0.5
        case level4 = 0.75
        case level5 = 1.0
    }
    
    enum Interval: Float {
        case level1 = 0
        case level2 = 0.3
        case level3 = 0.5
        case level4 = 0.7
        case level5 = 1.0
    }

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let model = BookModel()
        model.id = id
        model.title = title
        model.note = note
        model.isRepeat = isRepeat
        model.isMute = isMute
        model.rate = rate
        model.postInterval = postInterval
        model.preInterval = preInterval
        model.bookmarkType = bookmarkType
        model.learnType = learnType
        model.sortType = sortType
        model.displayOptionType = displayOptionType
        model.readPlace = readPlace
        model.frontTextPosition = frontTextPosition
        model.backTextPosition = backTextPosition
        model.commentTextPosition = commentTextPosition
        model.frontTextSize = frontTextSize
        model.backTextSize = backTextSize
        model.commentTextSize = commentTextSize
        model.isCommentOn = isCommentOn
        model.created_at = created_at
        model.updated_at = updated_at
        model.deleted_at = deleted_at
        let vocabulaiesRow = cards.map{$0}
        let newVocabularies = vocabulaiesRow.map{
            vocabulary -> CardModel in
            let vocabularyModel = CardModel()
            vocabularyModel.id = vocabulary.id
            vocabularyModel.book_id = vocabulary.book_id
            vocabularyModel.front = vocabulary.front
            vocabularyModel.back = vocabulary.back
            vocabularyModel.comment = vocabulary.comment
            vocabularyModel.isCheck = vocabulary.isCheck
            vocabularyModel.isBookmark = vocabulary.isBookmark
            vocabularyModel.deleted_at = vocabulary.deleted_at
            vocabularyModel.created_at = vocabulary.created_at
            vocabularyModel.updated_at = vocabulary.updated_at
            return vocabularyModel
        }
        newVocabularies.forEach{ model.cards.append($0) }
        return model
    }
    
    func changeInterval() {
        switch postInterval + preInterval {
        case 0:
            postInterval = 0.15
            preInterval = 0.15
        case 0.3:
            postInterval = 0.25
            preInterval = 0.25
        case 0.5:
            postInterval = 0.35
            preInterval = 0.35
        case 0.7:
            postInterval = 0.5
            preInterval = 0.5
        case 1:
            postInterval = 0
            preInterval = 0
        default:
            print("no toolbar button")
        }
    }
    
    func changeRate() {
        switch rate {
        case 0.1:
            rate = 0.25
        case 0.25:
            rate = 0.5
        case 0.5:
            rate = 0.75
        case 0.75:
            rate = 1
        case 1:
            rate = 0.1
        default:
            print("no toolbar button")
        }
    }
    
    func changeRepeat() {
        if isRepeat {
            isRepeat = false
        } else {
            isRepeat = true
        }
    }
    
    func changeMute() {
        if isMute {
            isMute = false
        } else {
            isMute = true
        }
    }
}

enum BookmarkType: Int {
    case none = 0 // 設定なし
    case only = 1 // ブックマーク
    case not = 2 // ブックマークを除く
}

enum LearnType: Int {
    case none = 0 // 設定なし
    case completed = 1 // 暗記済み
    case incomplete = 2 // 暗記済みを除く
}

enum SortType: Int {
    case custome = 0 // カスタム
    case shuffle = 1 // シャフル
    case createdAtAsc = 2 // 作成日昇順
    case createdAtDec = 3 // 作成日降順
    case titleAsc = 4 // タイトル昇順
    case titleDec = 5 // タイトル降順
}

enum DisplayOptionType: Int {
//    case none = 0 // 設定なし
    case front = 1 // 表面を先
    case back = 2 // 裏面を先
}

enum ReadType: Int {
    case both = 0 // 両面読み上げ
    case front = 1 // 表面のみ読み上げ
    case back = 2 // 裏面のみ読み上げ
}

enum TextPosition: Int {
    case left = 0 // 左寄せ
    case center = 1 // 中央
    case right = 2 // 右寄せ
}

enum TextSize: Int {
    case small = 0 // 小
    case medium = 1 // 中
    case large = 2 // 大
    case extraLarge = 3 // 特大
}

