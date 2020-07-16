//
//  CommonSettingViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/15.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class CommonSettingViewController: UIViewController {
    private var tableView: UITableView!
    private let sections: [String] = ["通知設定", "アプリ連携", "カード入力・出力", ""]
    private let notificationCell: [String] = ["単語復習の通知設定"]
    private let relationCell: [String] = ["他のアプリからカード登録"]
    private let inOutPutCell: [String] = ["バックアップ出力", "単語データ取り込み", "PCで単語データを作成"]
    private let nightModeCell: [String] = ["ナイトモード"]
    var childCallBack: ((String) -> Void)?
    
    static func createInstance() -> CommonSettingViewController {
        let storyboard = UIStoryboard(name: "CommonSetting", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CommonSettingViewController") as! CommonSettingViewController
    }
    
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

extension CommonSettingViewController {
    private func initNavigation() {
        navigationItem.title = "Setting"
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

extension CommonSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return notificationCell.count
        case 1:
            return relationCell.count
        case 2:
            return inOutPutCell.count
        case 3:
            return nightModeCell.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = notificationCell[indexPath.row]
            let sw = UISwitch(frame: CGRect(x: 0, y: 0, width: 80, height: cell.frame.height))
            cell.accessoryView = sw
        case 1:
            cell.textLabel?.text = relationCell[indexPath.row]
        case 2:
            cell.textLabel?.text = inOutPutCell[indexPath.row]
        case 3:
            cell.textLabel?.text = nightModeCell[indexPath.row]
            let sw = UISwitch(frame: CGRect(x: 0, y: 0, width: 80, height: cell.frame.height))
            cell.accessoryView = sw
        default:
            print("no section")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            switch indexPath.row {
            case 0:
                let vc = ExportViewController.createInstance()
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = ImportViewController.createInstance()
                navigationController?.pushViewController(vc, animated: true)
            default:
                return
            }
        default:
            return
        }
    }
}
