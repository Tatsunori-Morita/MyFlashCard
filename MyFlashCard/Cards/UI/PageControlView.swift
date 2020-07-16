//
//  PageControlView.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class PageControlView: UIView {
    weak var delegate: PageControlViewDelegete! = nil
    @IBOutlet weak var pageSlider: UISlider!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var maxPageLabel: UILabel!
    
    @IBAction func touchUpSlider(_ sender: Any) {
        delegate?.touchUpSlider(sender: self)
    }
    
    @IBAction func changeSliderValue(_ sender: Any) {
        delegate?.changeSliderValue(sender: self)
    }
    
    func initValue(currentValue: Int, maxValue: Int) {
        pageSlider.minimumValue = 1
        pageSlider.maximumValue = Float(maxValue)
        currentPageLabel.text = maxValue == 0 ? "0" : (currentValue + 1).description
        maxPageLabel.text = maxValue.description
    }
    
    var currentValue: Int {
        get {
            return Int(ceil(pageSlider.value))
        }
        
        set(v) {
            currentPageLabel.text = v.description
            pageSlider.value = Float(v)
        }
    }
}

protocol PageControlViewDelegete: class {
    func touchUpSlider(sender: PageControlView)
    func changeSliderValue(sender: PageControlView)
}
