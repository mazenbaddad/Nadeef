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
        guard !openCurlyBracesIndices.isEmpty || !closeCurlyBracesIndices.isEmpty else { return }
        
        if doubleQuotationIndices.isEmpty {
            self.openCurlyBraces += openCurlyBracesIndices.count
            self.closeCurlyBraces += closeCurlyBracesIndices.count
        } else {
            self.openCurlyBraces += openCurlyBracesIndices.filter({
                for range in rangesFromIndices(doubleQuotationIndices) {
                    if range ~= $0 {
                        return false
                    }
                }
                return true
            }).count
            self.closeCurlyBraces += closeCurlyBracesIndices.filter({
                for range in rangesFromIndices(doubleQuotationIndices) {
                    if range ~= $0 {
                        return false
                    }
                }
                return true
            }).count
        }
    }
    
    private func rangesFromIndices(_ indices: Array<Int>) -> Array<ClosedRange<Int>> {
        var ranges: Array<ClosedRange<Int>> = []
        var lastIndex: Int?
        for index in indices {
            if let last = lastIndex {
                let range = last...index
                ranges.append(range)
                lastIndex = nil
            } else {
                lastIndex = index
            }
        }
        return ranges
    }
    
    func capture() -> CodeBlock? {
        if validToCapture {
            return self.codeBlock
        }
        return nil
    }
}
