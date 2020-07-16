//
//  TextPositionViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class TextPositionViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["表面の表示位置(水平)", "裏面の表示位置(水平)", "コメントの表示位置(水平)"]
    private let cells: [String] = ["左寄せ", "中央寄せ", "右寄せ"]
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension TextPositionViewController {
    static func createInstance() -> TextPositionViewController {
        let storyboard = UIStoryboard(name: "TextPosition", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TextPositionViewController") as! TextPositionViewController
    }
    
    private func initNavigation() {
        navigationItem.title = "表示位置設定"
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
    
    private func updateTextPosition(book: BookModel, indexPath: IndexPath) {
        let model = bookModel?.copy() as! BookModel
        model.frontTextPosition = indexPath.section == 0 ? indexPath.row : book.frontTextPosition
        model.backTextPosition = indexPath.section == 1 ? indexPath.row : book.backTextPosition
        model.commentTextPosition = indexPath.section == 2 ? indexPath.row : book.commentTextPosition
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
    
    private func changeCheckmark(tableView: UITableView, indexPath: IndexPath, leftType: UITableViewCell.AccessoryType, centerType: UITableViewCell.AccessoryType, rightType: UITableViewCell.AccessoryType) {
        tableView.cellForRow(at: IndexPath(row: TextPosition.left.rawValue, section: indexPath.section))?.accessoryType = leftType
        tableView.cellForRow(at: IndexPath(row: TextPosition.center.rawValue, section: indexPath.section))?.accessoryType = centerType
        tableView.cellForRow(at: IndexPath(row: TextPosition.right.rawValue, section: indexPath.section))?.accessoryType = rightType
    }
}

extension TextPositionViewController: UITableViewDataSource, UITableViewDelegate {
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
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case bookModel.frontTextPosition:
                cell.accessoryType = .checkmark
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 1:
            switch indexPath.row {
            case bookModel.backTextPosition:
                cell.accessoryType = .checkmark
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 2:
            switch indexPath.row {
            case bookModel.commentTextPosition:
                cell.accessoryType = .checkmark
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        default:
            print("no section")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case TextPosition.left.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .checkmark, centerType: .none, rightType: .none)
            case TextPosition.center.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .checkmark, rightType: .none)
            case TextPosition.right.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .none, rightType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 1:
            switch indexPath.row {
            case TextPosition.left.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .checkmark, centerType: .none, rightType: .none)
            case TextPosition.center.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .checkmark, rightType: .none)
            case TextPosition.right.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .none, rightType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        case 2:
            switch indexPath.row {
            case TextPosition.left.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .checkmark, centerType: .none, rightType: .none)
            case TextPosition.center.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .checkmark, rightType: .none)
            case TextPosition.right.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, leftType: .none, centerType: .none, rightType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        default:
            print("no section")
        }
        updateTextPosition(book: bookModel, indexPath: indexPath)
    }
}
