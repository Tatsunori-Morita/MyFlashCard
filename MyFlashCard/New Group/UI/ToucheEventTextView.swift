//
//  ToucheEventTextView.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class ToucheEventTextView: UITextView {
    
//    override var contentSize: CGSize {
//        didSet {
//            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
//            topCorrection = max(0, topCorrection)
//            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
//        }
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesBegan(touches , with: event)
        } else {
            super.touchesBegan(touches , with: event)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesEnded(touches , with: event)
        } else {
            super.touchesEnded(touches , with: event)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesCancelled(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let next = next {
            next.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }
}
