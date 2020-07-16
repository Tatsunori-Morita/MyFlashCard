//
//  TextSizeViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class TextSizeViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["表面の文字サイズ", "裏面の文字サイズ", "コメントの文字サイズ"]
    private let cells: [String] = ["小", "中", "大", "特大"]
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension TextSizeViewController {
    static func createInstance() -> TextSizeViewController {
        let storyboard = UIStoryboard(name: "TextSize", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TextSizeViewController") as! TextSizeViewController
    }
    
    private func initNavigation() {
        navigationItem.title = "サイズ設定"
    }
    
    private func initTableView() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func updateTextSize(book: BookModel, indexPath: IndexPath) {
        let model = bookModel?.copy() as! BookModel
        model.frontTextSize = indexPath.section == 0 ? indexPath.row : book.frontTextSize
        model.backTextSize = indexPath.section == 1 ? indexPath.row : book.backTextSize
        model.commentTextSize = indexPath.section == 2 ? indexPath.row : book.commentTextSize
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
    
    private func changeCheckmark(tableView: UITableView, indexPath: IndexPath, smallType: UITableViewCell.AccessoryType, mediumType: UITableViewCell.AccessoryType, largeType: UITableViewCell.AccessoryType, extraLargeType: UITableViewCell.AccessoryType) {
        tableView.cellForRow(at: IndexPath(row: TextSize.small.rawValue, section: indexPath.section))?.accessoryType = smallType
        tableView.cellForRow(at: IndexPath(row: TextSize.medium.rawValue, section: indexPath.section))?.accessoryType = mediumType
        tableView.cellForRow(at: IndexPath(row: TextSize.large.rawValue, section: indexPath.section))?.accessoryType = largeType
        tableView.cellForRow(at: IndexPath(row: TextSize.extraLarge.rawValue, section: indexPath.section))?.accessoryType = extraLargeType
    }
}

extension TextSizeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .none
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case bookModel.frontTextSize:
                cell.accessoryType = .checkmark
            default:
                print("no front cell")
            }
        case 1:
            switch indexPath.row {
            case bookModel.backTextSize:
                cell.accessoryType = .checkmark
            default:
                print("no back cell")
            }
        case 2:
            switch indexPath.row {
            case bookModel.commentTextSize:
                cell.accessoryType = .checkmark
            default:
                print("no comment cell")
            }
        default:
            print("no section")
        }
        print(String(describing: self))
        print(#function)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case TextSize.small.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .checkmark, mediumType: .none, largeType: .none, extraLargeType: .none)
            case TextSize.medium.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .checkmark, largeType: .none, extraLargeType: .none)
            case TextSize.large.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .checkmark, extraLargeType: .none)
            case TextSize.extraLarge.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .none, extraLargeType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 1:
            switch indexPath.row {
            case TextSize.small.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .checkmark, mediumType: .none, largeType: .none, extraLargeType: .none)
            case TextSize.medium.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .checkmark, largeType: .none, extraLargeType: .none)
            case TextSize.large.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .checkmark, extraLargeType: .none)
            case TextSize.extraLarge.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .none, extraLargeType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 2:
            switch indexPath.row {
            case TextSize.small.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .checkmark, mediumType: .none, largeType: .none, extraLargeType: .none)
            case TextSize.medium.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .checkmark, largeType: .none, extraLargeType: .none)
            case TextSize.large.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .checkmark, extraLargeType: .none)
            case TextSize.extraLarge.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, smallType: .none, mediumType: .none, largeType: .none, extraLargeType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        default:
            print("no section")
        }
        self.updateTextSize(book: bookModel, indexPath: indexPath)
    }
}
