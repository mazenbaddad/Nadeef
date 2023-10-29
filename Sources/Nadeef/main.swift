import Foundation
import ArgumentParser


struct Nadeef: ParsableCommand {
    
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "finding unused objects", version: "1.0.0")
    
    @Argument(help: "Searching relative path, defaults to the current directory") var path: String?
    @Flag(name: .shortAndLong, help: "Show logs while running") var logs: Bool = false
    @Option(help: "Spicify the root classes, like the main or AppDelegate") var roots: [String] = ["Nadeef"]
    
    func run() throws {
        NadeefProcessor(configuration: NadeefConfiguration(path: path, logs: logs, roots: roots)).process()
        let _ = Holder()
    }
    
}

// TODO: REMOVE THIS
class Holder {
    
    init() {
        let _ = Nadeef()
    }
}

Nadeef.main()

