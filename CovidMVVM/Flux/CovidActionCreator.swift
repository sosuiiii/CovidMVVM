//
//  CovidActionCreator.swift
//  CovidMVVM
//
//  Created by TanakaSoushi on 2021/02/04.
//

import Foundation
import RxSwift
import RxCocoa

final class CovidActionCreator {

    let fetchCovidTotal: AnyObserver<Void>
    let fetchCovidPrefecture: AnyObserver<Void>
    private let disposeBag = DisposeBag()

    init(dispatcher: CovidDispatcher) {
        
        
        let _fetchCovidTotal = PublishRelay<Void>()
        self.fetchCovidTotal = AnyObserver<Void>(){ _ in
            _fetchCovidTotal.accept(Void())
        }
        
        let _fetchCovidPrefecture = PublishRelay<Void>()
        self.fetchCovidPrefecture = AnyObserver<Void>(){ _ in
            _fetchCovidPrefecture.accept(Void())
        }
        
        let _ = _fetchCovidTotal
            .flatMapLatest({ try CovidRepository.getTotal()
            .materialize() })
            .subscribe(onNext: { event in
                print("fetchTotal::\(event)")
                switch event {
                case .next(let value):
                    dispatcher.fetchCovidTotal.accept(value)
                case .error(let error):
                    dispatcher.error.accept(error)
                case .completed:
                    break
                }
            }).disposed(by: disposeBag)
        
        let _ = _fetchCovidPrefecture
            .flatMapLatest({ try CovidRepository.getPrefecture()
            .materialize() })
            .subscribe(onNext: { event in
                print("fetchPrefectures::\(event)")
                switch event {
                case .next(let value):
                    dispatcher.fetchCovidPrefecture.accept(value)
                case .error(let error):
                    dispatcher.error.accept(error)
                case .completed:
                    break
                }
            }).disposed(by: disposeBag)
    }
}
