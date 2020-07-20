//
//  FoldingViewCell.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit
import FoldingCell

class FoldingViewCell: FoldingCell {
    weak var delegate: FoldingViewCellDelegate! = nil
    @IBOutlet weak var closeFrontLabel: UILabel!
    @IBOutlet weak var opneFrontLabel: UILabel!
    @IBOutlet weak var openFrontTextView: ToucheEventTextView!
    @IBOutlet weak var openBackLabel: UILabel!
    @IBOutlet weak var openBackTextview: ToucheEventTextView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentTextView: ToucheEventTextView!
    @IBOutlet weak var openBookmarkActiveButton: UIButton!
    @IBOutlet weak var openBookmarkInactiveButton: UIButton!
    @IBOutlet weak var openCheckActivebutton: UIButton!
    @IBOutlet weak var openCheckInactiveButton: UIButton!
    @IBOutlet weak var frontSpeakButton: UIButton!
    @IBOutlet weak var backSpeakButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeBookmarkActiveButton: UIButton!
    @IBOutlet weak var closeBookmarkInactiveButton: UIButton!
    @IBOutlet weak var closeCheckActiveButton: UIButton!
    @IBOutlet weak var closeCheckInactiveButton: UIButton!
    var index: Int = 0

    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func tapOpenBookmarkActiveButton(_ sender: Any) {
        delegate?.tapOpenBookmarkActiveButton(sender: self)
    }
    
    @IBAction func tapOpenBookmarkInactiveButton(_ sender: Any) {
        delegate?.tapOpenBookmarkInactiveButton(sender: self)
    }
    
    @IBAction func tapOpenCheckActiveButton(_ sender: Any) {
        delegate?.tapOpenCheckActiveButton(sender: self)
    }
    
    @IBAction func tapOpenCheckInactiveButton(_ sender: Any) {
        delegate?.tapOpenCheckInactiveButton(sender: self)
    }
    
    @IBAction func tapFrontSpeakButton(_ sender: Any) {
        delegate?.tapFrontSpeakButton(sender: self)
    }
    
    @IBAction func tapBackSpeakButton(_ sender: Any) {
        delegate?.tapBackSpeakButton(sender: self)
    }
    
    @IBAction func edit(_ sender: Any) {
        delegate?.edit(sender: self)
    }
    
    @IBAction func tapCloseBookmarkActiveButton(_ sender: Any) {
        delegate?.tapCloseBookmarkActiveButton(sender: self)
    }
    
    @IBAction func tapCloseBookmarkInactiveButton(_ sender: Any) {
        delegate?.tapCloseBookmarkInactiveButton(sender: self)
    }
    
    @IBAction func tapCloseCheckActiveButton(_ sender: Any) {
        delegate?.tapCloseCheckActiveButton(sender: self)
    }
    
    @IBAction func tapCloseCheckInactiveButton(_ sender: Any) {
        delegate?.tapCloseCheckInactiveButton(sender: self)
    }
    
    private func setCardButton(cardModel: CardModel) {
        if cardModel.isBookmark {
            openBookmarkActiveButton.isHidden = false
            openBookmarkInactiveButton.isHidden = true
            closeBookmarkActiveButton.isHidden = false
            closeBookmarkInactiveButton.isHidden = true
        } else {
            openBookmarkActiveButton.isHidden = true
            openBookmarkInactiveButton.isHidden = false
            closeBookmarkActiveButton.isHidden = true
            closeBookmarkInactiveButton.isHidden = false
        }
        
        if cardModel.isCheck {
            openCheckActivebutton.isHidden = false
            openCheckInactiveButton.isHidden = true
            closeCheckActiveButton.isHidden = false
            closeCheckInactiveButton.isHidden = true
        } else {
            openCheckActivebutton.isHidden = true
            openCheckInactiveButton.isHidden = false
            closeCheckActiveButton.isHidden = true
            closeCheckInactiveButton.isHidden = false
        }
    }
    
    var folding: FoldingCellParam? {
        didSet {
            guard let f = folding else {
                return
            }
            index = f.index
            closeFrontLabel.text = f.front
            openFrontTextView.text = f.front
            openBackTextview.text = f.back
            commentTextView.text = f.comment
        }
    }
    
    var card: CardModel? {
        didSet {
            guard let c = card else {
                return
            }
            setCardButton(cardModel: c)
        }
    }
}

protocol FoldingViewCellDelegate: class {
    func tapOpenBookmarkActiveButton(sender: FoldingViewCell)
    func tapOpenBookmarkInactiveButton(sender: FoldingViewCell)
    func tapOpenCheckActiveButton(sender: FoldingViewCell)
    func tapOpenCheckInactiveButton(sender: FoldingViewCell)
    func tapFrontSpeakButton(sender: FoldingViewCell)
    func tapBackSpeakButton(sender: FoldingViewCell)
    func edit(sender: FoldingViewCell)
    func tapCloseBookmarkActiveButton(sender: FoldingViewCell)
    func tapCloseBookmarkInactiveButton(sender: FoldingViewCell)
    func tapCloseCheckActiveButton(sender: FoldingViewCell)
    func tapCloseCheckInactiveButton(sender: FoldingViewCell)
}

class FoldingCellParam {
    fileprivate var index: Int = 0
    fileprivate var front: String = ""
    fileprivate var back: String = ""
    fileprivate var comment: String = ""

    init(index: Int, front: String, back: String, comment: String) {
        self.index = index
        self.front = front
        self.back = back
        self.comment = comment
    }
}
