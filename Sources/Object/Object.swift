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
    private var configuration: NadeefConfiguration
    var systemObject: Bool {
        return configuration.roots.contains(name)
    }
    
    init(name: String, configuration: NadeefConfiguration) {
        self.name = name
        self.configuration = configuration
    }
    
    func add(codeBlock: CodeBlock) {
        self.codeBlocks.append(codeBlock)
    }
}

class SystemObject: Object {
    
    override var systemObject: Bool {
        return true
    }
    
    init() {
        super.init(name: "System", configuration: .init(logs: false, roots: []))
    }
}

class SwiftObject: Object {
    
    override var systemObject: Bool {
        return super.systemObject || codeBlocks.filter({ $0.metadata.type != "extension"}).isEmpty
    }
}
