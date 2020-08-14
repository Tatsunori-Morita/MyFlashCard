//
//  PlayControllToolbar.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/08/11.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class PlayControllToolbar: UIToolbar {
    weak var playDelegate: PlayControllToolbarDelegete! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initToolBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initToolBar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let playBtn = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        let speakerBtn = UIBarButtonItem(image: UIImage(systemName: "speaker.3"), style: .plain, target: self, action: nil)
        let repeatBtn = UIBarButtonItem(image: UIImage(named: "repeat_none_Icon2"), style: .plain, target: self, action: nil)
        let speedBtn = UIBarButtonItem(image: UIImage(named: "speed_one"), style: .plain, target: self, action: nil)
        let intervalBtn = UIBarButtonItem(image: UIImage(named: "during_one"), style: .plain, target: self, action: nil)
        playBtn.tag = 4
        speakerBtn.tag = 3
        repeatBtn.tag = 2
        speedBtn.tag = 1
        intervalBtn.tag = 0
        items = [playBtn, space, speakerBtn, space, repeatBtn, space, speedBtn, space, intervalBtn]
    }
    
    private func setToolBar(bookModel: BookModel) {
        setToolBarSpeakerButton(bookModel: bookModel)
        setToolBarRepeatButton(bookModel: bookModel)
        setToolBarSpeedButton(bookModel: bookModel)
        setToolBarIntervalButton(bookModel: bookModel)
    }
    
    func setToolBarPlayButton(isPlay: Bool) {
        if isPlay {
            insertBarButtonItem(at: 0, image: UIImage(systemName: "pause")!, tag: 4)
        } else {
            insertBarButtonItem(at: 0, image: UIImage(systemName: "play")!, tag: 4)
        }
    }
    
    func setToolBarSpeakerButton(bookModel: BookModel) {
        if bookModel.isMute {
            insertBarButtonItem(at: 2, image: UIImage(systemName: "speaker.3")!, tag: 3)
        } else {
            insertBarButtonItem(at: 2, image: UIImage(systemName: "speaker.slash")!, tag: 3)
        }
    }
    
    func setToolBarRepeatButton(bookModel: BookModel) {
        if bookModel.isRepeat {
            insertBarButtonItem(at: 4, image: UIImage(named: "repeatIcon")!, tag: 2)
        } else {
            insertBarButtonItem(at: 4, image: UIImage(named: "repeat_none_Icon2")!, tag: 2)
        }
    }
    
    func setToolBarSpeedButton(bookModel: BookModel) {
        if bookModel.rate == 0.1 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_one")!, tag: 1)
        } else if bookModel.rate == 0.25 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_two")!, tag: 1)
        } else if bookModel.rate == 0.5 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_three")!, tag: 1)
        } else if bookModel.rate == 0.75 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_four")!, tag: 1)
        } else if bookModel.rate == 1 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_five")!, tag: 1)
        }
    }
    
    func setToolBarIntervalButton(bookModel: BookModel) {
        if (bookModel.postInterval + bookModel.preInterval) == 0 {
            insertBarButtonItem(at: 8, image: UIImage(named: "during_one")!, tag: 0)
        } else if (bookModel.postInterval + bookModel.preInterval) == 0.3 {
            insertBarButtonItem(at: 8, image: UIImage(named: "during_two")!, tag: 0)
        } else if (bookModel.postInterval + bookModel.preInterval) == 0.5 {
            insertBarButtonItem(at: 8, image: UIImage(named: "during_three")!, tag: 0)
        } else if (bookModel.postInterval + bookModel.preInterval) == 0.7 {
            insertBarButtonItem(at: 8, image: UIImage(named: "during_four")!, tag: 0)
        } else if (bookModel.postInterval + bookModel.preInterval) == 1 {
            insertBarButtonItem(at: 8, image: UIImage(named: "during_five")!, tag: 0)
        }
    }
    
    func insertBarButtonItem(at: Int, image: UIImage, tag: Int) {
        let btn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        btn.tag = tag
        var items = self.items
        items!.remove(at: at)
        items!.insert(btn, at: at)
        self.items = items
    }
    
    var book: BookModel? {
        didSet {
            guard let b = book else {
                return
            }
            setToolBar(bookModel: b)
        }
    }
    
    @objc func tapToolBarButtonEvent(_ sender: UIBarButtonItem) {
        playDelegate?.tapToolBarButtonEvent(sender: sender)
    }
}

protocol PlayControllToolbarDelegete: class {
    func tapToolBarButtonEvent(sender: UIBarButtonItem)
}
