//
//  File 2.swift
//  
//
//  Created by mazen baddad on 9/3/23.
//

import Foundation

open class SwiftFileReader: FileReader {
    
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
                if blockCapture == nil, let blockMetadata = codeBlockMetaData(from: line) {
                    blockCapture = BlockCapture(metadata: blockMetadata)
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
    
    private func codeBlockMetaData(from input: String) -> CodeBlockMetadata? {
        var blockMetaData: CodeBlockMetadata?
        do {
            let objectRegex = "(?:class|actor|struct|extension|protocol|enum)\\s+(?!(func\\s+|var\\s+|let\\s+))([A-Za-z_][A-Za-z0-9_]*)"
            let regex = try NSRegularExpression(pattern: objectRegex, options: [])
            let nsInput = input as NSString
            regex.enumerateMatches(in: input, options: [], range: NSRange(location: 0, length: nsInput.length)) { (match, _, _) in
                guard let match = match, match.numberOfRanges > 1, let blockType = nsInput.substring(with: match.range(at: 0)).components(separatedBy: .whitespaces).first else { return }
                let blockName = nsInput.substring(with: match.range(at: match.numberOfRanges-1))
                var blockParents: Array<String> = []
                
                let inheritanceRegex = #":\s*([^{\n]+)"#
                if let range = input.range(of: inheritanceRegex, options: .regularExpression) {
                    let match = input[range]
                    let parentList = match.replacingOccurrences(of: ":", with: "").components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    blockParents = parentList
                }
                blockMetaData = CodeBlockMetadata(type: blockType, name: blockName, parents: blockParents)
            }
        } catch {
            return nil
        }
        return blockMetaData
    }
}

