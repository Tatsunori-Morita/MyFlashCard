//
//  HomeTableViewCell.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var bookMarkCountLabel: UILabel!
    @IBOutlet weak var checkCountlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        noteTextView.isUserInteractionEnabled = false
    }
    
    var home: HomeCellParam? {
        didSet {
            guard let h = home else {
                return
            }
            titleLabel.text = h.title
            noteTextView.text = h.note
            cardCountLabel.text = h.cardCount
            bookMarkCountLabel.text = h.bookMarkCount
            checkCountlLabel.text = h.checkCount
        }
    }
}

class HomeCellParam {
    fileprivate var title: String = ""
    fileprivate var note: String = ""
    fileprivate var cardCount: String = ""
    fileprivate var bookMarkCount: String = ""
    fileprivate var checkCount: String = ""
    
    init(title: String, note: String, cardCount: String, bookMarkCount: String, checkCount: String) {
        self.title = title
        self.note = note
        self.cardCount = cardCount
        self.bookMarkCount = bookMarkCount
        self.checkCount = checkCount
    }
}
