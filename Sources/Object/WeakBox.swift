//
//  File.swift
//  
//
//  Created by mazen baddad on 10/28/23.
//

import Foundation

class WeakBox<T:AnyObject> {
    weak var value: T?
    init(value: T?) {
        self.value = value
    }
}
