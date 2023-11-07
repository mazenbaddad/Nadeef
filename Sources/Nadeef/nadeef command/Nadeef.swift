//
//  File.swift
//  
//
//  Created by mazen baddad on 11/4/23.
//

import Foundation
import ArgumentParser

struct Nadeef: ParsableCommand {
    
    private static let subcommands: Array<ParsableCommand.Type> = {
        return [
            Swift.self
        ]
    }()
    
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "finding unused objects", version: "0.7.0", subcommands: subcommands)
}
