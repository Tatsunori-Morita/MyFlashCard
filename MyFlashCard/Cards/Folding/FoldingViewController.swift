//
//  FoldingViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit
import AVFoundation

class FoldingViewController: UITableViewController {
    private let closeCellHeight: CGFloat = 100
    private let openCellHeight: CGFloat = 400
    private var cellHeights: [CGFloat] = []
    private var cardModels: [CardModel] = []
    private var searchBar = UISearchBar()
    private var synthesizer = AVSpeechSynthesizer()
    var originCardModels: [CardModel] = []
    var childCallBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardModels = originCardModels
        initSearchBar()
        initNavigation()
        initTableView()
        cellHeights = Array.init(repeating: closeCellHeight, count: originCardModels.count)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension FoldingViewController {
    static func createInstance() -> FoldingViewController {
        let storyboard = UIStoryboard(name: "Folding", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "FoldingViewController") as! FoldingViewController
    }
    
    private func initSearchBar() {
        searchBar.showsCancelButton = true
        searchBar.placeholder = "キーワード検索"
        searchBar.delegate = self
    }
    
    private func initNavigation() {
        if let sortType = originCardModels.first?.book.first?.sortType {
            if sortType == SortType.custome.rawValue {
                navigationItem.rightBarButtonItem = editButtonItem
            }
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: "FoldingViewCell", bundle: nil), forCellReuseIdentifier: "FoldingViewCell")
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
    }
    
    private func closeModal() {
        dismiss(animated: true) {
            self.childCallBack?()
        }
    }
    
    private func speakText(text: String, voice: AVSpeechSynthesisVoice) {
        let ut = AVSpeechUtterance(string: text)
        ut.voice = voice
        ut.rate = 0.5
        ut.pitchMultiplier = 1
        ut.volume = 1
        synthesizer.speak(ut)
    }
}

extension FoldingViewController: FoldingViewCellDelegate {
    func tapFrontSpeakButton(sender: FoldingViewCell) {
        if let text = cardModels[sender.index].front {
            speakText(text: text, voice: AVSpeechSynthesisVoice(language: "en-US")!)
        }
    }
    
    func tapBackSpeakButton(sender: FoldingViewCell) {
        if let text = cardModels[sender.index].back {
            speakText(text: text, voice: AVSpeechSynthesisVoice(language: "ja-JP")!)
        }
    }
    
    func tapOpenBookmarkActiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isBookmark = false
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapOpenBookmarkInactiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isBookmark = true
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapOpenCheckActiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isCheck = false
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapOpenCheckInactiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isCheck = true
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapCloseBookmarkActiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isBookmark = false
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapCloseBookmarkInactiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isBookmark = true
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapCloseCheckActiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isCheck = false
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func tapCloseCheckInactiveButton(sender: FoldingViewCell) {
        let model = cardModels[sender.index].copy() as! CardModel
        model.isCheck = true
        model.updated_at = Date()
        RealmManager.update(cardModel: model)
        sender.card = model
    }
    
    func edit(sender: FoldingViewCell) {
        let vc = CardViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        vc.cardModel = cardModels[sender.index]
        vc.childCallBack = { () in
            self.tableView.reloadData()
        }
        present(nav, animated: true, completion: nil)
    }
}

extension FoldingViewController {
    @objc func close() {
        closeModal()
    }
}

extension FoldingViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardModels.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingViewCell") as! FoldingViewCell
        cell.delegate = self
        let card = cardModels[indexPath.row]
        let folding = FoldingCellParam(
            index: indexPath.row,
            front: card.front!,
            back: card.back!,
            comment: card.comment!
        )
        cell.folding = folding
        cell.card = cardModels[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as FoldingViewCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == closeCellHeight {
            cellHeights[indexPath.row] = openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            tableView.beginUpdates()
            tableView.endUpdates()

        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        } else {
            var newOrder: Double
            if destinationIndexPath.row == 0 {
                // 一番上に移動した場合は先頭セル - 1
                newOrder = originCardModels[destinationIndexPath.row].order - 1.0
            } else if destinationIndexPath.row == originCardModels.count - 1 {
                // 一番下に移動した場合は末尾セル + 1
                newOrder = originCardModels[destinationIndexPath.row].order + 1.0
            } else {
                // 途中に移動したときは上下セルの中央値
                var rowPrev: Int, rowNext: Int;
                if (destinationIndexPath.row < sourceIndexPath.row) {
                    // 上に移動した場合
                    rowPrev = destinationIndexPath.row - 1
                    rowNext = destinationIndexPath.row
                } else {
                    // 下に移動した場合
                    rowPrev = destinationIndexPath.row
                    rowNext = destinationIndexPath.row + 1
                }
                newOrder = (originCardModels[rowPrev].order + originCardModels[rowNext].order) / 2.0
            }
            let model = originCardModels[sourceIndexPath.row].copy() as! CardModel
            model.order = newOrder
            model.updated_at = Date()
            RealmManager.update(cardModel: model)
        }
    }
}

extension FoldingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = true
        
        cardModels = originCardModels.filter{
            $0.front!.contains(searchBar.text!) || $0.back!.contains(searchBar.text!) || ($0.comment!.contains(searchBar.text!))
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
        searchBar.text = ""
        cardModels = originCardModels
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
}
