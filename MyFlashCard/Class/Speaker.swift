//
//  Speaker.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import AVFoundation

class Speaker {
    class func speech(
        text: String,
        language: String,
        interrupt: Bool,
        rate: Float = AVSpeechUtteranceDefaultSpeechRate,
        pitch: Float = 1.0,
        volume: Float = 1.0,
        preInterval: Double = 1.0,
        postInterval: Double = 1.0,
        started: @escaping ()->() = {},
        finished: @escaping ()->() = {}
    ) {
        Speech.shared.speak(
            text: text,
            language: language,
            interrupt: interrupt,
            rate: rate,
            pitch: pitch,
            volume: volume,
            preInterval: preInterval,
            postInterval: postInterval,
            started: started,
            finished: finished
        )
    }
    
    class func pause() {
        Speech.shared.pause()
    }
    
    class func `continue`() {
        Speech.shared.continue()
    }
    
    class func isSpeaking() -> Bool {
        Speech.shared.isSpeaking()
    }
    
    class func isPause() -> Bool {
        Speech.shared.isPause()
    }
    
    class func reCreate() {
        Speech.shared.reCreate()
    }
}

class Speech: NSObject, AVSpeechSynthesizerDelegate {
    static var shared = Speech()
    private override init() {}
    fileprivate lazy var speech = AVSpeechSynthesizer()
    fileprivate lazy var started: ()->() = {}
    fileprivate lazy var finished: ()->() = {}
    
    func speak(text: String, language: String, interrupt: Bool, rate: Float, pitch: Float, volume: Float, preInterval: Double, postInterval: Double, started: @escaping ()->(), finished: @escaping ()->()) {
        if speech.isSpeaking && interrupt {
            speech.stopSpeaking(at: .immediate)
        }
        speech.delegate = self
        let ut = AVSpeechUtterance(string: text)
        ut.voice = AVSpeechSynthesisVoice(language: language)
        ut.rate = rate
        ut.pitchMultiplier = pitch
        ut.volume = volume
        ut.preUtteranceDelay = preInterval
        ut.postUtteranceDelay = postInterval
        self.started = started
        self.finished = finished
        speech.speak(ut)
    }
    
    func pause() {
        speech.pauseSpeaking(at: .immediate)
    }
    
    func `continue`() {
        speech.continueSpeaking()
    }
    
    func isSpeaking() -> Bool {
        return speech.isSpeaking
    }
    
    func isPause() -> Bool {
        return speech.isPaused
    }
    
    func reCreate() {
        speech.pauseSpeaking(at: .immediate)
        speech.stopSpeaking(at: .immediate)
        speech = AVSpeechSynthesizer()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        started()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finished()
    }
}
