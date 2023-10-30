//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 30/08/2023.
//

import Foundation

class ReferenceCounter {
    
    func searchReferences(for objects: [Object]) -> [ObjectReference] {
        var objectReferences: [ObjectReference] = []
        for searchedObject in objects {
            print("REFERENCE COUNTING \(searchedObject.name)")
            let objectReference = ObjectReference(object: searchedObject)
            objectReferences.append(objectReference)
            if !searchedObject.systemObject {
                for object in objects where searchedObject.name != object.name {
                    for codeBlock in object.codeBlocks {
                        if isLine(codeBlock.concatenatedLines, contains: searchedObject.name) {
                            objectReference.add(reference: object)
                            break
                        }
                    }
                }
            }
        }
        return objectReferences
    }
    
    private func isLine(_ line: String, contains name: String) -> Bool {
        let regexPattern = #"(?<!\p{L})(\#(name))(?!\p{L})"#
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex.matches(in: line, options: [], range: NSRange(line.startIndex..., in: line))
        return matches.count > 0
    }
}
