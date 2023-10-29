//
//  File.swift
//  
//
//  Created by mazen baddad on 10/29/23.
//

import Foundation

class NadeefProcessor {
    
    var configuration: NadeefConfiguration
    
    init(configuration: NadeefConfiguration) {
        self.configuration = configuration
    }
    
    func process() {
        let fileSearcher = SwiftFileSearcher()
        let files = fileSearcher.startSearching(from: configuration.path)
        print("TOTAL FILES COUNT ", files.count)
        
        let swiftFileReader = SwiftFileReader()
        let objectCollector = ObjectCollector(fileReader: swiftFileReader)
        
        let referenceCounter = ReferenceCounter()
        var objectsReferences = referenceCounter.searchReferences(for: objectCollector.collectObjects(from: files))
        print("TOTAL OBJECTS COUNT ", objectsReferences.count)

        let arcDeallocator = ARCDeallocator()
        let unusedObjects = arcDeallocator.removeUnused(objects: &objectsReferences)

        unusedObjects.forEach({ print("\($0) IS UNUSED")})
        print("\(unusedObjects.count) UNUSED OBJECT")
    }
}

