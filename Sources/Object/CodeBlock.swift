//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 29/08/2023.
//

import Foundation

class CodeBlock {
    var metadata: CodeBlockMetadata
    var lines: Array<String> = []
    lazy var concatenatedLines: String = {
        return lines.joined(separator: " ")
    }()
    
    init(metadata: CodeBlockMetadata) {
        self.metadata = metadata
    }
    
    func addLine(_ line: String) {
        lines.append(line)
    }
}
