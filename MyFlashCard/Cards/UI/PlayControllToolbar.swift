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
        playBtn.tag = Tag.playButton.rawValue
        speakerBtn.tag = Tag.speakerButton.rawValue
        repeatBtn.tag = Tag.repeatButton.rawValue
        speedBtn.tag = Tag.speedButton.rawValue
        intervalBtn.tag = Tag.intervalButton.rawValue
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
            insertBarButtonItem(at: Tag.playButton.rawValue, image: UIImage(systemName: "pause")!, tag: Tag.playButton.rawValue)
        } else {
            insertBarButtonItem(at: Tag.playButton.rawValue, image: UIImage(systemName: "play")!, tag: Tag.playButton.rawValue)
        }
    }
    
    func setToolBarSpeakerButton(bookModel: BookModel) {
        if bookModel.isMute {
            insertBarButtonItem(at: Tag.speakerButton.rawValue, image: UIImage(systemName: "speaker.3")!, tag: Tag.speakerButton.rawValue)
        } else {
            insertBarButtonItem(at: Tag.speakerButton.rawValue, image: UIImage(systemName: "speaker.slash")!, tag: Tag.speakerButton.rawValue)
        }
    }
    
    func setToolBarRepeatButton(bookModel: BookModel) {
        if bookModel.isRepeat {
            insertBarButtonItem(at: Tag.repeatButton.rawValue, image: UIImage(named: "repeatIcon")!, tag: Tag.repeatButton.rawValue)
        } else {
            insertBarButtonItem(at: Tag.repeatButton.rawValue, image: UIImage(named: "repeat_none_Icon2")!, tag: Tag.repeatButton.rawValue)
        }
    }
    
    func setToolBarSpeedButton(bookModel: BookModel) {
        if bookModel.rate == BookModel.Speed.level1.rawValue {
            insertBarButtonItem(at: Tag.speedButton.rawValue, image: UIImage(named: "speed_one")!, tag: Tag.speedButton.rawValue)
        } else if bookModel.rate == BookModel.Speed.level2.rawValue {
            insertBarButtonItem(at: Tag.speedButton.rawValue, image: UIImage(named: "speed_two")!, tag: Tag.speedButton.rawValue)
        } else if bookModel.rate == BookModel.Speed.level3.rawValue {
            insertBarButtonItem(at: Tag.speedButton.rawValue, image: UIImage(named: "speed_three")!, tag: Tag.speedButton.rawValue)
        } else if bookModel.rate == BookModel.Speed.level4.rawValue {
            insertBarButtonItem(at: Tag.speedButton.rawValue, image: UIImage(named: "speed_four")!, tag: Tag.speedButton.rawValue)
        } else if bookModel.rate == BookModel.Speed.level5.rawValue {
            insertBarButtonItem(at: Tag.speedButton.rawValue, image: UIImage(named: "speed_five")!, tag: Tag.speedButton.rawValue)
        }
    }
    
    func setToolBarIntervalButton(bookModel: BookModel) {
        if (bookModel.postInterval + bookModel.preInterval) == BookModel.Interval.level1.rawValue {
            insertBarButtonItem(at: Tag.intervalButton.rawValue, image: UIImage(named: "during_one")!, tag: Tag.intervalButton.rawValue)
        } else if (bookModel.postInterval + bookModel.preInterval) == BookModel.Interval.level2.rawValue {
            insertBarButtonItem(at: Tag.intervalButton.rawValue, image: UIImage(named: "during_two")!, tag: Tag.intervalButton.rawValue)
        } else if (bookModel.postInterval + bookModel.preInterval) == BookModel.Interval.level3.rawValue {
            insertBarButtonItem(at: Tag.intervalButton.rawValue, image: UIImage(named: "during_three")!, tag: Tag.intervalButton.rawValue)
        } else if (bookModel.postInterval + bookModel.preInterval) == BookModel.Interval.level4.rawValue {
            insertBarButtonItem(at: Tag.intervalButton.rawValue, image: UIImage(named: "during_four")!, tag: Tag.intervalButton.rawValue)
        } else if (bookModel.postInterval + bookModel.preInterval) == BookModel.Interval.level5.rawValue {
            insertBarButtonItem(at: Tag.intervalButton.rawValue, image: UIImage(named: "during_five")!, tag: Tag.intervalButton.rawValue)
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

enum Tag: Int {
    case playButton = 0
    case speakerButton = 2
    case repeatButton = 4
    case speedButton = 6
    case intervalButton = 8
}
