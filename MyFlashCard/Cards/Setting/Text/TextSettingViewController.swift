//
//  TextSettingViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class TextSettingViewController: UIViewController {
    private var tableView: UITableView!
    private let cells: [String] = ["表示位置", "サイズ"]
    var bookModel: BookModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
}

extension TextSettingViewController {
    static func createInstance() -> TextSettingViewController {
        let storyboard = UIStoryboard(name: "TextSetting", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TextSettingViewController") as! TextSettingViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "テキスト設定"
    }
    
    private func initTableView() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.allowsMultipleSelection = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
}

extension TextSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = TextPositionViewController.createInstance()
            vc.bookModel = bookModel
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = TextSizeViewController.createInstance()
            vc.bookModel = bookModel
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("no section")
        }
    }
}

