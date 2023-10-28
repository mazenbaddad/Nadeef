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
    
    init(metadata: CodeBlockMetadata) {
        self.codeBlock = CodeBlock(metadata: metadata)
    }
    
    func addLine(_ line: String) {
        codeBlock.addLine(line)
        var openCurlyBracesIndices: Array<Int> = []
        var closeCurlyBracesIndices: Array<Int> = []
        var doubleQuotationIndices: Array<Int> = []
        
        for (i, char) in line.enumerated() {
            if char == "{" { openCurlyBracesIndices.append(i) }
            if char == "}" { closeCurlyBracesIndices.append(i) }
            if char == #"""# { doubleQuotationIndices.append(i) }
        }
        if doubleQuotationIndices.isEmpty {
            self.openCurlyBraces += openCurlyBracesIndices.count
            self.closeCurlyBraces += closeCurlyBracesIndices.count
        } else {
            self.openCurlyBraces += openCurlyBracesIndices.filter({
                let firstIndex = doubleQuotationIndices.first ?? 0
                let lastIndex = doubleQuotationIndices.last ?? 0
                return !(firstIndex...lastIndex ~= $0)
            }).count
            self.closeCurlyBraces += closeCurlyBracesIndices.filter({
                let firstIndex = doubleQuotationIndices.first ?? 0
                let lastIndex = doubleQuotationIndices.last ?? 0
                return !(firstIndex...lastIndex ~= $0)
            }).count
        }
    }
    
    func capture() -> CodeBlock? {
        if validToCapture {
            return self.codeBlock
        }
        return nil
    }
}
