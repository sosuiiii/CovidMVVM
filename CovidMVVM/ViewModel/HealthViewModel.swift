//
//  HealthCheckViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa

protocol HealthViewModelInput {
    
}

protocol HealthViewModelOutPut {
    
}

protocol HealthViewModelType {
    var inputs: HealthViewModelInput {get}
    var outputs: HealthViewModelOutPut {get}
}

class HealthViewModel: HealthViewModelInput, HealthViewModelOutPut {
    
    init() {
    }
}

extension HealthViewModel: HealthViewModelType {
    var inputs: HealthViewModelInput {return self}
    var outputs: HealthViewModelOutPut {return self}
}
