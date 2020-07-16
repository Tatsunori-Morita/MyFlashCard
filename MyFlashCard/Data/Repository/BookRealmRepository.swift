//
//  BookRealmRepository.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

class BookRealmRepository: RepositoryProtocol {
    typealias Domain = BookModel
    var realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func toString() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func select(conditions: String, sortKey: String = "id", asc: Bool = true) -> Results<Domain> {
        let result = realm.objects(Domain.self).filter("deleted_at == nil").sorted(byKeyPath: sortKey, ascending: asc)
        if conditions.isEmpty {
            return result
        }
        return result.filter(conditions)
    }
    
    func findId(id: Int) -> Domain? {
        return realm.objects(Domain.self).filter("id == %@", id).first
    }
        
    func add(domains: [Domain]) {
        try! realm.write {
            realm.add(domains)
        }
    }
    
    func update(domains: [Domain]) {
        try! realm.write {
            realm.add(domains, update: .all)
        }
    }
}
