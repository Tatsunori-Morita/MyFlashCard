//
//  CardsViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit
import AVFoundation
import DZNEmptyDataSet

class CardsViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var toolbar = UIToolbar()
    private var pageControl: PageControlView!
    private var dataSource = RealmManager()
    private var flowLayout = FlowLayout()
    private var cellHeight: CGFloat = 0
    private let synthesizer = AVSpeechSynthesizer()
    private var isStopedSpeaking = false
    private var isEndSpeaking = false
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        initNavigation()
        initToolBar()
        initController()
        switchActiveButton()
        initCollectionView()
        initDZNEmptyDataSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        loadData()
        reloadBook()
        // バックグランド再生設定
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        switchActiveButton()
        setCellHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pageControl!.initValue(currentValue: flowLayout.currentIndex, maxValue: dataSource.cardModelsCount())
        pageControl!.translatesAutoresizingMaskIntoConstraints = false
        pageControl!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pageControl!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pageControl!.bottomAnchor.constraint(equalTo: toolbar.topAnchor, constant: -16).isActive = true
        pageControl!.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: pageControl!.topAnchor, constant: -16).isActive = true
    }
}

extension CardsViewController {
    static func createInstance() -> CardsViewController {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CardsViewController") as! CardsViewController
    }
    
    private func initNavigation() {
        // ナビゲーションを透明にする処理
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController!.navigationBar.shadowImage = UIImage()
        
        navigationController?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeEvent))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCardEvent)),
            UIBarButtonItem.init(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(showCardSettingViewEvent)),
            UIBarButtonItem.init(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showFoldingViewEvent))
        ]
    }
    
    private func initToolBar() {
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let playBtn = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        let speakerBtn = UIBarButtonItem(image: UIImage(systemName: "speaker.3"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        let repeatBtn = UIBarButtonItem(image: UIImage(named: "repeat_none_Icon2"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        let speedBtn = UIBarButtonItem(image: UIImage(named: "speed_one"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        let intervalBtn = UIBarButtonItem(image: UIImage(named: "during_one"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        
        playBtn.tag = 4
        speakerBtn.tag = 3
        repeatBtn.tag = 2
        speedBtn.tag = 1
        intervalBtn.tag = 0
        
        toolbar.items = [playBtn, space, speakerBtn, space, repeatBtn, space, speedBtn, space, intervalBtn]
        toolbarItems = [playBtn, space, speakerBtn, space, repeatBtn, space, speedBtn, space, intervalBtn]
        view.addSubview(toolbar)
        setToolBar()
    }
    
    private func setToolBar() {
        setToolBarSpeakerButton()
        setToolBarRepeatButton()
        setToolBarSpeedButton()
        setToolBarIntervalButton()
    }
    
    private func setToolBarSpeakerButton() {
        if bookModel.isMute {
            insertBarButtonItem(at: 2, image: UIImage(systemName: "speaker.3")!, tag: 3)
        } else {
            insertBarButtonItem(at: 2, image: UIImage(systemName: "speaker.slash")!, tag: 3)
        }
    }
    
    private func setToolBarRepeatButton() {
        if bookModel.isRepeat {
            insertBarButtonItem(at: 4, image: UIImage(named: "repeatIcon")!, tag: 2)
        } else {
            insertBarButtonItem(at: 4, image: UIImage(named: "repeat_none_Icon2")!, tag: 2)
        }
    }
    
    private func setToolBarSpeedButton() {
        if bookModel.rate == 0.1 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_one")!, tag: 1)
        } else if bookModel.rate == 0.25 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_two")!, tag: 1)
        } else if self.bookModel.rate == 0.5 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_three")!, tag: 1)
        } else if bookModel.rate == 0.75 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_four")!, tag: 1)
        } else if bookModel.rate == 1 {
            insertBarButtonItem(at: 6, image: UIImage(named: "speed_five")!, tag: 1)
        }
    }
    
    private func setToolBarIntervalButton() {
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
    
    private func insertBarButtonItem(at: Int, image: UIImage, tag: Int) {
        toolbarItems?.remove(at: at)
        let intervalBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
        intervalBtn.tag = tag
        toolbarItems?.insert(intervalBtn, at: at)
    }
    
    private func initController() {
        pageControl = Bundle.main.loadNibNamed("PageControlView", owner: self, options: nil)!.first! as? PageControlView
        view.addSubview(pageControl!)
        pageControl!.delegate = self
    }
    
    private func initCollectionView() {
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: cellHeight), collectionViewLayout: flowLayout)
        collectionView!.backgroundColor = .clear
        collectionView!.decelerationRate = .fast
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.showsVerticalScrollIndicator = false
        collectionView!.dataSource = self
        collectionView!.delegate = self
        view.addSubview(collectionView!)
        collectionView!.register(UINib(nibName: "CardsCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MyCell")
    }
    
    private func loadData() {
        dataSource.loadCardModels(bookModel: bookModel)
        collectionView!.reloadData()
        pageControl!.initValue(currentValue: flowLayout.currentIndex, maxValue: dataSource.cardModelsCount())
    }
    
    private func reloadBook()  {
        dataSource.loadBookModels(conditions: "id == '" + bookModel.id + "'", sortKey: "id", asc: true)
        bookModel = dataSource.bookData(id: bookModel.id)
    }
    
    private func speakBothText() {
        if bookModel.readPlace == ReadType.back.rawValue {
            speakBackText()
            return
        }
        if let cardModel = dataSource.cardData(at: flowLayout.currentIndex) {
            Speaker.speech(text: cardModel.front!, language: "en-US", interrupt: true, rate: bookModel.rate, volume: bookModel.isMute ? 1 : 0, preInterval: Double(bookModel.preInterval), postInterval: Double(bookModel.postInterval), finished: {
                if self.bookModel.readPlace == ReadType.front.rawValue {
                    self.moveCell()
                    return
                }
                self.speakBackText()
            });
        }
    }
    
    private func speakBackText() {
        if let cardModel = dataSource.cardData(at: flowLayout.currentIndex) {
            Speaker.speech(text: cardModel.back!, language: "ja-JP", interrupt: true, rate: bookModel!.rate, volume: bookModel.isMute ? 1 : 0, preInterval: Double(bookModel.preInterval), postInterval: Double(bookModel.postInterval), finished: {
                self.moveCell()
            });
        }
    }
    
    private func moveCell() {
        if flowLayout.currentIndex + 1 == dataSource.cardModelsCount() {
            flowLayout.currentIndex = 0
            isEndSpeaking = true
            if bookModel.isRepeat {
                insertBarButtonItem(at: 0, image: UIImage(systemName: "pause")!, tag: 4)
            } else {
                insertBarButtonItem(at: 0, image: UIImage(systemName: "play")!, tag: 4)
            }
            collectionView!.scrollToItem(at: IndexPath(row: flowLayout.currentIndex, section: 0), at: .right, animated: true)
        } else {
            flowLayout.currentIndex += 1
            collectionView!.scrollToItem(at: IndexPath(row: flowLayout.currentIndex, section: 0), at: .right, animated: true)
            collectionView?.contentOffset.x = (collectionView?.contentOffset.x)! + 20
            speakBothText()
        }
    }
    
    private func speekText(text: String, lang: String) {
        if !Speaker.isSpeaking() || Speaker.isPause() {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: lang)
            utterance.rate = 0.5
            utterance.pitchMultiplier = 1
            utterance.volume = 1
            synthesizer.speak(utterance)
        }
    }
    
    private func closeModal() {
        Speaker.reCreate()
        synthesizer.stopSpeaking(at: .immediate)
        dismiss(animated: true, completion: nil)
    }
    
    private func tapTookBarButton(tag: Int) {
        let model = bookModel.copy() as! BookModel
        var at = 0
        var img: UIImage?
        switch tag {
        case 0:
            at = 8
            switch bookModel.postInterval + bookModel.preInterval {
            case 0:
                model.postInterval = 0.15
                model.preInterval = 0.15
                img = UIImage(named: "during_two")
            case 0.3:
                model.postInterval = 0.25
                model.preInterval = 0.25
                img = UIImage(named: "during_three")
            case 0.5:
                model.postInterval = 0.35
                model.preInterval = 0.35
                img = UIImage(named: "during_four")
            case 0.7:
                model.postInterval = 0.5
                model.preInterval = 0.5
                img = UIImage(named: "during_five")
            case 1:
                model.postInterval = 0
                model.preInterval = 0
                img = UIImage(named: "during_one")
            default:
                print("no toolbar button")
            }
        case 1:
            at = 6
            switch bookModel.rate {
            case 0.1:
                model.rate = 0.25
                img = UIImage(named: "speed_two")
            case 0.25:
                model.rate = 0.5
                img = UIImage(named: "speed_three")
            case 0.5:
                model.rate = 0.75
                img = UIImage(named: "speed_four")
            case 0.75:
                model.rate = 1
                img = UIImage(named: "speed_five")
            case 1:
                model.rate = 0.1
                img = UIImage(named: "speed_one")
            default:
                print("no toolbar button")
            }
        case 2:
            at = 4
            if bookModel.isRepeat {
                model.isRepeat = false
                img = UIImage(named: "repeat_none_Icon2")
            } else {
                model.isRepeat = true
                img = UIImage(named: "repeatIcon")
            }
        case 3:
            at = 2
            if bookModel.isMute {
                model.isMute = false
                img = UIImage(systemName: "speaker.slash")
            } else {
                model.isMute = true
                img = UIImage(systemName: "speaker.3")
            }
        case 4:
            at = 0
            if Speaker.isPause() {
                Speaker.continue()
                img = UIImage(systemName: "pause")
            } else {
                if Speaker.isSpeaking() {
                    Speaker.pause()
                    img = UIImage(systemName: "play")
                } else {
                    speakBothText()
                    img = UIImage(systemName: "pause")
                }
            }
            insertBarButtonItem(at: at, image: img!, tag: tag)
            return
        default:
            print("no toolbar icon")
        }
        insertBarButtonItem(at: at, image: img!, tag: tag)
        RealmManager.update(bookModel: model)
        reloadBook()
    }
    
    private func showCardSettingView() {
        let vc = CardSettingViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        nav.presentationController?.delegate = self
        vc.bookModel = bookModel
        present(nav, animated: true, completion: nil)
    }
    
    private func showFoldingView() {
        let vc = FoldingViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        vc.originCardModels = dataSource.cardData()!
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func addCard() {
        let vc = CardViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        vc.bookModel = bookModel
        vc.childCallBack = { () in
            self.dataSource.loadCardModels(bookModel: self.bookModel)
            self.switchActiveButton()
            self.loadData()
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func changeCommentArea(isActive: Bool) {
        let cell = collectionView!.cellForItem(at: IndexPath(item: flowLayout.currentIndex, section: 0)) as! CardsCollectionViewCell
        cell.isActiveCommentArea = isActive
    }
    
    private func showCardView() {
        if !Speaker.isPause() {
            Speaker.pause()
            toolbarItems?.remove(at: 0)
            let playButton = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(tapToolBarButtonEvent))
            playButton.tag = 4
            toolbarItems?.insert(playButton, at: 0)
        }
        let vc = CardViewController.createInstance()
        vc.cardModel = dataSource.cardData(at: flowLayout.currentIndex)
        let nav = UINavigationController(rootViewController: vc)
        vc.bookModel = bookModel
        vc.childCallBack = { () in
            self.dataSource.loadCardModels(bookModel: self.bookModel)
            self.switchActiveButton()
            self.loadData()
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func tapSpeekButton(isFront: Bool) {
        if synthesizer.isSpeaking { return }
        if let cardModel = dataSource.cardData(at: flowLayout.currentIndex) {
            if isFront {
                speekText(text: cardModel.front!, lang: "en-US")
            } else {
                speekText(text: cardModel.back!, lang: "ja-JP")
            }
        }
    }
    
    private func tapEyeButton(isActive: Bool, isFront: Bool) {
        let cell = collectionView!.cellForItem(at: IndexPath(item: flowLayout.currentIndex, section: 0)) as! CardsCollectionViewCell
        if let cardModel = dataSource.cardData(at: flowLayout.currentIndex) {
            if isActive {
                if isFront {
                    cell.tapEyeSlashButton(isFront: true, text: cardModel.front!)
                } else {
                    cell.tapEyeSlashButton(isFront: false, text: cardModel.back!)
                }
            } else {
                if isFront {
                    cell.tapEyeButton(isFront: true)
                } else {
                    cell.tapEyeButton(isFront: false)
                }
            }
        }
    }
    
    private func tapCardButons(tag: Int, value: Bool) {
        let model = dataSource.cardData(at: flowLayout.currentIndex)!.copy() as! CardModel
        switch tag {
        case 0:
            model.isBookmark = value
        case 1:
            model.isCheck = value
        default:
            print("no \(tag) \(value)")
        }
        RealmManager.update(cardModel: model)
        let cell = collectionView!.cellForItem(at: IndexPath(item: flowLayout.currentIndex, section: 0)) as! CardsCollectionViewCell
        cell.card = model
    }
    
    private func touchUpSlider() {
        var isSpeaking = false
        if !Speaker.isPause() && Speaker.isSpeaking() {
            isSpeaking = true
        }
        Speaker.reCreate()
        let index = pageControl!.currentValue
        flowLayout.currentIndex = index - 1
        
        collectionView!.scrollToItem(at: IndexPath(row: flowLayout.currentIndex, section: 0), at: .right, animated: true)
        if flowLayout.currentIndex == 0 {
            collectionView?.contentOffset.x = (collectionView?.contentOffset.x)!
        } else {
            collectionView?.contentOffset.x = (collectionView?.contentOffset.x)! + 20
        }
        
        if isSpeaking {
            speakBothText()
        }
    }
    
    private func initDZNEmptyDataSet() {
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    private func switchActiveButton() {
        if dataSource.cardModelsCount() == 0 {
            toolbar.isHidden = true
            pageControl.isHidden = true
            navigationItem.rightBarButtonItems![1].isEnabled = false
            navigationItem.rightBarButtonItems![2].isEnabled = false
        } else {
            toolbar.isHidden = false
            pageControl.isHidden = false
            navigationItem.rightBarButtonItems![1].isEnabled = true
            navigationItem.rightBarButtonItems![2].isEnabled = true
        }
    }
    
    private func setCellHeight() {
        cellHeight = view.frame.height - pageControl.frame.height + (navigationController?.toolbar.frame.height)! + (navigationController?.navigationBar.frame.height)! - 10
    }
}

extension CardsViewController {
    @objc func tapToolBarButtonEvent(_ sender: UIBarButtonItem) {
        tapTookBarButton(tag: sender.tag)
    }
    
    @objc func showCardSettingViewEvent() {
        showCardSettingView()
    }

    @objc func showFoldingViewEvent() {
        showFoldingView()
    }
    
    @objc func addCardEvent(){
        addCard()
    }
    
    @objc func closeEvent() {
        closeModal()
    }
}

extension CardsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeViewController {
            Speaker.reCreate()
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.cardModelsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CardsCollectionViewCell
        if let card = dataSource.cardData(at: indexPath.row) {
            cell.delegate = self
            cell.book = bookModel
            cell.card = card
            return cell
        }
        return cell
    }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if Speaker.isPause() {
            Speaker.reCreate()
        }
        
        if !Speaker.isPause() && Speaker.isSpeaking() {
            Speaker.reCreate()
            isStopedSpeaking = true
        }
        let collectionView = scrollView as! UICollectionView
        (collectionView.collectionViewLayout as! FlowLayout).prepareForPaging()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        pageControl!.currentValue = (flowLayout.currentIndex + 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isStopedSpeaking {
            isStopedSpeaking = false
            speakBothText()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: cellHeight)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl!.currentValue = (flowLayout.currentIndex + 1)
        if isEndSpeaking && bookModel!.isRepeat {
            isEndSpeaking = false
            speakBothText()
        }
    }
}

extension CardsViewController: CardsCollectionViewCellDelegete {
    func tapBookmarkActiveButton(sender: CardsCollectionViewCell) {
        tapCardButons(tag: 0, value: false)
    }
    
    func tapBookmarkInactiveButton(sender: CardsCollectionViewCell) {
        tapCardButons(tag: 0, value: true)
    }
    
    func tapCheckActiveButton(sender: CardsCollectionViewCell) {
        tapCardButons(tag: 1, value: false)
    }
    
    func tapCheckInactiveButton(sender: CardsCollectionViewCell) {
        tapCardButons(tag: 1, value: true)
    }
    
    func edit(sender: CardsCollectionViewCell) {
        showCardView()
    }
    
    func tapCommentActiveButton(sender: CardsCollectionViewCell) {
        changeCommentArea(isActive: true)
    }
    
    func tapCommentInactiveButton(sender: CardsCollectionViewCell) {
        changeCommentArea(isActive: false)
    }
    
    func tapFrontSpeekButton(sender: CardsCollectionViewCell) {
        tapSpeekButton(isFront: true)
    }
    
    func tapBackSpeekButton(sender: CardsCollectionViewCell) {
        tapSpeekButton(isFront: false)
    }
    
    func tapFrontEyeInactiveButton(sender: CardsCollectionViewCell) {
        tapEyeButton(isActive: false, isFront: true)
    }
    
    func tapBackEyeInactiveButton(sender: CardsCollectionViewCell) {
        tapEyeButton(isActive: false, isFront: false)
    }
    
    func tapFrontEyeAtiveButton(sender: CardsCollectionViewCell) {
        tapEyeButton(isActive: true, isFront: true)
    }
    
    func tapBackEyeActiveButton(sender: CardsCollectionViewCell) {
        tapEyeButton(isActive: true, isFront: false)
    }
}

extension CardsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if !RealmManager.isRealmUpdate { return }
        RealmManager.isRealmUpdate = false
        loadData()
        reloadBook()
        if !RealmManager.isRefreshIndex { return }
        RealmManager.isRefreshIndex = false
        flowLayout.currentIndex = 0
        collectionView!.scrollToItem(at: IndexPath(row: flowLayout.currentIndex, section: 0), at: .right, animated: true)
    }
}

extension CardsViewController: PageControlViewDelegete {
    func touchUpSlider(sender: PageControlView) {
        touchUpSlider()
    }
    
    func changeSliderValue(sender: PageControlView) {
        pageControl!.currentValue = pageControl!.currentValue
    }
}

extension CardsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
}
