//
//  BooksListViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/15.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class BooksListViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource = RealmManager()
    var childCallBack: ((BookModel) -> Void)?
    var navigationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
        loadData()
    }
}

extension BooksListViewController {
    static func createInstance() -> BooksListViewController {
        let storyboard = UIStoryboard(name: "BooksList", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "BooksListViewController") as! BooksListViewController
    }
    
    private func initNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = navigationTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeEvent))
    }
    
    private func initTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func loadData() {
        dataSource.loadBookModels(conditions: "", sortKey: "updated_at", asc: false)
        tableView.reloadData()
    }
    
    private func closeModal() {
        self.dismiss(animated: true)
    }
}

extension BooksListViewController {
    @objc func closeEvent() {
        closeModal()
    }
}

extension BooksListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bookModelsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if let book = dataSource.bookData(at: indexPath.row) {
            cell.textLabel?.text = book.title
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.childCallBack?(self.dataSource.bookData(at: indexPath.row)!)
        }
    }
}
