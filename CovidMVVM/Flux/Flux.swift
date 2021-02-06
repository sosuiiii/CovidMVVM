//
//  Flux.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/06.
//

import Foundation

final class Flux {
    
    static var shared = Flux()
    let covidStore: CovidStore
    let covidActionCreator: CovidActionCreator
    
    init() {
        let covidDispatcher = CovidDispatcher()
        self.covidStore = CovidStore(dispatcher: covidDispatcher)
        self.covidActionCreator = CovidActionCreator(dispatcher: covidDispatcher)
    }
}
