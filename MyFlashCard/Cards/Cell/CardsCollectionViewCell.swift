//
//  CardsCollectionViewCell.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {

    weak var delegate: CardsCollectionViewCellDelegete! = nil
    
    @IBOutlet weak var frontTextView: UITextView!
    @IBOutlet weak var backTextView: UITextView!
    @IBOutlet weak var bookmarkActiveButton: UIButton!
    @IBOutlet weak var bookmarkInactiveButton: UIButton!
    @IBOutlet weak var checkActiveButton: UIButton!
    @IBOutlet weak var checkInactiveButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentActiveButton: UIButton!
    @IBOutlet weak var commentInactiveButton: UIButton!
    
//    private var frontSpeekButton: UIButton {
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        btn.backgroundColor = .clear
//        btn.setImage(UIImage(systemName: "speaker.3"), for: .normal)
//        btn.addTarget(self, action: #selector(tapFrontSpeekButton), for: .touchUpInside)
//        return btn
//    }
    private var frontSpeekButton: UIButton!
//    private var backSpeekButton: UIButton {
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        btn.backgroundColor = .clear
//        btn.setImage(UIImage(systemName: "speaker.3"), for: .normal)
//        btn.addTarget(self, action: #selector(tapBackSpeekButton), for: .touchUpInside)
//        return btn
//    }
    private var backSpeekButton: UIButton!
    private var frontEyeInactiveButton: UIButton!
    private var backEyeInactiveButton: UIButton!
    private var frontEyeAtiveButton: UIButton!
    private var backEyeActiveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        frontSpeekButton = UIButton()
        frontSpeekButton.backgroundColor = .clear
        frontSpeekButton.setImage(UIImage(systemName: "speaker.3"), for: .normal)
        frontSpeekButton.addTarget(self, action: #selector(tapFrontSpeekButton), for: .touchUpInside)
        
        
        backSpeekButton = UIButton()
        backSpeekButton.backgroundColor = .clear
        backSpeekButton.setImage(UIImage(systemName: "speaker.3"), for: .normal)
        backSpeekButton.addTarget(self, action: #selector(tapBackSpeekButton), for: .touchUpInside)
        
        
        frontEyeInactiveButton = UIButton()
        frontEyeInactiveButton.backgroundColor = .clear
        frontEyeInactiveButton.tag = 1
        frontEyeInactiveButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        frontEyeInactiveButton.addTarget(self, action: #selector(tapFrontEyeInactiveButton), for: .touchUpInside)
        
        backEyeInactiveButton = UIButton()
        backEyeInactiveButton.backgroundColor = .clear
        backEyeInactiveButton.tag = 2
        backEyeInactiveButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        backEyeInactiveButton.addTarget(self, action: #selector(tapBackEyeInactiveButton), for: .touchUpInside)
        
        frontEyeAtiveButton = UIButton()
        frontEyeAtiveButton.backgroundColor = .clear
        frontEyeAtiveButton.tag = 1
        frontEyeAtiveButton.setImage(UIImage(systemName: "eye"), for: .normal)
        frontEyeAtiveButton.addTarget(self, action: #selector(tapFrontEyeAtiveButton), for: .touchUpInside)
        
        backEyeActiveButton = UIButton()
        backEyeActiveButton.backgroundColor = .clear
        backEyeActiveButton.tag = 2
        backEyeActiveButton.setImage(UIImage(systemName: "eye"), for: .normal)
        backEyeActiveButton.addTarget(self, action: #selector(tapBackEyeActiveButton), for: .touchUpInside)
        
        frontEyeAtiveButton.isHidden = true
        backEyeActiveButton.isHidden = true
        
        frontTextView.addSubview(frontSpeekButton)
        backTextView.addSubview(backSpeekButton)
        frontTextView.addSubview(frontEyeInactiveButton)
        backTextView.addSubview(backEyeInactiveButton)
        frontTextView.addSubview(frontEyeAtiveButton)
        backTextView.addSubview(backEyeActiveButton)
    }
    
    override func layoutSubviews() {
        frontSpeekButton.frame = CGRect(x: 0, y: frontTextView.contentInset.top, width: 50, height: 50)
        backSpeekButton.frame = CGRect(x: 0, y: backTextView.contentInset.top, width: 50, height: 50)
        
        frontEyeAtiveButton.frame = CGRect(x: frontTextView.frame.width - 50, y: frontTextView.contentInset.top, width: 50, height: 50)
        frontEyeInactiveButton.frame = CGRect(x: frontTextView.frame.width - 50, y: frontTextView.contentInset.top, width: 50, height: 50)
        backEyeActiveButton.frame = CGRect(x: backTextView.frame.width - 50, y: backTextView.contentInset.top, width: 50, height: 50)
        backEyeInactiveButton.frame = CGRect(x: backTextView.frame.width - 50, y: backTextView.contentInset.top, width: 50, height: 50)
        
        frontEyeAtiveButton.isHidden = true
        frontEyeInactiveButton.isHidden = false
        backEyeActiveButton.isHidden = true
        backEyeInactiveButton.isHidden = false
    }

    @IBAction func tapBookmarkActiveButton(_ sender: Any) {
        delegate?.tapBookmarkActiveButton(sender: self)
    }
    
    @IBAction func tapBookmarkInactiveButton(_ sender: Any) {
        delegate?.tapBookmarkInactiveButton(sender: self)
    }
    
    @IBAction func tapCheckActiveButton(_ sender: Any) {
        delegate?.tapCheckActiveButton(sender: self)
    }
    
    @IBAction func tapCheckInactiveButton(_ sender: Any) {
        delegate?.tapCheckInactiveButton(sender: self)
    }
    
    @IBAction func edit(_ sender: Any) {
        delegate?.edit(sender: self)
    }
    
    @IBAction func tapCommentActiveButton(_ sender: Any) {
        delegate?.tapCommentActiveButton(sender: self)
    }
    
    @IBAction func tapCommentInactiveButton(_ sender: Any) {
        delegate?.tapCommentInactiveButton(sender: self)
    }
    
    @objc private func tapFrontSpeekButton(_ sender: Any) {
        delegate?.tapFrontSpeekButton(sender: self)
    }
    
    @objc private func tapBackSpeekButton(_ sender: Any) {
        delegate?.tapBackSpeekButton(sender: self)
    }
    
    @objc private func tapFrontEyeInactiveButton(_ sender: Any) {
        delegate?.tapFrontEyeInactiveButton(sender: self)
    }
    
    @objc private func tapBackEyeInactiveButton(_ sender: Any) {
        delegate?.tapBackEyeInactiveButton(sender: self)
    }
    
    @objc private func tapFrontEyeAtiveButton(_ sender: Any) {
        delegate?.tapFrontEyeAtiveButton(sender: self)
    }
    
    @objc private func tapBackEyeActiveButton(_ sender: Any) {
        delegate?.tapBackEyeActiveButton(sender: self)
    }
    
    // hide
    func tapEyeButton(isFront: Bool) {
        if isFront {
            frontTextView.text = "---"
            frontEyeInactiveButton.isHidden = true
            frontEyeAtiveButton.isHidden = false
        } else {
            backTextView.text = "---"
            backEyeInactiveButton.isHidden = true
            backEyeActiveButton.isHidden = false
        }
    }
    
    // open
    func tapEyeSlashButton(isFront: Bool, text: String) {
        if isFront {
            frontTextView.text = text
            frontEyeInactiveButton.isHidden = false
            frontEyeAtiveButton.isHidden = true
        } else {
            backTextView.text = text
            backEyeInactiveButton.isHidden = false
            backEyeActiveButton.isHidden = true
        }
    }
    
    private func setTextPosition(bookModel: BookModel) {
        switch bookModel.frontTextPosition {
        case 1:
            frontTextView.textAlignment = .center
        case 2:
            frontTextView.textAlignment = .right
        default:
            frontTextView.textAlignment = .left
        }
        
        switch bookModel.backTextPosition {
        case 1:
            backTextView.textAlignment = .center
        case 2:
            backTextView.textAlignment = .right
        default:
            backTextView.textAlignment = .left
        }
        
        switch bookModel.commentTextPosition {
        case 1:
            commentTextView.textAlignment = .center
        case 2:
            commentTextView.textAlignment = .right
        default:
            commentTextView.textAlignment = .left
        }
    }
    
    private func setTextSize(bookModel: BookModel) {
        switch bookModel.frontTextSize {
        case TextSize.small.rawValue:
            frontTextView.font = .systemFont(ofSize: 12)
        case TextSize.medium.rawValue:
            frontTextView.font = .systemFont(ofSize: 18)
        case TextSize.large.rawValue:
            frontTextView.font = .systemFont(ofSize: 24)
        case TextSize.extraLarge.rawValue:
            frontTextView.font = .systemFont(ofSize: 30)
        default:
            print("no font size")
        }
        
        switch bookModel.backTextSize {
        case TextSize.small.rawValue:
            backTextView.font = .systemFont(ofSize: 12)
        case TextSize.medium.rawValue:
            backTextView.font = .systemFont(ofSize: 18)
        case TextSize.large.rawValue:
            backTextView.font = .systemFont(ofSize: 24)
        case TextSize.extraLarge.rawValue:
            backTextView.font = .systemFont(ofSize: 30)
        default:
            print("no font size")
        }
        
        switch bookModel.commentTextSize {
        case TextSize.small.rawValue:
            commentTextView.font = .systemFont(ofSize: 12)
        case TextSize.medium.rawValue:
            commentTextView.font = .systemFont(ofSize: 18)
        case TextSize.large.rawValue:
            commentTextView.font = .systemFont(ofSize: 24)
        case TextSize.extraLarge.rawValue:
            commentTextView.font = .systemFont(ofSize: 30)
        default:
            print("no font size")
        }
    }
    
    private func setCommentArea(bookModel: BookModel) {
        if bookModel.isCommentOn {
            commentTextView.isHidden = false
            commentActiveButton.isHidden = true
            commentInactiveButton.isHidden = false
        } else {
            commentTextView.isHidden = true
            commentActiveButton.isHidden = false
            commentInactiveButton.isHidden = true
        }
    }
    
    private func setCardButton(cardModel: CardModel) {
        if cardModel.isBookmark {
            bookmarkActiveButton.isHidden = false
            bookmarkInactiveButton.isHidden = true
        } else {
            bookmarkActiveButton.isHidden = true
            bookmarkInactiveButton.isHidden = false
        }
        
        if cardModel.isCheck {
            checkActiveButton.isHidden = false
            checkInactiveButton.isHidden = true
        } else {
            checkActiveButton.isHidden = true
            checkInactiveButton.isHidden = false
        }
    }
    
    private func setCardText(cardModel: CardModel) {
        frontTextView.text = cardModel.front
        backTextView.text = cardModel.back
        commentTextView.text = cardModel.comment
    }
    
    var book: BookModel? {
        didSet {
            guard let b = book else {
                return
            }
            setTextPosition(bookModel: b)
            setTextSize(bookModel: b)
            setCommentArea(bookModel: b)
        }
    }
    
    var card: CardModel? {
        didSet {
            guard let c = card else {
                return
            }
            setCardText(cardModel: c)
            setCardButton(cardModel: c)
        }
    }
    
    var isActiveCommentArea: Bool? {
        didSet {
            guard let isActive = isActiveCommentArea else {
                return
            }
            if isActive {
                commentTextView.isHidden = false
                commentActiveButton.isHidden = true
                commentInactiveButton.isHidden = false
            } else {
                commentTextView.isHidden = true
                commentActiveButton.isHidden = false
                commentInactiveButton.isHidden = true
            }
        }
    }
}

protocol CardsCollectionViewCellDelegete: class {
    func tapBookmarkActiveButton(sender: CardsCollectionViewCell)
    func tapBookmarkInactiveButton(sender: CardsCollectionViewCell)
    func tapCheckActiveButton(sender: CardsCollectionViewCell)
    func tapCheckInactiveButton(sender: CardsCollectionViewCell)
    func edit(sender: CardsCollectionViewCell)
    func tapCommentActiveButton(sender: CardsCollectionViewCell)
    func tapCommentInactiveButton(sender: CardsCollectionViewCell)
    func tapFrontSpeekButton(sender: CardsCollectionViewCell)
    func tapBackSpeekButton(sender: CardsCollectionViewCell)
    func tapFrontEyeInactiveButton(sender: CardsCollectionViewCell)
    func tapBackEyeInactiveButton(sender: CardsCollectionViewCell)
    func tapFrontEyeAtiveButton(sender: CardsCollectionViewCell)
    func tapBackEyeActiveButton(sender: CardsCollectionViewCell)
}
