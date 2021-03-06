//
//  HomeViewController.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class HomeViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initTableView()
        initDZNEmptyDataSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dataSource.bookModelsCount() == 0 {
            navigationItem.leftBarButtonItem?.isEnabled = false
        } else {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
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
        navigationItem.title = "My Flash Card"
        navigationController?.navigationBar.barTintColor = UIColor(red: 250/255, green: 249/255, blue: 249/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 1.0)
        ]
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 90/255, green: 91/255, blue: 90/255, alpha: 1.0)
    }

    private func initTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - tabBarController!.tabBar.frame.size.height), style: .plain)
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.backgroundColor = UIColor(red: 233/255, green: 236/255, blue: 244/255, alpha: 1)
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
        dataSource.loadBookModels(conditions: "", sortKey: "order", asc: true)
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
    
    private func initDZNEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
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
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        } else {
            var newOrder: Double
            if destinationIndexPath.row == 0 {
                // 一番上に移動した場合は先頭セル - 1
                newOrder = (dataSource.bookData(at: destinationIndexPath.row)!.order ) - 1.0
            } else if destinationIndexPath.row == dataSource.bookModelsCount() - 1 {
                // 一番下に移動した場合は末尾セル + 1
                newOrder = (dataSource.bookData(at: destinationIndexPath.row)!.order ) + 1.0
            } else {
                // 途中に移動したときは上下セルの中央値
                var rowPrev: Int, rowNext: Int;
                if (destinationIndexPath.row < sourceIndexPath.row) {
                    // 上に移動した場合
                    rowPrev = destinationIndexPath.row - 1
                    rowNext = destinationIndexPath.row
                } else {
                    // 下に移動した場合
                    rowPrev = destinationIndexPath.row
                    rowNext = destinationIndexPath.row + 1
                }
                newOrder = ((dataSource.bookData(at: rowPrev)!.order ) + (dataSource.bookData(at: rowNext)!.order )) / 2.0
            }
            let model = dataSource.bookData(at: sourceIndexPath.row)!.copy() as! BookModel
            model.order = newOrder
            model.updated_at = Date()
            RealmManager.update(bookModel: model)
            loadData()
            tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "データがありません")
    }
}
