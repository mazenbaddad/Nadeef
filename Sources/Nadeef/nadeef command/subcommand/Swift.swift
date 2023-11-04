//
//  File.swift
//  
//
//  Created by mazen baddad on 11/4/23.
//

import Foundation
import ArgumentParser

extension Nadeef {
    
    struct Swift: ParsableCommand {
        
        static let configuration: CommandConfiguration = CommandConfiguration(abstract: "finding unused objects", version: "0.1.0")
        
        @Argument(help: "Searching relative path, defaults to the current directory") var path: String?
        @Flag(name: .shortAndLong, help: "Show logs while running") var logs: Bool = false
        @Option(help: "Spicify the root classes, like the main or AppDelegate") var roots: [String] = ["Nadeef"]
        
        func run() throws {
            try NadeefProcessor(configuration: NadeefConfiguration(path: path, logs: logs, roots: roots)).process()
        }
    }
}
