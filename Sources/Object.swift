//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 30/08/2023.
//

import Foundation

class Object {
    var name: String
    var codeBlocks: Array<CodeBlock> = []
    
    init(name: String) {
        self.name = name
    }
    
    func add(codeBlock: CodeBlock) {
        self.codeBlocks.append(codeBlock)
    }
}
