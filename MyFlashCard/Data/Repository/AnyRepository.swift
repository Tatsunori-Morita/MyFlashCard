//
//  AnyRepository.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

struct AnyRepository<DomainType: Object>: RepositoryProtocol {
    typealias Domain = DomainType
    
    private let _toSting:() -> ()
    private let _select:(String, String, Bool) -> Results<Domain>
    private let _findId:(Int) -> Domain?
    private let _add:([Domain]) -> ()
    private let _update:([Domain]) -> ()
    
    init<T: RepositoryProtocol>(_ repository: T) where T.Domain == DomainType {
        _toSting = repository.toString
        _select = repository.select
        _findId = repository.findId
        _add = repository.add
        _update = repository.update
    }
    
    func toString() {
        return _toSting()
    }
    
    func select(conditions: String, sortKey: String, asc: Bool) -> Results<Domain> {
        return _select(conditions, sortKey, asc)
    }

    func findId(id: Int) -> DomainType? {
        return _findId(id)
    }
    
    func add(domains: [DomainType]) -> () {
        return _add(domains)
    }
    
    func update(domains: [DomainType]) -> () {
        return _update(domains)
    }
}
