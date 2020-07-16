//
//  SpeakerSettingViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class SpeakerSettingViewController: UIViewController {
    private var tableView: UITableView!
    private let cells: [String] = ["両面読み上げ", "表面のみ読み上げ", "裏面のみ読み上げ"]
    var bookModel: BookModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
}

extension SpeakerSettingViewController {
    static func createInstance() -> SpeakerSettingViewController {
        let storyboard = UIStoryboard(name: "SpeakerSetting", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SpeakerSettingViewController") as! SpeakerSettingViewController
    }
    
    private func initNavigation() {
        navigationItem.title = "読み上げ設定"
    }
    
    private func initTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func updateReadPlace(book: BookModel, indexPath: IndexPath) {
        let model = bookModel?.copy() as! BookModel
        model.readPlace = indexPath.row
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
    
    private func changeCheckmark(tableView: UITableView, indexPath: IndexPath, bothType: UITableViewCell.AccessoryType, frontType: UITableViewCell.AccessoryType, backType: UITableViewCell.AccessoryType) {
        tableView.cellForRow(at: IndexPath(row: TextSize.small.rawValue, section: indexPath.section))?.accessoryType = bothType
        tableView.cellForRow(at: IndexPath(row: TextSize.medium.rawValue, section: indexPath.section))?.accessoryType = frontType
        tableView.cellForRow(at: IndexPath(row: TextSize.large.rawValue, section: indexPath.section))?.accessoryType = backType
    }
}

extension SpeakerSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row]
        cell.selectionStyle = .none
        if bookModel.readPlace == indexPath.row { cell.accessoryType = .checkmark }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeCheckmark(tableView: tableView, indexPath: indexPath, bothType: .checkmark, frontType: .none, backType: .none)
        case 1:
            changeCheckmark(tableView: tableView, indexPath: indexPath, bothType: .none, frontType: .checkmark, backType: .none)
        case 2:
            changeCheckmark(tableView: tableView, indexPath: indexPath, bothType: .none, frontType: .none, backType: .checkmark)
        default:
            print("section:\(indexPath.section) row:\(indexPath.row) not checked")
        }
        self.updateReadPlace(book: bookModel, indexPath: indexPath)
    }
}
