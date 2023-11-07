//
//  File.swift
//  
//
//  Created by mazen baddad on 11/4/23.
//

import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
