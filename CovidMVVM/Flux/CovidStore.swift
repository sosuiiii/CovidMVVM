//
//  CovidStore.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa

final class CovidStore {
    
    private let _covidTotalResponse = BehaviorRelay<CovidInfo.Total?>(value: nil)
    private let _covidPrefectureResponse = BehaviorRelay<[CovidInfo.Prefecture]?>(value: nil)
    private let _error = PublishRelay<Error>()
    private let disposeBag = DisposeBag()
    
    var covidTotalResponse:
        Observable<CovidInfo.Total?> {
        return _covidTotalResponse.asObservable()
    }
    var covidTotalResponseValue: CovidInfo.Total? {
        return _covidTotalResponse.value
    }
    
    var covidPrefectureResponse: Observable<[CovidInfo.Prefecture]?> {
        return _covidPrefectureResponse.asObservable()
    }
    var covidPrefectureResponseValue: [CovidInfo.Prefecture]? {
        return _covidPrefectureResponse.value
    }
    var error: Observable<Error> {
        return _error.asObservable()
    }
    
    init(dispatcher: CovidDispatcher) {
        
        let _ = dispatcher.fetchCovidTotal
            .bind(to: _covidTotalResponse)
            .disposed(by: disposeBag)
        
        let _ = dispatcher.fetchCovidPrefecture
            .bind(to: _covidPrefectureResponse)
            .disposed(by: disposeBag)
        
        let _ = dispatcher.error
            .bind(to: _error)
            .disposed(by: disposeBag)
    }
}
