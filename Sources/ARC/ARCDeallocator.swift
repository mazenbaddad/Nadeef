//
//  File 2.swift
//  
//
//  Created by Mazen Baddad on 30/08/2023.
//

import Foundation

class ARCDeallocator  {
    
    func findUnused(objects: UnsafeMutablePointer<[ObjectReference]>) -> [String] {
        var names: [String] = []
        var referenceChanged = false
        print("iteration ", objects.pointee.count)
        for (i, object) in objects.pointee.enumerated().reversed() {
            if object.references.count < 1  {
                names.append(object.object.name)
                objects.pointee.remove(at: i)
                referenceChanged = true
            }
        }
        objects.pointee.forEach({ $0.clearReferences() })
        if referenceChanged {
            names += findUnused(objects: objects)
        }
        return names
    }
}
