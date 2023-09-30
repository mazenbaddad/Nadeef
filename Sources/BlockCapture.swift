//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 29/08/2023.
//

import Foundation

class BlockCapture {

    var openCurlyBraces = 0
    var closeCurlyBraces = 0
    private var codeBlock: CodeBlock
    private var validToCapture: Bool {
        return openCurlyBraces == closeCurlyBraces && openCurlyBraces > 0
    }
    
    init(name: String) {
        self.codeBlock = CodeBlock(name: name)
    }
    
    func addLine(_ line: String) {
        codeBlock.addLine(line)
        openCurlyBraces += line.filter({$0 == "{"}).count
        closeCurlyBraces += line.filter({$0 == "}"}).count
        
    }
    
    func capture() -> CodeBlock? {
        if validToCapture {
            return self.codeBlock
        }
        return nil
    }
}
