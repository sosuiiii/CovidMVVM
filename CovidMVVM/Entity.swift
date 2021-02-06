//
//  Entity.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation

struct CovidInfo: Codable {
    
    struct Total: Codable {
        var pcr: Int
        var positive: Int
        var hospitalize: Int
        var severe: Int
        var death: Int
        var discharge: Int
        
        enum CodingKeys: String, CodingKey {
            case pcr
            case positive
            case hospitalize
            case severe
            case death
            case discharge
        }
    }
    
    struct Prefecture: Codable {
        var id: Int
        var nameJa: String
        var cases: Int
        var deaths: Int
        var pcr: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case nameJa = "name_ja"
            case cases
            case deaths
            case pcr
        }
    }
}
