//
//  BookViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class BookViewController: UITableViewController {
    private let sections: [String] = ["タイトル", "説明", "表面の読み上げ言語", "裏面の読み上げ言語", ""]
    private var titleTextField: DoneTextField!
    private var noteTextView: DoneTextView!
    var bookModel: BookModel!
    var childCallBack: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension BookViewController {
    static func createInstance() -> BookViewController {
        let storyboard = UIStoryboard(name: "Book", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
    }
    
    private func initNavigation() {
        navigationItem.title = bookModel != nil ? "Edit Book" : "New Book"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeEvent))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveEvent))
    }
    
    private func initTableView() {
        tableView.allowsMultipleSelection = true
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    private func saveBook(title: String?, note: String?) {
        if let _title = title {
            if _title.isEmpty {
                let ac = UIAlertController(title: "タイトルを入力してください", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
                return
            }
        }
        
        if let _note = note {
            if _note.isEmpty {
                let ac = UIAlertController(title: "説明を入力してください", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
                return
            }
        }
        
        if let book = bookModel {
            let model = book.copy() as! BookModel
            model.id = book.id
            model.title = title
            model.note = note
            model.updated_at = Date()
            RealmManager.update(bookModel: model)
        } else {
            let model = BookModel()
            model.title = title
            model.note = note
            model.created_at = Date()
            model.updated_at = Date()
            RealmManager.update(bookModel: model)
        }
        
        dismiss(animated: true) {
            self.childCallBack?()
        }
    }
    
    private func closeModal() {
        dismiss(animated: true)
    }
    
    private func deleteBook() {
        if let book = bookModel {
            let model = book.copy() as! BookModel
            model.deleted_at = Date()
            RealmManager.update(bookModel: model)
        }
        dismiss(animated: true) {
            self.childCallBack?()
        }
    }
}

extension BookViewController {
    @objc func saveEvent() {
        saveBook(title: titleTextField.text, note: noteTextView.text)
    }
    
    @objc func closeEvent() {
        closeModal()
    }
    
    @objc func deleteEven() {
        deleteBook()
    }
}

extension BookViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if bookModel == nil {
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
        case 1:
            // note height
            return 100
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            titleTextField = DoneTextField(frame: CGRect(x: 16, y: 0, width: cell.frame.width, height: cell.frame.height))
            titleTextField.text = bookModel != nil ? bookModel.title : ""
            cell.addSubview(titleTextField)
        case 1:
            noteTextView = DoneTextView(frame: CGRect(x: 16, y: 0, width: cell.frame.width, height: cell.frame.height))
            noteTextView.text = bookModel != nil ? bookModel.note : ""
            cell.addSubview(noteTextView)
        case 2:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "US"
        case 3:
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "JP"
        case 4:
            let deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            deleteButton.setTitle("Delete", for: .normal)
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteEven), for: .touchUpInside)
            cell.addSubview(deleteButton)
        default:
            print("no section")
        }
        return cell
    }
}
