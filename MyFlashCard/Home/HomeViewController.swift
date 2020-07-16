//
//  HomeViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
        tableView.allowsSelectionDuringEditing = true
    }
}

extension HomeViewController {
    @objc func addEvent() {
        addBook()
    }
}

extension HomeViewController {
    static func createInstance() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    private func initNavigation() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func initTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.backgroundColor = .systemGroupedBackground
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func reView() {
        // 透明にしたナビゲーションを元に戻す処理
        navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController!.navigationBar.shadowImage = nil
        tabBarController?.tabBar.isHidden = false
        loadData()
    }

    private func loadData() {
        dataSource.loadBookModels(conditions: "", sortKey: "updated_at", asc: false)
        tableView.reloadData()
    }

    private func addBook() {
        let vc = BookViewController.createInstance()
        let nav = UINavigationController(rootViewController: vc)
        vc.childCallBack = { () in
            self.loadData()
        }
        present(nav, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bookModelsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.selectionStyle = .none
    
        if let book = dataSource.bookData(at: indexPath.row) {
            let count = book.cards.filter { $0.deleted_at == nil }.count.description
            let bookMarkCount = book.cards.filter { $0.isBookmark == true }.count.description
            let checkCount = book.cards.filter { $0.isCheck == true }.count.description

            let home = HomeCellParam(
                title: book.title ?? "",
                note: book.note ?? "",
                cardCount: count,
                bookMarkCount: bookMarkCount,
                checkCount: checkCount
            )
            cell.home = home
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            let vc = BookViewController.createInstance()
            let nav = UINavigationController(rootViewController: vc)
            if let book = dataSource.bookData(at: indexPath.row) {
                vc.bookModel = book
                vc.childCallBack = { () in
                    self.loadData()
                }
                present(nav, animated: true, completion: nil)
            }
        }else{
            let vc = CardsViewController.createInstance()
            if let book = dataSource.bookData(at: indexPath.row) {
                vc.bookModel = book
                let nv = UINavigationController(rootViewController: vc)
                nv.modalPresentationStyle = .fullScreen
                present(nv, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
