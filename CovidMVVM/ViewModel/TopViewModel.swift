//
//  TopViewModel.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa


protocol TopViewModelInput {
    var fetchCovidTotal: AnyObserver<Void> {get}
}

protocol TopViewModelOutPut {
    var apiProgress: Observable<Bool> {get}
    var error: Observable<Error> {get}
    var covidTotalResponse: Observable<CovidInfo.Total?>{get}
}

protocol TopViewModelType {
    var inputs: TopViewModelInput {get}
    var outputs: TopViewModelOutPut {get}
}

class TopViewModel: TopViewModelInput, TopViewModelOutPut {
    
    //input
    var fetchCovidTotal: AnyObserver<Void>
    
    //output
    var apiProgress: Observable<Bool>
    var error: Observable<Error>
    var covidTotalResponse: Observable<CovidInfo.Total?>
    
    init() {
        
        let ac = Flux.shared.covidActionCreator
        let store = Flux.shared.covidStore
        
        //MARK: Outputs
        let _apiProgress = BehaviorRelay<Bool>(value: false)
        self.apiProgress = _apiProgress.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        let _covidTotalResponse = BehaviorRelay<CovidInfo.Total?>(value: nil)
        self.covidTotalResponse = _covidTotalResponse.asObservable()
        
        let _ = store.error.subscribe(onNext: { element in
            _apiProgress.accept(false)
            _error.accept(element)
        })
        
        let _ = store.covidTotalResponse.subscribe(onNext: { element in
            _apiProgress.accept(false)
            _covidTotalResponse.accept(element)
        })
        
        //MARK: Inputs
        self.fetchCovidTotal = AnyObserver<Void>() { _ in
            _apiProgress.accept(true)
            ac.fetchCovidTotal.onNext(Void())
        }
        
        
    }
}

extension TopViewModel: TopViewModelType {
    var inputs: TopViewModelInput {return self}
    var outputs: TopViewModelOutPut {return self}
}
