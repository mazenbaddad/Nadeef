//
//  SwiftFileSearcher.swift
//  
//
//  Created by mazen baddad on 6/30/23.
//

import Foundation

class SwiftFileSearcher: FileSearcher {
    
    var fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func startSearching(from path: String = FileManager.default.currentDirectoryPath) -> Array<SwiftFile> {
        var swiftFiles: Array<SwiftFile> = []
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                let filePath = path + "/" + file
                print("found ", file)
                guard !self.fileHidden(filePath: filePath) else { continue }
                if self.fileIsDirectoryType(filePath: filePath), file != "Pods" {
                    print("searching directory \(file)")
                    swiftFiles += startSearching(from: filePath)
                } else {
                    let fileExtension: String = "swift"
                    if self.fileExtension(filePath: filePath) == fileExtension {
                        swiftFiles.append(SwiftFile(name: file, path: filePath))
                    }
                }
            }
        } catch {
            print(error)
        }
        return swiftFiles
    }
}

