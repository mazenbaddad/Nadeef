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
    
    func startSearching(from path: String?) -> Array<File> {
        let path = path ?? FileManager.default.currentDirectoryPath
        var swiftFiles: Array<File> = []
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                let filePath = path + "/" + file
                guard !self.fileHidden(filePath: filePath) else { continue }
                if self.fileIsDirectoryType(filePath: filePath), file != "Pods" {
                    print("searching directory \(filePath)")
                    swiftFiles += startSearching(from: filePath)
                } else {
                    let fileExtension: String = "swift"
                    if self.fileExtension(filePath: filePath) == fileExtension {
                        print("added ", file)
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

