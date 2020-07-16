//
//  ExportViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/15.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["エクスポートする単語帳", "区切り文字", ""]
    private var bookNameButton: UIButton!
    private var delimiterButton: UIButton!
    private var delimiter: Character?
    private var bookModel: BookModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension ExportViewController {
    static func createInstance() -> ExportViewController {
        let storyboard = UIStoryboard(name: "Export", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ExportViewController") as! ExportViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "エクスポート"
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

extension ExportViewController {
    @objc func selectBookEvent() {
        let vc = BooksListViewController.createInstance()
        vc.navigationTitle = "エクスポートする単語帳"
        vc.childCallBack = { (bookModel) in
            self.bookModel = bookModel
            self.bookNameButton.setTitle(bookModel.title, for: .normal)
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
    
    @objc func exportEvent() {
        guard let book = bookModel else {
            let ac = UIAlertController(title: "エラー", message: "エクスポートする単語帳が選択されていません", preferredStyle: .alert)
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

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask ).first {
            let path = dir.appendingPathComponent("data.csv")
            var array: [String] = []
            for card in book.cards {
                array.append("\(card.front!)\(separator)\(card.back!)\(separator)\(card.comment ?? "")")
            }
            let lines = array.joined(separator: "\n")
            let data = lines.data(using: .utf8)
            do {
                try data?.write(to: path)
                let ac = UIAlertController(title: "完了", message: "エクスポートが完了しました。", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
            } catch let error {
                print(error)
                let ac = UIAlertController(title: "エラー", message: "エクスポートエラーが発生しました。", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .destructive) { (action) in }
                ac.addAction(ok)
                present(ac, animated: true, completion: nil)
            }
        }
    }
}

extension ExportViewController: UITableViewDataSource, UITableViewDelegate {
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
            bookNameButton = UIButton(frame: CGRect(x: 20, y: 0, width: view.frame.width, height: cell.frame.height))
            bookNameButton.setTitle("単語帳を選択...", for: .normal)
            bookNameButton.setTitleColor(.systemGray, for: .normal)
            bookNameButton.contentHorizontalAlignment = .left
            bookNameButton.addTarget(self, action: #selector(selectBookEvent), for: .touchUpInside)
            cell.addSubview(bookNameButton)
        case 1:
            delimiterButton = UIButton(frame: CGRect(x: 20, y: 0, width: view.frame.width, height: cell.frame.height))
            delimiterButton.setTitle("区切り文字を選択...", for: .normal)
            delimiterButton.setTitleColor(.systemGray, for: .normal)
            delimiterButton.contentHorizontalAlignment = .left
            delimiterButton.addTarget(self, action: #selector(selectDelimiterEvent), for: .touchUpInside)
            cell.addSubview(delimiterButton)
        case 2:
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: cell.frame.height))
            btn.setTitle("エクスポート", for: .normal)
            btn.setTitleColor(.systemBlue, for: .normal)
            btn.addTarget(self, action: #selector(exportEvent), for: .touchUpInside)
            cell.addSubview(btn)
        default:
            print("no section")
        }
        return cell
    }
}
