//
//  SqueezeViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class SqueezeViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["ブックマーク", "暗記・未暗記", ""]
    private let bookmarkCells: [String] = ["ブックマークのカードのみ", "ブックマークのカードを除く"]
    private let checkItemCells: [String] = ["暗記済みのカードのみ", "未暗記のカードのみ"]
    var bookModel: BookModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension SqueezeViewController {
    static func createInstance() -> SqueezeViewController {
        let storyboard = UIStoryboard(name: "Squeeze", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SqueezeViewController") as! SqueezeViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "絞り込み"
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
    
    private func updateReadPlace(book: BookModel, section: Int, selectedType: Int) {
        let model = bookModel?.copy() as! BookModel
        model.bookmarkType = section == 0 ? selectedType : book.bookmarkType
        model.learnType = section == 1 ? selectedType : book.learnType
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
    
    private func clearConditions() {
        let model = bookModel?.copy() as! BookModel
        model.bookmarkType = 0
        model.learnType = 0
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
        RealmManager.isRefreshIndex = true
        dismiss(animated: true, completion: nil)
    }
    
    private func changeCheckmark(tableView: UITableView, indexPath: IndexPath, firstRow: Int, secondRow: Int, firstCellType: UITableViewCell.AccessoryType, secondCellType: UITableViewCell.AccessoryType) {
        tableView.cellForRow(at: IndexPath(row: firstRow, section: indexPath.section))?.accessoryType = firstCellType
        tableView.cellForRow(at: IndexPath(row: secondRow, section: indexPath.section))?.accessoryType = secondCellType
    }
}

extension SqueezeViewController {
    @objc func clear() {
        clearConditions()
    }
}

extension SqueezeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bookmarkCells.count
        case 1:
            return checkItemCells.count
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = bookmarkCells[indexPath.row]
            switch indexPath.row {
            case 0:
                if bookModel.bookmarkType == BookmarkType.only.rawValue { cell.accessoryType = .checkmark }
            case 1:
                if bookModel.bookmarkType == BookmarkType.not.rawValue { cell.accessoryType = .checkmark }
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) no cell")
            }
        case 1:
            cell.textLabel?.text = checkItemCells[indexPath.row]
            switch indexPath.row {
            case 0:
                if bookModel.learnType == LearnType.completed.rawValue { cell.accessoryType = .checkmark }
            case 1:
                if bookModel.learnType == LearnType.incomplete.rawValue { cell.accessoryType = .checkmark }
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) no cell")
            }
        case 2:
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: cell.frame.height))
            btn.setTitle("条件をクリア", for: .normal)
            btn.setTitleColor(.systemRed, for: .normal)
            btn.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
            cell.addSubview(btn)
        default:
            print("no section")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableView.cellForRow(at: indexPath)?.accessoryType
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if type == .checkmark {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .none)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: BookmarkType.none.rawValue)
                } else {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .checkmark, secondCellType: .none)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: BookmarkType.only.rawValue)
                }
            case 1:
                if type == .checkmark {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .none)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: BookmarkType.none.rawValue)
                } else {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .checkmark)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: BookmarkType.not.rawValue)
                }
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 1:
            switch indexPath.row {
            case 0:
                if type == .checkmark {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .none)
                    updateReadPlace(book: bookModel, section:indexPath.section, selectedType: LearnType.none.rawValue)
                } else {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .checkmark, secondCellType: .none)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: LearnType.completed.rawValue)
                }
            case 1:
                if type == .checkmark {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .none)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: LearnType.none.rawValue)
                } else {
                    changeCheckmark(tableView: tableView, indexPath: indexPath, firstRow: 0, secondRow: 1, firstCellType: .none, secondCellType: .checkmark)
                    updateReadPlace(book: bookModel, section: indexPath.section, selectedType: LearnType.incomplete.rawValue)
                }
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        default:
            print("no section")
        }
    }
}
