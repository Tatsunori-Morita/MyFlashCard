//
//  SortViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    private var tableView: UITableView!
    private let cells: [String] = ["カスタム", "シャフル", "作成日昇順", "作成日降順", "タイトル昇順", "タイトル降順"]
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension SortViewController {
    static func createInstance() -> SortViewController {
        let storyboard = UIStoryboard(name: "Sort", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "ソート"
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
    
    private func updateSortType(book: BookModel, indexPath: IndexPath) {
        let model = bookModel?.copy() as! BookModel
        model.sortType = indexPath.row
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
    
    private func changeCheckmark(tableView: UITableView, indexPath: IndexPath, customeType: UITableViewCell.AccessoryType, shuffleType: UITableViewCell.AccessoryType, createdAtAscType: UITableViewCell.AccessoryType, createdAtDecType: UITableViewCell.AccessoryType, titleAscType: UITableViewCell.AccessoryType, titleDecType: UITableViewCell.AccessoryType) {
        tableView.cellForRow(at: IndexPath(row: SortType.custome.rawValue, section: indexPath.section))?.accessoryType = customeType
        tableView.cellForRow(at: IndexPath(row: SortType.shuffle.rawValue, section: indexPath.section))?.accessoryType = shuffleType
        tableView.cellForRow(at: IndexPath(row: SortType.createdAtAsc.rawValue, section: indexPath.section))?.accessoryType = createdAtAscType
        tableView.cellForRow(at: IndexPath(row: SortType.createdAtDec.rawValue, section: indexPath.section))?.accessoryType = createdAtDecType
        tableView.cellForRow(at: IndexPath(row: SortType.titleAsc.rawValue, section: indexPath.section))?.accessoryType = titleAscType
        tableView.cellForRow(at: IndexPath(row: SortType.titleDec.rawValue, section: indexPath.section))?.accessoryType = titleDecType
    }
    
    private func clearConditions() {
        let model = bookModel?.copy() as! BookModel
        model.sortType = 0
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
        dismiss(animated: true, completion: nil)
    }
}

extension SortViewController {
    @objc func clear() {
        clearConditions()
    }
}

extension SortViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cells.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = cells[indexPath.row]
            switch indexPath.row {
            case SortType.custome.rawValue:
                if bookModel.sortType == SortType.custome.rawValue { cell.accessoryType = .checkmark}
            case SortType.shuffle.rawValue:
                if bookModel.sortType == SortType.shuffle.rawValue { cell.accessoryType = .checkmark}
            case SortType.createdAtAsc.rawValue:
                if bookModel.sortType == SortType.createdAtAsc.rawValue { cell.accessoryType = .checkmark}
            case SortType.createdAtDec.rawValue:
                if bookModel.sortType == SortType.createdAtDec.rawValue { cell.accessoryType = .checkmark}
            case SortType.titleAsc.rawValue:
                if bookModel.sortType == SortType.titleAsc.rawValue { cell.accessoryType = .checkmark}
            case SortType.titleDec.rawValue:
                if bookModel.sortType == SortType.titleDec.rawValue { cell.accessoryType = .checkmark}
            default:
                print("no cell")
            }
        case 1:
            let btn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: cell.frame.height))
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
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case SortType.custome.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .checkmark, shuffleType: .none, createdAtAscType: .none, createdAtDecType: .none, titleAscType: .none, titleDecType: .none)
            case SortType.shuffle.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .none, shuffleType: .checkmark, createdAtAscType: .none, createdAtDecType: .none, titleAscType: .none, titleDecType: .none)
            case SortType.createdAtAsc.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .none, shuffleType: .none, createdAtAscType: .checkmark, createdAtDecType: .none, titleAscType: .none, titleDecType: .none)
            case SortType.createdAtDec.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .none, shuffleType: .none, createdAtAscType: .none, createdAtDecType: .checkmark, titleAscType: .none, titleDecType: .none)
            case SortType.titleAsc.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .none, shuffleType: .none, createdAtAscType: .none, createdAtDecType: .none, titleAscType: .checkmark, titleDecType: .none)
            case SortType.titleDec.rawValue:
                changeCheckmark(tableView: tableView, indexPath: indexPath, customeType: .none, shuffleType: .none, createdAtAscType: .none, createdAtDecType: .none, titleAscType: .none, titleDecType: .checkmark)
            default:
                print("section:\(indexPath.section) row:\(indexPath.row) not checked")
            }
        default:
            print("no section")
        }
        updateSortType(book: bookModel, indexPath: indexPath)
    }
}

