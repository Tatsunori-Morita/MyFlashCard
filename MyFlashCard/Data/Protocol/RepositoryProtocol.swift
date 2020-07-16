//
//  RepositoryProtocol.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import Foundation
import RealmSwift

protocol RepositoryProtocol {
    associatedtype Domain: Object

    func toString() -> ()
    func select(conditions: String, sortKey: String, asc: Bool) -> Results<Domain>
    func findId(id: Int) -> Domain?
    func add(domains: [Domain]) -> ()
    func update(domains: [Domain]) -> ()
}
