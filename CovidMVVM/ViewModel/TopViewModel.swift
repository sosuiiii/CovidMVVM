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
    var fetchCovidPrefecture: AnyObserver<Void> {get}
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
    var fetchCovidPrefecture: AnyObserver<Void>
    
    //output
    var apiProgress: Observable<Bool>
    var error: Observable<Error>
    var covidTotalResponse: Observable<CovidInfo.Total?>
    
    private var disposeBag = DisposeBag()
    
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
        }).disposed(by: disposeBag)
        
        let _ = store.covidTotalResponse.subscribe(onNext: { element in
            _apiProgress.accept(false)
            _covidTotalResponse.accept(element)
        }).disposed(by: disposeBag)
        
        //MARK: Inputs, API
        self.fetchCovidTotal = AnyObserver<Void>() { _ in
            _apiProgress.accept(true)
            ac.fetchCovidTotal.onNext(Void())
        }
        self.fetchCovidPrefecture = AnyObserver<Void>() { _ in
            ac.fetchCovidPrefecture.onNext(Void())
        }
        let _ = store.covidPrefectureResponse.subscribe(onNext: { element in
            guard let element = element else {return}
            CovidSingleton.shared.prefecture = element
        }).disposed(by: disposeBag)
        
        
    }
}

extension TopViewModel: TopViewModelType {
    var inputs: TopViewModelInput {return self}
    var outputs: TopViewModelOutPut {return self}
}
