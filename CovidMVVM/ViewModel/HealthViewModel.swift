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
    var switchAction: AnyObserver<Int> {get}
}

protocol HealthViewModelOutPut {
    var title:Observable<String> {get}
    var message:Observable<String> {get}
}

protocol HealthViewModelType {
    var inputs: HealthViewModelInput {get}
    var outputs: HealthViewModelOutPut {get}
}

class HealthViewModel: HealthViewModelInput, HealthViewModelOutPut {
    
    //MARK: Input
    var switchAction: AnyObserver<Int>
    
    //MARK: Output
    var title: Observable<String>
    var message: Observable<String>
    
    //MARK: other
    private var disposeBag = DisposeBag()
    private var point:Observable<Int>
    private var sum = 0
    
    
    init() {
        
        let _point = PublishRelay<Int>()
        self.point = _point.asObservable()
        
        let _title = PublishRelay<String>()
        self.title = _title.asObservable()
        
        let _message = PublishRelay<String>()
        self.message = _message.asObservable()
        
        //MARK: Input
        self.switchAction = AnyObserver<Int>() {value in
            guard let value = value.element else {return}
            _point.accept(value)
        }
        
        //MARK: Output
        let _ = _point.subscribe(onNext: { [weak self] value in
            guard let self = self else {return}
            
            self.sum += value
            if self.sum >= 4 {
                _title.accept("高")
                _message.accept("感染している可能性が\n比較的高いです。\nPCR検査をしましょう。")
            } else if self.sum >= 2 {
                _title.accept("中")
                _message.accept("やや感染している可能性が\nあります。外出は控えましょう。")
            } else {
                _title.accept("低")
                _message.accept("感染している可能性は\n今のところ低いです。\n今後も気をつけましょう")
            }
        }).disposed(by: disposeBag)
        
    }
}

extension HealthViewModel: HealthViewModelType {
    var inputs: HealthViewModelInput {return self}
    var outputs: HealthViewModelOutPut {return self}
}
