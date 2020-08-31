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
    
    private var frontTextView: ToucheEventTextView!
    private var backTextView: ToucheEventTextView!
    @IBOutlet weak var bookmarkActiveButton: UIButton!
    @IBOutlet weak var bookmarkInactiveButton: UIButton!
    @IBOutlet weak var checkActiveButton: UIButton!
    @IBOutlet weak var checkInactiveButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentActiveButton: UIButton!
    @IBOutlet weak var commentInactiveButton: UIButton!
    @IBOutlet weak var frontBaseView: UIView!
    @IBOutlet weak var backBaseView: UIView!
    private var frontSpeekButton: UIButton!
    private var backSpeekButton: UIButton!
    private var frontEyeInactiveButton: UIButton!
    private var backEyeInactiveButton: UIButton!
    private var frontEyeAtiveButton: UIButton!
    private var backEyeActiveButton: UIButton!
    let frontBaseBorder = CALayer()
    let backBaseBorder = CALayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor(red: 203/255, green: 208/255, blue: 216/255, alpha: 1).cgColor
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        
        frontTextView = ToucheEventTextView()
        frontTextView.textColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        frontTextView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        frontTextView.isEditable = false
        backTextView = ToucheEventTextView()
        backTextView.textColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        backTextView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        backTextView.isEditable = false
        
        frontSpeekButton = UIButton(type: .system)
        frontSpeekButton.backgroundColor = .clear
        frontSpeekButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        frontSpeekButton.setImage(UIImage(systemName: "speaker.3"), for: .normal)
        frontSpeekButton.addTarget(self, action: #selector(tapFrontSpeekButton), for: .touchUpInside)
        
        backSpeekButton = UIButton(type: .system)
        backSpeekButton.backgroundColor = .clear
        backSpeekButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        backSpeekButton.setImage(UIImage(systemName: "speaker.3"), for: .normal)
        backSpeekButton.addTarget(self, action: #selector(tapBackSpeekButton), for: .touchUpInside)
        
        frontEyeInactiveButton = UIButton(type: .system)
        frontEyeInactiveButton.backgroundColor = .clear
        frontEyeInactiveButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        frontEyeInactiveButton.tag = 1
        frontEyeInactiveButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        frontEyeInactiveButton.addTarget(self, action: #selector(tapFrontEyeInactiveButton), for: .touchUpInside)
        
        backEyeInactiveButton = UIButton(type: .system)
        backEyeInactiveButton.backgroundColor = .clear
        backEyeInactiveButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        backEyeInactiveButton.tag = 2
        backEyeInactiveButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        backEyeInactiveButton.addTarget(self, action: #selector(tapBackEyeInactiveButton), for: .touchUpInside)
        
        frontEyeAtiveButton = UIButton(type: .system)
        frontEyeAtiveButton.backgroundColor = .clear
        frontEyeAtiveButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        frontEyeAtiveButton.tag = 1
        frontEyeAtiveButton.setImage(UIImage(systemName: "eye"), for: .normal)
        frontEyeAtiveButton.addTarget(self, action: #selector(tapFrontEyeAtiveButton), for: .touchUpInside)
        
        backEyeActiveButton = UIButton(type: .system)
        backEyeActiveButton.backgroundColor = .clear
        backEyeActiveButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 0.6)
        backEyeActiveButton.tag = 2
        backEyeActiveButton.setImage(UIImage(systemName: "eye"), for: .normal)
        backEyeActiveButton.addTarget(self, action: #selector(tapBackEyeActiveButton), for: .touchUpInside)
        
        frontEyeAtiveButton.isHidden = true
        backEyeActiveButton.isHidden = true

        frontBaseView.addSubview(frontTextView)
        backBaseView.addSubview(backTextView)
        
        frontBaseView.addSubview(frontSpeekButton)
        frontBaseView.bringSubviewToFront(frontSpeekButton)
        frontBaseView.addSubview(frontEyeInactiveButton)
        frontBaseView.bringSubviewToFront(frontEyeInactiveButton)
        frontBaseView.addSubview(frontEyeAtiveButton)
        frontBaseView.bringSubviewToFront(frontEyeAtiveButton)
        
        backBaseView.addSubview(backSpeekButton)
        backBaseView.bringSubviewToFront(backSpeekButton)
        backBaseView.addSubview(backEyeInactiveButton)
        backBaseView.bringSubviewToFront(backEyeInactiveButton)
        backBaseView.addSubview(backEyeActiveButton)
        backBaseView.bringSubviewToFront(frontEyeAtiveButton)
        
        frontBaseBorder.backgroundColor = UIColor(red: 207/255, green: 207/255, blue: 209/255, alpha: 1).cgColor
        frontBaseView.layer.addSublayer(frontBaseBorder)
        backBaseBorder.backgroundColor = UIColor(red: 207/255, green: 207/255, blue: 209/255, alpha: 1).cgColor
        backBaseView.layer.addSublayer(backBaseBorder)
    }
    
    override func layoutSubviews() {
        frontTextView.frame = CGRect(x: 0, y: 0, width: frontBaseView.frame.width, height: frontBaseView.frame.height)
        backTextView.frame = CGRect(x: 0, y: 0, width: backBaseView.frame.width, height: backBaseView.frame.height)
        
        frontSpeekButton.frame = CGRect(x: 0, y: frontBaseView.frame.height - 50, width: 50, height: 50)
        backSpeekButton.frame = CGRect(x: 0, y: backBaseView.frame.height - 50, width: 50, height: 50)
        
        frontEyeAtiveButton.frame = CGRect(x: frontBaseView.frame.width - 50, y: frontBaseView.frame.height - 50, width: 50, height: 50)
        frontEyeInactiveButton.frame = CGRect(x: frontBaseView.frame.width - 50, y: frontBaseView.frame.height - 50, width: 50, height: 50)
        backEyeActiveButton.frame = CGRect(x: backBaseView.frame.width - 50, y: backBaseView.frame.height - 50, width: 50, height: 50)
        backEyeInactiveButton.frame = CGRect(x: backBaseView.frame.width - 50, y: backBaseView.frame.height - 50, width: 50, height: 50)
        
        frontEyeAtiveButton.isHidden = true
        frontEyeInactiveButton.isHidden = false
        backEyeActiveButton.isHidden = true
        backEyeInactiveButton.isHidden = false
        
        frontBaseBorder.frame = CGRect(x: 12, y: frontBaseView.frame.height - 1, width: frontBaseView.frame.width - 24, height: 1)
        backBaseBorder.frame = CGRect(x: 0, y: backBaseView.frame.height - 1, width: backBaseView.frame.width, height: 1)
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
