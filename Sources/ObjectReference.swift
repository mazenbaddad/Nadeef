//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 30/08/2023.
//

import Foundation

class ObjectReference {
    var object: Object
    var references: [WeakBox<Object>] = []
    
    init(object: Object) {
        self.object = object
    }
    
    func add(reference: Object) {
        references.append(WeakBox(value: reference))
    }
    
    func clearReferences() {
        references.removeAll(where: {$0.value == nil})
    }
}

class WeakBox<T:AnyObject> {
    weak var value: T?
    init(value: T?) {
        self.value = value
    }
}
