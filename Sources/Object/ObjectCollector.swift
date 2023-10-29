//
//  File.swift
//  
//
//  Created by mazen baddad on 10/29/23.
//

import Foundation

class ObjectCollector {
    
    var fileReader: FileReader
    
    init(fileReader: FileReader) {
        self.fileReader = fileReader
    }
    
    func collectObjects(from files: Array<File>) -> Array<Object> {
        var objects: [String: Object] = [:]
        for file in files {
            for block in fileReader.read(file: file) {
                if objects[block.metadata.name] == nil {
                    objects[block.metadata.name] = Object(name: block.metadata.name)
                }
                objects[block.metadata.name]?.add(codeBlock: block)
            }
        }
        return Array(objects.values)
    }
}
