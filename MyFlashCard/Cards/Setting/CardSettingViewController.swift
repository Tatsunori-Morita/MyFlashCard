//
//  CardSettingViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class CardSettingViewController: UIViewController {
    private var tableView: UITableView!
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

extension CardSettingViewController {
    static func createInstance() -> CardSettingViewController {
        let storyboard = UIStoryboard(name: "CardSetting", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CardSettingViewController") as! CardSettingViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Card Setting"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
    }
    
    private func initTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func closeModal() {
        dismiss(animated: true)
    }
    
    private func changeCommentArea(isOn: Bool) {
        let model = bookModel?.copy() as! BookModel
        model.isCommentOn = isOn
        RealmManager.update(bookModel: model)
        RealmManager.isRealmUpdate = true
    }
}

extension CardSettingViewController {
    @objc func close() {
        closeModal()
    }
    
    @objc func changeCommentArea(sender: UISwitch) {
        changeCommentArea(isOn: sender.isOn)
    }
}

extension CardSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "テキスト設定"
            case 1:
                cell.textLabel?.text = "読み上げ設定"
            default:
                print("section:\(indexPath.section) no cell")
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "絞り込み"
            case 1:
                cell.textLabel?.text = "ソート"
            default:
                print("section:\(indexPath.section) no cell")
            }
        case 2:
            cell.textLabel?.text = "コメントを常に表示"
            let sw = UISwitch(frame: CGRect(x: 0, y: 0, width: 80, height: cell.frame.height))
            sw.isOn = bookModel.isCommentOn
            sw.addTarget(self, action: #selector(changeCommentArea(sender:)), for: .valueChanged)
            cell.accessoryView = sw
        default:
            print("no section")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let vc = TextSettingViewController.createInstance()
                vc.bookModel = bookModel
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = SpeakerSettingViewController.createInstance()
                vc.bookModel = bookModel
                navigationController?.pushViewController(vc, animated: true)
            default:
                print("section:\(indexPath.section) no cell")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = SqueezeViewController.createInstance()
                vc.bookModel = bookModel
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = SortViewController.createInstance()
                vc.bookModel = bookModel
                navigationController?.pushViewController(vc, animated: true)
            default:
                print("section:\(indexPath.section) no cell")
            }

        default:
            print("no section")
        }
    }
}
