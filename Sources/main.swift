import Foundation
import ArgumentParser


struct Nadeef: ParsableCommand {
    
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "finding unused objects", version: "1.0.0")
    
    @Argument(help: "Searching relative path, defaults to the current directory") var path: String?
    @Flag(name: .shortAndLong, help: "Show logs while running") var logs: Bool = false
    @Option(help: "Spicify the root classes, like the main or AppDelegate") var roots: [String] = ["Nadeef"]
    
    func run() throws {
        let fileSearcher = SwiftFileSearcher()
        let files = fileSearcher.startSearching(from: path)
        print("TOTAL FILE COUNT ", files.count)
        let fileReader =  SwiftFileReader()
        var objects: [String: Object] = [:]
        for file in files {
            for block in fileReader.read(file: file) {
                if objects[block.metadata.name] != nil {
                    objects[block.metadata.name]?.add(codeBlock: block)
                } else {
                    objects[block.metadata.name] = Object(name: block.metadata.name)
                    objects[block.metadata.name]?.add(codeBlock: block)
                }
            }
        }
        print("Object count = \(objects.count)")
        let referenceCounter = ReferenceCounter()
        var objectsReferences = referenceCounter.searchReferences(for: objects.map( { $0.value } ))
        objects.removeAll()
        
        objectsReferences.forEach({  print("\($0.object.name) used in \($0.references.map({ $0.value?.name }))") })
        print(objectsReferences.count)
        print()
        print()

        let arcDeallocator = ARCDeallocator()
        let unusedObjects = arcDeallocator.findUnused(objects: &objectsReferences)

        objectsReferences.forEach({  print("\($0.object.name) used in \($0.references.count) places" ) })
        print()
        print()
        print()
        print()
        print()
        unusedObjects.forEach({ print("\($0) IS UNUSED")})
        print("\(unusedObjects.count) UNUSED OBJECT")
    }
    
}

Nadeef.main()

