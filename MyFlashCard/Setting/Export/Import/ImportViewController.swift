//
//  ImportViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/15.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["インポートファイル", "インポート先の単語帳", "区切り文字", ""]
    private var fileNameButton: UIButton!
    private var folderNameButton: UIButton!
    private var delimiterButton: UIButton!
    private var fileUrl: URL?
    private var delimiter: Character?
    private var bookModel: BookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension ImportViewController {
    static func createInstance() -> ImportViewController {
        let storyboard = UIStoryboard(name: "Import", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ImportViewController") as! ImportViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "インポート"
    }
    
    private func initTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension ImportViewController {
    @objc func selectFileEvent() {
        let vc = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func selectBookEvent() {
        let vc = BooksListViewController.createInstance()
        vc.navigationTitle = "インポートする単語帳"
        vc.childCallBack = { (bookModel) in
            self.bookModel = bookModel
            self.folderNameButton.setTitle(bookModel.title, for: .normal)
        }
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true, completion: nil)
    }
    
    @objc func selectDelimiterEvent() {
        let ac = UIAlertController(title: "", message: "区切り文字を選択してください", preferredStyle: .actionSheet)
        let comma = UIAlertAction(title: "カンマ", style: .default) { (action) -> Void in
            self.delimiter = ","
            self.delimiterButton.setTitle("カンマ", for: .normal)
        }
        let tab = UIAlertAction(title: "タブ", style: .default) { (action) -> Void in
            self.delimiter = "\t"
            self.delimiterButton.setTitle("タブ", for: .normal)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in }
        ac.addAction(comma)
        ac.addAction(tab)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func importEvent() {
        guard let url = fileUrl else {
            let ac = UIAlertController(title: "エラー", message: "インポートファイルが選択されていません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
            return
        }
        
        guard let originBook = bookModel else {
            let ac = UIAlertController(title: "エラー", message: "インポート先の単語帳が選択されていません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
            return
        }
        
        guard let separator = delimiter else {
            let ac = UIAlertController(title: "エラー", message: "区切り文字が選択されていません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
            return
        }
        
        do {
            let fileData = try Data(contentsOf: url)
            let line = String(data: fileData, encoding: .utf8)
            var blocks: [String.SubSequence] = []
            
            if (line!.contains("\r\n")) {
                blocks = line!.split(separator: "\r\n")
            } else {
                blocks = line!.split(separator: "\n")
            }
            
            var isError = false
            for block in blocks {
                let colums = block.split(separator: separator)
                if colums.count < 2 {
                    isError = true
                    break
                }
            }
            
            if isError {
                let ac = UIAlertController(title: "エラー", message: "インポートデータに誤りがあります。", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
                return
            }
            
            for block in blocks {
                let copyBook = originBook.copy() as! BookModel
                let colums = block.split(separator: ",")
                let cardModel = CardModel()
                cardModel.book_id = copyBook.id
                cardModel.front = String(colums[0])
                cardModel.back = String(colums[1])
                cardModel.comment = colums.count == 3 ? String(colums[2]) : ""
                cardModel.created_at = Date()
                cardModel.updated_at = Date()
                copyBook.cards.append(cardModel)
                RealmManager.update(bookModel: copyBook)
            }
            
            let ac = UIAlertController(title: "完了", message: "インポートが完了しました。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        } catch let error {
            print(error)
            let ac = UIAlertController(title: "エラー", message: "インポートエラーが発生しました。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .destructive) { (action) in }
            ac.addAction(ok)
            present(ac, animated: true, completion: nil)
        }
    }
}

extension ImportViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        switch indexPath.section {
        case 0:
            fileNameButton = UIButton(frame: CGRect(x: 20, y: 0, width: view.frame.width, height: cell.frame.height))
            fileNameButton.setTitle("ファイルを選択...", for: .normal)
            fileNameButton.setTitleColor(.systemGray, for: .normal)
            fileNameButton.contentHorizontalAlignment = .left
            fileNameButton.addTarget(self, action: #selector(selectFileEvent), for: .touchUpInside)
            cell.addSubview(fileNameButton)
        case 1:
            folderNameButton = UIButton(frame: CGRect(x: 20, y: 0, width: view.frame.width, height: cell.frame.height))
            folderNameButton.setTitle("単語帳を選択...", for: .normal)
            folderNameButton.setTitleColor(.systemGray, for: .normal)
            folderNameButton.contentHorizontalAlignment = .left
            folderNameButton.addTarget(self, action: #selector(selectBookEvent), for: .touchUpInside)
            cell.addSubview(folderNameButton)
        case 2:
            delimiterButton = UIButton(frame: CGRect(x: 20, y: 0, width: view.frame.width, height: cell.frame.height))
            delimiterButton.setTitle("区切り文字を選択...", for: .normal)
            delimiterButton.setTitleColor(.systemGray, for: .normal)
            delimiterButton.contentHorizontalAlignment = .left
            delimiterButton.addTarget(self, action: #selector(selectDelimiterEvent), for: .touchUpInside)
            cell.addSubview(delimiterButton)
        case 3:
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: cell.frame.height))
            btn.setTitle("インポート", for: .normal)
            btn.setTitleColor(.systemBlue, for: .normal)
            btn.addTarget(self, action: #selector(importEvent), for: .touchUpInside)
            cell.addSubview(btn)
        default:
            print("no section")
        }
        return cell
    }
}

extension ImportViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        fileUrl = url
        fileNameButton.setTitle(url.lastPathComponent, for: .normal)
    }
}

