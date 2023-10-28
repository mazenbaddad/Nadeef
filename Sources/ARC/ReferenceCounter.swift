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
        for searchedObject in objects where !shouldIgnoreType(type: searchedObject.name){
            print("REFERENCE COUNTING \(searchedObject.name)")
            let objectReference = ObjectReference(object: searchedObject)
            objectReferences.append(objectReference)
            for object in objects where searchedObject.name != object.name {
                for codeBlock in object.codeBlocks {
                    if isSentence(codeBlock.concatenatedLines, contains: searchedObject.name) {
                        objectReference.add(reference: object)
                        break
                    }
                }
            }
        }
        return objectReferences
    }
    
    private func isSentence(_ sentence: String, contains name: String) -> Bool {
        let regexPattern = #"(?<!\p{L})(\#(name))(?!\p{L})"#
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex.matches(in: sentence, options: [], range: NSRange(sentence.startIndex..., in: sentence))
        return matches.count > 0
    }
    
    private func shouldIgnoreType(type: String) -> Bool {
        let ignoreType: [String] = ["String", "Int" , "Float" , "Array", "Dictionary" , "Data", "Double", "Character", "TimeInterval", "Date", "URL", "Set", "func"]
        return ignoreType.contains(type) || hasApplePreFix(value: type)
    }
    
    private func hasApplePreFix(value: String) -> Bool {
        return value.hasPrefix("UI") || value.hasPrefix("CG") || value.hasPrefix("CA") || value.hasPrefix("NS")
    }
}
