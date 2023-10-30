//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 30/08/2023.
//

import Foundation

class ObjectReference {
    var object: Object
    private var _references: [WeakBox<Object>] = []
    var references: [WeakBox<Object>] {
        !object.systemObject ? _references : [WeakBox(value: systemObject)]
    }
    private lazy var systemObject = SystemObject()
    
    init(object: Object) {
        self.object = object
    }
    
    func add(reference: Object) {
        _references.append(WeakBox(value: reference))
    }
    
    func clearReferences() {
        _references.removeAll(where: {$0.value == nil})
    }
}

