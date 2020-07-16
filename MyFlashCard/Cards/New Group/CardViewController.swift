//
//  CardViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class CardViewController: UITableViewController {
    private let sections: [String] = ["表面", "裏面", "コメント", ""]
    private var frontTextView: DoneTextView!
    private var backTextView: DoneTextView!
    private var commentTextView: DoneTextView!
    var cardModel: CardModel?
    var bookModel: BookModel!
    var childCallBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension CardViewController {
    static func createInstance() -> CardViewController {
        let storyboard = UIStoryboard(name: "Card", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CardViewController") as! CardViewController
    }
    
    private func initNavigation() {
        navigationItem.title = cardModel != nil ? "Edit Card" : "New Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeEvent))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEvent))
    }
    
    private func initTableView() {
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func saveCard(front: String?, back: String?, comment: String?) {
        if let _front = front {
            if _front.isEmpty {
                let ac = UIAlertController(title: "表面を入力してください", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
                return
            }
        }
        
        if let _back = back {
            if _back.isEmpty {
                let ac = UIAlertController(title: "裏面を入力してください", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
                return
            }
        }
        
        if let card = cardModel {
            let model = card.copy() as! CardModel
            model.front = front
            model.back = back
            model.comment = comment
            model.updated_at = Date()
            RealmManager.update(cardModel: model)
            
        } else {
            let model = CardModel()
            model.front = front
            model.back = back
            model.comment = comment
            model.book_id = bookModel.id
            model.created_at = Date()
            model.updated_at = Date()
            let book = bookModel.copy() as! BookModel
            book.cards.append(model)
            RealmManager.update(bookModel: book)
        }
        
        dismiss(animated: true) {
            self.childCallBack?()
        }
    }
    
    private func closeModal() {
        dismiss(animated: true)
    }
}

extension CardViewController {
    @objc func closeEvent() {
        closeModal()
    }
    
    @objc func saveEvent() {
        saveCard(front: frontTextView.text, back: backTextView.text, comment: commentTextView.text)
    }
    
    @objc func deleteEvent() {
        if let card = cardModel {
            let model = card.copy() as! CardModel
            model.deleted_at = Date()
            RealmManager.update(cardModel: model)
        }
        dismiss(animated: true) {
            self.childCallBack?()
        }
    }
}

extension CardViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cardModel == nil {
            return sections.count - 1
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1, 2:
            // front, back, comment height
            return 200
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            frontTextView = DoneTextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 200))
            frontTextView.text = cardModel != nil ? cardModel!.front : ""
            cell.addSubview(frontTextView)
        case 1:
            backTextView = DoneTextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 200))
            backTextView.text = cardModel != nil ? cardModel?.back : ""
            cell.addSubview(backTextView)
        case 2:
            commentTextView = DoneTextView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 200))
            commentTextView.text = cardModel != nil ? cardModel?.comment : ""
            cell.addSubview(commentTextView)
        case 3:
            let deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteEvent), for: .touchUpInside)
            cell.addSubview(deleteButton)
        default:
            print("no section")
        }
        return cell
    }
}
