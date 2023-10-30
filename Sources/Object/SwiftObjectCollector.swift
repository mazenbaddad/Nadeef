//
//  File.swift
//  
//
//  Created by mazen baddad on 10/30/23.
//

import Foundation

class SwiftObjectCollector: ObjectCollector {
    
    var fileReader: FileReader
    var configuration: NadeefConfiguration
    
    init(fileReader: FileReader, configuration: NadeefConfiguration) {
        self.fileReader = fileReader
        self.configuration = configuration
    }
    
    func collectObjects(from files: Array<File>) -> Array<Object> {
        var objects: [String: Object] = [:]
        for file in files {
            for block in fileReader.read(file: file) {
                if objects[block.metadata.name] == nil {
                    objects[block.metadata.name] = SwiftObject(name: block.metadata.name, configuration: configuration)
                }
                objects[block.metadata.name]?.add(codeBlock: block)
            }
        }
        return Array(objects.values)
    }
}
