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
    private var toolbar = PlayControllToolbar()
    private var pageControl: PageControlView!
    private var dataSource = RealmManager()
    private var flowLayout = FlowLayout()
    private let sliderButton = UIButton(type: .system)
    private let listButton = UIButton(type: .system)
    
    private let synthesizer = AVSpeechSynthesizer()
    private var isStopedSpeaking = false
    private var isEndSpeaking = false
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 233/255, green: 236/255, blue: 244/255, alpha: 1)
        initToolBar()
        initController()
        initCollectionView()
        initDZNEmptyDataSet()
        initHeaderButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        loadData()
        reloadBook()
        // バックグランド再生設定
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        switchActiveButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
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
    
    private func initToolBar() {
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        toolbar.book = bookModel
        view.addSubview(toolbar)
        toolbar.playDelegate = self
    }
    
    private func initController() {
        pageControl = Bundle.main.loadNibNamed("PageControlView", owner: self, options: nil)!.first! as? PageControlView
        pageControl.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        view.addSubview(pageControl!)
        pageControl!.delegate = self
    }
    
    private func initCollectionView() {
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: setCellHeight()), collectionViewLayout: flowLayout)
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
                toolbar.setToolBarPlayButton(isPlay: true)
            } else {
                toolbar.setToolBarPlayButton(isPlay: false)
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
        switch tag {
        case Tag.intervalButton.rawValue:
            model.changeInterval()
            toolbar.setToolBarIntervalButton(bookModel: model)
        case Tag.speedButton.rawValue:
            model.changeRate()
            toolbar.setToolBarSpeedButton(bookModel: model)
        case Tag.repeatButton.rawValue:
            model.changeRepeat()
            toolbar.setToolBarRepeatButton(bookModel: model)
        case Tag.speakerButton.rawValue:
            model.changeMute()
            toolbar.setToolBarSpeakerButton(bookModel: model)
        case Tag.playButton.rawValue:
            if Speaker.isPause() {
                Speaker.continue()
                toolbar.setToolBarPlayButton(isPlay: true)
            } else {
                if Speaker.isSpeaking() {
                    Speaker.pause()
                    toolbar.setToolBarPlayButton(isPlay: false)
                } else {
                    speakBothText()
                    toolbar.setToolBarPlayButton(isPlay: true)
                }
            }
            return
        default:
            print("no toolbar icon")
        }
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
            toolbarItems?.remove(at: Tag.playButton.rawValue)
            toolbar.setToolBarPlayButton(isPlay: false)
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
            sliderButton.isEnabled = bookModel.cards.count > 0 ? true : false
            listButton.isEnabled = false
        } else {
            toolbar.isHidden = false
            pageControl.isHidden = false
            sliderButton.isEnabled = true
            listButton.isEnabled = true
        }
    }
    
    private func setCellHeight() -> CGFloat {
        return view.frame.height - pageControl.frame.height - toolbar.frame.height - 80
    }
    
    private func initHeaderButton() {
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 5, y: 20, width: 45, height: 45)
        let closeImg = UIImage(systemName: "multiply")
        closeButton.setImage(closeImg, for: .normal)
        closeButton.tintColor = UIColor(red: 90/255, green: 91/255, blue: 91/255, alpha: 1)
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
        closeButton.layer.masksToBounds = true
        closeButton.backgroundColor = UIColor(red: 207/255, green: 207/255, blue: 209/255, alpha: 0.4)
        closeButton.addTarget(self, action: #selector(closeEvent), for: .touchUpInside)
        view.addSubview(closeButton)
        view.bringSubviewToFront(closeButton)
        
        let addButton = UIButton(type: .system)
        addButton.frame = CGRect(x: view.frame.width - 50, y: 20, width: 45, height: 45)
        addButton.setTitleColor(.systemBlue, for: .normal)
        let plusImg = UIImage(systemName: "plus")
        addButton.setImage(plusImg, for: .normal)
        addButton.layer.masksToBounds = true
        addButton.backgroundColor = .clear
        addButton.addTarget(self, action: #selector(addCardEvent), for: .touchUpInside)
        view.addSubview(addButton)
        view.bringSubviewToFront(addButton)
        
        sliderButton.frame = CGRect(x: addButton.frame.origin.x - 50, y: 20, width: 45, height: 45)
        sliderButton.setTitleColor(.systemBlue, for: .normal)
        let sliderImg = UIImage(systemName: "slider.horizontal.3")
        sliderButton.setImage(sliderImg, for: .normal)
        sliderButton.layer.masksToBounds = true
        sliderButton.backgroundColor = .clear
        sliderButton.addTarget(self, action: #selector(showCardSettingViewEvent), for: .touchUpInside)
        view.addSubview(sliderButton)
        view.bringSubviewToFront(sliderButton)
        
        listButton.frame = CGRect(x: sliderButton.frame.origin.x - 50, y: 20, width: 45, height: 45)
        listButton.setTitleColor(.systemBlue, for: .normal)
        let listImg = UIImage(systemName: "list.bullet")
        listButton.setImage(listImg, for: .normal)
        listButton.layer.masksToBounds = true
        listButton.backgroundColor = .clear
        listButton.addTarget(self, action: #selector(showFoldingViewEvent), for: .touchUpInside)
        view.addSubview(listButton)
        view.bringSubviewToFront(listButton)
    }
}

extension CardsViewController {
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
        return CGSize(width: view.frame.width * 0.9, height: setCellHeight())
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
        switchActiveButton()
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
        guard let page = pageControl else { return }
        let index = page.currentValue
        page.currentValue = index
        flowLayout.currentIndex = page.currentValue
    }
}

extension CardsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
}

extension CardsViewController: PlayControllToolbarDelegete {
    func tapToolBarButtonEvent(sender: UIBarButtonItem) {
        tapTookBarButton(tag: sender.tag)
    }
}
