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
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var containerView: UIView!
    private let bottomBorder = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 5
        containerView.layer.cornerRadius = 5
        bottomBorder.backgroundColor = UIColor(red: 215/255, green: 213/255, blue: 213/255, alpha: 1).cgColor
        titleLabel.layer.addSublayer(bottomBorder)
        
        baseView.layer.shadowColor = UIColor(red: 203/255, green: 208/255, blue: 216/255, alpha: 1).cgColor
        baseView.layer.shadowRadius = 4
        baseView.layer.shadowOffset = CGSize(width: 3, height: 3)
        baseView.layer.shadowOpacity = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        noteTextView.isUserInteractionEnabled = false
        let borderWidth = CGFloat(1)
        bottomBorder.frame = CGRect(x: 0, y: titleLabel.frame.size.height - borderWidth, width: frame.size.width - 80, height: borderWidth)
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
