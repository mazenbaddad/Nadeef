//
//  File 2.swift
//  
//
//  Created by mazen baddad on 9/3/23.
//

import Foundation

class SwiftFileReader: FileReader {
    
    func read(file: File) -> [CodeBlock] {
        guard FileManager.default.fileExists(atPath: file.path) else {
            preconditionFailure("file expected at \(file.path) is missing")
        }
        guard let filePointer:UnsafeMutablePointer<FILE> = fopen(file.path, "r") else {
            preconditionFailure("Could not open file at \(file.path)")
        }
        var codeBlocks: [CodeBlock] = []
        var blockCapture: BlockCapture?
        var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
        defer {
            fclose(filePointer)
            lineByteArrayPointer?.deallocate()
        }
        var lineCap: Int = 0
        var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
        var lineNumber = 1
        while (bytesRead > 0) {
            let line = String.init(cString:lineByteArrayPointer!)
            if !shouldIgnore(line: line) {
                if blockCapture == nil, let objectName = extractDeclarationName(from: line) {
                    blockCapture = BlockCapture(name: objectName)
                }
                blockCapture?.addLine(line)
                if let codeBlock = blockCapture?.capture() {
                    codeBlocks.append(codeBlock)
                    blockCapture = nil
                }
            }
            bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            lineNumber += 1
        }
        return codeBlocks
    }
    
    private func extractDeclarationName(from input: String) -> String? {
        let pattern = "\\b(?:class|struct|extension|protocol|enum)\\s+([A-Za-z_][A-Za-z0-9_]*)"
        var objectName: String?
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = input as NSString
            regex.enumerateMatches(in: input, options: [], range: NSRange(location: 0, length: nsString.length)) { (match, _, _) in
                if let match = match, match.numberOfRanges == 2 {
                    let nameRange = match.range(at: 1)
                    let name = nsString.substring(with: nameRange)
                    objectName = name
                }
            }
        } catch {
            print("Regex error: \(error.localizedDescription)")
        }
        return objectName
    }
}
