//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 29/08/2023.
//

import Foundation

protocol FileReader {
    func read(file: File) throws -> Array<CodeBlock>
}

extension FileReader {
    
    func shouldIgnore(line: String) -> Bool {
        return isEmpty(line: line) || isCommented(line: line)
    }
    
    func isEmpty(line: String) -> Bool {
        return line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isCommented(line: String) -> Bool {
        let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedLine.hasPrefix("//")
    }
    
}
